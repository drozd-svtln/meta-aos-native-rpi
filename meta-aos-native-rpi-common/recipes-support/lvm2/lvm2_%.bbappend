FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append:class-target = " \
    file://aos-lvm-refresh.service \
"

FILES:${PN} += " \
    ${systemd_system_unitdir}/aos-lvm-refresh.service \
    ${sysconfdir}/systemd/system/local-fs-pre.target.wants/aos-lvm-refresh.service \
"

do_install:append:class-target() {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
        install -d ${D}${systemd_system_unitdir}
        install -m 0644 ${UNPACKDIR}/aos-lvm-refresh.service ${D}${systemd_system_unitdir}/aos-lvm-refresh.service
        install -d ${D}${sysconfdir}/systemd/system/local-fs-pre.target.wants
        ln -sf ${systemd_system_unitdir}/aos-lvm-refresh.service \
            ${D}${sysconfdir}/systemd/system/local-fs-pre.target.wants/aos-lvm-refresh.service
    fi
}