APRIL 8th DADS getting married

# Arch Linux installation guide for cool ladies

## Partition schema

The system I will be installing this on is a Lenovo W550s, the system is a core i7 x86_64 architecture with the stock EFI system in-tact.

The root partition will be encrypted for at-rest privacy, with LVM configured for easy adjustment. The underlying filesystem will rung BTRFS for its Copy-On-Write (reduces space from duplication and modification), snapshotting, and deduplication features.

```none
50M vfat /efi
2G  ext4 /boot
%% LUKS volume
   ├─lmv-root 100%FREE (BTRFS)
   │ ├─@
   │ ├─@/root
   │ ├─@/opt
   │ ├─@/srv
   │ ├─@/home
   │ ├─@/usr/local
   │ ├─@/var/cache
   │ ├─@/var/spool
   │ ├─@/var/log
   │ ├─@/var/tmp
   │ ├─@/var/lib/containers
   │ ├─@/var/lib/libvirt
   │ └─@/.snapshots
   └─lvm-swap 16G (swap)
```

The ArchWiki refers to the partion sheme as LVM-On-LUKS, because the LVM PV is under the LUKS encryption.

The root BTRFS structure will allow us to create snapshots usng an application called `snapper` and is plotted to reduce frequently changing yet supurflus files from being included in the COW snapshots as well as retain log files for troubleshooting when we encounter a system issue which we would need to boot from an earlier snapshot.

### Creating the partion scheme

```shell
mkfs.vfat /dev/sda1                # format the efi system partiton 
mkfs.ext4 /dev/sda2                # format the boot partition with ext4
cryptsetup luksFormat /dev/sda3    # create the LUKS volume, this will ask for a password
cryptsetup luksOpen /dev/sda3 root # Open the LUKS volume in dm, this will ask for the password
pvcreate /dev/mapper/root          # Create an LVM Physical Volume on the LUKS volume
vgcreate lvm /dev/mapper/root      # Add the PV to a Volume Group called "lvm"
lvcreate lvm -L 16G -n swap        # Add a 16gig Logical Volume on the VG called "Swap"
lvcreate lvm -l 100%FREE -n root   # Make the remaining storage the root LV
mkswap /dev/lvm/swap               # format the swap LV for swapping
mkfs.btrfs /dev/lvm/root           # format the root LV with BTRFS
```

### Create btrfs subvolumes

Each subvolume created under the @ heirarchy will be ignored by snapper, since btrfs snapshots are per-subvolume. Snapper will use the heirarchy under `@/.snapshots` to store the snapshots it creates. A modification of the standard technique will be used to essentially pacstrap the system to the initial snapshot.

```shell
mount /dev/lvm/root /mnt # mount the BTRFS default partition on the ISO-FSHs /mnt
btrfs subvol create /mnt/@ # create the first subvolume, it will be the default by default (essencially naming the root)
btrfs subvol create /mnt/@/opt # FHS /opt exclusion subvol
btrfs subvol create /mnt/@/srv # FHS /srv exclusion subvol
btrfs subvol create /mnt/@/home # FHS /home exclusion subvol
btrfs subvol create /mnt/@/root # FHS /root exclusion subvol

# Create the /var/ directory structure and subsequent exclusion snapshots
mkdir -p /mnt/@/var/lib # Creat a directory tree
btrfs subvol create /mnt/@/var/log # /var/log exclusion, retains consistent logging information when loading different snapshots
btrfs subvol create /mnt/@/var/tmp # Excludes /var/tmp from snapshots
btrfs subvol create /mnt/@/var/spool # Excludes /var/spool from snapshots
btrfs subvol create /mnt/@/var/cache # Excludes /var/cache from snapshots
btrfs subvol create /mnt/@/var/lib/containers # Excludes /var/lib/containers from snapshots, contains podman container data
btrfs subvol create /mnt/@/var/lib/libvirt # Excludes /var/lib/libvirt from snapshots, contains virtualmachine data

# Create directory and /usr/local subvol
mkdir /mnt/@/usr; btrfs subvol create /mnt/@/usr/local

btrfs subvol create /mnt/@/.snapshots # Subvol for snapper snapshots
```

At this stage we should also disable Copy-on-Write functionality for the `/var` tree as data stored there tends to be random writes, especially to virtual machine image files. Random writes on a COW enabled filesystem will lead to performance issues due to fragmentation.

```shell
chattr +C /mnt/@/var/lib/containers
chattr +C /mnt/@/var/lib/libvirt
chattr +C /mnt/@/var/cache
chattr +C /mnt/@/var/spool
chattr +C /mnt/@/var/log
chattr +C /mnt/@/var/tmp
```

Finally, unmount the b-tree filesystem

