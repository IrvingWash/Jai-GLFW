#import "Basic";
#import "Compiler";
#import "File";

BUILD_DIR :: "build";

#run {
    set_build_options_dc(.{
        do_output = false
    });

    build_options_dc := get_build_options();

    if build_options_dc.compile_time_command_line.count < 1 {
        print("No example name provided.\n");

        return;
    }

    example_name := build_options_dc.compile_time_command_line[0];

    entry_path := tprint("examples/%/main.jai", example_name);

    w := compiler_create_workspace("Example");

    build_options := get_build_options(w);
    copy_commonly_propagated_fields(
        build_options_dc,
        *build_options,
    );
    {
        using build_options;

        output_type = .EXECUTABLE;
        output_executable_name = example_name;
        output_path, intermediate_path = BUILD_DIR;
    }
    set_optimization(*build_options, .DEBUG);
    set_build_options(build_options, w);

    make_directory_if_it_does_not_exist(BUILD_DIR, recursive = true);

    add_build_file(entry_path, w);
}
