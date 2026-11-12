FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://iam.cfg \
    file://0001-common-utils-fswatcher-fix-compilation-with-GCC-15.patch \
    file://0002-fix-deprecated-declarations-warnings.patch \
"

do_install:append() {
    install -d ${D}${sysconfdir}/aos
    install -m 0644 ${UNPACKDIR}/iam.cfg ${D}${sysconfdir}/aos/iam.cfg
}
