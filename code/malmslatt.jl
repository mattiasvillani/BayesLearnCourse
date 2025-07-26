# Malmslatt temp
using Plots, DataFrames, CSV, Dates, Loess, Statistics

df = CSV.read("/home/mv/Dropbox/Teaching/BayesLearning/Code/templink.csv", DataFrame, header = true)
df.datetime = DateTime.(df.date,df.time)
colgrad = cgrad(:acton)

p = plot(title = "yearly smoothed temp profiles 2012-2021", 
    xlab = "normalized day of the year", ylab = "daily average temp")
count = 0
years = 2012:2021
preds = zeros(length(years), 1000)
for year = years
    count = count + 1
    tmp = df[(df.datetime .>= DateTime(year,01,01)) .&& (df.datetime .<= DateTime(year,12,31)), 
    [5,3]]
    model = loess(range(0,1, length = length(tmp[:,1])), tmp[:,2], span=0.5)
    us = range(0, 1, length = 1000)
    pred = predict(model, us)
    preds[count,:] .= pred
    if year == 2016
        plot!(p, us, pred, lw = 3, color = :black, label = "$year")
    else
        plot!(p, us, pred, lw = 1, col = colgrad[10*count], label = "$year")
    end
end
p
savefig("templink2012_2021.pdf")
savefig("templink2012_2021.png")

p = plot(title = "yearly smoothed temp profiles 1944-2021", 
    xlab = "normalized day of the year", ylab = "daily average temp", legend = :topright)
count = 0
years = 1944:2021
preds = zeros(length(years), 1000)
for year = years
    count = count + 1
    tmp = df[(df.datetime .>= DateTime(year,01,01)) .&& (df.datetime .<= DateTime(year,12,31)), 
    [5,3]]
    model = loess(range(0,1, length = length(tmp[:,1])), tmp[:,2], span=0.5)
    us = range(0, 1, length = 1000)
    pred = predict(model, us)
    preds[count,:] .= pred
    if year == 2016
        plot!(p, us, pred, lw = 3, color = :black, label = "$year")
    else
        plot!(p, us, pred, lw = 1, col = colgrad[3*count], label = "")
    end
end
plot!(p, us, mean(preds, dims = 1)', c = :red, lw = 3, label = "mean 1944-2021")
p
savefig("templink1944_2021.pdf")
savefig("templink1944_2021.png")
