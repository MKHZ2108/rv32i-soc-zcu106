# Ket noi lai Hardware Server/Target sau khi rut-cap, dong target hoac target shutdown.
# Script khong tu Program Device va khong ghi IMEM.
# Chay: source -notrace reconnect_hw.tcl

if {![info exists ::rv_quiet_guard]} { set ::rv_quiet_guard 1; set _rc [catch {uplevel #0 [list source -notrace [info script]]} _res _opt]; unset ::rv_quiet_guard; if {$_rc != 0} { return -options $_opt $_res }; return }

set _rv_dir [file dirname [file normalize [info script]]]
source -notrace [file join $_rv_dir rv_common.tcl]

rv::banner "KET NOI LAI HARDWARE TARGET"
rv::reset_conn

catch { close_hw_target -quiet }
catch { disconnect_hw_server -quiet }
after 300

catch { open_hw_manager -quiet }
if {[catch { connect_hw_server -allow_non_jtag -quiet } _err]} {
    rv::fail "Khong ket noi duoc hw_server: $_err"
    return
}

set _targets [get_hw_targets -quiet]
if {[llength $_targets] == 0} {
    rv::fail "Khong thay Hardware Target."
    puts "  Kiem tra cap JTAG va nguon board, sau do chay lai script."
    return
}

current_hw_target [lindex $_targets 0]
if {[catch { open_hw_target -quiet } _err]} {
    rv::fail "Khong mo duoc Hardware Target: $_err"
    return
}

set _fpga ""
foreach _dev [get_hw_devices -quiet] {
    if {[string match "xczu*" $_dev]} {
        set _fpga $_dev
        break
    }
}

if {$_fpga eq ""} {
    rv::fail "Target da mo nhung khong tim thay FPGA xczu."
    return
}

catch { refresh_hw_device -quiet $_fpga }
rv::kv "FPGA" $_fpga

set _axes [get_hw_axis -quiet]
if {[llength $_axes] == 0} {
    rv::warn "Da ket noi target nhung khong thay JTAG-to-AXI."
    puts "  Neu Hardware Manager bao DONE=0: phai Program Device lai."
    puts "  Neu DONE=1: Refresh Device, roi chay lai script."
    return
}

set _axis [lindex $_axes 0]
rv::kv "JTAG-AXI node" $_axis
catch { reset_hw_axi $_axis }
rv::reset_conn

if {[catch { rv::connect 1 } _err]} {
    rv::fail "Da thay JTAG-to-AXI nhung khong tao lai ket noi duoc: $_err"
    return
}

set _data [rv::r32 0x00000000]
if {$_data eq ""} {
    rv::fail "Target da ket noi nhung giao dich AXI van TIMEOUT."
} else {
    rv::ok "Ket noi lai thanh cong; doc IMEM 0x00000000 = $_data"
}
