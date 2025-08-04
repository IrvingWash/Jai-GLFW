#import "Basic";
GLFW :: #import,file "../../module.jai"; // #import "GLFW";

main :: () {
    {
        ok := GLFW.init();
        assert(xx ok, "Failed to initialize GLFW");
    }
    defer GLFW.terminate();

    window := GLFW.create_window(800, 600, "Window example");
    assert(window != null, "Failed to create GLFW window");
    defer GLFW.destroy_window(window);

    while !GLFW.window_should_close(window) {
        GLFW.poll_events();

        GLFW.swap_buffers(window);
    }
}
