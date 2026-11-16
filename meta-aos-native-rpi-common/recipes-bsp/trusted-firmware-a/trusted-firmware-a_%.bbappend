# Ported from meta-xt-rpi5 (scarthgap) to wrynose (meta-arm TF-A 2.14.1).

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

COMPATIBLE_MACHINE:raspberrypi5 = "raspberrypi5"

TFA_PLATFORM:raspberrypi5 = "rpi5"
TFA_SPD:raspberrypi5 = "opteed"
TFA_BUILD_TARGET:raspberrypi5 = "bl31"

DEPENDS:append:raspberrypi5 = " optee-os"

# Make sure optee-os has deployed tee-raw.bin before we pack it
do_compile[depends] += "optee-os:do_deploy"

# Pass the DTB to OP-TEE so it can create /firmware/optee
SRC_URI:append:raspberrypi5 = " file://0001-rpi5-add-OP-TEE-support.patch"

do_compile:append:raspberrypi5() {
    # Packing per TF-A docs/plat/rpi5.rst: BL31 at offset 0, OP-TEE at 512 KiB
    BL31=$(find ${B} -name bl31.bin | head -1)
    [ -n "$BL31" ] || bbfatal "bl31.bin not found under ${B}"

    if [ "$(stat -c %s "$BL31")" -gt 524288 ]; then
        bbfatal "bl31.bin is larger than 512 KiB, it would overlap OP-TEE"
    fi

    TEE_RAW=${DEPLOY_DIR_IMAGE}/optee/tee-raw.bin
    [ -f "$TEE_RAW" ] || bbfatal "tee-raw.bin not found: $TEE_RAW"

    cp "$BL31" ${B}/armstub8-2712.bin
    dd if="$TEE_RAW" of=${B}/armstub8-2712.bin bs=1024 seek=512 conv=notrunc
}

do_deploy:append:raspberrypi5() {
    ARMSTUB=${B}/armstub8-2712.bin
    [ -f "$ARMSTUB" ] || bbfatal "armstub8-2712.bin was not built in ${B}"
    install -m 0644 "$ARMSTUB" ${DEPLOYDIR}/armstub8-2712.bin
}