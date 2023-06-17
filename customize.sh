#####################
# xray Customization
#####################

SKIPUNZIP=1
ASH_STANDALONE=1

module_path="/data/adb/xray"
if [ ! -d ${module_path} ]; then
    mkdir -p ${module_path}
fi

installModule() {
    ui_print "- Install helper"
    mkdir -p ${module_path}/bin
    unzip -j -o "${ZIPFILE}" "xray/bin/${ARCH}/xrayhelper" -d ${module_path}/bin >&2
    set_perm ${module_path}/bin/xrayhelper 0 0 0755
    [ -f ${module_path}/xrayhelper.yml ] ||
        unzip -j -o "${ZIPFILE}" 'xray/etc/xrayhelper.yml' -d ${module_path} >&2

    ui_print "- Release scripts"
    mkdir -p ${module_path}/run
    mkdir -p ${module_path}/scripts
    unzip -j -o "${ZIPFILE}" 'xray/scripts/*' -d ${module_path}/scripts >&2
    if [ ! -d /data/adb/service.d ]; then
        mkdir -p /data/adb/service.d
    fi
    unzip -j -o "${ZIPFILE}" 'xray4magisk_service.sh' -d /data/adb/service.d >&2
    unzip -j -o "${ZIPFILE}" 'uninstall.sh' -d $MODPATH >&2

    ui_print "- Release configs"
    unzip -j -o "${ZIPFILE}" 'xray/etc/v2ray.v5.json' -d ${module_path} >&2
    if [ ! -d ${module_path}/confs ]; then
        mkdir -p ${module_path}/confs
        unzip -j -o "${ZIPFILE}" 'xray/etc/confs/proxy.json' -d ${module_path}/confs >&2
    fi
    unzip -j -o "${ZIPFILE}" 'xray/etc/confs/base.json' -d ${module_path}/confs >&2
    unzip -j -o "${ZIPFILE}" 'xray/etc/confs/dns.json' -d ${module_path}/confs >&2
    unzip -j -o "${ZIPFILE}" 'xray/etc/confs/policy.json' -d ${module_path}/confs >&2
    unzip -j -o "${ZIPFILE}" 'xray/etc/confs/routing.json' -d ${module_path}/confs >&2
    if [ ! -d ${module_path}/singconfs ]; then
        mkdir -p ${module_path}/singconfs
        unzip -j -o "${ZIPFILE}" 'xray/etc/singconfs/proxy.json' -d ${module_path}/singconfs >&2
    fi
    unzip -j -o "${ZIPFILE}" 'xray/etc/singconfs/base.json' -d ${module_path}/singconfs >&2
    unzip -j -o "${ZIPFILE}" 'xray/etc/singconfs/dns.json' -d ${module_path}/singconfs >&2
    unzip -j -o "${ZIPFILE}" 'xray/etc/singconfs/route.json' -d ${module_path}/singconfs >&2
    if [ ! -d ${module_path}/clashconfs ]; then
        mkdir -p ${module_path}/clashconfs
    fi
    unzip -j -o "${ZIPFILE}" 'xray/etc/clashconfs/template.yaml' -d ${module_path}/clashconfs >&2

    ui_print "- Install geodata asset"
    ${module_path}/bin/xrayhelper -c ${module_path}/xrayhelper.yml update geodata

    ui_print "- Install core"
    ${module_path}/bin/xrayhelper -c ${module_path}/xrayhelper.yml update core

    ui_print "- Set permission"
    set_perm /data/adb/service.d/xray4magisk_service.sh 0 0 0755
    set_perm $MODPATH/uninstall.sh 0 0 0755
    set_perm_recursive ${module_path}/scripts 0 0 0755 0755
    set_perm ${module_path} 0 0 0755
    unzip -j -o "${ZIPFILE}" "module.prop" -d $MODPATH >&2
}

main() {
  installModule
}

main
