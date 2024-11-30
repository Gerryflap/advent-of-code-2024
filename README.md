# Advent of Code 2024
This year the honour goes to the Julia language.

## Running
From the **root folder** (aoc_2024) of this project, do the following:

- Start the julia REPL: `julia`
- Activate and import the project using `include("src/aoc_2024.jl")`
- Run the day you want to run using `<day_name>.run()` (e.g `day_01.run()`)
    - Days are modules and may also expose other values and functions like the inputs (e.g. `real_input`) 
        and the individual part functions (e.g. `part_1(input::String)`)