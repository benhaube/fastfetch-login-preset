<p align="center">
    <img src="assets/icons/square-terminal.png" alt="Project logo">
</p>
<p>
<h1 align="center">
    Fastfetch Login Preset
</h1>
</p>

### About

This is a preset for Fastfetch that is intended to run on login when you open a terminal, or login to your server over SSH. It shows relevant system information and an ASCII logo of your operating system. 

> [!note]
> *You can change the colors of the presets to match your distribution. Currently, they are cyan to match fedora.*
> 
> *This preset requires a [Nerd Font](https://www.nerdfonts.com/) to be installed and set in your terminal to properly display the icons.*
> 
> *If you are using a mobile device (such as a laptop) you can use the `login-mobile.jsonc` preset instead to show power adaptor and battery information.*
> 
> *If your computer does not have an active Wi-Fi connection you can use the `login-no-wifi.jsonc` preset.*

### Screenshots

<p align=center>
    <img src="assets/screenshots/fastfetch-login.png" alt="Screenshot of the fastfetch login preset" width="800">
    <img src="assets/screenshots/fastfetch-login-mobile.png" alt="Screenshot of the fastfetch login mobile preset" width="800">
    <img src="assets/screenshots/fastfetch-login-zimaos.png" alt="Screenshot of the fastfetch login zimaos preset" width="800">
    <img src="assets/screenshots/fastfetch-login-zimaos-large.png" alt="Screenshot of the fastfetch login zimaos preset with large ASCII logo" width="800">
</p>

### Install

1. Clone the Github repository:

    ```Bash
    git clone https://github.com/benhaube/fastfetch-login-preset.git
    ```
2. Install `fastfetch` if you have not already:

    + Fedora/RHEL based distributions:

        ```Bash
        sudo dnf install fastfetch
        ```
    + Debian/Ubuntu based distributions:

        ```Bash
        sudo apt install fastfetch
        ```
    + Visit the `fastfetch` [Github](https://github.com/fastfetch-cli/fastfetch.git) repository if it is not available in your distribution's package manager. 

3. Backup your `.bashrc` file in case you make a mistake:

    ```Bash
    cp .bashrc .bashrc.bkp
    ```

4. Enter the project directory:

    ```Bash
    cd fastfetch-login-preset/
    ```

5. Copy the file `login.jsonc` to the `/usr/share/fastfetch/presets/` directory and confirm fastfetch can see the preset:

    ```Bash
    sudo cp login.jsonc /usr/share/fastfetch/presets/
    fastfetch --list-presets
    ```
6. Go back to your `/home/user/` directory and edit the `.bashrc` file to add the `fastfetch` command:

    ```Bash
    cd
    nano .bashrc
    ```
7. Add the following to the end of your `.bashrc` file:

    ```Bash
    # Run the fastfetch command with the login.jsonc profile at login to show relavant system information
    fastfetch -c login
    ```
8. `Ctrl+O` and `Enter` to save the changes and `Ctrl+X` to close the file

Now you should be able to open a new terminal window or tab and see the `fastfetch` command run with the `login.jsonc` profile before you get your terminal prompt. 

### ZimaOS

#### Install Fastfetch

1. On another PC, download the latest release from the Fastfetch [GitHub repo](https://github.com/fastfetch-cli/fastfetch) for your ZimaOS system's architecture:

    ``` bash
    # Set the `FF_VERSION` variable for the latest release
    FF_VERSION=2.70.0  # Check the latest version on the releases page
    
    # For x86_64
    wget https://github.com/fastfetch-cli/fastfetch/releases/download/$FF_VERSION/fastfetch-linux-amd64.tar.gz 

    # For arm64
    wget https://github.com/fastfetch-cli/fastfetch/releases/download/$FF_VERSION/fastfetch-linux-aarch64.tar.gz
    ``` 

2. Transfer the downloaded tarball to the `/tmp` directory on your server:

    ``` bash
    # For x86_64
    scp fastfetch-linux-amd64.tar.gz admin@server-ip:/tmp
    
    # For arm64
    scp fastfetch-linux-aarch64.tar.gz admin@server-ip:/tmp
    ```

3. Log into your ZimaOS server via SSH as the `admin` user, and enter the `/tmp` directory. 

    ``` bash
    cd /tmp
    ```

4. Unpack the archive: 

    ``` bash
    # For x86_64
    tar -xvf fastfetch-linux-amd64.tar.gz

    # For arm64
    tar -xvf fastfetch-linux-aarch64.tar.gz
    ```

5. Copy the contents to the `/opt` directory: 

    ``` bash
    # For x86_64
    sudo cp -r fastfetch-linux-amd64/usr /opt

    # For arm64
    sudo cp -r fastfetch-linux-aarch64/usr /opt
    ```

6. Make sure the `/opt/bin` directory is listed as a binary path on your system _(it should be)_: 

    ``` bash
    echo $PATH | tr ":" "\n"
    ```

7. If you do not see `/opt/bin` in the output, then add the following line to your `~/.bashrc` file:

    ``` bash
    # Open `.bashrc` in `nano` text editor
    sudo nano /DATA/.bashrc

    # Add this line
    export PATH=/opt/bin:$PATH

    # Use `Ctrl+O` to save and `Ctrl+X` to exit `nano`
    ```

8. Run the `fastfetch` command to make sure it is working.

#### Add Login Preset

1. Still in the `/tmp` directory, clone my [GitHub repo](https://github.com/benhaube/fastfetch-login-preset):

    ``` bash
    git clone https://github.com/benhaube/fastfetch-login-preset.git
    ```

3. Copy the `login-zimaos.jsonc` preset file into the `/opt/share/fastfetch/presets` directory

    ``` bash
    sudo cp fastfetch-login-preset/login-zimaos/login-zimaos.jsonc /opt/share/fastfetch/presets
    ``` 

4. Create the `/opt/share/fasfetch/logos` directory and copy the `zimaos.txt` ASCII logo file into it

    ``` bash
    sudo mkdir /opt/share/fastfetch/logos
    sudo cp fastfetch-login-preset/login-zimaos/zimaos.txt /opt/share/fastfetch/logos
    ```

5. Run the command `fastfetch -c login-zimaos` to test the new preset.
6. Add that same command to the bottom of your `.bashrc` file to print the preset on every login: 

    ``` bash
    # Open `.bashrc` in `nano` text editor
    sudo nano /DATA/.bashrc

    # Add this command at the bottom of the file
    fastfetch -c login-zimaos

    # Use `Ctrl+O` to save and `Ctrl+X` to exit `nano`
    # Reload Bash
    source /DATA/.bashrc
    ```

Congratulations! Now you will see a custom Fastfetch preset showing relevant system information every time you log into your ZimaOS server. 

> [!tip]
> To use the version with the large ASCII logo, replace the file names in the copy commands with `login-zima-large.jsonc` and `zimaos-large.txt`. You can also copy both versions if you want to have an option.