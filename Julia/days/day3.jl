function day3()

    function run()
        println("Running Day 3:")
        @time val = findJoltage("$inputDIR/day3.txt")
        shouldbe = 170731717900423
        if val == shouldbe
            print("✓ Test Passed: $val == $shouldbe\n")
        else
            print("X Test Failed: $val != $shouldbe\n")
        end
        println()
        return nothing
    end

    function findJoltage(filepath::String)
        rangeString::String = ""
        joltage::UInt = 0
        open(filepath) do file
            let
                currLine::String = ""
                
                digitVec::Vector{UInt} = []

                while !eof(file)
                    currLine = readline(file)
                    digitVec = []
                    for char in currLine
                        push!(digitVec,parse(UInt,char))
                    end
                    x = findBankJoltage(digitVec)
                    joltage += x
                end  
            end
        end
        return joltage
    end

    function findBankJoltage(vec::Vector{UInt})

        digitsNeeded::UInt = 12
        currDigit::UInt = 1
        modVec::Vector{UInt} = fill(0,digitsNeeded)

        largestDigit::UInt = 0
        largestDigiti::UInt = 0
        
        for d::UInt = 1:digitsNeeded
            largestDigit = 0
            largestDigiti = 0
            for i::UInt = (length(vec)-(digitsNeeded-d)):-1:1
                if vec[i] >= largestDigit
                    largestDigit = vec[i]
                    largestDigiti = i
                end
            end
            modVec[d] = largestDigit
            if d != digitsNeeded
                vec = vec[largestDigiti+1:end]
            end
        end
        
        joltageString::String = ""

        for digit in modVec
            joltageString = joltageString*string(digit)
        end

        
        bankJoltage::UInt = parse(UInt,joltageString)
        return bankJoltage
    end

    run()
end