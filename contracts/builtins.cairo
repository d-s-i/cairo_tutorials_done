%builtins output pedersen 

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.hash import hash2
from starkware.cairo.common.serialize import serialize_word

func hash3{pedersen_ptr : HashBuiltin*}(
    x,
    y,
    z
) -> (result):
    let (first_hash) = hash2{hash_ptr=pedersen_ptr}(
        x=x,
        y=y
    )
    let (full_hash) = hash2{hash_ptr=pedersen_ptr}(
        x=first_hash, 
        y=z
    )

    return (result=full_hash)
end

func main{output_ptr : felt*, pedersen_ptr : HashBuiltin*}():
    tempvar x = 10
    tempvar y = 3
    tempvar z = 7

    let (hash_all) = hash3{pedersen_ptr=pedersen_ptr}(x=x, y=y, z=z)
    serialize_word(hash_all)
    return()
end

