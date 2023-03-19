Run "C:\Program Files\Lenovo\LenovoOTP64\LenovoOTP64.exe",,, &PID
sleep 500
Run "C:\Program Files\Lenovo\LenovoOTP64\LenovoOTP64.exe",,, &PID
WinWait "ahk_exe LenovoOTP64.exe" ; Wait for it to appear.
ControlSend "904241{Enter}", "Edit1"
