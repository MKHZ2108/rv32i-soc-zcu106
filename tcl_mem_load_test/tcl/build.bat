@echo off
setlocal

REM ===========================================================================
REM build.bat - BIEN DICH FILE .s -> .elf -> .mem
REM
REM   build.bat                 -> main.s      -> firmware.elf / firmware.mem
REM   build.bat test_cpu.s      -> test_cpu.s  -> test_cpu.elf / test_cpu.mem
REM   build.bat test_uart.s     -> test_uart.s -> test_uart.elf / test_uart.mem
REM   build.bat test_uart_irq.s -> test UARTLite -> AXI INTC -> core interrupt
REM   build.bat test_uart_calculator.s -> UART calculator (A, op, B)
REM
REM Khong tham so thi mac dinh main.s (giu thoi quen double-click nhu cu,
REM va van sinh ra dung ten firmware.mem ma load_imem.tcl doc mac dinh).
REM ===========================================================================

set GCC_PATH=C:\riscv\bin\riscv-none-elf-gcc.exe
set OBJ_PATH=C:\riscv\bin\riscv-none-elf-objcopy.exe

REM --- Chon file nguon -------------------------------------------------------
if "%~1"=="" (
    set SRC=main.s
    set OUT=firmware
) else (
    set SRC=%~1
    set OUT=%~n1
)

if not exist "%SRC%" (
    echo.
    echo [LOI] Khong tim thay file nguon "%SRC%"
    echo.
    pause
    exit /b 1
)

echo ===================================================
echo   Nguon : %SRC%
echo   Dich  : %OUT%.elf  /  %OUT%.mem
echo ===================================================
echo.

echo [1/2] Dang bien dich %SRC% ...
"%GCC_PATH%" -nostdlib -nostartfiles -Ttext 0x00000000 -march=rv32i_zicsr -mabi=ilp32 -mno-relax "%SRC%" -o "%OUT%.elf"

if %errorlevel% neq 0 (
    echo.
    echo [LOI] Bien dich GCC that bai! Kiem tra lai file %SRC%
    pause
    exit /b %errorlevel%
)

echo [2/2] Dang chuyen doi sang %OUT%.mem ...
"%OBJ_PATH%" -O verilog "%OUT%.elf" "%OUT%.mem"

if %errorlevel% neq 0 (
    echo.
    echo [LOI] Chuyen doi objcopy that bai!
    pause
    exit /b %errorlevel%
)

echo.
echo ===================================================
echo   BIEN DICH THANH CONG: %OUT%.mem da san sang.
echo ===================================================
echo.
echo   Nap trong Vivado Tcl Console:
if "%OUT%"=="firmware" (
    echo       source load_imem.tcl
) else (
    echo       set ::rv_mem_file "%OUT%.mem"
    echo       source load_imem.tcl
)
echo.
pause
