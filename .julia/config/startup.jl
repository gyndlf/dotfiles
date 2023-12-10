# My startup script

# If in a REPL add some nice libraries

atreplinit() do repl
    try
        @eval using OhMyREPL  # get some nice repl stuff here
    catch err
        if isa(err, ArgumentError)
            @info "OhMyREPL is not in the current environment"
        end
    end

    try
        @eval using Revise
    catch err
        if isa(err, ArgumentError)
            @info "Revise is not in the current environment"
        end
    end
end
