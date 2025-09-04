# Code figures in the slides

using Plots, Distributions, LaTeXStrings, Measures, CSV, DataFrames, Downloads
using LinearAlgebra, Random, Statistics, Optim, KernelDensity
using BayesianLearningBook
colors = BayesianLearningBook.colors
using ColorSchemes: grays
courseFolder = "/home/mv/Dropbox/Teaching/BayesLearning/"
figFolder = courseFolder*"slides/Images/"

# Set seed   
Random.seed!(123)

Plots.reset_defaults()
gr(legend = nothing, grid = false, color = colors[1], lw = 2, legendfontsize=12,
    xtickfontsize=12, ytickfontsize=12, xguidefontsize=14, yguidefontsize=16,
    markerstrokecolor = :auto)



nSim = 1000
p1 = plot(xlabel = "number of samples, "*L"n", ylabel = L"\bar{x}_n",
    title = L"\mathrm{Gamma}(5,1)", legend = :bottomright)
hline!([5], lw = 2, linestyle = :dash, label = "true mean")
for i = 1:3
    x = rand(Gamma(5, 1), nSim)
    plot!(1:nSim, (1 ./ (1:nSim)) .* cumsum(x), color = colors[i], 
    label = "replicate $i", lw = 2)
end
p1

p2 = plot(xlabel = "number of samples, "*L"n", ylabel = L"\bar{x}_n",
    title = L"\mathrm{Poisson}(2)", legend = false)
hline!([2], lw = 2, linestyle = :dash, label = "true mean")
for i = 1:3
x = rand(Poisson(2), nSim)
    plot!(1:nSim, (1 ./ (1:nSim)) .* cumsum(x), color = colors[i], 
    label = "replicate $i", lw = 2)
end
p2

p3 = plot(xlabel = "number of samples, "*L"n", ylabel = L"\bar{x}_n",
    title = L"\mathrm{Cauchy(0,1)}", legend = false)
for i = 1:3
x = rand(TDist(1), nSim)
    plot!(1:nSim, (1 ./ (1:nSim)) .* cumsum(x), color = colors[i], 
    label = "replicate $i", lw = 2)
end
p3

plot(p1, p2, p3, layout = (1,3), size = (1200,300), margin = 8mm)

savefig(figFolder*"lawoflarge_numbers.pdf")