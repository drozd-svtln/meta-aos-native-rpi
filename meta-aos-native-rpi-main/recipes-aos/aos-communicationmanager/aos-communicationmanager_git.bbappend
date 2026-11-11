FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "\
    file://optee-identity.conf \
    file://0001-common-utils-fswatcher-fix-compilation-with-GCC-15.patch \
    file://0002-core-increase-AOS_STACK_USAGE-limit-to-16384.patch \
    file://0003-change-lib-to-custom.patch \
    file://0004-fix-deprecated-declarations-warnings.patch \
    file://0005-depracated-2.patch \
    file://0006-deprecated-3.patch \
"

EXTRA_OECMAKE += "-DCMAKE_CXX_FLAGS='-Wno-error=deprecated-declarations -Wno-stack-usage'"

do_install:append() {
    install -d ${D}${sysconfdir}/systemd/system/aos-cm.service.d
    install -m 0644 ${UNPACKDIR}/optee-identity.conf ${D}${sysconfdir}/systemd/system/aos-cm.service.d/10-optee-identity.conf
}
