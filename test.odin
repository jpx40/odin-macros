
package main


import "base:intrinsics"
import "base:runtime"
import "core:fmt"
import "core:os"
import "core:path/filepath"
import "core:strings"


main :: proc() {
	test := "test"
	fmt.println("test ${test}") // test fmt
	
	fmt.println("test ${test}") // test fmt

	fmt.println("test ${test}") // test fmt
	b : strings.Builder
	fmt.sbprint(&b, "test ${test}") // test fmt


}

