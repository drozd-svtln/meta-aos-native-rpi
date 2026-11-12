FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://iam.cfg \
    file://0001-fix-for-gcc-15.patch \
"

do_install:append() {
    install -d ${D}${sysconfdir}/aos
    install -m 0644 ${UNPACKDIR}/iam.cfg ${D}${sysconfdir}/aos/iam.cfg
}
