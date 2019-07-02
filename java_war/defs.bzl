def _initial_zipper_args(compression):
    default_args = "c"

    if compression:
        default_args += "C"

    return default_args

def _add_web_app_srcs_args(zipper_args, web_app_root, web_app_srcs):
    for src in web_app_srcs:
        web_app_root_index = src.path.index(web_app_root)
        web_app_root_len = len(web_app_root)
        index_path = (web_app_root_index + web_app_root_len) + 1
        path_inside_war = src.path[index_path:]
        name = path_inside_war + "=" + src.path
        zipper_args.append(name)

def _collect_runtime_deps(deps):
    runtime_deps = []

    for this_dep in deps:
        if JavaInfo in this_dep:
            runtime_deps += this_dep[JavaInfo].transitive_runtime_jars.to_list()

    return runtime_deps

def _add_runtime_deps_args(zipper_args, runtime_deps):
    for runtime_dep in runtime_deps:
        name = "WEB-INF/lib/" + runtime_dep.basename + "=" + runtime_dep.path
        zipper_args.append(name)

def _war_impl(ctx):
    web_app_root = ctx.attr.web_app_root
    web_app_srcs = ctx.files.web_app_srcs
    compression = ctx.attr.compression
    deps = ctx.attr.deps
    zipper = ctx.executable._zipper
    war = ctx.outputs.war

    default_zipper_args = _initial_zipper_args(compression)
    all_zipper_args = [default_zipper_args, war.path]
    _add_web_app_srcs_args(all_zipper_args, web_app_root, web_app_srcs)
    runtime_deps = _collect_runtime_deps(deps)
    _add_runtime_deps_args(all_zipper_args, runtime_deps)

    ctx.actions.run(
        inputs = web_app_srcs + runtime_deps,
        outputs = [war],
        executable = zipper,
        arguments = all_zipper_args,
        progress_message = "Creating war...",
        mnemonic = "war",
    )

war = rule(
    implementation = _war_impl,
    doc = """
Rule for generating a Java Web Archive (WAR).
""",
    attrs = {
        "web_app_root": attr.string(
            doc = "Root directory containing web application files (e.g. web.xml, CSS or JavaScript files).",
            default = "src/main/webapp",
            mandatory = True,
        ),
        "web_app_srcs": attr.label_list(
            doc = "Source files to be included fromt the web application root directory.",
            allow_files = True,
            mandatory = True,
        ),
        "compression": attr.bool(
            doc = "Enables compression for the WAR file.",
            default = False,
            mandatory = True,
        ),
        "deps": attr.label_list(
            doc = "Dependencies for this target.",
        ),
        "_zipper": attr.label(
            default = Label("@bazel_tools//tools/zip:zipper"),
            executable = True,
            cfg = "host",
        ),
    },
    outputs = {
        "war" : "%{name}.war"
    },
)

def java_war(name, web_app_dir = "src/main/webapp", java_srcs = [], deps = [], compression = False, **kwargs):
    """Creates a Java Web Archive (WAR).

    Automatically creates a Java library and bundles it with the web application files and any dependencies.
    For more information on the internal structure of a WAR file, see the [official documentation](https://docs.oracle.com/javaee/6/tutorial/doc/bnadx.html).

    Args:
        name: A unique name for this rule.
        web_app_dir: The root web application directory (defaults to src/main/webapp).
        java_srcs: Java source files for compilation (defaults to any empty label list).
        deps: Dependencies for this java_library target (defaults to any empty label list).
        compression: Enables compression for the WAR (defaults to False).

    Example:
        java_war(
            name = "web-app",
            java_srcs = glob(["src/main/java/**/*.java"]),
            compression = True,
            deps = [
                "@maven//:org_mortbay_jetty_servlet_api",
                "@maven//:ch_qos_logback_logback_classic",
            ],
        )
    """
    native.java_library(
        name = "lib%s" % name,
        srcs = java_srcs,
        deps = deps,
        **kwargs
    )

    war(
        name = name,
        web_app_root = web_app_dir,
        web_app_srcs = native.glob([web_app_dir + "/**/*.*"]),
        compression = compression,
        deps = [":lib%s" % name]
    )