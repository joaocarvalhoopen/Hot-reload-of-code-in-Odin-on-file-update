package dynamic_library_plug_code

import "core:c"
import "core:fmt"
import "core:runtime"

@export
hello_plug :: proc "c" ( in_a : [^]c.float, in_b : [^]c.float, out_c : [^]c.float, num_elem : c.int ) -> c.int {
    out_c := out_c
    context = runtime.default_context()
    fmt.printf("Hello bll from Dynamic Library hello_plug!\n")

    for i in 0..<num_elem {
        out_c[i] = in_a[i] + in_b[i]
    }

    return 1
}