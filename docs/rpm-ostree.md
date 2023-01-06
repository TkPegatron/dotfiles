# RPM-OSTree (Fedora Silverblue / CoreOS)

I wanted a workstation designed around moderate stability and moderate bleeding edge. Fedora has been trustworthy in this endevour, more than others anyhow.

I like the idea of an immutable root, even though rpm-ostree can feel sluggish. Here, I will be documenting my journey through installation and usage.

It will be necessary to add the flathub repository to the configuration, mainly to get steam but there are plenty of useful utilities and other applications.

```shell
# Adding flatpak remotes
flatpak remote-add --if-not-exists fedora oci+https://registry.fedoraproject.org
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak update --appstream

# Install flatpak apps, (gaming, coding, writing)
flatpak install \
  com.visualstudio.code \
  com.github.tchx84.Flatseal \
  flathub org.libreoffice.LibreOffice \
  com.valvesoftware.Steam \
  org.videolan.VLC \
  com.valvesoftware.Steam.CompatibilityTool.Proton \
  com.valvesoftware.Steam.CompatibilityTool.Proton-GE \
  com.valvesoftware.Steam.Utility.MangoHud \
  com.valvesoftware.Steam.Utility.gamescope \
  com.valvesoftware.Steam.Utility.protontricks
```


```shell
sudo vi /etc/rpm-ostreed.conf
rpm-ostree reload
systemctl enable rpm-ostreed-automatic.timer --now



# Add the RPMFusion repositories
sudo rpm-ostree install \
  https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm \
  https://downloads.vivaldi.com/stable/vivaldi-stable-5.6.2867.50-1.x86_64.rpm

# Install Vivaldi Browser, it's my chromium of choice :P


# Install additional packages
rpm-ostree install \
  zsh exa bat htop \
  skim stow 
```

flatpak list --columns application > /run/media/elliana/ISOHAULER/flatpak_installed.txt

curl -sS https://starship.rs/install.sh | sh




In one go, this will layer all of the packages I like to have in my running-system:

```sh
# Enable RPM Fusion repositories
rpm-ostree install rpmfusion-free-release rpmfusion-nonfree-release
# Enable the Vivaldi repository
sudo curl -so /etc/yum.repos.d/vivaldi-fedora.repo https://repo.vivaldi.com/archive/vivaldi-fedora.repo
# Userspace applications
rpm-ostree install \
  bat zsh exa code direnv skim \
  kffmpegthumbnailer kubernetes-client latte-dock \
  yt-dlp syncthing steam-devices stow vivaldi-stable \
  yakuake

# Baremetal Optimizations
rpm-ostree override remove \
  open-vm-tools open-vm-tools-desktop qemu-guest-agent \
  spice-vdagent spice-webdavd virtualbox-guest-additions
```

OSTREEd config

```ini
[Daemon]
AutomaticUpdatePolicy=check
```

systemctl enable rpm-ostreed-automatic.timer --now
