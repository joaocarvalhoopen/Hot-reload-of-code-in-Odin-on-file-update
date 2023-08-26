package host_hot_reload

import "core:dynlib"
import "core:c"
import "core:fmt"
import "core:runtime"
import "core:strings"
import "core:time"
// import "core:c/libc"


// External C library import.
when ODIN_OS == .Linux   do foreign import foo { "main_c_file_monitor.a", "system:rt" }

foreign foo {
    //  file_path = "/path/to/watched/file"
    file_monitor_init            :: proc "c" ( file_path : cstring ) -> c.int --- 
    file_monitor_file_as_changed :: proc "c" ( ) -> c.int ---
    file_monitor_rm_watch        :: proc "c" ( ) -> c.int ---
}

// Note: This is the hello_plug function. 
hello_plug__func_type :: proc "c" ( in_a : [^]c.float, in_b : [^]c.float, out_c : [^]c.float, num_elem : c.int ) -> c.int 


main :: proc() {

    DLL_LIBRARY_PATH :: "./dll_plug_code.so"

    DLL_LIBRARY_PATH_cstring : cstring = strings.clone_to_cstring( DLL_LIBRARY_PATH )


    // // Initialize the file monitor.
    // res_1: c.int = file_monitor_init( DLL_LIBRARY_PATH_cstring )
    // defer file_monitor_rm_watch( )

    library : dynlib.Library
    ok : bool

    ptr_call_hello_plug : hello_plug__func_type = nil 

    res_int : c.int
    res_2   : c.int

    for {
        fmt.printf( "Waiting for the file to change...\n" )
        ok = false

        // Loads the dynamic dll library.
        library, ok = dynlib.load_library( DLL_LIBRARY_PATH )
        if !ok {
            panic("couldnt find dll_plug_odin.so\n")
        }

        fmt.printf( "The library %v was successfully loaded!\n",
            DLL_LIBRARY_PATH )


        ptr, found := dynlib.symbol_address( library, "hello_plug" )
        assert(found)
        ptr_call_hello_plug = cast( hello_plug__func_type ) ptr
        fmt.println( "DLL_lib_reloaded...");


        // Call the function from the library.

        // Create the input and output arrays.
        NUM_ELEM :: 3
        in_a :  [NUM_ELEM]f32 = [NUM_ELEM]f32{ 1.0, 2.0, 3.0 } 
        in_b :  [NUM_ELEM]f32 = [NUM_ELEM]f32{ 3.0, 3.0, 3.0 } 
        out_c : [NUM_ELEM]f32 = [NUM_ELEM]f32{ 0.0, 0.0, 0.0 } 

        in_a_ptr  : [^]c.float = raw_data( in_a[:] )
        in_b_ptr  : [^]c.float = raw_data( in_b[:] )
        out_c_ptr : [^]c.float = raw_data( out_c[:] )
        num_elements : c.int = NUM_ELEM

        // Call the dll_plug_code.so
        res_int = ptr_call_hello_plug( in_a_ptr, in_b_ptr, out_c_ptr, num_elements ) 

        for i in 0..<NUM_ELEM {
            fmt.printf( "in_a[%v]: %v + in_b[%v]: %v out_c[%v]: %v  \n",
                i,
                in_a_ptr[ i ],
                i,
                in_b_ptr[ i ],
                i,
                out_c_ptr[ i ] )
        }


        fmt.printf("Result from plug: %v \n", int(res_int), "\n")


        // Unload the library.
        // if library != nil {
            did_unload := dynlib.unload_library(library)
            if !did_unload {
                // file_monitor_rm_watch( )
                panic("couldnt unload the library dll_plug_odin.so")
            }
            fmt.printf( "The library %v was successfully unloaded\n", DLL_LIBRARY_PATH )
        //}
        
        // library = nil

        // Initialize the file monitor.
        res_1: c.int = file_monitor_init( DLL_LIBRARY_PATH_cstring )

        // Wait for the file to change.
        res_2 = file_monitor_file_as_changed()

        // Remove the file monitor.
        _ = file_monitor_rm_watch( )

        fmt.printf( "The file %v was changed", DLL_LIBRARY_PATH )

        // Sleep for 5 second to give time for the DLL dynamic file to finish being written to disk.
        duration_sec : time.Duration = 2 * time.Second
        time.sleep( duration_sec )
 
        fmt.println( "After wait for DLL dynamic file to be written to disk, and after 2 seconds" )        
    }
}