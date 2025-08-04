#import "Basic";
#import "GL";
GLFW :: #import,file "../../module.jai";

main :: () {
    ////////////////////////////////////////////////////////
    // GLFW and OpenGL initialization
    ////////////////////////////////////////////////////////
    {
        ok := GLFW.init();
        assert(xx ok, "Failed to initialize GLFW");
    }
    defer GLFW.terminate();

    GLFW.window_hint(.CONTEXT_VERSION_MAJOR, 3);
    GLFW.window_hint(.CONTEXT_VERSION_MINOR, 3);
    GLFW.window_hint(.OPENGL_PROFILE, .OPENGL_CORE_PROFILE);
    #if OS == .MACOS {
        GLFW.window_hint(.OPENGL_FORWARD_COMPAT, .TRUE);
    }

    window := GLFW.create_window(800, 600, "Triangle");
    assert(window != null, "Failed to create GLFW window");
    defer GLFW.destroy_window(window);

    GLFW.make_context_current(window);
    gl_load(*gl, GLFW.get_proc_address);

    ////////////////////////////////////////////////////////
    // Shaders
    ////////////////////////////////////////////////////////
    VERTEX_SHADER_SOURCE :: #string GLSL
        #version 330 core

        layout (location = 0) in vec2 aPos;

        void main()
        {
            gl_Position = vec4(aPos, 0, 1);
        }
    GLSL

    FRAGMENT_SHADER_SOURCE :: #string GLSL
        #version 330 core

        out vec4 fragmentColor;

        void main()
        {
            fragmentColor = vec4(0, 0, 1, 1);
        }
    GLSL

    vertex_shader := gl.glCreateShader(GL_VERTEX_SHADER);
    defer gl.glDeleteShader(vertex_shader);
    gl.glShaderSource(vertex_shader, 1, *temp_c_string(VERTEX_SHADER_SOURCE), null);
    gl.glCompileShader(vertex_shader);

    fragment_shader := gl.glCreateShader(GL_FRAGMENT_SHADER);
    defer gl.glDeleteShader(fragment_shader);
    gl.glShaderSource(fragment_shader, 1, *temp_c_string(FRAGMENT_SHADER_SOURCE), null);
    gl.glCompileShader(fragment_shader);

    shader_program := gl.glCreateProgram();
    gl.glAttachShader(shader_program, vertex_shader);
    gl.glAttachShader(shader_program, fragment_shader);
    glLinkProgram(shader_program);
    defer gl.glDeleteProgram(shader_program);

    gl.glUseProgram(shader_program);

    ////////////////////////////////////////////////////////
    // Data
    ////////////////////////////////////////////////////////
    VERTICES :: float.[
        0,    0.5,
        -0.5, -0.5,
        0.5,  -0.5,
    ];
    
    vao: u32;
    gl.glGenVertexArrays(1, *vao);
    defer gl.glDeleteVertexArrays(1, *vao);
    gl.glBindVertexArray(vao);

    vbo: u32;
    gl.glGenBuffers(1, *vbo);
    defer gl.glDeleteBuffers(1, *vbo);
    gl.glBindBuffer(GL_ARRAY_BUFFER, vbo);

    gl.glBufferData(
        GL_ARRAY_BUFFER,
        size_of(float) * VERTICES.count,
        VERTICES.data,
        GL_STATIC_DRAW
    );
    gl.glVertexAttribPointer(
        0,
        2,
        GL_FLOAT,
        GL_FALSE,
        2 * size_of(float),
        cast(*void, 0)
    );
    gl.glEnableVertexAttribArray(0);

    ////////////////////////////////////////////////////////
    // Loop
    ////////////////////////////////////////////////////////
    while !GLFW.window_should_close(window) {
        GLFW.poll_events();

        gl.glClearColor(0.3, 0.3, 0.3, 1);
        glClear(GL_COLOR_BUFFER_BIT);
        gl.glDrawArrays(
            GL_TRIANGLES,
            0,
            3
        );

        GLFW.swap_buffers(window);
    }
}
