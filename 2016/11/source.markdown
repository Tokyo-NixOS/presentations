% NixOS Install
% サニエ エリック
% 2016年11月22日 - Tokyo NixOS Meetup


# News

- [Open source conference Tokyo Fall](http://www.ospn.jp/press/20161114osc2016-tokyofall-report.html)
- [Better cross building](https://github.com/shlevy/cowsay-haskell)
- [Styx 0.3](https://styx-static.github.io/styx-site/), Nix based static site generator
- [Companies using NixOS](https://www.reddit.com/r/NixOS/comments/5dz8fp/list_of_companies_using_nixos/)


# NixOS

- [Why NixOS](http://nixos.org/nixos/about.html)


# Install

- Virtual Machine
    - VirtualBox recommended
- [Real machine](https://github.com/Tokyo-NixOS/Tokyo-NixOS-Meetup-Wiki/wiki/install)
- [VPS](https://github.com/Tokyo-NixOS/Tokyo-NixOS-Meetup-Wiki/wiki/vultr)


# Install flow

- Prepare the install media
- Partition the disk
- Configure
- Install


# Prepare the media

- [CD](http://nixos.org/nixos/download.html)
- [USB](http://nixos.org/nixos/manual/index.html#sec-booting-from-usb)
- [netboot](http://nixos.org/nixos/manual/index.html#sec-booting-from-usb)


# Prepare VirtualBox


# Boot the Install Media

- change keyboard layout

    ```sh
    # loadkeys jp106
    ```

- prevent log messages (optional)

    ```sh
    # sysctl -w kernel.printk="3 4 1 3"
    ```

- manual on TTY 8 (`ALT + F8`)


# Partitioning

- one single ext4 partition (5 ~ 20 GB)

    ```sh
    # fdisk /dev/sda
    ```

- create the filesystem

    ```sh
    # mkfs.ext4 /dev/sda1
    ```

- mount the partition

    ```sh
    # mount /dev/sda1 /mnt
    ```

# Pre-install

- Check the network

    ```sh
    # ping nixos.org -c3
    ```

- setup wifi (Laptop setups)

    ```sh
    # systemctl stop wpa_supplicant
    # wpa_supplicant -i wlpXs0 -c <(wpa_passphrase 'my-essid' 'pa$$w0rd')
    ```

- install an editor (`nano` available by default)

    - vim

        ```sh
        # nix-env -iA nixos.vim
        ```

    - emacs

        ```sh
        # nix-env -iA nixos.emacs
        ```

# Configuration


- Generate the config

    ```sh
    # nixos-generate-config --root /mnt
    ```

- Check the hardware config

    ```sh
    # less /mnt/etc/nixos/hardware-configuration.nix
    ```

- Edit the main config

    ```sh
    # nano /mnt/etc/nixos/configuration.nix
    ```

- Run the install


    ```sh
    # nixos-install
    ```

- Don't forget to set the root password at the end

- shutdown the machine


    ```sh
    # poweroff
    ```

- Remove the ISO image


# Booting NixOS


- Set `users.extraUsers` password (`Right Ctrl + F2` to switch to a console TTY, `Right Ctrl + F7` to switch back)

    ```sh
    # passwd USER
    ```

- Log in!


