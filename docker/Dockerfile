FROM archlinux:latest

RUN pacman -Syu --noconfirm \
    && pacman -S --noconfirm sudo base-devel fish neovim git fastfetch eza \
    && pacman -Scc --noconfirm

RUN useradd -m -G wheel -s /bin/bash dev \
    && echo '%wheel ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers.d/wheel \
    && chmod 440 /etc/sudoers.d/wheel

USER dev
WORKDIR /home/dev

CMD ["/bin/bash"]
