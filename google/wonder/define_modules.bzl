load(":repo_paths.bzl", "soc_label")
load("//build/kernel/kleaf:kernel.bzl", "ddk_module")

def define_modules(target, variant):
    tv = "{}_{}".format(target, variant)

    ddk_module(
        name = "{}_wonder".format(tv),
        out = "wonder.ko",
        srcs = native.glob([
            "**/*.h",
        ]) + [
            "band_config.c",
            "mac80211.c",
            "mac80211_txs.c",
            "main.c",
            "nl80211_ven_cmd.c",
            "ssr.c",
            "wondertap.c",
        ],
        conditional_srcs = {
            "CONFIG_DEBUG_FS": {
                True: [
                    "debugfs.c",
                ],
            },
        },
        kconfig = "Kconfig",
        defconfig = "defconfig",
        deps = [
            soc_label("all_headers"),
            soc_label("{}/net/mac80211/mac80211".format(tv)),
            soc_label("{}/net/wireless/cfg80211".format(tv)),
            ":wonder_headers",
        ],
        kernel_build = soc_label("{}_base_kernel".format(tv)),
        visibility = ["//visibility:public"],
    )
