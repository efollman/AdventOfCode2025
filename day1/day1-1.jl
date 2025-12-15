global const currDIR::String = @__DIR__

function passfunc(filedir::String)
    open(filedir) do file

        counter = 0
        dial = 50
        while !eof(file)
            currLine = readline(file)
            if currLine[1] == 'L'
                dial = (dial - parse(Int,currLine[2:end]))%100
            elseif currLine[1] == 'R'
                dial = (dial + parse(Int,currLine[2:end]))%100
            else
                @error "Not L or R???"
            end
            if dial == 0
                counter += 1
            end
        end
        println("Total 0's: $counter")
    end
end

@time passfunc("$currDIR/day1-1.txt")
