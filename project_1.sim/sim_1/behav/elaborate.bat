@echo off
set xv_path=C:\\Xilinx\\Vivado\\2015.2\\bin
call %xv_path%/xelab  -wto c597108db6c64997bb03d20fb49ac29b -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot tx_fifo_tb_behav xil_defaultlib.tx_fifo_tb -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
