Run "C:\Program Files\Lenovo\LenovoOTP64\LenovoOTP64.exe",,, &PID
WinWait "ahk_exe LenovoOTP64.exe" ; Wait for it to appear.
sleep 2000
ControlClick "x317 y57", "ahk_exe LenovoOTP64.exe"
