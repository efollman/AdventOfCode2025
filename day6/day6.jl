global const currDIR::String = @__DIR__

function run()
    @time val = solveProblems("$currDIR/day6.txt")
    shouldbe = 13215665360076
    if val == shouldbe
        print("✓ Test Passed: $val == $shouldbe\n")
    else
        print("X Test Failed: $val != $shouldbe\n")
    end
    return nothing
end

function parseProblems(filepath::String)
    #Part two is a bruh moment
    allLines::Vector{String} = Vector{String}[]
    open(filepath) do file
        while !eof(file)
            push!(allLines,readline(file))
        end
    end

    strLen::UInt = length(allLines[1])
    charMat::Matrix{Char} = Matrix{Char}(undef,length(allLines),length(allLines[1]))
    for i in eachindex(allLines)
        if length(allLines[i]) != strLen
            @error "Line Length mismatch in parse"
        end
        charMat[i,:] = collect(allLines[i])
    end
    

    return charMat
end

function solveProblems(filepath::String)
    totalAnswer::UInt = 0

    charMat::Matrix{Char} = parseProblems(filepath)

    currentProblem::Vector{Int} = Vector{Int}[]
    for j = size(charMat,2):-1:1

        if all(charMat[:,j] .== ' ')
            currentProblem = Vector{Int}[]
            continue
        end

        push!(currentProblem,parse(Int,join(charMat[1:end-1,j])))

        if charMat[end,j] == ' '
            continue
        elseif charMat[end,j] == '*'
            totalAnswer += prod(currentProblem)
        elseif charMat[end,j] == '+'
            totalAnswer += sum(currentProblem)
        else
            @error "Operator Logic Problem"
        end

    end

    return totalAnswer

end

run()