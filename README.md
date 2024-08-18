# glim-flake

A flake for [glim](https://github.com/thias/glim) with a couple of customizations.

## Overview

I've Nixified the upstream glim script, so it should work out of the box on systems with Nix. I've also added a few customizations like enabling Secure Boot support and switching the default theme out for [Catppuccin Frappe](https://github.com/catppuccin/grub).

## Installation

Follow the upstream instructions for setting up your USB device.

Then, install glim to your USB by running `nix run github:Liassica/glim-flake`. You can override the theme or by adding this repo as a flake input and overriding the 'theme' input.

E.g, to use the Breeze GRUB theme:

```nix
{ pkgs, glim, ...}:
{
  environment.systemPackages = [
    glim.packages.x86_64-linux.glim.override {
      theme = "${pkgs.kdePackages.breeze-grub}/grub/themes/breeze";
    };
  ];
}
```

## Supported distros

<!-- prettier-ignore-start -->

[//]: # (distro-list-start)

* [`almalinux`](https://almalinux.org/) - _Live Media only_
* [`antix`](https://antixlinux.com/)
* [`arch`](https://archlinux.org/)
* [`artix`](https://artixlinux.org/)
* [`bodhi`](https://www.bodhilinux.com/)
* [`calculate`](https://wiki.calculate-linux.org/desktop)
* ~~[`centos`](https://www.centos.org/)~~ - _Live was discontinued_
* [`clonezilla`](https://clonezilla.org/)
* [`debian`](https://www.debian.org/CD/live/) - _live & `mini.iso`_
* [`elementary`](https://elementary.io/)
* [`fedora`](https://fedoraproject.org/)
* [`finnix`](https://www.finnix.org/)
* [`gentoo`](https://www.gentoo.org/)
* [`gparted`](https://gparted.org/)
* [`grml`](https://grml.org/)
* [`ipxe`](https://ipxe.org/) - _.iso or .efi_
* [`kali`](https://www.kali.org/)
* [`kubuntu`](https://kubuntu.org/)
* [`libreelec`](https://libreelec.tv/)
* [`linuxmint`](https://linuxmint.com/)
* [`lubuntu`](https://lubuntu.me/)
* [`manjaro`](https://manjaro.org/)
* [`memtest`](https://memtest.org/) - _Only .bin/.efi, not .iso_
* [`mxlinux`](https://mxlinux.org/)
* [`netrunner`](https://www.netrunner.com/)
* [`nixos`](https://nixos.org/)
* [`openbsd`](https://www.openbsd.org/)
* [`opensuse`](https://www.opensuse.org/) - _Live from Alternative Downloads only_
* [`peppermint`](https://peppermintos.com/)
* [`popos`](https://pop.system76.com/)
* [`porteus`](http://www.porteus.org/)
* [`rhel`](https://www.redhat.com/rhel) - _Installation only_
* [`rockylinux`](https://rockylinux.org/)
* [`slitaz`](https://slitaz.org/)
* [`supergrub2disk`](https://www.supergrubdisk.org/)
* [`systemrescue`](https://www.system-rescue.org/)
* [`tails`](https://tails.net/)
* [`ubuntubudgie`](https://ubuntubudgie.org/)
* [`ubuntu`](https://ubuntu.com/)
* [`void`](https://voidlinux.org/)
* [`xubuntu`](https://xubuntu.org/)
* [`zorinos`](https://zorin.com/os/)

[//]: # (distro-list-end)

<!-- prettier-ignore-end -->

## License

MIT, with the exception of some theme files. See the upstream repository's license for details.
