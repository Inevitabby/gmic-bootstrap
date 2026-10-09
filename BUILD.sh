#!/usr/bin/env bash
cd "$(dirname "$0")" || exit

update() {
    if [ -d "$1" ]; then
        git -C "$1" pull
    else
        git clone "https://github.com/GreycLab/$1"
    fi
}

# 1. Update src code
update "gmic"
update "gmic-qt"
make -C gmic/src CImg.h gmic_stdlib_community.h

# 2. Build
cd gmic-qt || exit
qmake6 HOST=gimp
PATH="$(qmake6 -query QT_INSTALL_BINS):$PATH" make -j"$(nproc)"
cd .. || exit

# 3. Install to GIMP
install -Dm755 gmic-qt/gmic_gimp_qt "${HOME}/.config/GIMP/3.2/plug-ins/gmic/gmic"
