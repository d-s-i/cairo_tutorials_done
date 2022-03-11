func foo(a, x, y) -> (z, w):
    [ap] = x + y; ap++  # z.
    [ap] = x * y; ap++  # w.
    ret
end

func main():
    let args = cast(ap, foo.Args*)
    args.a = 8; ap++
    args.x = 12; ap++
    args.y = 1; ap++

    static_assert args + foo.Args.SIZE == ap
    let foot_ret = call foo
    return ()
end