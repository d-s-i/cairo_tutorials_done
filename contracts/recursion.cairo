%builtins output

from starkware.cairo.common.serialize import serialize_word

func calc_exposant(base, value, n) -> (result):
    if n == 1:
    [ap] = value; ap++
    ret
    end

    [ap] = base; ap++
    [ap] = base * value; ap++
    [ap] = n - 1; ap++
    let result = call calc_exposant
    ret
end

func main{output_ptr : felt*}():
    [ap] = 2; ap++
    [ap] = [ap - 1]; ap++
    [ap] = 10; ap++
    let fn_result = call calc_exposant
    serialize_word(fn_result.result)
    return ()
end