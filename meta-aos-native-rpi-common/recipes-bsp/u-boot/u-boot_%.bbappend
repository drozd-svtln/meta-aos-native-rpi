FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append:raspberrypi5 = " \
    file://linux-kernel-header.cfg \
"