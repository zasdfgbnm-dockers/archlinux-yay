FROM archlinux:base-devel

RUN pacman-key --init
RUN ls /usr/lib/sysusers.d/*.conf | /usr/share/libalpm/scripts/systemd-hook sysusers

COPY remove-pkg-cache.hook /etc/pacman.d/hooks/
COPY mirrorlist /etc/pacman.d/

RUN sed -i "s/#Color/Color/g" /etc/pacman.conf
RUN sed -i "s/DownloadUser/#DownloadUser/g" /etc/pacman.conf
RUN sed -i "s/NoProgressBar/#NoProgressBar/g" /etc/pacman.conf
COPY custom_repo.conf /
RUN cat /custom_repo.conf >> /etc/pacman.conf

RUN rm -rf /etc/pacman.d/gnupg
RUN pacman-key --init
RUN pacman-key --populate archlinux
RUN pacman -Sy --noconfirm archlinux-keyring

# https://www.archlinuxcn.org/archlinuxcn-keyring-manually-trust-farseerfc-key/
RUN pacman-key --lsign-key "farseerfc@archlinux.org"
RUN pacman -Sy --noconfirm archlinuxcn-keyring

RUN pacman -Syu --noconfirm
RUN pacman -Sy --noconfirm sudo yay

RUN echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
RUN useradd -m user; usermod -a -G wheel user

USER user
