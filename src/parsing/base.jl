module PBase

# The result of parsing, with the remaining input and the 
struct ParseResult{ResultType, ErrorType}
    remainder::String
    result::Union{ResultType, ErrorType}
end

# Represents the result of parsing successfully
struct Result{T}
    v :: T
end

# Represents an error during parsing
struct Error{T}
    v :: T
end

ParseOutcome{S, E} = Union{Result{S}, Error{E}}

struct NotImplementedException <: Exception end

function pl_parse(input::String) where {ResultType, ErrorType}  :: ParseResult{ResultType, ErrorType}
    throw(NotImplementedException())
end

Parser{ResultType, ErrorType} = pl_parse{ResultType, ErrorType}

# The type of this is gonna be a bit messy
function combine(result_combinator{}, p::Parser ...) where {T, E} :: Parser{T <: Tuple, E}
    function pl_parse(input::String) :: PBase.ParseResult{Char, CharError}
        s = input
        for parser in p
           result = parser(s)
           
        end
    end
end

end