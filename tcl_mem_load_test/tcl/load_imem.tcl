# Tu nap lai o che do im lang de Tcl Console chi in KET QUA, khong echo ca file.
# Luu y: neu lan source -notrace thanh cong thi phai "return" rieng de dung
# ban source dang bi trace. Dung "return -options" voi ket qua catch thanh cong
# se co -code 0, khien Vivado tiep tuc chay va echo phan con lai cua file.
if {![info exists ::rv_quiet_guard]} { set ::rv_quiet_guard 1; set _rc [catch {uplevel #0 [list source -notrace [info script]]} _res _opt]; unset ::rv_quiet_guard; if {$_rc != 0} { return -options $_opt $_res }; return }

# =============================================================================
# load_imem.tcl - NAP FILE .mem VAO IMEM QUA JTAG-to-AXI (co tu kiem chung)
#
# CACH DUNG trong Vivado Tcl Console:
#     cd C:/Users/Dell/Desktop/RISCV_RV32I/Tutorial/tcl
#     source -notrace load_imem.tcl
#
# Nap firmware khac (khong can sua than script):
#     set ::rv_mem_file "test_cpu.mem"
#     source -notrace load_imem.tcl
#
# Firmware (.s/.mem/.elf) va build.bat nam CUNG thu muc voi script nay.
#
# Dinh dang file .mem = output cua "objcopy -O verilog":
#     @00000000
#     B7 20 00 00 13 01 80 00 ...
# Moi byte cach nhau bang khoang trang, ghep 4 byte -> 1 word little-endian.
# =============================================================================

source -notrace [file join [file dirname [info script]] rv_common.tcl]

# --- Tham so (co the dat truoc khi source de ghi de) --------------------------
if {![info exists ::rv_mem_file]}  { set ::rv_mem_file  "firmware.mem" }
if {![info exists ::rv_base_addr]} { set ::rv_base_addr 0x00000000 }
if {![info exists ::rv_verify]}    { set ::rv_verify    1 }

set mem_file  $::rv_mem_file
set base_addr $::rv_base_addr

rv::banner "NAP IMEM QUA JTAG-to-AXI"

# --- 1. Tim file .mem --------------------------------------------------------
# Firmware nam CUNG thu muc voi script nay. Tim theo thu tu: duong dan nhu
# da cho (thu muc hien hanh) -> cung thu muc voi script. Nho vay khong phu
# thuoc vao thu muc hien hanh cua Vivado.
set _here [file dirname [info script]]

set _try [list $mem_file [file join $_here $mem_file]]
set mem_path ""
foreach _p $_try {
    if {[file exists $_p]} { set mem_path $_p ; break }
}

if {$mem_path eq ""} {
    rv::fail "Khong tim thay '$mem_file'"
    puts ""
    puts "  Da tim tai:"
    foreach _p $_try { puts "    - [file normalize $_p]" }
    puts ""
    puts "  Chay build.bat trong thu muc nay de sinh file .mem truoc."
    return
}
set mem_file $mem_path
rv::kv "File nguon" "[file tail $mem_file] ([file size $mem_file] bytes)"
rv::kv "Dia chi goc" [rv::hex $base_addr]

# --- 2. Ket noi --------------------------------------------------------------
if {[catch { rv::connect } err]} { return }

# --- 3. Doc va phan tich file .mem -------------------------------------------
# Gom truoc thanh list {addr word}, ghi sau. Tach ro 2 buoc giup:
#   - biet truoc tong so word -> in duoc thanh tien trinh
#   - phat hien loi dinh dang truoc khi cham vao phan cung
set fp [open $mem_file r]
set file_data [read $fp]
close $fp

set current_addr $base_addr
set byte_buffer {}
set records {}          ;# list cac cap {addr word_hex}
set leftover 0

foreach line [split $file_data "\n"] {
    set clean_line [string trim $line]
    if {$clean_line eq "" || [string match "/*" $clean_line]} { continue }

    # Dong chi dinh dia chi, vi du "@00000000"
    if {[string match "@*" $clean_line]} {
        # Flush byte le con sot lai truoc khi nhay dia chi
        if {[llength $byte_buffer] != 0} {
            set leftover [llength $byte_buffer]
            set byte_buffer {}
        }
        set current_addr [expr {"0x[string range $clean_line 1 end]"}]
        continue
    }

    foreach tok [split $clean_line " "] {
        set tok [string trim $tok]
        if {$tok eq ""} { continue }
        lappend byte_buffer $tok

        # Du 4 byte -> ghep thanh 1 word 32-bit little-endian
        # (byte dau tien trong file la byte THAP nhat cua word)
        if {[llength $byte_buffer] == 4} {
            lassign $byte_buffer b0 b1 b2 b3
            lappend records [list $current_addr "${b3}${b2}${b1}${b0}"]
            incr current_addr 4
            set byte_buffer {}
        }
    }
}

# Byte le cuoi file -> pad 0 cho du 1 word, canh bao ro
if {[llength $byte_buffer] != 0} {
    set leftover [llength $byte_buffer]
    while {[llength $byte_buffer] < 4} { lappend byte_buffer "00" }
    lassign $byte_buffer b0 b1 b2 b3
    lappend records [list $current_addr "${b3}${b2}${b1}${b0}"]
    incr current_addr 4
}

set n [llength $records]
if {$n == 0} {
    rv::fail "File khong chua du lieu hop le."
    return
}
if {$leftover != 0} {
    rv::warn "File co so byte khong chia het cho 4 -> da pad them so 0."
}

set addr_lo [lindex [lindex $records 0] 0]
set addr_hi [lindex [lindex $records end] 0]
rv::kv "So word (32-bit)" $n
rv::kv "Dai dia chi" "[rv::hex $addr_lo] .. [rv::hex $addr_hi]"

# --- 4. Ghi vao IMEM ---------------------------------------------------------
# In thanh tien trinh gon 1 dong thay vi N dong (script cu in moi word 1 dong).
rv::step "Dang ghi $n word vao IMEM..."
rv::tic

set step [expr {$n < 20 ? 1 : $n / 20}]
puts -nonewline "  \["
flush stdout
set i 0
foreach rec $records {
    lassign $rec a w
    rv::w32 $a $w
    incr i
    if {$i % $step == 0} { puts -nonewline "#" ; flush stdout }
}
puts "\] $n/$n"
set t_write [rv::toc]
rv::kv "Thoi gian ghi" $t_write

# --- 5. Doc lai va so khop ---------------------------------------------------
# Buoc nay script cu KHONG co: bao "THANH CONG" ma chua he xac nhan
# BRAM that su nhan dung du lieu.
if {!$::rv_verify} {
    rv::ok "Da ghi xong (bo qua verify vi rv_verify = 0)."
    rv::rule "="
    return
}

rv::step "Dang doc lai de kiem chung..."
rv::tic

set bad 0
set timeout 0
set first_bad ""
foreach rec $records {
    lassign $rec a expect
    set got [rv::r32 $a]

    if {$got eq ""} {
        incr timeout
        if {$first_bad eq ""} { set first_bad [list $a $expect "<TIMEOUT>"] }
        break
    }
    if {![string equal -nocase $got $expect]} {
        incr bad
        if {$first_bad eq ""} { set first_bad [list $a $expect $got] }
    }
}
set t_read [rv::toc]

# --- 6. Tong ket -------------------------------------------------------------
puts ""
rv::rule "-"
if {$timeout > 0} {
    lassign $first_bad a e g
    rv::warn_timeout $a
    rv::fail "NAP THAT BAI - bus AXI khong phan hoi."
} elseif {$bad == 0} {
    rv::kv "Thoi gian doc lai" $t_read
    rv::ok "NAP THANH CONG - $n/$n word khop hoan toan."
    puts ""
    puts "  Buoc tiep theo:"
    puts "    1. Nhap NHE nut Reset ~0.5s roi tha (CPU nap lai PC=0x0)."
    puts "    2. Neu JTAG-to-AXI da map Data BRAM: source -notrace read_dmem.tcl"
} else {
    lassign $first_bad a e g
    rv::fail "SAI LECH: $bad/$n word khong khop."
    rv::kv "Sai dau tien tai" [rv::hex $a]
    rv::kv "  Mong doi" "0x$e"
    rv::kv "  Doc duoc" "0x$g"
    puts ""
    puts "  Kha nang: IMEM chi 8KB (0x0000-0x1FFF). Neu firmware vuot qua"
    puts "  gioi han nay, dia chi se wrap hoac roi vao vung khac."
}
rv::rule "="
