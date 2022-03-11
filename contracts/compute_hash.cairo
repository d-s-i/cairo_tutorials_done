%builtins output pedersen

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.hash import hash2
from starkware.cairo.common.serialize import serialize_word
from starkware.cairo.common.alloc import alloc

func hash_all{output_ptr : felt*, pedersen_ptr : HashBuiltin*}(
    unhashed_numbers : felt*,
    size : felt
) -> (hashed_numbers : felt):
    if size == 0:
        return (size)
    end

    tempvar x = [unhashed_numbers]
    tempvar y = [unhashed_numbers + 1]

    let (hash) = hash2{hash_ptr=pedersen_ptr}(x=x, y=y)
    serialize_word(hash)

    return hash_all(unhashed_numbers=unhashed_numbers + 2, size=size - 2)
end

func main{output_ptr : felt*, pedersen_ptr : HashBuiltin*}():
    alloc_locals

    const ARRAY_SIZE = 4
    
    local unhashed_numbers : felt*
    let (local unhashed_numbers : felt*) = alloc()

    assert unhashed_numbers[0] = 10
    assert unhashed_numbers[1] = 3
    assert unhashed_numbers[2] = 3
    assert unhashed_numbers[3] = 10

    hash_all(unhashed_numbers, ARRAY_SIZE)
    return ()
end