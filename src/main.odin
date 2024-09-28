package main


import "base:intrinsics"
import "base:runtime"
import "core:fmt"
import "core:os"
import "core:path/filepath"
import "core:strings"
import "core:unicode/utf8"


internal_substring :: proc(s: string, rune_start: int, rune_end: int) -> (sub: string, ok: bool) {
	sub = s
	ok  = true

	rune_i: int = 0

	if rune_start > 0 {
		ok = false
		for _, i in sub {
			if rune_start == rune_i {
				ok = true
				sub = sub[i:]
				break
			}
			rune_i += 1
		}
		if !ok { return }
	}

	if rune_end >= rune_start {
		ok = false
		for _, i in sub {
			if rune_end == rune_i {
				ok = true
				sub = sub[:i]
				break
			}
			rune_i += 1
		}

		if rune_end == rune_i {
			ok = true
		}
	}

	return
}
substring :: proc(s: string, rune_start: int, rune_end: int) -> (sub: string, ok: bool) {
	if rune_start < 0 || rune_end < 0 || rune_end < rune_start {
		return
	}

	return internal_substring(s, rune_start, rune_end)
}

read_file :: proc(name: string) -> string {


	data, ok := os.read_entire_file(name)
	if !ok {
		fmt.eprintln("Failed to read: ", name)

	}


	text := string(data)


	return text


}


new_list :: proc($T: typeid, allocator := context.allocator) -> [dynamic]T {
	return make([dynamic]T, allocator)
}
to_lines :: proc(s: string) -> []string {
	return strings.split(s, "\n")


}

Pos :: struct {
	line:  u32,
	index: u32,
}

parse_fmt :: proc(p: ^Pos, line: string, fmt := "println") -> string {
    if strings.contains(line, "${") {
        
        buf := new_list(rune)
        for s, i in line {
            
            if '$'== s {
    
               
                
               append(&buf, '"')
              append(&buf, ',')

            } else if  '}'== s {
               
             append(&buf, ',')
                append(&buf, '"')
              
               
            }
             else  {
                 if  '{'!= s {
                append(&buf, s)
             }
            }

            
        }
    
        
        
        
        
    tmp := utf8.runes_to_string(buf[:])
    
     split_str := strings.split_after(tmp, fmt)
    out := new_list(string)
    for s, i in split_str {
        if s[0] == '(' {
            count:= 0
            for st, ix in s {
                
                if st == ')' {
                    count = ix
                    break
                }
                
                
            }
            front,_ := substring(s, 0, count)
            tail,_ := substring(s,count +1, len(s) - 1 )

            sep: string = " "
            st := strings.concatenate([]string{front, ",sep = \"\")", tail })
            append(&out , st)
           
            
        } else {
            append(&out , s)
        }
        
        
    }
  	// tmp2 := strings.concatenate(split_str)
   
    sf, err  := strings.replace_all(strings.concatenate(out[:]),  ",\"\"", "")
    return sf

    } 
        return line
        
}
parse_lines :: proc(lines: []string) -> string {
	p: Pos
	out := new_list(string)
	for l, i in lines {
		p.line = u32(i)
		p.index = 0 
		// println
		if strings.contains(l, "fmt.println") {
		
		
		tmp := strings.concatenate([]string{parse_fmt(&p, l,"println" ), "\n"})
		append(&out, tmp)

		} else if  strings.contains(l, "fmt.sbprint") {
		
		
		tmp := strings.concatenate([]string{parse_fmt(&p, l,"sbprint" ), "\n"})
		append(&out, tmp)

		}   else {
			tmp := strings.concatenate([]string{l, "\n"})
			append(&out, tmp)
		}

	}
	
	return strings.concatenate(out[:])
}
main :: proc() {
    f := read_file("/Users/jonas/code/odin/odin-macros/test.odin")
    lines := to_lines(f)
    s:=parse_lines(lines)
    
    err := os.write_entire_file_or_err("/Users/jonas/code/odin/odin-macros/test_out.odin", transmute([]u8)s)
}