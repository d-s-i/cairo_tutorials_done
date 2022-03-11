# func main():
#     [ap] = 10; ap++

#     my_loop:
#         [ap] = [ap - 1] - 1; ap++
#         if [ap - 1] == 0:
#             return ()
#         end
#     jmp my_loop
# end

func main():
    let x = [ap]
    [ap] = 1; ap++
    [ap] = 2; ap++

    [ap] = x; ap++
    jmp rel -1  # Jump to the previous instruction.
end