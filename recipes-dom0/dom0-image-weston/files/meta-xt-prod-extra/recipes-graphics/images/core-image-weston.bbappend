IMAGE_INSTALL_append = " \
    guest-addons \
    kmscube \
"

populate_append() {
        install -m 0644 ${DEPLOY_DIR_IMAGE}/xen-${MACHINE}.gz ${DEST}/xen.gz
}
