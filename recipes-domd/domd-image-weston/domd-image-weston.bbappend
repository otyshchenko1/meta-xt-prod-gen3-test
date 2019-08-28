FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
FILESEXTRAPATHS_prepend := "${THISDIR}/../../inc:"
FILESEXTRAPATHS_prepend := "${THISDIR}/../../recipes-domx:"

XT_PRODUCT_NAME ?= "prod-gen3-test"

python __anonymous () {
    product_name = d.getVar('XT_PRODUCT_NAME', True)
    folder_name = product_name.replace("-", "_")
    d.setVar('XT_MANIFEST_FOLDER', folder_name)
}

SRC_URI = " \
    repo://github.com/xen-troops/manifests;protocol=https;branch=master;manifest=${XT_MANIFEST_FOLDER}/domd.xml;scmdata=keep \
"

XT_QUIRK_UNPACK_SRC_URI += " \
    file://meta-xt-prod-extra;subdir=repo \
    file://xt_shared_env.inc;subdir=repo/meta-xt-prod-extra/inc \
    file://xen-version.inc;subdir=repo/meta-xt-prod-extra/recipes-extended/xen \
"

XT_QUIRK_BB_ADD_LAYER += " \
    meta-xt-prod-extra \
"

XT_BB_IMAGE_TARGET = "core-image-weston"

# Dom0 is a generic ARMv8 machine w/o machine overrides,
# but still needs to know which system we are building,
# e.g. Salvator-X M3 or H3, for instance
# So, we provide machine overrides from this build the domain.
# The same is true for Android build.
addtask domd_install_machine_overrides after do_configure before do_compile
python do_domd_install_machine_overrides() {
    bb.debug(1, "Installing machine overrides")

    d.setVar('XT_BB_CMDLINE', "-f domd-install-machine-overrides")
    bb.build.exec_func("build_yocto_exec_bitbake", d)
}

################################################################################
# Renesas R-Car
################################################################################

XT_QUIRK_PATCH_SRC_URI_rcar = "\
    file://${S}/meta-renesas/meta-rcar-gen3/docs/sample/patch/patch-for-linaro-gcc/0001-rcar-gen3-add-readme-for-building-with-Linaro-Gcc.patch;patchdir=meta-renesas \
    file://0001-hack-Remove-dependency-to-multi-user.target-from-wes.patch;patchdir=meta-renesas \
    file://0001-rcar-gen3-arm-trusted-firmware-Allow-to-add-more-bui.patch;patchdir=meta-renesas \
    file://0001-copyscript-Set-GFX-Library-List-to-empty-string.patch;patchdir=meta-renesas \
    file://0001-Add-vspfilter-config-for-salvator-x-4x2g-machine.patch;patchdir=meta-renesas \
    file://0001-recipes-kernel-Load-multimedia-related-modules-autom.patch;patchdir=meta-renesas \
"

XT_BB_LOCAL_CONF_FILE_rcar = "meta-xt-prod-extra/doc/local.conf.rcar-domd-image-weston"
XT_BB_LAYERS_FILE_rcar = "meta-xt-prod-extra/doc/bblayers.conf.rcar-domd-image-weston"

GLES_VERSION_rcar = "1.10"

