def _impl(ctx):
    """
    Takes srcjar as source and outputs JavaInfo with srcjar as source
    """
    srcjar = ctx.file.srcjar
    output_jar = ctx.actions.declare_file(srcjar.basename + ".output.jar")
    ctx.actions.run_shell(
        inputs = [srcjar],
        outputs = [output_jar],
        command = "cp %s %s" % (srcjar.path, output_jar.path),
    )
    return [
        JavaInfo(
            generated_class_jar = None,
            output_jar = output_jar,
            compile_jar = None,
            source_jar = srcjar,
        ),
        DefaultInfo(files = depset([output_jar])),
    ]

fake_javainfo = rule(
    implementation = _impl,
    doc = "Generates a JavaInfo with srcjar as source",
    attrs = {
        "srcjar": attr.label(
            allow_single_file = True,
            doc = "The source jar to use",
        ),
    },
)
