
package main


import "base:intrinsics"
import "base:runtime"
import "core:fmt"
import "core:os"
import "core:path/filepath"
import "core:strings"


main :: proc() {
	test := "test"
	fmt.println("test ",test,sep = "") // test fm
	
	fmt.println("test ",test,sep = "") // test fm

	fmt.println("test ",test,sep = "") // test fm
	b : strings.Builder
	fmt.sbprint(&b, "test ",test,sep = "") // test fm


}


