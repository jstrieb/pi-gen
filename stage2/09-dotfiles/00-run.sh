#!/bin/bash

set -e;

cd "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/";
git clone https://github.com/jstrieb/dotfiles.git;

on_chroot <<EOF
  cd "/home/${FIRST_USER_NAME}/dotfiles";
  sudo -u ${FIRST_USER_NAME} bash install.sh;
EOF
