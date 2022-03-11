%builtins output

from starkware.cairo.common.serialize import serialize_word
from starkware.cairo.common.alloc import alloc

struct MyStruct:
    member first_member: felt
    member second_member: felt
end

func main{output_ptr : felt*}() -> ():
    alloc_locals
    local felt_array : felt*
    let (local struct_array : MyStruct*) = alloc()
    assert struct_array[0] = MyStruct(
        first_member=1, 
        second_member=2
    )

    serialize_word(struct_array[0].first_member)
    serialize_word(struct_array[0].second_member)

    return ()
end