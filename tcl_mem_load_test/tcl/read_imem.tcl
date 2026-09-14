# Doc nhanh noi dung IMEM qua JTAG-to-AXI.
# Chay: source -notrace read_imem.tcl
# Tuy chon:
#   set ::rv_imem_start 0x00000000
#   set ::rv_imem_words 32

if {![info exists ::rv_quiet_guard]} { set ::rv_quiet_guard 1; set _rc [catch {uplevel #0 [list source -notrace [info script]]} _res _opt]; unset ::rv_quiet_guard; if {$_rc != 0} { return -options $_opt $_res }; return }

source -notrace [file join [file dirname [info script]] rv_common.tcl]

if {![info exists ::rv_imem_start]} { set ::rv_imem_start 0x00000000 }
if {![info exists ::rv_imem_words]} { set ::rv_imem_words 16 }

set start_addr $::rv_imem_start
set num_words  $::rv_imem_words

rv::banner "NOI DUNG IMEM"
if {[catch { rv::connect } err]} { return }

rv::kv "Dia chi bat dau" [rv::hex $start_addr]
rv::kv "So word" $num_words
puts ""
puts "  ADDR         WORD"
rv::rule "-"

set timeout 0
for {set i 0} {$i < $num_words} {incr i} {
    set addr [expr {$start_addr + $i * 4}]
    set data [rv::r32 $addr]
    if {$data eq ""} {
        puts [format "  0x%08X   <TIMEOUT>" $addr]
        set timeout 1
        break
    }
    puts [format "  0x%08X   %s" $addr $data]
}

rv::rule "-"
if {$timeout} {
    rv::warn_timeout $start_addr
} else {
    rv::ok "Da doc $num_words word IMEM."
}
rv::rule "="