```shell
umount -r /mnt
```

### Remount and Create the filesystem heirarchy

```shell
# Mount the default subvolume to /mnt
mount /dev/lvm/root -o defaults,noatime,compress=zstd,commit=120 /mnt

# Create tree
mkdir -pv /mnt/{.snapshots,efi,boot,root,opt,srv,tmp,home,usr/local,var/{cache,spool,log,tmp,lib/{containers,libvirt}}}

# Mount the filesystems and subvolumes
mount /dev/sda1 /mnt/efi
mount /dev/sda2 /mnt/boot
mount /dev/lvm/root -o defaults,noatime,compress=zstd,commit=120,subvol=@/srv /mnt/srv
mount /dev/lvm/root -o defaults,noatime,compress=zstd,commit=120,subvol=@/opt /mnt/opt
mount /dev/lvm/root -o defaults,noatime,compress=zstd,commit=120,subvol=@/root /mnt/root
mount /dev/lvm/root -o defaults,noatime,compress=zstd,commit=120,subvol=@/usr/local /mnt/usr/local
mount /dev/lvm/root -o defaults,noatime,compress=zstd,commit=120,subvol=@/var/cache /mnt/var/cache
mount /dev/lvm/root -o defaults,noatime,compress=zstd,commit=120,subvol=@/var/spool /mnt/var/spool
mount /dev/lvm/root -o defaults,noatime,compress=zstd,commit=120,subvol=@/var/log /mnt/var/log
mount /dev/lvm/root -o defaults,noatime,compress=zstd,commit=120,subvol=@/var/tmp /mnt/var/tmp
mount /dev/lvm/root -o defaults,noatime,compress=zstd,commit=120,subvol=@/var/lib/containers /mnt/var/lib/containers
mount /dev/lvm/root -o defaults,noatime,compress=zstd,commit=120,subvol=@/var/lib/libvirt /mnt/var/lib/libvirt
mount /dev/lvm/root -o defaults,noatime,compress=zstd,commit=120,subvol=@/.snapshots /mnt/.snapshots
```

## Pacstrap the installation

### Basic Shell and system utils

```shell
pacstrap /mnt base base-devel linux linux-headers \
   linux-firmware intel-ucode btrfs-progs ntfs-3g sudo \
   podman podman-docker podman-compose podman-dnsname \
   neovim grub networkmanager efibootmgr snapper snap-pac zsh acpi \
   man-db man-pages texinfo nftables grub-btrfs openssh \
   starship neofetch reflector git curl wget lvm2 btrfs \
   zram-generator rsync
```

### Graphical environment

```shell
pacstrap /mnt plasma-meta plasma-wayland-session \
   wl-clipboard egl-wayland \
   kde-graphics-meta kde-multimedia-meta \
   kde-network-meta kde-pim-meta kde-pim-meta \
   kde-utilities-meta \
   sddm sddm-kcm
```

### General graphical utilities

```shell
pacstrap /mnt vivaldi vivaldi-ffmpeg-codecs code discord
```

## Generate and modify the Filesystem Table

The block below will generate the Filesystem Table used to instruct the init system where to mount partitions.

```shell
genfstab -U /mnt > /mnt/etc/fstab
```

## Configure the system

We'll now want to jump into the new system's environment using `arch-chroot /mnt`

This first section will set the hostname, timezone, systemclock, and locale

```shell
# Set the system hostname
echo "w550-0g0x7p.zynthovian.xyz" > /etc/hostname
# Configure hosts file
cat <<EOF > /etc/hosts
# IPv6
::1 localhost
::1 w550-0g0x7p
# IPv4
127.0.0.1 localhost
127.0.0.1 w550-0g0x7p
EOF
# Set the system timezone
ln -sf /usr/share/zoneinfo/America/Detroit /etc/localtime
# Set the system clock to UTC
hwclock --systohc
# Set the system locale and generate it
LANG_CODE="en_US.UTF-8"
sed "/${LANG_CODE}/s/^#//" -i /etc/locale.gen
echo "LANG=${LANG_CODE}" > /etc/locale.conf
locale-gen
```

Next, set the root password and create a user account for yourself

```shell
useradd -mG wheel -c "Elliana Perry" -s $(which zsh) elliana # Create your user account
passwd root # set the password for the root account.
passwd elliana # Set user account password
echo "elliana ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/elliana # Allow your user to use sudo without a password, takes too much time lol
```

Enable desired systemd units

```shell
# This will enable the Network Manager, SSHd, and systemd out-of-memory killer daemon
systemctl enable \
   NetworkManager.service \
   systemd-timesyncd.service \
   systemd-oomd.service \
   sshd.service

# If we want a plasma graphical environment
systemctl enable ssdm.service

# Alternatively a grup environment
systemctl enable gdm.service
```

