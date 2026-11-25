FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://tee-supplicant-owner.conf"

# Start supplicant for /dev/tee0
FILES:${PN} += " \
    ${systemd_system_unitdir}/tee-supplicant@.service \
    ${systemd_system_unitdir}/tee-supplicant@.service.d/10-owner.conf \
"

SYSTEMD_SERVICE:${PN} = "tee-supplicant@tee0.service"

do_install:append() {
    install -d ${D}${systemd_system_unitdir}/tee-supplicant@.service.d
    install -m 0644 ${UNPACKDIR}/tee-supplicant-owner.conf \
        ${D}${systemd_system_unitdir}/tee-supplicant@.service.d/10-owner.conf
}