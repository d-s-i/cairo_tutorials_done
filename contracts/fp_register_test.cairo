%builtins output

from starkware.cairo.common.serialize import serialize_word
from starkware.cairo.common.registers import get_fp_and_pc

# func main():
#     call foo
#     call foo
#     call foo

#     ret
# end

# func foo():
#     [ap] = 1000; ap++
#     ret
# end

func main{output_ptr: felt*}():
    [ap] = fp; ap++
    serialize_word([ap - 1])
    return ()
end