# Tu nap lai o che do im lang khi nguoi dung source truc tiep file thu vien.
if {![info exists ::rv_quiet_guard]} { set ::rv_quiet_guard 1; set _rc [catch {uplevel #0 [list source -notrace [info script]]} _res _opt]; unset ::rv_quiet_guard; if {$_rc != 0} { return -options $_opt $_res }; return }

# =============================================================================
# rv_common.tcl - THU VIEN DUNG CHUNG CHO CAC SCRIPT JTAG-to-AXI
#
# Moi script khac chi can them dong dau tien:
#     source -notrace rv_common.tcl
#
# Cung cap:
#   rv::connect          - ket noi hw_manager + jtag_axi (co cache, goi lai khong ton thoi gian)
#   rv::w32  addr data   - ghi 1 word 32-bit
#   rv::r32  addr        - doc 1 word 32-bit (tra ve chuoi hex 8 ky tu, hoac "" neu timeout)
#   rv::banner / ok / fail / warn / info / kv / rule  - in an dong nhat
#   rv::hex  value       - format 0xXXXXXXXX
#   rv::ascii word_hex   - doi 1 word thanh 4 ky tu ASCII (little-endian)
#
# GHI CHU KY THUAT:
#   AXI4-Lite -> -len BAT BUOC = 1, khong burst duoc.
#   Txn handle duoc TAO 1 LAN roi tai su dung (thay vi create/delete moi word)
#   -> nhanh hon dang ke khi nap firmware nhieu word.
# =============================================================================

namespace eval rv {
    variable axi_node ""      ;# node jtag_axi da ket noi
    variable txn_ready 0      ;# da tao 2 txn handle chua
    variable t0 0             ;# moc thoi gian cho rv::tic / rv::toc

    # Do rong cot dung chung cho moi bang
    variable W_ADDR 12
}

# -----------------------------------------------------------------------------
# IN AN
# -----------------------------------------------------------------------------
proc rv::rule {{ch "="}} {
    puts [string repeat $ch 68]
}

proc rv::banner {title} {
    rv::rule "="
    puts [format "  %s" $title]
    rv::rule "="
}

proc rv::ok    {msg} { puts "  \[ OK \]   $msg" }
proc rv::fail  {msg} { puts "  \[FAIL\]   $msg" }
proc rv::warn  {msg} { puts "  \[WARN\]   $msg" }
proc rv::info  {msg} { puts "  \[INFO\]   $msg" }
proc rv::step  {msg} { puts "\n>>> $msg" }

# In cap "nhan : gia tri" thang cot
proc rv::kv {key value} {
    puts [format "  %-24s : %s" $key $value]
}

# 0xXXXXXXXX tu so nguyen
proc rv::hex {value} {
    return [format "0x%08X" $value]
}

# Doi 1 word hex (8 ky tu) thanh 4 ky tu ASCII, little-endian.
# Byte khong in duoc -> dau cham.
proc rv::ascii {word_hex} {
    set out ""
    if {[string length $word_hex] != 8} { return "...." }
    # Little-endian: byte thap nhat (2 ky tu cuoi) la ky tu dau tien
    foreach i {6 4 2 0} {
        set b [scan [string range $word_hex $i [expr {$i + 1}]] %x]
        if {$b >= 32 && $b < 127} {
            append out [format %c $b]
        } else {
            append out "."
        }
    }
    return $out
}

# -----------------------------------------------------------------------------
# DO THOI GIAN
# -----------------------------------------------------------------------------
proc rv::tic {} {
    variable t0
    set t0 [clock milliseconds]
}

proc rv::toc {} {
    variable t0
    set ms [expr {[clock milliseconds] - $t0}]
    return [format "%.2f s" [expr {$ms / 1000.0}]]
}

# -----------------------------------------------------------------------------
# KET NOI
#
# Gom dung khoi open_hw_manager/connect_hw_server/open_hw_target/get_hw_axis
# von bi lap y het o ca 3 script cu. Ket qua duoc cache trong rv::axi_node,
# nen goi lan thu hai gan nhu tuc thoi.
#
# Tra ve ten node jtag_axi. Neu khong tim thay -> error (script goi se dung han).
# -----------------------------------------------------------------------------
proc rv::connect {{quiet 0}} {
    variable axi_node
    variable txn_ready

    if {$axi_node ne ""} { return $axi_node }

    catch { open_hw_manager -quiet }
    catch { connect_hw_server -quiet }
    catch { open_hw_target -quiet }

    set nodes [get_hw_axis -quiet]
    if {[llength $nodes] == 0} {
        rv::fail "Khong tim thay IP JTAG-to-AXI."
        puts ""
        puts "  Kiem tra theo thu tu:"
        puts "    1. Cap JTAG da cam va board da bat nguon?"
        puts "    2. Bitstream da nap chua? (Program Device)"
        puts "    3. Hardware Manager co thay device khong?"
        error "rv::connect - khong co jtag_axi node"
    }

    set axi_node [lindex $nodes 0]
    set txn_ready 0

    if {!$quiet} { rv::kv "JTAG-AXI node" $axi_node }
    return $axi_node
}

# Tao san 2 txn handle dung lai cho moi lan doc/ghi.
proc rv::_ensure_txn {} {
    variable axi_node
    variable txn_ready

    if {$txn_ready} { return }
    rv::connect 1

    # Xoa handle cu neu con sot lai tu lan chay truoc
    catch { delete_hw_axi_txn [get_hw_axi_txns -quiet rv_wr] }
    catch { delete_hw_axi_txn [get_hw_axi_txns -quiet rv_rd] }

    create_hw_axi_txn -quiet rv_wr $axi_node -type WRITE \
        -address 00000000 -data 00000000 -len 1 -force
    create_hw_axi_txn -quiet rv_rd $axi_node -type READ  \
        -address 00000000 -len 1 -force

    set txn_ready 1
}

# Giai phong handle (goi khi muon ket noi lai tu dau)
proc rv::reset_conn {} {
    variable axi_node
    variable txn_ready
    catch { delete_hw_axi_txn [get_hw_axi_txns -quiet rv_wr] }
    catch { delete_hw_axi_txn [get_hw_axi_txns -quiet rv_rd] }
    set axi_node ""
    set txn_ready 0
}

# -----------------------------------------------------------------------------
# GHI / DOC 32-bit
#
#   rv::w32 0x00000000 000020B7
#   set d [rv::r32 0x00002000]
#
# addr : so nguyen hoac chuoi 0x...
# data : chuoi hex (co hoac khong co tien to 0x)
# -----------------------------------------------------------------------------

# Chuan hoa chuoi hex -> dung 8 ky tu hoa.
# Luu y: KHONG dung [string trimleft $s "0xX"] vi no cat CA cac so 0 dan dau
# ("00000000" -> "" -> loi). Chi bo dung tien to "0x" neu co.
proc rv::norm_hex {s} {
    set s [string trim $s]
    if {[string match -nocase "0x*" $s]} {
        set s [string range $s 2 end]
    }
    if {$s eq ""} { set s 0 }
    return [format "%08X" [expr {"0x$s"}]]
}

proc rv::w32 {addr data} {
    variable axi_node
    rv::connect 1
    set a [format "%08X" [expr {$addr}]]
    set d [rv::norm_hex $data]

    # Tao lai txn moi lan voi -address/-data ngay luc tao.
    # KHONG dung set_property ADDRESS tren txn cu: nhieu phien ban Vivado
    # coi ADDRESS la read-only sau khi tao -> loi "does not have ADDRESS property".
    create_hw_axi_txn -quiet rv_wr $axi_node \
        -type WRITE -address $a -data $d -len 1 -force
    run_hw_axi -quiet rv_wr
    return
}

# Tra ve chuoi hex 8 ky tu, hoac "" neu giao dich timeout.
#
# Chuoi rong chinh la trieu chung AXI timeout mo ta o muc 3 cam nang
# ("Addr ... : 0x"): giao dich khong nhan duoc RVALID nen thuoc tinh DATA
# khong co gia tri. Bat o day de bao loi ro rang thay vi in dong trong.
proc rv::r32 {addr} {
    variable axi_node
    rv::connect 1
    set a [format "%08X" [expr {$addr}]]

    # Tao lai txn READ moi lan voi -address ngay luc tao (xem ghi chu o rv::w32).
    create_hw_axi_txn -quiet rv_rd $axi_node -type READ -address $a -len 1 -force
    if {[catch { run_hw_axi -quiet rv_rd } err]} {
        return ""
    }
    set d [get_property DATA [get_hw_axi_txns rv_rd]]
    if {$d eq "" || [string trim $d] eq ""} {
        return ""
    }
    return [rv::norm_hex $d]
}

# In canh bao chuan khi gap timeout - dung chung cho moi script doc.
proc rv::warn_timeout {addr} {
    rv::fail "Doc [rv::hex $addr] khong co du lieu tra ve (AXI TIMEOUT)."
    puts ""
    puts "  Nguyen nhan thuong gap:"
    puts "    - Vua giu nut Reset qua lau -> PLL mat lock -> bus AXI dung."
    puts "      Cach xu ly: tha Reset, doi PLL lock, sau do chay:"
    puts "      source -notrace reconnect_hw.tcl"
    puts "    - aresetn dang bi giu asserted -> moi AXI slave ket trong reset."
    puts "    - Bitstream chua nap, hoac nap ban khong khop block design."
    puts ""
}

# -----------------------------------------------------------------------------
# DOC/GHI THEO KHOI - tra ve list
# -----------------------------------------------------------------------------

# Doc n word lien tiep tu addr. Tra ve list cac chuoi hex (phan tu rong = timeout).
proc rv::read_block {addr n} {
    set out {}
    for {set i 0} {$i < $n} {incr i} {
        lappend out [rv::r32 [expr {$addr + $i * 4}]]
    }
    return $out
}

# Ghi list word (chuoi hex) bat dau tu addr.
proc rv::write_block {addr words} {
    set i 0
    foreach w $words {
        rv::w32 [expr {$addr + $i * 4}] $w
        incr i
    }
    return $i
}
