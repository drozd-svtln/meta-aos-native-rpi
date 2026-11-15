# Ported from meta-xt-rpi5 (rpi-config_git.bbappend)

do_deploy:append() {
    install -d ${DEPLOYDIR}/${BOOTFILES_DIR_NAME}
    CONFIG=${DEPLOYDIR}/${BOOTFILES_DIR_NAME}/config.txt

    # Let the firmware start U-Boot ("u-boot" file on the boot partition)
    if [ "${RPI_USE_U_BOOT}" = "1" ]; then
        if grep -q '^#\?kernel=' $CONFIG; then
            sed -i '/^#\?kernel=/ c\kernel=u-boot' $CONFIG
        else
            echo "kernel=u-boot" >> $CONFIG
        fi
    fi

    # UART support on bootloader stage
    if [ "${UART_BOORLOADER}" = "1" ] || [ "${ENABLE_BOOTLOADER}" = "0" ]; then
        echo "# Enable UART on bootloader" >> $CONFIG
        echo "uart_2ndstage=${UART_BOORLOADER}" >> $CONFIG
    elif [ -n "${UART_BOORLOADER}" ]; then
        bbfatal "Invalid value for UART_BOORLOADER [${UART_BOORLOADER}]. The value for UART_BOORLOADER can be 0 or 1."
    fi
}
