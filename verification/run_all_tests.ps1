$ErrorActionPreference = "Stop"

# -----------------------------------------------------------------------------
# Self-contained verification runner for the Desktop RV32I project.
#
# RTL nguon = ban CHUAN o imports\rtl (khong copy RTL, tham chieu truc tiep).
# Testbench + module sim-only nam trong verification\ nay.
#
#   powershell -ExecutionPolicy Bypass -File run_all_tests.ps1
#
# In "==> compile/run <ten>" cho tung test; bat ky dong "FAIL:" -> throw.
# Ket thuc in tong ket PASS/FAIL.
# -----------------------------------------------------------------------------

# iverilog / vvp
$iverilog = Get-Command iverilog -ErrorAction SilentlyContinue
$vvp = Get-Command vvp -ErrorAction SilentlyContinue
if ($null -eq $iverilog -or $null -eq $vvp) {
    $env:Path = $env:Path + ";C:\iverilog\bin"
}

$V = $PSScriptRoot
$BUILD = Join-Path $V "build"
New-Item -ItemType Directory -Force -Path $BUILD | Out-Null

# RTL chuan: ..\RISCV- RV32I.srcs\sources_1\imports\rtl  (co dau cach trong ten)
$RTL = (Resolve-Path (Join-Path $V "..\RISCV- RV32I.srcs\sources_1\imports\rtl")).Path
$SIM = Join-Path $V "sim_only"

function Rtl($rel) { return (Join-Path $RTL $rel) }   # duong dan RTL chuan
function Sim($rel) { return (Join-Path $SIM $rel) }   # module sim-only
function Tb($rel)  { return (Join-Path $V   $rel) }   # testbench

# Danh sach file core day du (thu tu nhu OneDrive commit_stall/core_smoke).
$CORE = @(
    (Rtl "accel\ripple_adder.v"),
    (Rtl "core\units\pc_unit.v"), (Rtl "core\stages\if_stage.v"), (Rtl "core\regs\if_id_reg.v"),
    (Rtl "core\units\decoder.v"), (Rtl "core\units\imm_gen.v"), (Rtl "core\units\control_unit.v"),
    (Rtl "core\units\csr_file.v"), (Rtl "core\regs\reg_file.v"), (Rtl "core\stages\id_stage.v"),
    (Rtl "core\regs\id_ex_reg.v"), (Rtl "core\units\forwarding_unit.v"), (Rtl "core\units\branch_unit.v"),
    (Rtl "core\units\alu.v"), (Rtl "core\stages\ex_stage.v"), (Rtl "core\regs\ex_mem_reg.v"),
    (Rtl "core\stages\mem_stage.v"), (Rtl "core\regs\mem_wb_reg.v"), (Rtl "core\stages\wb_stage.v"),
    (Rtl "core\units\hazard_unit.v"), (Rtl "core\units\trap_unit.v"), (Rtl "core\rv32i_core.v")
)

$global:pass = 0
$global:fail = 0
$global:faillist = @()

function Run-Test {
    param([string]$Name, [string]$Top, [string[]]$Sources, [string[]]$Params = @())
    $out = Join-Path $BUILD "$Name.vvp"
    Write-Host "==> compile $Name"
    $compileArgs = @("-g2005-sv", "-Wall") + $Params + @("-o", $out, "-s", $Top) + $Sources
    & iverilog @compileArgs
    if ($LASTEXITCODE -ne 0) {
        Write-Host "FAIL: $Name (compile)"; $global:fail++; $global:faillist += "$Name(compile)"; return
    }
    Write-Host "==> run $Name"
    $simOutput = & vvp $out 2>&1
    $simOutput | ForEach-Object { Write-Host $_ }
    if ($LASTEXITCODE -ne 0 -or ($simOutput -match "FAIL:")) {
        $global:fail++; $global:faillist += $Name; return
    }
    $global:pass++
}

# ------------------------------------------------------------------ tb/ (unit)
Run-Test "control_unit_rv32i_tb" "control_unit_rv32i_tb" @((Rtl "core\units\control_unit.v"), (Tb "tb\control_unit_rv32i_tb.v"))
Run-Test "csr_file_tb" "csr_file_tb" @((Rtl "core\units\csr_file.v"), (Tb "tb\csr_file_tb.v"))
Run-Test "trap_unit_tb" "trap_unit_tb" @((Rtl "core\units\trap_unit.v"), (Tb "tb\trap_unit_tb.v"))
Run-Test "bus_interconnect_tb" "bus_interconnect_tb" @((Sim "bus_interconnect.v"), (Tb "tb\bus_interconnect_tb.v"))

# ------------------------------------------------------------------ tb_ext/
Run-Test "imem_axi_lite_adapter_tb" "imem_axi_lite_adapter_tb" @((Rtl "bus\imem_axi_lite_adapter.v"), (Tb "tb_ext\imem_axi_lite_adapter_tb.v"))
Run-Test "dmem_axi_lite_adapter_tb" "dmem_axi_lite_adapter_tb" @((Rtl "bus\dmem_axi_lite_adapter.v"), (Tb "tb_ext\dmem_axi_lite_adapter_tb.v"))
Run-Test "alu_ext_tb" "alu_ext_tb" @(
    (Rtl "accel\ripple_adder.v"),
    (Rtl "core\units\alu.v"), (Tb "tb_ext\alu_ext_tb.v"))
