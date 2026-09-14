# Tu nap lai o che do im lang de Tcl Console chi in KET QUA, khong echo ca file.
if {![info exists ::rv_quiet_guard]} { set ::rv_quiet_guard 1; set _rc [catch {uplevel #0 [list source -notrace [info script]]} _res _opt]; unset ::rv_quiet_guard; if {$_rc != 0} { return -options $_opt $_res }; return }

# =============================================================================
# read_dmem.tcl - HEX DUMP VUNG DMEM (0x00002000)
#
# CACH DUNG:
#     cd C:/Users/Dell/Desktop/RISCV_RV32I/Tutorial/tcl
#     source -notrace Tutorial/tcl/read_dmem.tcl
#
# Doc vung khac:
#     set ::rv_dmem_start 0x00002040
#     set ::rv_dmem_words 32
#     source -notrace Tutorial/tcl/read_dmem.tcl
#
# Yeu cau: /jtag_axi_0/Data phai co segment axi_bram_ctrl_1/S_AXI active.
# Neu segment nay dang Excluded trong Address Editor, script se timeout.
# In 4 word moi dong kem cot ASCII (tien khi soi buffer ky tu UART).
# =============================================================================

source -notrace [file join [file dirname [info script]] rv_common.tcl]

if {![info exists ::rv_dmem_start]} { set ::rv_dmem_start 0x00002000 }
if {![info exists ::rv_dmem_words]} { set ::rv_dmem_words 16 }

set start_addr $::rv_dmem_start
set num_words  $::rv_dmem_words

rv::banner "GIA TRI TRONG BO NHO DMEM"

if {[catch { rv::connect } err]} { return }

rv::kv "Dia chi bat dau" [rv::hex $start_addr]
rv::kv "So word" $num_words
puts ""

puts "  ADDR         +0        +4        +8        +C         ASCII"
rv::rule "-"

set timeout 0
set nonzero 0

# Doc va in theo tung hang 4 word
for {set i 0} {$i < $num_words} {incr i 4} {
    set row_addr [expr {$start_addr + $i * 4}]
    set cells {}
    set ascii ""

    for {set j 0} {$j < 4} {incr j} {
        if {$i + $j >= $num_words} {
            lappend cells "        "
            append ascii "    "
            continue
        }
        set data [rv::r32 [expr {$row_addr + $j * 4}]]
        if {$data eq ""} {
            lappend cells "--------"
            append ascii "????"
            set timeout 1
        } else {
            lappend cells $data
            append ascii [rv::ascii $data]
            if {$data ne "00000000"} { incr nonzero }
        }
    }

    puts [format "  0x%08X   %s  %s  %s  %s   |%s|" \
            $row_addr [lindex $cells 0] [lindex $cells 1] \
            [lindex $cells 2] [lindex $cells 3] $ascii]

    if {$timeout} { break }
}

rv::rule "-"

if {$timeout} {
    rv::warn_timeout $start_addr
} elseif {$nonzero == 0} {
    rv::warn "Toan bo vung deu bang 0."
    puts ""
    puts "  Kha nang:"
    puts "    - CPU chua chay (chua nhap Reset sau khi nap IMEM)."
    puts "    - Firmware chua ghi gi vao vung nay."
} else {
    rv::ok "Da doc $num_words word ($nonzero word khac 0)."
    puts ""
    puts "  Meo: chay lai script 2 lan. Neu gia tri THAY DOI -> CPU dang chay."
}
rv::rule "="
