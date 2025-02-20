[update]
compatible={{ env "ota_compatible" }}
version={{ env "ota_version" }}

[bundle]
format=verity

[hooks]
filename=hook
hooks=install-check;

[image.uboot]
filename=uboot
hooks=install;

[image.rootfs]
filename=rootfs.img


