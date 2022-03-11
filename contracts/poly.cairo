%builtins output

from starkware.cairo.common.serialize import serialize_word

func main{output_ptr: felt*}():
    [ap] = 100; ap++
    [ap] = [ap - 1] * [ap - 1]; ap++
    [ap] = [ap - 1] * [ap - 2]; ap++
    [ap] = [ap - 2] * 23; ap++
    [ap] = [ap - 4] * 45; ap++

    serialize_word([ap - 3] + [ap - 2] + [ap - 1] + 67)
    return ()
end

# same fn as above using tempvar
# func main{output_ptr : felt*}():
#     [ap] = 100; ap++
#     tempvar result = ([ap - 1] * [ap - 1] * [ap - 1]) + ([ap - 1] * [ap - 1] * 23) + (45 * [ap - 1]) + 67

#     serialize_word(result)
#     return ()
# end