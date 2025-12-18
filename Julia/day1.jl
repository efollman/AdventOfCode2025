global const currDIR::String = @__DIR__

function passfunc(filedir::String)
    open(filedir) do file
        let
            counter::UInt = 0
            dial::Int = 50
            sign::Int = 0
            tempdial::Int = 0
            currLine::String = ""
            value::Int = 0
            while !eof(file)
                currLine = readline(file)
                value = parse(Int,currLine[2:end])
                

                if value >= 100
                    counter += UInt(floor(abs(value/100)))
                    value = mod(value,100)
                end

                if currLine[1] == 'L'
                    value = -value
                elseif currLine[1] != 'R'
                    @error "Not L or R???"
                end
                
                tempdial = dial + value

                if (tempdial >=100 || tempdial <=0) && dial != 0
                    counter += UInt(1)
                end

                dial = mod(tempdial,100)

            end
            return counter
        end
    end
end

function run()
    test::UInt = 0
    @time test = passfunc("$currDIR/day1.txt")
    if test == 6738
        println("Passed: $test = 6738")
    end
    return nothing
end

run()
