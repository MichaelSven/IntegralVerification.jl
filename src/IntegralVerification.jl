module IntegralVerification

using Statistics
using Random

export testIntegral, testExpressions

function doStatTest(testvalues, precision; verbose = true)
    output = Statistics.mean(testvalues),Statistics.std(testvalues)
    if verbose
        println("mean = ",output[1])
        println("std  = ", output[2])
    end
    if abs(output[1]) < precision && abs(output[2]) < precision
        return true
    end
    return false
end

function generateRandomArgs(randomVariables)
    vars = zeros(ComplexF64, length(randomVariables))
    for (i,f) in enumerate(randomVariables)
        vars[i] = f()
    end
    return vars
end

function testIntegral(integrator, integrand, analytic, randomVariables, Ntests,  precision = 10. ^ (-7))
    
    numeric(args...) = integrator(x -> integrand(x, args...))
    
    return testExpressions(numeric, analytic, randomVariables, Ntests,precision)
    
end 


function testExpressions(expr1, expr2, Ntests)
    return testExpressions(expr1,expr2,[randn],Ntests)
end

function testExpressions(expr1,expr2,randomVariables,Ntests,precision = 10. ^ (-7))
    
    if Ntests < 2
        throw(ArgumentError)
    end
    
    outvalues = zeros(ComplexF64, Ntests)
    for i in 1:Ntests
        args = generateRandomArgs(randomVariables)
        outvalues[i] = expr1(args...) - expr2(args...)
    end
    
    passed = doStatTest(outvalues, precision)
    
    if passed
        println("passed")
    else
        println("failed")
    end
    return passed
end

end # module
