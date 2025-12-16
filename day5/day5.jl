global const currDIR::String = @__DIR__

function run()
    val = freshNum("$currDIR/day5ex.txt")
    println(val)
    return nothing
end

function freshNum(filepath::String)
    freshIDs::Set{UInt64} = Set()
    availIDs::Set{UInt64} = Set()
    open(filepath) do file
        currLine::String = ""
        rangeStart::String = ""
        rangeEnd::String = ""
        while !eof(file)
            currLine = readline(file)
            if contains(currLine,"-")
                rangeStart,rangeEnd = split(currLine,"-")
                freshIDs = union(freshIDs,Set{UInt64}(parse(UInt64,rangeStart):parse(UInt64,rangeEnd)))
            elseif isempty(currLine)
                continue
            else
                availIDs = union(availIDs,Set(parse(UInt64,currLine)))
            end
            println(freshIDs)
            println(availIds)
            println()

        end
    end
    
    return 0

end

run()