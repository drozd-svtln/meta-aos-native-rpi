SUMMARY = "U-Boot boot script for native (non-Xen) Aos on Raspberry Pi 5"
DESCRIPTION = "Generates boot.scr: loads the kernel at 0x10000000 and boots with OS_BOOTARGS"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"
COMPATIBLE_MACHINE = "^raspberrypi5$"

DEPENDS = "u-boot-mkimage-native"
INHIBIT_DEFAULT_DEPS = "1"

SRC_URI = "file://boot.cmd.in"
S = "${UNPACKDIR}"

# Boot partition is on the SD card (mmc 0), as in meta-aos-rpi
BOOT_MEDIA ?= "mmc"
KERNEL_IMAGE ?= "Image"
# Load address: well above U-Boot's default, fits the 100 MB Image-initramfs
KERNEL_IMG_ADDR ?= "0x10000000"
OS_BOOTARGS ?= "console=ttyAMA10,115200 root=/dev/mmcblk0p2 rootfstype=ext4 rootwait"

do_compile() {
    sed -e 's|@@BOOT_MEDIA@@|${BOOT_MEDIA}|g' \
        -e 's|@@KERNEL_IMAGE@@|${KERNEL_IMAGE}|g' \
        -e 's|@@KERNEL_IMG_ADDR@@|${KERNEL_IMG_ADDR}|g' \
        -e 's|@@OS_BOOTARGS@@|${OS_BOOTARGS}|g' \
        "${UNPACKDIR}/boot.cmd.in" > "${WORKDIR}/boot.cmd"

    mkimage -A ${@oe.kernel.map_uboot_arch(d)} -T script -C none -n "Boot script" \
        -d "${WORKDIR}/boot.cmd" boot.scr
}

inherit kernel-arch deploy nopackages

do_deploy() {
    install -d ${DEPLOYDIR}
    install -m 0644 boot.scr ${DEPLOYDIR}
    install -m 0644 ${WORKDIR}/boot.cmd ${DEPLOYDIR}
}
addtask do_deploy after do_compile before do_build

PROVIDES += "u-boot-default-script"
