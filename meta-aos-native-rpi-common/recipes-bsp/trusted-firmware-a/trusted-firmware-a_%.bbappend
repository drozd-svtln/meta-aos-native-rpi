COMPATIBLE_MACHINE:raspberrypi5 = "raspberrypi5"
TFA_PLATFORM:raspberrypi5 = "rpi5"
TFA_SPD:raspberrypi5 = "opteed"
TFA_BUILD_TARGET:raspberrypi5 = "bl31"
DEPENDS:append:raspberrypi5 = " optee-os"

# optee-os already deployed tee-raw.bin into the image deploy dir (verified in tmp/deploy/.../optee/)
do_compile[depends] += "${@'optee-os:do_deploy' if d.getVar('MACHINE') == 'raspberrypi5' else ''}"

do_compile:append:raspberrypi5() {
    # Packing per TF-A docs/plat/rpi5.rst: BL31 at 0, OP-TEE raw image at 512 KiB
    BL31=$(find ${B} -name bl31.bin | head -1)
    if [ -z "$BL31" ]; then
        bbfatal "bl31.bin not found under ${B}"
    fi
    if [ "$(stat -c %s $BL31)" -gt 524288 ]; then
        bbfatal "bl31.bin is larger than 512 KiB, the OP-TEE offset would overwrite it"
    fi
    cp "$BL31" ${B}/armstub8-2712.bin
    dd if=${DEPLOY_DIR_IMAGE}/optee/tee-raw.bin of=${B}/armstub8-2712.bin \
       bs=1024 seek=512 conv=notrunc
}
