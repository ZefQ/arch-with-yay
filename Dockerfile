FROM archlinux:base-devel

RUN pacman -Syu --noconfirm git &&\
    useradd -m makepkg_user
USER makepkg_user
RUN cd $HOME &&\
    git clone https://aur.archlinux.org/yay-bin.git &&\
    cd yay-bin &&\
    makepkg

FROM archlinux:latest
COPY --from=0 /home/makepkg_user/yay-bin/yay-bin-*.pkg.* .
RUN pacman -Syu --noconfirm git base-devel &&\
    pacman -U --noconfirm yay-bin-*.pkg.* &&\
    rm -rf /var/lib/pacman/sync &&\
    echo "alias pacman=yay" >> /etc/profile
CMD /bin/bash
