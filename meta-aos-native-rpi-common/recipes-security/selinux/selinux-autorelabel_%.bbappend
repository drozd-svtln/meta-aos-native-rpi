do_install:append() {
    sed -i '/\/sbin\/reboot/i sync' ${D}${bindir}/${SELINUX_SCRIPT_SRC}.sh
}
