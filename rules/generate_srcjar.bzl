def _impl(ctx):
    """Generates srcjar with one java file in it.
    """
    srcjar = ctx.actions.declare_file("example.srcjar")
    source_file = ctx.actions.declare_file("src/main/java/com/example/Example.java")
    ctx.actions.write(
        output = source_file,
        content = "package com.example;\npublic class Example {String foo = \"bar\";};",
    )

    java_common.pack_sources(
        java_toolchain = ctx.toolchains["@bazel_tools//tools/jdk:toolchain_type"].java,
        actions = ctx.actions,
        output_source_jar = srcjar,
        sources = [source_file],
    )

    return [
        JavaInfo(
            generated_class_jar = srcjar,
            output_jar = srcjar,
            compile_jar = srcjar,
            source_jar = srcjar,
        ),
        DefaultInfo(files = depset([srcjar])),
    ]

def _impl_kt(ctx):
    """Generates srcjar with one file in it.
    """
    srcjar = ctx.actions.declare_file("kexample.srcjar")
    source_file = ctx.actions.declare_file("src/main/kotlin/com/kexample/Kexample.kt")
    ctx.actions.write(
        output = source_file,
        content = "package com.kexample;\n class Kexample(val foo: String = \"gnargl\");",
    )

    java_common.pack_sources(
        java_toolchain = ctx.toolchains["@bazel_tools//tools/jdk:toolchain_type"].java,
        actions = ctx.actions,
        output_source_jar = srcjar,
        sources = [source_file],
    )

    return [
        JavaInfo(
            generated_class_jar = srcjar,
            output_jar = srcjar,
            compile_jar = srcjar,
            source_jar = srcjar,
        ),
        DefaultInfo(files = depset([srcjar])),
    ]

generate_srcjar = rule(
    implementation = _impl,
    doc = "Generates a srcjar with one java file in it.",
    toolchains = ["@bazel_tools//tools/jdk:toolchain_type"],
)

generate_srcjar_kt = rule(
    implementation = _impl_kt,
    doc = "Generates a srcjar with one kotlin file in it.",
    toolchains = ["@bazel_tools//tools/jdk:toolchain_type"],
)
