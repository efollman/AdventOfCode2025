#Part 1 complete!
#speed improvment likely possible with using bitwise operators instead of parsing a binary representation as a string in the pressing sim.
#Part2 is yikes 
#brute force even with some optimization is far too slow. Quarter second to do example case but tens of minutes to get through just the first machine in actual data.
#linear algebra solution likely the best option (how to ensure no fractions and minimum presses?)


function day10()

    function run()
        println("Running day10:")
        @time val = day10main2("$inputDIR/day10.txt")
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

    function day10main2(filepath::String)
        machines::Dict{UInt,Dict{String,Union{Vector{Bool},Vector{Vector{UInt}},Vector{UInt}}}} = parseFile(filepath)

        minPress::UInt = 0
        for i in keys(machines)
            println("X")
            minPress += minPressMachine2(machines[i])
        end

        return minPress

    end

    function minPressMachine2(machine::Dict{String,Union{Vector{Bool},Vector{Vector{UInt}},Vector{UInt}}})
        joltage::Vector{UInt} = machine["Joltage"]
        buttons::Vector{Vector{UInt}} = machine["Buttons"]

        maxN::UInt = maximum(joltage)
        maxComb::Vector{UInt} = fill(maxN, length(buttons))
        currComb::Vector{UInt} = fill(0,length(buttons))
        tmpJolt0::Vector{UInt} = fill(0,length(joltage))
        tmpJolt::Vector{UInt} = copy(tmpJolt0)
        minPresses::UInt = typemax(UInt)
        currPresses::UInt = 0

        while true
            for (button,N) in zip(buttons,currComb)
                tmpJolt = pressButton2(tmpJolt,button,N)
                currPresses += N
            end

            if (tmpJolt == joltage) && (currPresses < minPresses)
                minPresses = currPresses
            end

            if currComb == maxComb
                break
            end

            if any(tmpJolt .> joltage)
                currComb = nextnextCombo(currComb,maxN)
            else
                currComb = nextCombo(currComb,maxN)
            end

            tmpJolt = copy(tmpJolt0)
            currPresses = 0

        end

        return minPresses   
    end

    function nextnextCombo(comb::Vector{UInt},maxN::UInt)
        flag::Bool = false
        flag2::Bool = false
        for i in eachindex(comb)
            if (comb[i] == 0) && (flag == false)
                continue
            elseif flag == false
                flag = true
                comb[i] = 0
            elseif flag == true
                if comb[i] < maxN
                    comb[i] += 1
                    flag2 = true
                    break
                else
                    comb[i] = 0
                end
            end
        end

        if flag2 == false
            comb = fill(maxN,length(comb))
        end

        return comb
    end

    function nextCombo(comb::Vector{UInt},maxN::UInt)
        for i in eachindex(comb)
            if comb[i] < maxN
                comb[i] += 1
                break
            else
                comb[i] = 0
                continue
            end
        end
        return comb
    end

    function pressButton2(jolt::Vector{UInt},button::Vector{UInt},N::UInt)
        for i in button
            jolt[i+1] += N #input 0 indexed
        end
        return jolt
    end

    function day10main(filepath::String)
        machines::Dict{UInt,Dict{String,Union{Vector{Bool},Vector{Vector{UInt}},Vector{UInt}}}} = parseFile(filepath)

        minPress::UInt = 0
        for i in keys(machines)
            minPress += minPressMachine(machines[i])
        end

        return minPress

    end

    function minPressMachine(machine::Dict{String,Union{Vector{Bool},Vector{Vector{UInt}},Vector{UInt}}})
        indicator::Vector{Bool} = machine["Indicator"]
        buttons::Vector{Vector{UInt}} = machine["Buttons"]
        
        currInd::Vector{Bool} = fill(false,length(indicator))
        currComb::UInt = 0
        currCombS::String = ""
        currCombMax = 2^(length(buttons))-1
        presses::UInt = 0
        minPresses::UInt = typemax(UInt)

        while currComb <= currCombMax
            currCombS = bitstring(currComb)[end-(length(buttons))+1:end]
            for chari in eachindex(currCombS)
                if currCombS[chari] == '1'
                    currInd = pressButton(currInd,buttons[chari])
                    presses +=1
                elseif currCombS[chari] == '0'
                else
                    @error "button combination logic fault"
                end
            end
            if currInd == indicator && presses < minPresses
                minPresses = presses
            end
            currComb += 1
            presses = 0
            currInd = fill(false,length(currInd))
        end
        return minPresses   
    end

    function pressButton(ind::Vector{Bool},button::Vector{UInt})
        for i in button
            ind[i+1] = !ind[i+1] #input 0 indexed
        end
        return ind
    end

    run()
end