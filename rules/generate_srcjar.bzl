def make_srcjar(
        ctx,
        filename_tpl,  # For substituting (package_as_path, class_name)
        content_tpl):  # For substituting (package, class_name, class_name)
    """Generates a srcjar file with the given content.
    """
    package = ctx.attr.package
    package_as_path = package.replace(".", "/")
    class_name = ctx.attr.class_name

    srcjar = ctx.actions.declare_file("%s.srcjar" % ctx.attr.name)
    source_file = ctx.actions.declare_file(filename_tpl % (package_as_path, class_name))
    ctx.actions.write(
        output = source_file,
        content = content_tpl % (package, class_name, class_name),
    )
    java_common.pack_sources(
        java_toolchain = ctx.toolchains["@bazel_tools//tools/jdk:toolchain_type"].java,
        actions = ctx.actions,
        output_source_jar = srcjar,
        sources = [source_file],
    )
    return srcjar

def _impl(ctx):
    """Generates srcjar with one java file in it.
    """
    srcjar = make_srcjar(
        ctx = ctx,
        filename_tpl = "src/main/java/%s/%s.java",
        content_tpl = "package %s;\npublic class %s {public String myNameIs = \"%s\";};",
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

    srcjar = make_srcjar(
        ctx,
        filename_tpl = "src/main/kotlin/%s/%s.kt",
        content_tpl = "package %s;\n class %s(val myNameIs: String = \"%s\");",
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

generate_srcjar_java = rule(
    implementation = _impl,
    doc = "Generates a srcjar with one java file in it.",
    toolchains = ["@bazel_tools//tools/jdk:toolchain_type"],
    attrs = {
        "package": attr.string(mandatory = True),
        "class_name": attr.string(mandatory = True),
    },
)

generate_srcjar_kt = rule(
    implementation = _impl_kt,
    doc = "Generates a srcjar with one kotlin file in it.",
    toolchains = ["@bazel_tools//tools/jdk:toolchain_type"],
    attrs = {
        "package": attr.string(mandatory = True),
        "class_name": attr.string(mandatory = True),
    },
)
