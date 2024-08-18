{
  lib,
  coreutils-full,
  gnugrep,
  grub2_efi,
  rsync,
  util-linux,
  writeShellScriptBin,
  theme,
}:
let
  cfg = ../../grub2;
in
writeShellScriptBin "glim" ''
  shopt -s expand_aliases

  export PATH=${
    lib.makeBinPath [
      coreutils-full
      gnugrep
      grub2_efi
      rsync
      util-linux
    ]
  }:''$PATH

  # Check that we are *NOT* running as root
  if [[ `id -u` -eq 0 ]]; then
    echo "ERROR: Don't run as root, use a user with full sudo access."
    exit 1
  fi

  # Use alternative if sudo is not found
  if [[ ! `which sudo &>/dev/null` ]]; then
    if which doas &>/dev/null; then
      alias sudo=doas
    else
      sudo () {
        su -c "$*"
      }
    fi
  fi

  # Find GLIM device (use the first if multiple found, you've asked for trouble!)
  USBDEV1=`blkid -L GLIM | head -n 1`

  # Sanity check : we found one partition to use with matching label
  if [[ -z "$USBDEV1" ]]; then
    echo "ERROR: no partition found with label 'GLIM', please create one."
    exit 1
  fi
  echo "Found partition with label 'GLIM': ''${USBDEV1}"

  # Sanity check : our partition is the first and only one on the block device
  USBDEV=''${USBDEV1%1}
  if [[ ! -b "$USBDEV" ]]; then
    echo "ERROR: ''${USBDEV} block device not found."
    exit 1
  fi
  echo "Found block device where to install GRUB2: ''${USBDEV}"
  if [[ `ls -1 ''${USBDEV}* | wc -l` -ne 2 ]]; then
    echo "ERROR: ''${USBDEV1} isn't the only partition on ''${USBDEV}"
    exit 1
  fi

  # Sanity check : our partition is mounted
  if ! grep -q -w ''${USBDEV1} /proc/mounts; then
    echo "ERROR: ''${USBDEV1} isn't mounted"
    exit 1
  fi
  USBMNT=`grep -w ''${USBDEV1} /proc/mounts | cut -d ' ' -f 2`
  if [[ -z "$USBMNT" ]]; then
    echo "ERROR: Couldn't find mount point for ''${USBDEV1}"
    exit 1
  fi
  echo "Found mount point for filesystem: ''${USBMNT}"

  # Sanity check : human will read the info and confirm
  read -n 1 -s -p "Ready to install GLIM. Continue? (y/n) " PROCEED
  if [[ "$PROCEED" == "n" ]]; then
    echo "n"
    exit 2
  else
    echo "y"
  fi

  # Install GRUB2
  GRUB_TARGET="--target=x86_64-efi --efi-directory=''${USBMNT} --removable --modules=tpm --disable-shim-lock"
  echo "Running grub-install ''${GRUB_TARGET} --boot-directory=''${USBMNT}/boot (with sudo)..."
  sudo grub-install ''${GRUB_TARGET} --boot-directory=''${USBMNT}/boot ''${USBDEV}
  if [[ $? -ne 0 ]]; then
    echo "ERROR: grub-install returned with an error exit status."
    exit 1
  fi

  # Copy GRUB2 configuration
  echo "Running rsync -rt --delete --exclude=i386-pc --exclude=x86_64-efi --exclude=fonts ${cfg}/ ''${USBMNT}/boot/grub ..."
  rsync -rt --delete --exclude=i386-pc --exclude=x86_64-efi --exclude=fonts ${cfg}/ ''${USBMNT}/boot/grub
  if [[ $? -ne 0 ]]; then
    echo "ERROR: the rsync copy returned with an error exit status."
    exit 1
  fi

  # Set up theme
  echo "Copying theme..."
  rsync -rt --delete ${theme}/ ''${USBMNT}/boot/grub/themes/theme
  if [[ $? -ne 0 ]]; then
    echo "ERROR: the rsync copy returned with an error exit status."
    exit 1
  fi

  # Be nice and pre-create the directory, and mention it
  [[ -d ''${USBMNT}/boot/iso ]] || mkdir ''${USBMNT}/boot/iso
  echo "GLIM installed! Time to populate the boot/iso/ sub-directories."

  # Now also pre-create all supported sub-directories since empty are ignored
  args=(
    -E -n
    '/\(distro-list-start\)/,/\(distro-list-end\)/{s,^\* \[`([a-z0-9]+)`\].*$,\1,p}'
  )

  for DIR in $(sed "''${args[@]}" "${../../README.md}"); do
    [[ -d ''${USBMNT}/boot/iso/''${DIR} ]] ||  mkdir ''${USBMNT}/boot/iso/''${DIR}
  done
''
