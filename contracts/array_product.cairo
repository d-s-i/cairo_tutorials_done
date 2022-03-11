%builtins output

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.serialize import serialize_word

func array_product(array: felt*, size) -> (product):
    if size == 0:
        return (1)
    end

    let (arr_product) = array_product(array + 1, size - 1)
    return (product = [array] * arr_product)
end

func main{output_ptr: felt*}():

    const ARRAY_SIZE = 3

    let (ptr) = alloc()

    assert [ptr] = 4
    assert [ptr + 1] = 3
    assert [ptr + 2] = 1

    let (product) = array_product(array=ptr, size=ARRAY_SIZE)

    serialize_word(product)

    return ()

end