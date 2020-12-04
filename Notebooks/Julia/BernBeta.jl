### A Pluto.jl notebook ###
# v0.12.15

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 3f3dbc34-3593-11eb-2250-13fc496e403e
begin
	using Plots, LaTeXStrings, PlutoUI
	import Distributions: Beta, pdf
	import ColorSchemes.Paired_12;
	colors = Paired_12[[1,2,7,8,3,4,5,6,9,10]]
	nothing
end

# ╔═╡ 2ea253b6-358a-11eb-10c9-6d257cbca066
md"### Bayesian analysis of the Bernoulli model"

# ╔═╡ 5d6396b0-358a-11eb-2995-eb061a2476aa
md" **Bernoulli model**:

$$x_1,\ldots,x_n |\theta \overset{\mathrm{iid}}{\sim} \mathrm{Bernoulli}(\theta)$$"

# ╔═╡ b7b9303e-358a-11eb-067d-fd0020d579a3
md"**Beta prior**:

$$\theta \sim \mathrm{Beta}(\alpha,\beta)$$"

# ╔═╡ da5f2ce0-358a-11eb-2522-81165870626e
md" **Beta posterior**:

$$\theta | x_1,\ldots,x_n \sim \mathrm{Beta}(\alpha+s,\beta+f),$$

where $s=\sum_{i=1}^n x_i$ is the number of successes and $f = n-s$ is the number of failures."

# ╔═╡ d39a7b72-358b-11eb-1d11-dfdcf238a7f4
md"""
**Input data and prior hyperparameters**:

n =  $(@bind n Slider(1:100; default=10, show_value=true))         

s/n =  $(@bind sFrac Slider(0:0.01:1; default=0.5, show_value=true))

\$\alpha = \$ $(@bind α Slider(eps():100; default=3, show_value=true)) 

\$\beta = \$ $(@bind β Slider(eps():100; default=3, show_value=true))

"""

# ╔═╡ 698e86b0-3590-11eb-185b-df426ce40664
begin
	# Function to compute the Beta posterior and moments
	function BernBeta(s, f, α, β)
		priorMean = α/(α+β)
		priorStd = √(α*β/((α+β)^2*(α+β+1)))
		αPost = α + s
		βPost = β + f
		postMean = αPost/(αPost+βPost)
		postStd = √(αPost*βPost/((αPost+βPost)^2*(αPost+βPost+1)))
		post = Beta(αPost, βPost)
		return post, αPost, βPost, priorMean, priorStd, postMean, postStd
	end
	s = sFrac*n
	post, αPost, βPost, priorMean, priorStd, postMean, postStd = BernBeta(s, n-s, α, β)
end;

# ╔═╡ ca4114a4-3591-11eb-1777-4593b8760a68
begin
	# using Pkg
	# Pkg.build("GR")
	f = n - s
	θGrid = range(eps(),1-eps(), length = 1000)
	binWidth = θGrid[2]-θGrid[1]
	logℓ = s*log.(θGrid) .+ f*log.(1 .- θGrid)
	like = exp.(logℓ .- maximum(logℓ))
	normLike = like/(sum(like)*binWidth)
	plot(θGrid, pdf.(Beta(α,β),θGrid), lw = 3, color = colors[6], xlabel = L"\theta", label = "Prior", yaxis = false)
	plot!(θGrid, normLike, lw = 3, color = colors[2], label = "Likelihood")
	plot!(θGrid, pdf.(Beta(αPost,βPost),θGrid), lw = 3, color = colors[4], label = "Posterior")
end

# ╔═╡ 7cdb3f2c-358d-11eb-03e6-df23873fb7b4
md"""
**Prior mean and standard deviation**:

\$\mathbb{E}(\theta)=\$ $(priorMean)

\$\mathbb{S}(\theta)=\$ $(priorStd)
"""

# ╔═╡ 25b33df2-3598-11eb-2364-a540b649f80d
md"""
**Posterior mean and standard deviation**:

\$\mathbb{E}(\theta|\mathbf{x})=\$  $(postMean)

\$\mathbb{S}(\theta|\mathbf{x})=\$ $(postStd)
"""

# ╔═╡ 3d25b63c-359c-11eb-2aa0-c558e2eb0a6b


# ╔═╡ 1f03b924-359c-11eb-0e7a-41c84b5dc313
md"""
---
Notebook for the book: Villani, M. (2020). [Bayesian Learning]()."""

# ╔═╡ Cell order:
# ╟─2ea253b6-358a-11eb-10c9-6d257cbca066
# ╟─3f3dbc34-3593-11eb-2250-13fc496e403e
# ╟─5d6396b0-358a-11eb-2995-eb061a2476aa
# ╟─b7b9303e-358a-11eb-067d-fd0020d579a3
# ╟─da5f2ce0-358a-11eb-2522-81165870626e
# ╟─d39a7b72-358b-11eb-1d11-dfdcf238a7f4
# ╟─698e86b0-3590-11eb-185b-df426ce40664
# ╟─ca4114a4-3591-11eb-1777-4593b8760a68
# ╟─7cdb3f2c-358d-11eb-03e6-df23873fb7b4
# ╟─25b33df2-3598-11eb-2364-a540b649f80d
# ╟─3d25b63c-359c-11eb-2aa0-c558e2eb0a6b
# ╟─1f03b924-359c-11eb-0e7a-41c84b5dc313
