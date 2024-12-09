module day_06
using Match

real_input = read("inputs/04_real.txt", String)
test_input_1 = read("inputs/04_test_p1.txt", String)
# Test input the same...
test_input_2 = read("inputs/04_test_p1.txt", String)

function run()
    println("Day 6:")
    println("Part 1 - Test:")
    println(part_1(test_input_1))
    println("Part 1 - Real:")
    println(part_1(real_input))
    
    println("Part 2 - Test:")
    println(part_2(test_input_2))
    println("Part 2 - Real:")
    println(part_2(real_input))
end

function part_1(input::String) :: Int64
    # Transform into char matrix
    split_inp = split(input, "\n")
    rows = length(split_inp)
    cols = length(split_inp[1])
    grid = reduce(vcat, permutedims.(collect.(split_inp)))
    row, column = findfirst(x -> x=='^', grid).I
    grid = map(convert_gridslots, grid)

    direction::Direction = Direction.UP
    pos = row, column
    while row in 1:rows && column in 1:cols
    
    end
end

@enum Direction begin
    UP      = 1;
    RIGHT   = 2;
    DOWN    = 3;
    LEFT    = 4;
end

function turn_right(dir::Direction) :: Direction
    return @match dir begin
        $UP => $RIGHT
        $RIGHT => $DOWN
        $DOWN => $LEFT
        $LEFT => $UP
    end
end

@enum GridSlot begin
    EMPTY
    BLOCKED
    BOUND
end

function convert_gridslots(v::Char) :: GridSlot
    return @match v begin
        '#' => $BLOCKED
        _ => $EMPTY
    end
end

function movement(dir:Direction) :: Tuple{Int64, Int64}
    return @match dir begin
        $UP => (-1, 0)
        $RIGHT => (0, 1)
        $DOWN => (1, 0)
        $LEFT => (0, -1)
    end    
end

function get_grid_slot(grid::Array{GridSlot, 2}, pos::Tuple{Int64, Int64}) :: GridSlot
    rows, cols = size(grid)
    row, col = pos
    if !(row in 1:rows && col in 1:cols)
        return $BOUND
    end

end
end