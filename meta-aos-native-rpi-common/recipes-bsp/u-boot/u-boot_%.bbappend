do_configure:prepend:raspberrypi5() {
    if ! grep -q "LINUX_KERNEL_IMAGE_HEADER" ${S}/arch/arm/mach-bcm283x/Kconfig; then
        sed -i '/config TARGET_RPI_ARM64/,/select ARM64/ s/select ARM64/select ARM64\n\tselect LINUX_KERNEL_IMAGE_HEADER/' \
            ${S}/arch/arm/mach-bcm283x/Kconfig
        cat >> ${S}/arch/arm/mach-bcm283x/Kconfig << 'EOF'

config LNX_KRNL_IMG_TEXT_OFFSET_BASE
    default TEXT_BASE
EOF
    fi
}