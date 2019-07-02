def java_war_test_suite():
    native.test_suite(
        name = "test-suite",
        tests = [
            ":test-minimal",
            ":test-compression",
            ":test-extdeps",
            ":test-custom",
        ],
    )

    native.sh_test(
        name = "test-minimal",
        srcs = [":minimal_verification.sh"],
        args = ["$(location :minimal.war)"],
        data = [":minimal.war"],
    )

    native.sh_test(
        name = "test-compression",
        srcs = [":compression_verification.sh"],
        args = ["$(location :compression.war)"],
        data = [":compression.war"],
    )

    native.sh_test(
       name = "test-extdeps",
       srcs = [":extdeps_verification.sh"],
       args = ["$(location :extdeps.war)"],
       data = [":extdeps.war"],
    )

    native.sh_test(
        name = "test-custom",
        srcs = [":custom_verification.sh"],
        args = ["$(location :custom.war)"],
        data = [":custom.war"],
    )
