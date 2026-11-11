FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "\
    file://optee-identity.conf \
    file://0001-common-utils-fswatcher-fix-compilation-with-GCC-15.patch \
"

EXTRA_OECMAKE += "-DCMAKE_CXX_FLAGS=-Wno-error=deprecated-declarations"

do_install:append() {
    install -d ${D}${sysconfdir}/systemd/system/aos-cm.service.d
    install -m 0644 ${UNPACKDIR}/optee-identity.conf ${D}${sysconfdir}/systemd/system/aos-cm.service.d/10-optee-identity.conf
}
