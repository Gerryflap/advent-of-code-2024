module day_09
using Match
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
    
    println("Part 2 - Test:")
    println(part_2(test_input_2))
    println("Part 2 - Real:")
    println(part_2(real_input))
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

"""
    Parses the line into a vector of blocks following the parse rules.
    The parse rules of AoC alternate between file and empty blocks.
    File blocks will get incrementing unique ids (starting at 0).
"""
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

"""
    Find the next non-empty blocks from the right, starting at current_index.
    Will return min_index if if cannot find any non-empty blocks before that.
"""
function next_file_index_from_right(fs::Vector{Blocks}, current_index::Int64, min_index::Int64)
    while current_index > min_index && fs[current_index].block_type == empty_block
        current_index -= 1
    end
    return current_index
end

"""
    Swaps all empty blocks on the left hand side with filled blocks until the filled and empty blocks are completely separated.

    When I wrote this, God and I knew what happened here.
    Now only God knows.
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
                fs[i] = Blocks(fs[i].block_type, fs[i].amount - fs[j].amount)
                # fs[j] is now invalid, move left
                j -= 1
                # Also check if we emptied fs[i]
                if fs[i].amount == 0
                    i += 1
                end
            else
                push!(fs_new, Blocks(fs[j].block_type, fs[i].amount))
                fs[j] = Blocks(fs[j].block_type, fs[j].amount - fs[i].amount)
                i += 1
            end
        else
            # Simply append
            push!(fs_new, fs[i])
            i +=1
        end          
    end
    if is_file(fs[i])
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

""" 
    Computes the new score and new index for a single block
"""
function compute_score(index::Int64, score::Int64, blocks::Blocks) :: Tuple{Int64, Int64}
    if is_empty(blocks)
        return index + blocks.amount, score
    end

    for i in index:(index + blocks.amount - 1)
        score += i * blocks.block_type.id
    end
    return index + blocks.amount, score
end

""" 
    Computes the score for the whole array of blocks
"""
function compute_score(blocks_vec::Vector{Blocks}) :: Int64
    index = 0
    total = 0
    for blocks in blocks_vec
        index, total = compute_score(index, total, blocks)
    end
    return total
end

# ====================================== Part 2 ======================================
function part_2(input::String)
    fs = parse_line(input)
    compact_defrag!(fs)
    checksum = compute_score(fs)
    return checksum
end

"""
    Compacts the blocks without fragmenting them.
    This function operates in-place, and may extend the array.
"""
function compact_defrag!(fs::Vector{Blocks})
    # Take the highest id as the start
    max_file_id = maximum(map(f -> f.block_type.id, filter(is_file, fs)))
    for file_id in max_file_id:-1:0
        file_pos = find_file_id(fs, file_id)
        to_pos = find_fitting_space(fs, file_pos)
        if !isnothing(to_pos)
            if fs[to_pos].amount == fs[file_pos].amount
                fs[file_pos],fs[to_pos] = fs[to_pos], fs[file_pos]
            else
                # empty space bigger than our file, we need to keep some empty space there
                file = fs[file_pos]
                empty_space = fs[to_pos]
                fs[file_pos] = Blocks(empty_block, file.amount)
                fs[to_pos] = Blocks(empty_block, empty_space.amount - file.amount)
                insert!(fs, to_pos, file)
            end
        end           
    end
end

"""
    Finds the index of the given file id.

    If multiple exist then you're messing around with my code, because that should never happen, but it'll pick the rightmost index.
    If no index exists then you're also messing with my code, and you'll get what you deserve >:3 
"""
function find_file_id(fs::Vector{Blocks}, file_id::Int64)
    for i in length(fs):-1:1
        if is_file(fs[i]) && fs[i].block_type.id == file_id
            return i
        end
    end
    error(@sprintf("Could not find file id %d", file_id))
end

"""
    Finds a place earlier in the blocks array for the object in fs at object_index.
    Will return nothing if this index cannot be found.
"""
function find_fitting_space(fs::Vector{Blocks}, object_index::Int64) :: Union{Int64, Nothing}
    size = fs[object_index].amount
    for i in 1:object_index
        if is_empty(fs[i]) && fs[i].amount >= size
            return i
        end
    end
    return nothing
end

end
