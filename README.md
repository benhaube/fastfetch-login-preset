# Fastfetch Login Preset

This is a preset for fastfetch that is intended to run on login when you open a terminal, or login to your server over SSH. It shows relavant system information and an ASCII logo of your operating system. 

Here is a list of the modules included with this preset:

+ title (user@hostname)
+ datetime (MMM dd, yyyy: hh:mm:ss timezone)
+ loadavg (1m, 5m, 15m)
+ processes
+ OS
+ kernel
+ uptime
+ packages
+ memory ({bar}{num}: {used} / {total})
+ swap ({bar}{num}: {used} / {total})
+ drives ({bar}{num}: {used} / {total} - {filesystem})
+ wifi ({bar}{num}: {SSID} - {frequency} {channel} - {encryption} - {Rx} {Tx})
+ localip ({device} - {IPv4} - {IPv6} - {MAC})
+ publicip ({IPv4} {location})
+ dns ({IPv4} {IPv6})
+ netio ({IN} - {OUT})

![Screenshot](screenshots/fastfetch-login-preset.png)

