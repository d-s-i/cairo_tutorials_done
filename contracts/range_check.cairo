%builtins range_check

from starkware.cairo.common.serialize import serialize_word

# func foo{range_check_ptr : felt}(x):
#     [range_check_ptr] = x
#     assert [range_check_ptr + 1] = 1000 - 1 - x
#     serialize_word([range_check_ptr])
#     serialize_word([range_check_ptr + 1])
#     let range_check_ptr = range_check_ptr + 2
#     return ()
# end

func foo{range_check_ptr : felt}(w, x, y, z):
    [range_check_ptr] = w
    [range_check_ptr + 1] = x
    [range_check_ptr + 2] = y
    [range_check_ptr + 3] = z
    assert [range_check_ptr + 4] =  y - 1 - x
    assert [range_check_ptr + 5] =  z - 1 - x
    assert [range_check_ptr + 6] =  w - 1 - z
    assert [range_check_ptr + 7] = 2 ** 64 - 1 - w

    let range_check_ptr = range_check_ptr + 8
    return ()
end

func is_divisible_by_3{range_check_ptr : felt}(x):
    %{
        memory[ap] = int(ids.x / 3)
    %}
    tempvar y = [ap]
    [range_check_ptr] = x
    assert [range_check_ptr + 1] = 2 ** 128 - 1 - x
    [range_check_ptr + 2] = y
    assert [range_check_ptr + 3] = 2 ** 128 - 1 - y
    assert x = 3 * y
    let range_check_ptr = range_check_ptr + 4
    return ()
end

func main{range_check_ptr : felt}():
    # x < y < z < w 
    tempvar w = 20
    tempvar x = 10
    tempvar y = 13
    tempvar z = 14
    # foo(x)
    # foo(w, x, y, z)
    is_divisible_by_3(x)
    return ()
end