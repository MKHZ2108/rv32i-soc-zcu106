# Chay riscv-tests chinh thuc tren rv32i_core, dung anh .hex DA BUILD SAN trong work\.
# KHONG can riscv-gcc: chi nap work\<test>.imem.hex (+ .dmem.hex neu co) qua plusargs.
# RTL nguon = imports\rtl chuan.
#
#   powershell -ExecutionPolicy Bypass -File run_official.ps1            # profile mac dinh
#   powershell -ExecutionPolicy Bypass -File run_official.ps1 -Wait      # them pass wait-stall

param([switch]$Wait)

$ErrorActionPreference = "Stop"

$iverilog = Get-Command iverilog -ErrorAction SilentlyContinue
if ($null -eq $iverilog) { $env:Path = $env:Path + ";C:\iverilog\bin" }

$OFF = $PSScriptRoot
$V = (Resolve-Path (Join-Path $OFF "..")).Path
$BUILD = Join-Path $V "build"
$WORK = Join-Path $OFF "work"
New-Item -ItemType Directory -Force -Path $BUILD | Out-Null
$RTL = (Resolve-Path (Join-Path $V "..\RISCV- RV32I.srcs\sources_1\imports\rtl")).Path
function Rtl($rel) { return (Join-Path $RTL $rel) }

# Core-only sources (khong bus/top) dung cho riscv_test_tb.
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

$sim = Join-Path $BUILD "official_sim.vvp"
Write-Host "==> compile riscv_test_tb"
& iverilog -g2005-sv -o $sim -s riscv_test_tb (Join-Path $OFF "riscv_test_tb.v") @CORE
if ($LASTEXITCODE -ne 0) { throw "BUILD ERROR (iverilog)" }

# Tap test core M-mode nay ho tro (khong PMP/trigger/supervisor/interrupt).
$RV32UI = @("add","addi","and","andi","auipc","beq","bge","bgeu","blt","bltu","bne","jal","jalr","lb","lbu","ld_st","lh","lhu","lui","lw","or","ori","sb","sh","simple","sll","slli","slt","slti","sltiu","sltu","sra","srai","srl","srli","st_ld","sub","sw","xor","xori")
$RV32MI = @("csr","scall","illegal","ma_addr","ma_fetch","lh-misaligned","lw-misaligned","sh-misaligned","sw-misaligned","shamt")

$tests = @()
foreach ($t in $RV32UI) { $tests += @{ Isa = "rv32ui"; Name = $t } }
foreach ($t in $RV32MI) { $tests += @{ Isa = "rv32mi"; Name = $t } }

$pass = 0; $fail = 0; $faillist = @(); $missing = @()

function Run-One($isa, $t, $extra, $tag) {
    $img = Join-Path $WORK "$t.imem.hex"
    $dmem = Join-Path $WORK "$t.dmem.hex"
    if (-not (Test-Path $img)) { return "MISSING" }
    $vvpArgs = @($sim, "+IMEM_HEX=$img", "+NAME=$isa-$t-$tag", "+MAX_CYCLES=200000")
    if ((Test-Path $dmem) -and ((Get-Item $dmem).Length -gt 0)) { $vvpArgs += "+DMEM_HEX=$dmem" }
    $vvpArgs += $extra
    $o = & vvp @vvpArgs 2>&1
    return ($o | Select-String -Pattern "PASS:|FAIL:" | ForEach-Object { $_.Line }) -join "`n"
}

foreach ($entry in $tests) {
    $out = Run-One $entry.Isa $entry.Name @() "fast"
    if ($out -eq "MISSING") { Write-Host "SKIP (no image): $($entry.Isa)-$($entry.Name)"; $missing += "$($entry.Isa)-$($entry.Name)"; continue }
    Write-Host $out
    if ($out -match "^PASS:") { $pass++ } else { $fail++; $faillist += "$($entry.Isa)-$($entry.Name)" }

    if ($Wait) {
        $out2 = Run-One $entry.Isa $entry.Name @("+IMEM_WAIT_PERIOD=3", "+DMEM_WAIT_PERIOD=2") "wait"
        if ($out2 -ne "MISSING") {
            Write-Host $out2
            if ($out2 -match "^PASS:") { $pass++ } else { $fail++; $faillist += "$($entry.Isa)-$($entry.Name)-wait" }
        }
    }
}

Write-Host ""
Write-Host "==================== OFFICIAL SUMMARY ===================="
Write-Host "PASS: $pass   FAIL: $fail   SKIP(missing image): $($missing.Count)"
if ($missing.Count -gt 0) { Write-Host "Missing: $($missing -join ', ')" }
if ($fail -gt 0) { Write-Host "Failing: $($faillist -join ', ')"; exit 1 }
Write-Host "All available official tests passed."