# In order to copy proprietary "graphics" packages,
# XT_RCAR_EVAPROPRIETARY_DIR variable under [local_conf] section in
# the configuration file should point to the real packages location.
configure_versions_rcar() {
    local local_conf="${S}/build/conf/local.conf"

    cd ${S}
    base_update_conf_value ${local_conf} PREFERRED_VERSION_xen "4.13.0+git\%"
    base_update_conf_value ${local_conf} PREFERRED_VERSION_u-boot_rcar "v2018.09\%"
    if [ -z ${XT_RCAR_EVAPROPRIETARY_DIR} ];then
        base_update_conf_value ${local_conf} PREFERRED_PROVIDER_gles-user-module "gles-user-module"
        base_update_conf_value ${local_conf} PREFERRED_VERSION_gles-user-module ${GLES_VERSION}

        base_update_conf_value ${local_conf} PREFERRED_PROVIDER_kernel-module-gles "kernel-module-gles"
        base_update_conf_value ${local_conf} PREFERRED_VERSION_kernel-module-gles ${GLES_VERSION}

        base_update_conf_value ${local_conf} PREFERRED_PROVIDER_gles-module-egl-headers "gles-module-egl-headers"
        base_update_conf_value ${local_conf} PREFERRED_VERSION_gles-module-egl-headers ${GLES_VERSION}
        base_add_conf_value ${local_conf} EXTRA_IMAGEDEPENDS "prepare-graphic-package"
    else
        base_update_conf_value ${local_conf} PREFERRED_PROVIDER_virtual/libgles2 "rcar-proprietary-graphic"
        base_update_conf_value ${local_conf} PREFERRED_PROVIDER_virtual/egl "rcar-proprietary-graphic"
        base_set_conf_value ${local_conf} PREFERRED_PROVIDER_kernel-module-pvrsrvkm "rcar-proprietary-graphic"
        base_set_conf_value ${local_conf} PREFERRED_PROVIDER_kernel-module-dc-linuxfb "rcar-proprietary-graphic"
        base_set_conf_value ${local_conf} PREFERRED_PROVIDER_kernel-module-gles "rcar-proprietary-graphic"
        base_set_conf_value ${local_conf} PREFERRED_PROVIDER_gles-user-module "rcar-proprietary-graphic"
        base_set_conf_value ${local_conf} PREFERRED_PROVIDER_gles-module-egl-headers "rcar-proprietary-graphic"
        base_add_conf_value ${local_conf} BBMASK "meta-xt-images-vgpu/recipes-graphics/gles-module/"
        base_add_conf_value ${local_conf} BBMASK "meta-xt-prod-extra/recipes-graphics/gles-module/"
        base_add_conf_value ${local_conf} BBMASK "meta-xt-prod-vgpu/recipes-graphics/gles-module/"
        base_add_conf_value ${local_conf} BBMASK "meta-xt-prod-vgpu/recipes-graphics/wayland/"
        base_add_conf_value ${local_conf} BBMASK "meta-xt-prod-vgpu/recipes-kernel/kernel-module-gles/"
        base_add_conf_value ${local_conf} BBMASK "meta-xt-images-vgpu/recipes-kernel/kernel-module-gles/"
        base_add_conf_value ${local_conf} BBMASK "meta-renesas/meta-rcar-gen3/recipes-kernel/kernel-module-gles/"
        base_add_conf_value ${local_conf} BBMASK "meta-renesas/meta-rcar-gen3/recipes-graphics/gles-module/"
        xt_unpack_proprietary
    fi

    # HACK: force ipk instead of rpm b/c it makes troubles to PVR UM build otherwise
    base_update_conf_value ${local_conf} PACKAGE_CLASSES "package_ipk"

    # FIXME: normally bitbake fails with error if there are bbappends w/o recipes
    # which is the case for agl-demo-platform's recipe-platform while building
    # agl-image-weston: due to AGL's Yocto configuration recipe-platform is only
    # added to bblayers if building agl-demo-platform, thus making bitbake to
    # fail if this recipe is absent. Workaround this by allowing bbappends without
    # corresponding recipies.
    base_update_conf_value ${local_conf} BB_DANGLINGAPPENDS_WARNONLY "yes"

    # override console specified by default by the meta-rcar-gen3
    # to be hypervisor's one
    base_update_conf_value ${local_conf} SERIAL_CONSOLE "115200 hvc0"

    # set default timezone to Las Vegas
    base_update_conf_value ${local_conf} DEFAULT_TIMEZONE "US/Pacific"

    base_update_conf_value ${local_conf} XT_GUESTS_INSTALL "${XT_GUESTS_INSTALL}"

    # DomU based product doesn't need ivi-shell
    if echo "${XT_GUESTS_INSTALL}" | grep -qi "domu";then
        base_set_conf_value ${local_conf} DISTRO_FEATURES_remove "ivi-shell"
    fi
}

# In order to copy proprietary "multimedia" packages,
# XT_RCAR_PROPRIETARY_MULTIMEDIA_DIR variable under [local_conf] section in
# the configuration file should point to the real packages location.
copy_rcar_proprietary_multimedia() {
    local local_conf="${S}/build/conf/local.conf"

    if [ ! -z ${XT_RCAR_PROPRIETARY_MULTIMEDIA_DIR} ];then
        # Populate meta-renesas with proprietary software packages
        # (according to the https://elinux.org/R-Car/Boards/Yocto-Gen3)
        cd ${S}/meta-renesas
        sh meta-rcar-gen3/docs/sample/copyscript/copy_evaproprietary_softwares.sh -f ${XT_RCAR_PROPRIETARY_MULTIMEDIA_DIR}
    fi
}

python do_configure_append_rcar() {
    bb.build.exec_func("configure_versions_rcar", d)
    bb.build.exec_func("copy_rcar_proprietary_multimedia", d)
}

do_install_append () {
    local LAYERDIR=${TOPDIR}/../meta-xt-prod-devel
    find ${LAYERDIR}/doc -iname "u-boot-env*" -exec cp -f {} ${DEPLOY_DIR}/domd-image-weston/images/${MACHINE}-xt \; || true
    find ${LAYERDIR}/doc -iname "mk_sdcard_image.sh" -exec cp -f {} ${DEPLOY_DIR}/domd-image-weston/images/${MACHINE}-xt \; \
    -exec cp -f {} ${DEPLOY_DIR} \; || true
}
