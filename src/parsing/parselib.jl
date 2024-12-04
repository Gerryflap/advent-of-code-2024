module ParseLib
include("base.jl")
using .PBase

struct CharError
    to_match::Char
    input::String
end

function char_parser(char_to_match::Char) :: PBase.Parser
    function pl_parse(input::String) :: PBase.ParseResult{Char, CharError}
        if length(input) > 0 && input[1] == char_to_match
            return PBase.ParseResult(input[2:end], char_to_match)
        else
            return PBase.ParseResult(input, char_to_match)
        end            
    end
end

end #module