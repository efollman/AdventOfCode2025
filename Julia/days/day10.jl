#Part 1 complete!
#speed improvment likely possible with using bitwise operators instead of parsing a binary representation as a string in the pressing sim.
#Part2 is yikes 
#brute force even with some optimization is far too slow. Quarter second to do example case but tens of minutes to get through just the first machine in actual data.
#linear algebra solution likely the best option (how to ensure no fractions and minimum presses?)

using LinearAlgebra
using RowEchelon
function day10()

    function run()
        println("Running day10:")
        @time val = day10main("$inputExDIR/day10.txt")
        shouldbe = 33
        if val == shouldbe
            print("✓ Test Passed: $val == $shouldbe\n")
        else
            print("X Test Failed: $val != $shouldbe\n")
        end
        println()
        return nothing
    end

    function parseFile(filepath::String)
        currLine::Vector{String} = []
        machines::Dict{UInt,Dict{String,Union{Vector{Bool},Vector{Vector{UInt}},Vector{UInt}}}} = Dict()
        lineCount::UInt = 1
        buttonCount::UInt = 1

        open(filepath) do file
            while !eof(file)
                machines[lineCount] = Dict()
                currLine = split(readline(file)," ")
                for str in currLine
                    if str[1] == '['
                        machines[lineCount]["Indicator"] = extractIndicator(str)
                    elseif str[1] == '('
                        if buttonCount == 1
                            machines[lineCount]["Buttons"] = Vector{UInt}[]
                        end
                        push!(machines[lineCount]["Buttons"],extractNumList(str))
                        buttonCount += 1
                    elseif str[1] == '{'
                        machines[lineCount]["Joltage"] = extractNumList(str)
                    else
                        @error "Parse Logic Fault"
                    end
                end
                lineCount += 1
                buttonCount = 1
            end
        end
        return machines
    end

    function extractIndicator(str::String)
        boolVec::Vector{Bool} = []

        for char in str
            if char == '.'
                push!(boolVec,false)
            elseif char == '#'
                push!(boolVec,true)
            elseif char == '[' || char == ']'
            else
                @error "Indicator Parse Logic Fault"
            end
        end

        return boolVec
    end
    
    function extractNumList(str::String)
        numList::Vector{UInt} = []
        currN::String = ""

        for char in str
            if isnumeric(char)
                currN = currN * char
            elseif char == ',' || char == ')' || char == '}'
                push!(numList,parse(UInt,currN))
                currN = ""
            elseif char == '(' || char == '{'
            else
                @error "Indicator Parse Logic Fault"
            end
        end

        return numList
    end

    function day10main(filepath::String)
        #LA solution, convert buttons to sys of equations and RREF fix underdefined later
        machinesType::Type = Dict{UInt,Dict{String,Union{Vector{Bool},Vector{Vector{UInt}},Vector{UInt}}}} 
        machines::machinesType = parseFile(filepath)
        minPresses::UInt = 0
        for key in sort(collect(keys(machines)))
            minPresses += minimumMachine(machines[key])
        end
        
        return minPresses
    end

    function minimumMachine(machine::Dict{String,Union{Vector{Bool},Vector{Vector{UInt}},Vector{UInt}}})
        buttons::Vector{Vector{UInt}} = machine["Buttons"]
        joltage::Vector{UInt} = machine["Joltage"]
        M::Matrix = fill(0,length(joltage),length(buttons))
        for i in eachindex(buttons), j in buttons[i]
            M[j+1,i] = 1
        end
        
        M = hcat(M,joltage)
        println()
        for row in eachrow(M)
            println(row)
        end
        M = rref(M)
        println()
        for row in eachrow(M)
            println(row)
        end

        return 0

    end

    run()
end