Run-Test "decoder_imm_ext_tb" "decoder_imm_ext_tb" @((Rtl "core\units\decoder.v"), (Rtl "core\units\imm_gen.v"), (Tb "tb_ext\decoder_imm_ext_tb.v"))
Run-Test "reg_pc_wb_ext_tb" "reg_pc_wb_ext_tb" @((Rtl "core\regs\reg_file.v"), (Rtl "core\units\pc_unit.v"), (Rtl "core\stages\wb_stage.v"), (Tb "tb_ext\reg_pc_wb_ext_tb.v"))
Run-Test "branch_forward_hazard_ext_tb" "branch_forward_hazard_ext_tb" @((Rtl "core\units\branch_unit.v"), (Rtl "core\units\forwarding_unit.v"), (Rtl "core\units\hazard_unit.v"), (Tb "tb_ext\branch_forward_hazard_ext_tb.v"))
Run-Test "mem_stage_ext_tb" "mem_stage_ext_tb" @((Rtl "core\stages\mem_stage.v"), (Tb "tb_ext\mem_stage_ext_tb.v"))
Run-Test "memory_ext_tb" "memory_ext_tb" @((Sim "data_bram.v"), (Sim "instr_bram.v"), (Tb "tb_ext\memory_ext_tb.v"))
Run-Test "stage_ext_tb" "stage_ext_tb" @(
    (Rtl "accel\ripple_adder.v"),
    (Rtl "core\units\pc_unit.v"), (Rtl "core\stages\if_stage.v"), (Rtl "core\units\decoder.v"),
    (Rtl "core\units\imm_gen.v"), (Rtl "core\units\control_unit.v"), (Rtl "core\regs\reg_file.v"),
    (Rtl "core\stages\id_stage.v"), (Rtl "core\units\branch_unit.v"), (Rtl "core\units\alu.v"),
    (Rtl "core\stages\ex_stage.v"), (Tb "tb_ext\stage_ext_tb.v"))
Run-Test "pipeline_regs_ext_tb" "pipeline_regs_ext_tb" @(
    (Rtl "core\regs\if_id_reg.v"), (Rtl "core\regs\id_ex_reg.v"), (Rtl "core\regs\ex_mem_reg.v"),
    (Rtl "core\regs\mem_wb_reg.v"), (Tb "tb_ext\pipeline_regs_ext_tb.v"))
Run-Test "commit_stall_ext_tb" "commit_stall_ext_tb" ($CORE + @((Tb "tb_ext\commit_stall_ext_tb.v")))
Run-Test "external_interrupt_ext_tb" "external_interrupt_ext_tb" ($CORE + @((Tb "tb_ext\external_interrupt_ext_tb.v")))
Run-Test "core_smoke_ext_tb" "core_smoke_ext_tb" ($CORE + @((Tb "tb_ext\core_smoke_ext_tb.v")))
Run-Test "soc_smoke_ext_tb" "soc_smoke_ext_tb" ($CORE + @(
    (Sim "instr_bram.v"), (Sim "data_bram.v"), (Sim "bus_interconnect.v"), (Sim "rv32i_soc_top.v"),
    (Tb "tb_ext\soc_smoke_ext_tb.v")))

# ------------------------------------------------------------------ compile-only top-levels
$AXI = $CORE + @((Rtl "bus\imem_axi_lite_adapter.v"), (Rtl "bus\dmem_axi_lite_adapter.v"), (Rtl "top\rv32i_axi_integration_top.v"))
$SOC = $CORE + @((Sim "instr_bram.v"), (Sim "data_bram.v"), (Sim "bus_interconnect.v"), (Sim "rv32i_soc_top.v"))

function Compile-Only {
    param([string]$Name, [string]$Top, [string[]]$Sources, [string[]]$Params = @())
    $out = Join-Path $BUILD "$Name.vvp"
    Write-Host "==> compile $Name"
    $compileArgs = @("-g2005-sv", "-Wall") + $Params + @("-o", $out, "-s", $Top) + $Sources
    & iverilog @compileArgs
    if ($LASTEXITCODE -ne 0) {
        Write-Host "FAIL: $Name (compile)"; $global:fail++; $global:faillist += "$Name(compile)"; return
    }
    $global:pass++
}

# AXI integration test: core -> 2 AXI-Lite adapter -> slave RAM. Bai DUY NHAT lai core
# qua adapter that (tap duong imem_cancel/core_ready). Luu y: comb-loop LUTLP-1 la
# hazard TONG HOP, sim event-driven khong phan biet duoc core cu vs da fix — guard dung
# la lint/DRC (Verilator UNOPTFLAT / Vivado report_drc), khong phai sim.
Run-Test "axi_integration_ext_tb" "axi_integration_ext_tb" ($AXI + @((Tb "tb_ext\axi_integration_ext_tb.v")))

Compile-Only "rv32i_axi_integration_top" "rv32i_axi_integration_top" $AXI
Compile-Only "rv32i_soc_top" "rv32i_soc_top" $SOC

# ------------------------------------------------------------------ summary
Write-Host ""
Write-Host "==================== SUMMARY ===================="
Write-Host "PASS: $($global:pass)   FAIL: $($global:fail)"
if ($global:fail -gt 0) {
    Write-Host "Failing: $($global:faillist -join ', ')"
    exit 1
}
Write-Host "All directed/unit/ext tests + top-level compile checks passed."
