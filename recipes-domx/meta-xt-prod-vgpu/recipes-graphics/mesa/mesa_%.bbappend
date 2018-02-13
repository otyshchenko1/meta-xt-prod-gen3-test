# We need this header file to build gles-user-module. Since it was removed
# by mesa recipe we have to install it manually.
do_install_append () {
    install -Dm 644 ${S}/include/EGL/eglmesaext.h ${D}/${includedir}/EGL/eglmesaext.h
}
