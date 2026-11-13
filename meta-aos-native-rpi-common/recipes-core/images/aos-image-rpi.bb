SUMMARY = "Aos image for Raspberry Pi devices"
DESCRIPTION = "AosCore image for Native Linux for Raspberry Pi devices"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

# Makes this recipe an image (do_rootfs, do_image_ext4, ...)
require recipes-core/images/core-image-minimal.bb

# Enable package manager (as in meta-aos-rpi)
EXTRA_IMAGE_FEATURES += "package-management"

# Deploy everything moulin puts on the boot partition before the image is done
do_image[depends] += " \
    rpi-bootfiles:do_deploy \
    rpi-config:do_deploy \
    rpi-cmdline:do_deploy \
    virtual/kernel:do_deploy \
    ${@bb.utils.contains('RPI_USE_U_BOOT', '1', 'u-boot-tools-native:do_populate_sysroot', '', d)} \
    ${@bb.utils.contains('RPI_USE_U_BOOT', '1', 'u-boot:do_deploy', '', d)} \
    ${@bb.utils.contains('RPI_USE_U_BOOT', '1', 'u-boot-default-script:do_deploy', '', d)} \
"

# Phase 2 (OP-TEE): uncomment once the TF-A bbappend for raspberrypi5 exists
# do_image[depends] += "trusted-firmware-a:do_deploy"

# Basic packages (as in meta-aos-rpi, Xen packages removed)
PACKAGE_INSTALL:append = " \
    coreutils \
    u-boot \
"

# Only ext4 is used by moulin (wic needs a .wks file, ext3 not needed)
IMAGE_FSTYPES:remove = "wic.bz2 wic.bmap ext3"
IMAGE_FSTYPES:append = " ext4"

require recipes-core/images/aos-image.inc

inherit extrausers

CAN_PACKAGES = " \
    iproute2 \
    can-utils \
"

IMAGE_INSTALL:append = " \
    packagegroup-core-ssh-openssh \
    netconfig \
    tzdata \
    sudo \
    ${@bb.utils.contains("MACHINE_FEATURES", "rpi_can", "${CAN_PACKAGES}", "" ,d)} \
    udev-rules-rpi \
    v4l-utils \
"

PACKAGE_INSTALL:append = " \
    kernel-modules \
"

EXTRA_USERS_PARAMS = " \
    useradd aos; \
    usermod -a -G sudo aos; \
"

enable_sudo_group() {
    # Uncomment the following line from sudoers:
    #   %sudo   ALL=(ALL:ALL) ALL
    sed -i 's/^#\s*\(%sudo\s*ALL=(ALL:ALL)\s*ALL\)/\1/'  ${IMAGE_ROOTFS}/etc/sudoers
}

update_user_profile() {
    echo 'PATH=$PATH:/usr/local/sbin:/usr/sbin:/sbin' >> ${IMAGE_ROOTFS}/home/aos/.profile
}

ROOTFS_POSTPROCESS_COMMAND:append = " \
    enable_sudo_group; \
    update_user_profile; \
"

# Set fixed rootfs size
IMAGE_ROOTFS_SIZE ?= "1048576"
IMAGE_OVERHEAD_FACTOR ?= "1.0"
IMAGE_ROOTFS_EXTRA_SPACE ?= "524288"
