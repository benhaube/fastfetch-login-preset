# Fastfetch Login Preset

![Screenshot](screenshots/fastfetch-login-preset.png)
![Screenshot Server](screenshots/fastfetch-server-login.png)

This is a preset for fastfetch that is intended to run on login when you open a terminal, or login to your server over SSH. It shows relavant system information and an ASCII logo of your operating system. 

**This preset requires a [Nerd Font](https://www.nerdfonts.com/) to be installed and set in your terminal to properly display the icons.**

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

# Install

1. Clone the Github repository:

    ```Bash
    wget https://github.com/benhaube/fastfetch-login-preset.git
    ```

2. Backup your `.bashrc` file in case you make a mistake:

    ```Bash
    cp .bashrc .bashrc.bkp
    ```

3. Enter the project directory:

    ```Bash
    cd fastfetch-login-preset/
    ```

4. Copy the file `login.jsonc` to the `/usr/share/fastfetch/presets/` directory and confirm fastfetch can see the preset:

    ```Bash
    sudo cp login.jsonc /usr/share/fastfetch/presets/
    fastfetch --list-presets
    ```
5. Go back to your `/home/user/` directory and edit the `.bashrc` file to add the `fastfetch` command:

    ```Bash
    cd
    nano .bashrc
    ```
6. Add the following to the end of your `.bashrc` file:

    ```Bash
    # Run the fastfetch command with the login.jsonc profile at login to show relavant system information
    fastfetch -c login
    ```
7. `Ctrl+O` and `Enter` to save the changes and `Ctrl+X` to close the file

Now you should be able to open a new terminal window or tab and see the `fastfetch` command run with the `login.jsonc` profile before you get your terminal prompt. 