### Pacman

```shell
sed 's/^#Color/Color/;s/^#ParallelDownloads/ParallelDownloads/' -i /etc/pacman.conf

```

### Swap on ZRAM

```shell
echo <<EOF > /etc/systemd/zram-generator.conf
[zram0]
zram-size = min(ram / 5, 4096)
compression-algorithm = zstd
[zram1]
zram-size = min(ram / 2, 4096)
compression-algorithm = zstd
mount-point = /tmp
fs-type = ext2
```

## Boot process

At this stage, we are not able to boot our system from the main drive. There is no bootloader executable installed on the efi partition. Earlier, we did strap the GRUB into the system but this did not *install* grub to the system, only gave us the tools to do so.

Install the Grand Unified BootLoader for UEFI and BTRFS.

```shell
# Install The GRUB
grub-install --target=x86_64-efi --efi-directory=/efi --boot-directory /boot --bootloader-id=Arch-Linux \
   --modules="normal test efi_gop efi_uga search echo linux all_video gfxmenu gfxterm_background gfxterm_menu gfxterm loadenv configfile gzio part_gpt btrfs"
```

Before we generate the GRUB configuration file, two files will need modification. `/etc/mkinitcpio.conf` needs to be modified to build a linux initramfs capable of unlocking the encrypted root partition. `/etc/default/grub` needs to inform the linux kernel to actually attempt to unlock the encrypted filesystem before continuing to scan and mount partitions. 

`/etc/mkinitcpio.conf`

```ini
BINARIES=(btrfs)
HOOKS=(base udev autodetect keyboard keymap consolefont modconf block encrypt lvm2 filesystems fsck)
```

You will need to get the UUID of the LUKS partition, mine is `1767261d-ac73-436d-bb3f-2d3987be41e4`. This can be gotten with `lsblk -f`.

`/etc/default/grub`

```ini
cryptdevice=UUID=1767261d-ac73-436d-bb3f-2d3987be41e4:cryptlvm
```

Now that the two files have been modified we need to do the following.

```shell
# Rebuild the Linux initramfs
mkinitcpio -p linux
# Generate GRUB Config
grub-mkconfig -o /boot/grub/grub.cfg
```

At this point we are able to exit the chroot environment and reboot into the arch system. There should be an EFI boot entry called `Arch-Linux`.

## Install an AUR helper

An AUR helper is an application that makes use of the API of the Arch User Repository to download, build, install, and transact applcication packages maintainded by the user community.

I am going to use the helper `paru` as it is written in rust and rust is pretty cool :shades:

```shell
# Install dependencies
pacman -S asp bat devtools rust rustup
# Clone the Paru AUR repo
git clone https://aur.archlinux.org/paru.git /tmp/paru
# Build and install
cd /tmp/paru
makepkg -sic
```

## GRUB Customization

### Menu Entries

I like the ability to, in an emergency, boot the installation ISO to repare a broken system in a pinch, that is why the `/boot/` partition is relatively large.

You'll need to download and verify the archlinux installation ISO to `mkdir /boot/iso`.

Then append the following to `/etc/grub.d/40_custom`

```
menuentry '[loopback] Arch ISO' {
	set isofile='/boot/iso/archlinux-2022.10.01-x86_64.iso'
	loopback loop $isofile
	linux (loop)/arch/boot/x86_64/vmlinuz-linux img_dev=$imgdevpath img_loop=$isofile earlymodules=loop
	initrd (loop)/arch/boot/intel-ucode.img (loop)/arch/boot/amd-ucode.img (loop)/arch/boot/x86_64/initramfs-linux.img
}
menuentry '[loopback] Arch ISO Memtest' {
	set isofile='/boot/iso/archlinux-2022.10.01-x86_64.iso'
	loopback loop $isofile
	linux16 (loop)/arch/boot/memtest
}
```

You will then need to regenerate the grub configuration: `grub-mkconfig -o /boot/grub/grub.cfg`

### GRUB Themes

## Configure Snapper

The following will generate a configuration for snapper to work on the root partition, we need to unmount the `@/.snapshots` subvolume and remove the `/.snapshots` directory beforehand.

```shell
umount /.snapshots
rm -r /.snapshots
snapper -c root create-config / # init snapper
btrfs subvolume delete /.snapshots # Delete snappers subvolume
mkdir /.snapshots # Recreate snapshots dir
mount -a # Remount all filesystems
chmod 750 /.snapshots # Correct permissions
```

## Create the initial system snapshot

```shell
sudo snapper create \
   --description "System Installation Snapshot" \
   --type single
```
