%builtins output

from starkware.cairo.common.serialize import serialize_word
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.registers import get_fp_and_pc

struct MyStruct:
    member x : felt
    member y : felt
    member z : felt
end

func main{output_ptr : felt*}():
    alloc_locals
    let (local struct_array : MyStruct*) = alloc()
    let (__fp__, _) = get_fp_and_pc()

    const test = 11
    const test2 = 15
    const test3 = 23
    # assert struct_array[0] = MyStruct(
    #     x=5, 
    #     y=12,
    #     z=9
    # )

    # assert [[fp] + 1] = [[fp] + MyStruct.y]
    # serialize_word(struct_array[0].x)
    serialize_word([fp])
    serialize_word([ap])
    # serialize_word([[fp] + 1])
    # serialize_word([[fp] + MyStruct.y])
    # serialize_word(MyStruct.y)
    # serialize_word(fp)

    return ()
end