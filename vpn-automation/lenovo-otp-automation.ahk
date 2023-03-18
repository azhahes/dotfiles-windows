Run "C:\Program Files\Lenovo\LenovoOTP64\LenovoOTP64.exe",,, &PID
sleep 2000
Run "C:\Program Files\Lenovo\LenovoOTP64\LenovoOTP64.exe",,, &PID
WinWait "ahk_exe LenovoOTP64.exe" ; Wait for it to appear.
WinActivate
sleep 2000
ControlSend "904241{Enter}", "Edit1"
