[system]
compatible={{ env "ota_compatible" }}
mountprefix=/run/rauc
statusfile=/mnt/data/rauc.db
bootloader=uboot
max-bundle-download-size=1073741824

[keyring]
path=/etc/rauc/keyring.pem

[slot.spl.0]
device=/dev/disk/by-path/platform-d0072000.mmc
type=raw

[slot.rootfs.0]
device=/dev/disk/by-path/platform-d0072000.mmc-part3
type=raw
bootname=A

[slot.rootfs.1]
device=/dev/disk/by-path/platform-d0072000.mmc-part4
type=raw
bootname=B

