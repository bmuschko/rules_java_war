load("@io_bazel_rules_java_war//java_war:defs.bzl", "java_war")

java_war(
    name = "web-app",
    java_srcs = glob(["java/**/*.java"]),
    web_app_dir = "web",
    deps = [
        "@maven//:org_mortbay_jetty_servlet_api",
    ],
)