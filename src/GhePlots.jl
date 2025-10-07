module GhePlots

    import ColorSchemes 
    import Makie as Mke

    export dark_mode, light_mode, FigText

    """

        dark_mode()

    Makie theme for dark backgrounds.
    """
    dark_mode() = Mke.Theme(

        fonts=(;regular="IBM Plex Sans Regular",bold="IBM Plex Sans Bold",italic="IBM Plex Sans Italic"),fontsize = 14, 

        backgroundcolor=:transparent, labelcolor=:white, palette = (; color = ColorSchemes.tol_bright),
        

        Axis =(backgroundcolor=:transparent, 

            spinewidth=2.,ytickwidth=2., xtickwidth=2.,
            
            bottomspinecolor=:white,topspinecolor=:white,leftspinecolor=:white,rightspinecolor=:white,
            

            xgridcolor=(:white,0.1),ygridcolor=(:white,0.1),
            xgridvisible=false,ygridvisible=false,

            xtickcolor=:white,ytickcolor=:white, 
            yticklabelcolor=:white,xticklabelcolor=:white,
            
            xlabelcolor=:white,ylabelcolor=:white,titlecolor=:white),

        Legend = (
            labelcolor=:white,
            backgroundcolor=:transparent,
            framecolor=:white),
            )

    """

        light_mode()

    Makie theme for white backgrounds.

    """
    light_mode() = Mke.Theme(; 
        palette = (
            colormap=:tokyo, 
            color = ColorSchemes.seaborn_colorblind ),
        fonts=(;regular="IBM Plex Sans Regular", bold="IBM Plex Sans Bold", italic="IBM Plex Sans Italic",), fontsize = 14,
        Axis=(  spinewidth=1,ytickwidth=1, xtickwidth=1, backgroundcolor=:white, yticksize=3.0, xticksize=3.0,
        
                xgridvisible=false,ygridvisible=false,
                bottomspinecolor=:gray10,topspinecolor=:gray10,leftspinecolor=:gray10,rightspinecolor=:gray10,)     
    )



    """

    The FigText module contains functions that make adding text to tables and figures prettier, easier: 
    - `FigText.sub` (subscript)
    - `FigText.sup` (superscript)
    - `FigText.siground`

    Use `help?` for more info.

    """
    module FigText

        """
            
            FigText.sub(I)

        Return a unicode string subscript of Integer `I`. 

        """
        function sub(I::Int)
            c = I < 0 ? [Char(0x208B)] : []

            for d in reverse(digits(abs(I)))
                push!(c, Char(0x2080+d))
            end
            return join(c)
        end


        """
            
            FigText.sup(I)

        Return a unicode string superscript of Integer `I`. 

        """
        function sup(I::Int)
            c = I < 0 ? [Char(0x207B)] : []

            for d in reverse(digits(abs(I)))
                d == 0 && push!(c, Char(0x2070))
                d == 1 && push!(c, Char(0x00B9))
                d == 2 && push!(c, Char(0x00B2))
                d == 3 && push!(c, Char(0x00B3))
                d >  3 && push!(c, Char(0x2070+d))
            end
            return join(c)
        end


        """

            FigText.siground(x,u,sigfigs=3)

        Round a measurement `x` and its uncertainty `u` to `sigfigs`. Accepts a single value or a `Tuple` of values for `u`.

        Returns a `Tuple` of `(x,u...)`

        e.g.
            julia> siground(523.12, (15.8,278.0) )
            (523, 16, 278)

        """
        function siground(x::Number, u; sigfigs::Int=3)
            @assert length(u) >= 1

            x = round(x,sigdigits=sigfigs)

            if isinteger(x)
                x = Int(x)
                u = round.(Int,u)
                Δdigits = ndigits(x) .- ndigits.(u)
                u = (( Int(round(u[i],sigdigits = sigfigs - Δdigits[i])) for i in eachindex(u))..., )
            else
                ur = round.(u, sigdigits=sigfigs)
                _,xex = Base.Ryu.reduce_shortest(x)
                uex = ((Base.Ryu.reduce_shortest(i)[2] for i in ur)...,)
                u = ((round(u[i],sigdigits = sigfigs - (xex-uex[i])) for i in eachindex(u))...,)
            end
            (x,u...)
        end

    end 

end