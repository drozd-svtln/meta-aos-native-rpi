#!/bin/sh

COMMAND="$1"

clear_disks() {
    echo "Remove IAM DB and PKCS11 storage"
    rm /var/aos/iam -rf
    /opt/aos/clearhsm.sh

    echo "Delete Aos disks"
    /opt/aos/setupdisk.sh delete

    sync

    systemctl reboot
}

remove_firewall_rules() {
    nft delete table inet aos-provfw 2>/dev/null
}

deprovision_async() {
    {
        sleep 1

        # use systemctl stop all aos.target services instead of systemctl stop aos.target, because this approach doesn't wait
        # all services really stopped.
        systemctl stop -- $(systemctl show -p Wants aos.target | cut -d= -f2)

        remove_firewall_rules

        echo "Restore unprovisioned flag" | systemd-cat
        rm /var/aos/.provisionstate -f

        # Native single-node build: aos-iam-prov has no ExecStartPre cleanup (remove-deprovision.conf),
        # so clear IAM DB, OP-TEE storage and Aos disks here. clear_disks reboots the unit at the end.
        clear_disks
    } > /dev/null 2>&1 &
}

case "$COMMAND" in
async)
    deprovision_async
    ;;

*)
    clear_disks
    ;;
esac
