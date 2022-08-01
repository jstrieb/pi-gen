#!/bin/bash

set -e;

wget \
  --output-document /tmp/go1.18.3.linux-amd64.tar.gz \
  "https://go.dev/dl/go1.18.4.linux-armv6l.tar.gz";
tar \
  --directory "${ROOTFS_DIR}/usr/local" \
  --extract \
  --gzip \
  --file /tmp/go1.18.4.linux-armv6l.tar.gz;
rm \
  --force \
  /tmp/go1.18.4.linux-armv6l.tar.gz;

echo '' >> "${ROOTFS_DIR}/etc/profile"
echo 'export PATH="$PATH:/usr/local/go/bin"' >> "${ROOTFS_DIR}/etc/profile"
echo '' >> "${ROOTFS_DIR}/etc/profile"


wget \
  --output-document "${ROOTFS_DIR}/usr/local/bin/quickserv" \
  "https://github.com/jstrieb/quickserv/releases/download/v0.2.0/quickserv_raspi_arm";
chmod +x "${ROOTFS_DIR}/usr/local/bin/quickserv";


on_chroot <<EOF
pushd /tmp;

git clone "https://github.com/ReFirmLabs/binwalk.git";
pushd binwalk;
python3 setup.py install;
popd;
rm \
  --recursive \
  --force \
  binwalk;

popd;


pushd /tmp;
git clone "https://github.com/cmatsuoka/figlet.git";
pushd figlet/fonts;

# Download additional figlet fonts
curl "http://patorjk.com/software/taag/" \
  | grep --only-matching "[[:alnum:]][[:alnum:][:space:]]*\.flf" \
  | sort \
  | uniq \
  | sed "s/^\(.*\)/\"\1\"\n\"http:\/\/patorjk.com\/software\/taag\/fonts\/\1\"/g" \
  | xargs -L 2 -P 16 \
    curl --silent --output;

cd ..;
make;
sudo make install;
popd;
rm \
  --recursive \
  --force \
  figlet;
popd;


python3 \
  -m pip \
  install \
  --upgrade \
  pip \
  setuptools \
  wheel;

python3 \
  -m pip \
  install \
  youtube-dl;
EOF
