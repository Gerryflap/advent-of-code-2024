module day_09
using Match
using Accessors
using Printf

real_input = read("inputs/09_real.txt", String)
test_input_1 = read("inputs/09_test.txt", String)
test_input_2 = read("inputs/09_test.txt", String)

function run()
    println("Day 9:")
    println("Part 1 - Test:")
    println(part_1(test_input_1))
    println("Part 1 - Real:")
    println(part_1(real_input))
    
    # println("Part 2 - Test:")
    # println(part_2(test_input_2))
    # println("Part 2 - Real:")
    # println(part_2(real_input))
end

struct EmptyBlock end
struct FileBlock
    id :: Int64
end

Block = Union{EmptyBlock, FileBlock}

empty_block::Block = EmptyBlock()


struct Blocks
    block_type::Block
    amount::Int64
end

function is_empty(blocks::Blocks) :: Bool
    return blocks.block_type == empty_block
end

function is_file(blocks::Blocks) :: Bool
    return !is_empty(blocks)
end

function part_1(input::String) :: Int64
    fs = parse_line(input)
    fs_new = compact(fs)
    checksum = compute_score(fs_new)
    return checksum
end

function parse_line(line::String) :: Vector{Blocks}
    fs::Vector{Blocks} = fill(Blocks(empty_block, 0), length(line))
    empty = false
    id = 0
    for (i::Int64, c::Char) in enumerate(line)
        amount::Int64 = parse(Int64, c)
        if empty
            fs[i] = Blocks(empty_block, amount)
            empty = false
        else
            fs[i] = Blocks(FileBlock(id), amount)
            id += 1
            empty = true
        end
    end
    return fs
end

function next_empty_index_from_left(fs::Vector{Blocks}, current_index::Int64, max_index::Int64)
    while current_index < max_index && fs[current_index] != empty_block
        current_index += 1
    end
    return current_index
end

function next_file_index_from_right(fs::Vector{Blocks}, current_index::Int64, min_index::Int64)
    while current_index > min_index && fs[current_index].block_type == empty_block
        current_index -= 1
    end
    return current_index
end

"""
    Swaps all empty blocks on the left hand side with filled blocks until the filled and empty blocks are completely separated
"""
function compact(fs::Vector{Blocks}) :: Vector{Blocks}
    fs = copy(fs)
    i = 1
    j = length(fs)
    fs_new::Vector{Blocks} = []
    while i < j
        if is_empty(fs[i])
            j = next_file_index_from_right(fs, j, i)
            if i >= j
                break
            end

            if fs[i].amount >= fs[j].amount
                push!(fs_new, fs[j])
                # @printf(">= : i=%d, j=%d, %s\n", i, j, fs_new)
                fs[i] = Blocks(fs[i].block_type, fs[i].amount - fs[j].amount)
                # fs[j] is now invalid, move left
                j -= 1
                # Also check if we emptied fs[i]
                if fs[i].amount == 0
                    i += 1
                end
            else
                push!(fs_new, Blocks(fs[j].block_type, fs[i].amount))
                # @printf("< : i=%d, j=%d, %s\n", i, j, fs_new)
                fs[j] = Blocks(fs[j].block_type, fs[j].amount - fs[i].amount)
                i += 1
            end
        else
            # Simply append
            push!(fs_new, fs[i])
            # @printf("file : i=%d, j=%d, %s\n", i, j, fs_new)
            i +=1
        end          
    end
    # @printf("Stopped at i=%d, j=%d\n", i, j)
    if is_file(fs[i])
        # @printf("Is File at i=%d, j=%d\n", i, j)
        if fs[i].block_type == fs_new[end].block_type
            fs_new[end] = Blocks(fs[i].block_type, fs[i].amount + fs_new[end].amount)
        else
            push!(fs_new, fs[i])
        end
    end
    empty_blocks = sum([e.amount for e in fs if e.block_type == empty_block])
    push!(fs_new, Blocks(empty_block, empty_blocks))
    return fs_new
end

function compute_score(index::Int64, score::Int64, blocks::Blocks) :: Tuple{Int64, Int64}
    if is_empty(blocks)
        return index + blocks.amount, score
    end

    for i in index:(index + blocks.amount - 1)
        score += i * blocks.block_type.id
    end
    return index + blocks.amount, score
end

function compute_score(blocks_vec::Vector{Blocks}) :: Int64
    index = 0
    total = 0
    for blocks in blocks_vec
        index, total = compute_score(index, total, blocks)
    end
    return total
end
end



day_09.run()
