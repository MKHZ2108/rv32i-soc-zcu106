$ErrorActionPreference = "Stop"

# Mini architectural signature tests. Nap chuong trinh .hex vao core, chay N chu ky,
# so sanh cac gia tri ky vong (qua plusargs) voi ket qua. RTL nguon = imports\rtl chuan.

$iverilog = Get-Command iverilog -ErrorAction SilentlyContinue
if ($null -eq $iverilog) { $env:Path = $env:Path + ";C:\iverilog\bin" }

$ARCH = $PSScriptRoot
$V = (Resolve-Path (Join-Path $ARCH "..")).Path
$BUILD = Join-Path $V "build"
New-Item -ItemType Directory -Force -Path $BUILD | Out-Null
$RTL = (Resolve-Path (Join-Path $V "..\RISCV- RV32I.srcs\sources_1\imports\rtl")).Path
function Rtl($rel) { return (Join-Path $RTL $rel) }

$sources = @(
    (Rtl "accel\ripple_adder.v"),
    (Rtl "core\units\pc_unit.v"), (Rtl "core\stages\if_stage.v"), (Rtl "core\regs\if_id_reg.v"),
    (Rtl "core\units\decoder.v"), (Rtl "core\units\imm_gen.v"), (Rtl "core\units\control_unit.v"),
    (Rtl "core\units\csr_file.v"), (Rtl "core\regs\reg_file.v"), (Rtl "core\stages\id_stage.v"),
    (Rtl "core\regs\id_ex_reg.v"), (Rtl "core\units\forwarding_unit.v"), (Rtl "core\units\branch_unit.v"),
    (Rtl "core\units\alu.v"), (Rtl "core\stages\ex_stage.v"), (Rtl "core\regs\ex_mem_reg.v"),
    (Rtl "core\stages\mem_stage.v"), (Rtl "core\regs\mem_wb_reg.v"), (Rtl "core\stages\wb_stage.v"),
    (Rtl "core\units\hazard_unit.v"), (Rtl "core\units\trap_unit.v"), (Rtl "core\rv32i_core.v"),
    (Join-Path $ARCH "arch_mini_core_tb.v")
)

$out = Join-Path $BUILD "arch_mini_core_tb.vvp"
& iverilog -g2005-sv -Wall -o $out -s arch_mini_core_tb @sources
if ($LASTEXITCODE -ne 0) { throw "iverilog failed for mini arch testbench" }

$tests = @(
    @{ Name = "rv32i_alu"; Program = "rv32i_alu.hex"; Expect = @("0000000c","00000002","00000005","00000007","00000002","00000014","0000000a","fffffffc") },
    @{ Name = "rv32i_branch_load"; Program = "rv32i_branch_load.hex"; Expect = @("00000011","00000001") },
    @{ Name = "rv32i_mem_byte_half"; Program = "rv32i_mem_byte_half.hex"; Expect = @("12807fff","12807fff","ffffffff","000000ff","00007fff","00001280") },
    @{ Name = "rv32i_jump_auipc"; Program = "rv32i_jump_auipc.hex"; Expect = @("0000000c","00000030","00000020","0000000c","00000000","00000000","00000000") },
    @{ Name = "rv32i_branch_matrix"; Program = "rv32i_branch_matrix.hex"; Expect = @("0000003f") },
    @{ Name = "rv32i_csr"; Program = "rv32i_csr.hex"; Expect = @("00000000","00000080","00000000","0000001f","0000001f","0000001f","00000010") },
    @{ Name = "rv32i_csr_warl_forward"; Program = "rv32i_csr_warl_forward.hex"; Expect = @("40000100","40000100","40000100","00001800","00001800") },
    @{ Name = "rv32i_csr_alias_forward"; Program = "rv32i_csr_alias_forward.hex"; Expect = @("12345678") },
    @{ Name = "rv32i_trap_illegal"; Program = "rv32i_trap_illegal.hex"; Expect = @("00000002","00000018","ffffffff","00000055","00000000","00000000","00000000","00000000") },
    @{ Name = "rv32i_trap_mtvec_forward"; Program = "rv32i_trap_mtvec_forward.hex"; Expect = @("00000002","00000020","00000066") },
    @{ Name = "rv32i_trap_mret"; Program = "rv32i_trap_mret.hex"; Expect = @("00000002","00000010","ffffffff","00000044","00000000") },
    @{ Name = "rv32i_trap_misaligned_load"; Program = "rv32i_trap_misaligned_load.hex"; Expect = @("00000004","00000010","00010002","00000000","00000000") },
    @{ Name = "rv32i_trap_misaligned_store"; Program = "rv32i_trap_misaligned_store.hex"; Expect = @("00000006","00000014","00010002","00000000") },
    @{ Name = "rv32i_trap_load_access"; Program = "rv32i_trap_load_access.hex"; Expect = @("00000005","00000010","00020000","00000000","00000000") },
    @{ Name = "rv32i_trap_store_access"; Program = "rv32i_trap_store_access.hex"; Expect = @("00000007","00000014","00020000","00000000") }
)

$imemWaitPeriods = @(0, 3)
$pass = 0; $fail = 0; $faillist = @()

foreach ($test in $tests) {
    foreach ($imemWaitPeriod in $imemWaitPeriods) {
        $runName = $test.Name
        if ($imemWaitPeriod -ne 0) { $runName = "$($test.Name)_imemwait" }
        Write-Host "==> $runName"
        $progPath = Join-Path $ARCH (Join-Path "programs" $test.Program)
        $programWords = (Get-Content -Path $progPath | Where-Object { $_.Trim() -ne "" }).Count
        $vvpArgs = @($out, "+NAME=$runName", "+PROGRAM=$progPath", "+PROGRAM_WORDS=$programWords", "+CYCLES=260", "+NUM_EXPECT=$($test.Expect.Count)")
        if ($imemWaitPeriod -ne 0) { $vvpArgs += "+IMEM_WAIT_PERIOD=$imemWaitPeriod" }
        for ($i = 0; $i -lt $test.Expect.Count; $i++) { $vvpArgs += "+EXPECT$i=$($test.Expect[$i])" }
        $simOutput = & vvp @vvpArgs 2>&1
        $simOutput | ForEach-Object { Write-Host $_ }
        if ($LASTEXITCODE -ne 0 -or ($simOutput -match "FAIL:")) { $fail++; $faillist += $runName } else { $pass++ }
    }
}

Write-Host ""
Write-Host "==================== ARCH SUMMARY ===================="
Write-Host "PASS: $pass   FAIL: $fail"
if ($fail -gt 0) { Write-Host "Failing: $($faillist -join ', ')"; exit 1 }
Write-Host "All mini arch tests passed."
