using GhePlots
using Documenter

DocMeta.setdocmeta!(GhePlots, :DocTestSetup, :(using GhePlots); recursive=true)

makedocs(;
    modules=[GhePlots],
    authors="Graham Harper Edwards",
    sitename="GhePlots.jl",
    format=Documenter.HTML(;
        canonical="https://grahamedwards.github.io/GhePlots.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/grahamedwards/GhePlots.jl",
    devbranch="main",
)
