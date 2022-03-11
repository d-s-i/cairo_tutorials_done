# func main():
#     ap += SIZEOF_LOCALS
#     tempvar x = 0

#     local y
#     y = 6
#     ret
# end

func pow4(n) -> (m):
    # alloc_locals
    # local x

    jmp body if n != 0
    [ap] = 0; ap++
    ret

    body:
    tempvar x = n * n
    [ap] = x * x; ap++
    ret
end

func main():
    pow4(n=5)
    ret
end