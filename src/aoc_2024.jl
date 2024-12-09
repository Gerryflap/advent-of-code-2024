import Pkg

Pkg.activate(".")

include("old_day_01_2023.jl")
include("day_01.jl")
include("day_02.jl")
include("day_03.jl")
include("day_04.jl")
include("day_05.jl")
include("day_09.jl")

# Runs all implemented days from 2024
function run_all()
    day_01.run()
    day_02.run()
    day_03.run()
    day_04.run()
    day_05.run()
    day_09.run()
end