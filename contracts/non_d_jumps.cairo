%builtins output

from starkware.cairo.common.serialize import serialize_word

func div2(x):
    %{ memory[ap] = 0 %}
    jmp odd if [ap] != 0; ap++

    even:
    # Case n % 2 == 0.
    [ap] = x / 2; ap++
    ret

    odd:
    # Case n % 2 == 1.
    [ap] = x - 1; ap++
    [ap] = [ap - 1] / 2; ap++
    ret
end

func main{output_ptr: felt*}():
    [ap] = 11; ap++
    call div2
    serialize_word([ap - 1])
    ret
end