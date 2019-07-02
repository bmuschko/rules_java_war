load("//java_war:defs.bzl", "java_war")
load(":test_suite.bzl", "java_war_test_suite")

java_war(
    name = "minimal",
    java_srcs = glob(["src/main/java/**/*.java"]),
    deps = [
        "@maven//:org_mortbay_jetty_servlet_api",
    ],
)

java_war(
    name = "compression",
    java_srcs = glob(["src/main/java/**/*.java"]),
    compression = True,
    deps = [
        "@maven//:org_mortbay_jetty_servlet_api",
    ],
)

java_war(
    name = "extdeps",
    java_srcs = glob(["src/main/java/**/*.java"]),
    deps = [
        "@maven//:org_mortbay_jetty_servlet_api",
        "@maven//:ch_qos_logback_logback_classic",
    ],
)

java_war(
    name = "custom",
    java_srcs = glob(["custom/java/**/*.java"]),
    web_app_dir = "custom/web",
    deps = [
        "@maven//:org_mortbay_jetty_servlet_api",
    ],
)

java_war_test_suite()