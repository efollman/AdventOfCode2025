let

n = 5

boolMat::Matrix{Bool} = fill(false,n,n)

u1::UInt64 = 0
u2::UInt64 = 0
u3::UInt64 = 0
u4::UInt64 = 0

i1::Int64 = 0
i2::Int64 = 0
i3::Int64 = 0
i4::Int64 = 0
for i = 1:n
  for j = 1:n
    for k = 1:n
      for l = 1:n

        u1 = i
        u2 = j
        u3 = k
        u4 = l

        i1 = i
        i2 = j
        i3 = k
        i4 = l

        try
          boolMat[u1:u2,u3:u4] .= true
        catch
          println("UInt Error @ [$u1:$u2,$u3:$u4]")
        end

        try
          boolMat[u1,u3:u4] .= true
        catch
          println("UInt Error @ [$u1,$u3:$u4]")
        end

        try
          boolMat[u1:u2,u4] .= true
        catch
          println("UInt Error @ [$u1:$u2,$u4]")
        end

        try
          boolMat[i1:i2,i3:i4] .= true
        catch
          println("Int Error @ [$i1:$i2,$i3:$i4]")
        end

        try
          boolMat[i1,i3:i4] .= true
        catch
          println("Int Error @ [$i1,$i3:$i4]")
        end

        try
          boolMat[i1:i2,i4] .= true
        catch
          println("Int Error @ [$i1:$i2,$i4]")
        end

      end
    end
  end
end
end

#=
Only seems to error in the form M[number,UInt64:number] .= something where the UInt is equal to 1

m[num:num,num] doesnt seem to ever throw anything as well as m[num:num,num:num] with the nums set to UInts

doesn't seem to be limited to bool matrixes or square matricies either i got the same error with

M = fill(0,2,4)

M[1,UInt(1):2] .= 0

though the value in InexactError was different 0xffffffffffffffff instead of 0xfffffffffffffffc

Only 64 bit UInt seems to throw the error consistently though ive gotten it to still throw on other bitlengths if the value after the colon is still UInt64

I was able to reproduce error on 2 Linux machines and a windows machine (all x86 cpus I dont have anything else to test on)
=#

## original case that gave me the issue

boolMatEx::Matrix{Bool} = fill(false,11,11)

p1::UInt = 7
p2::UInt = 1
p3::UInt = 3

boolMatEx[p1,p2:p3] .= true
