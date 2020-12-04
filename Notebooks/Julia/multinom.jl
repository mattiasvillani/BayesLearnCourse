### A Pluto.jl notebook ###
# v0.12.15

using Markdown
using InteractiveUtils

# ╔═╡ 91f7ce64-2fef-11eb-1148-e7facd9b65e4
begin
	# Load packages
	using Plots, Distributions, LaTeXStrings, Random
	import ColorSchemes.Paired_12; colors = Paired_12[[1,2,7,8,3,4,5,6,9,10]]
	nothing
end

# ╔═╡ 3cfb8c20-2fef-11eb-09c1-05434669bc4f
begin
	md"""### Bayesian analysis of smartphone survey data
	*- using a multinomial likelihood with Dirichlet prior*"""
end

# ╔═╡ cedb5cbe-2ff0-11eb-25be-c95ca9cff11e
md"##### Function that simulates from Dirichlet(α) distribution"

# ╔═╡ fafd5c44-2fef-11eb-3f12-c1cb9dfed658
# Simulate a draw from the Dirichlet(α) distribution
function rDirichlet(α)
	C = length(α)
	y = zeros(C)
	for c in 1:C
		y[c] = rand(Gamma(α[c],1))
	end
	return y/sum(y)
end;

# ╔═╡ dce67264-2ff1-11eb-2569-73616730987e
md" ##### **Data** 

A company has conduct a survey of mobile phone usage. 513 participants were asked the question: 'What kind of mobile phone do you main use?' with the four options:

* iPhone
* Android Phone
* Windows Phone
* Other/Don't know

The responses in the four categories were: 180, 230, 62, 41."

# ╔═╡ b806c186-2ff0-11eb-159c-7f0b49ea71e9
md"##### **Model**
$(y_1,\ldots,y_4) \vert \theta_1,\ldots,\theta_4 \sim \mathrm{Multinomial}(\theta_1,\ldots,\theta_4)$"

# ╔═╡ a491956c-2ff3-11eb-072d-89f581341233
md"##### **Prior**

The conjugate prior for multinomial data is the Dirichlet prior. 

$(\theta_1,\ldots,\theta_K) \sim \mathrm{Dirichlet}(\alpha_1,\ldots,\alpha_K),$

where the $\alpha_k$ are positive hyperparameters such that 

$\mathbb{E}(\theta_k) = \frac{\alpha_k}{\sum_{j=1}^K \alpha_j}$
and
$\sum_{k=1}^K \alpha_j$ determines the precision (inverse variance) of the Dirichlet distribution. 

We will determine the prior hyperparameters from data from a similar survey that was conducted four year ago. The proportions in the four categories back then were: 30%, 30%, 20% and 20%. This was a large survey, but since time has passed and user patterns most likely has changed, we value the information in this older survey as being equivalent to a survey with only 50 participants. 
This gives us the prior:
$(\theta_1,\ldots,\theta_4) \sim \mathrm{Dirichlet}(\alpha_1 = 15,\alpha_2 = 15,\alpha_3 = 10,\alpha_4=10)$. Note that $\mathbb{E}(\theta_1) = 15/50 = 0.3$ and so on, so the prior mean is set equal to the proportions from the older survey. Also, $\sum_{k=1}^4 \alpha_k = 50$, so the prior information is equivalent to a survey based on 50 respondents, as required.
"

# ╔═╡ b8133978-2ff5-11eb-056d-c53f28462190
md"""
##### **Posterior**
The joint posterior of all market shares is

$(\theta_1,\ldots,\theta_K) \vert \mathbf{y} \sim \mathrm{Dirichlet}(\alpha_1 +y_1,\ldots,\alpha_K + y_K).$

The marginal posterior of \$\theta_k\$ is 

$\theta_k\sim\mathrm{Beta}\left(\alpha_k + y_k, \sum_{j=1}^K(\alpha_j + y_j)-(\alpha_k + y_k)\right).$

The marginal posteriors are shown in the figure below, both obtained by simulation (histograms) and using the analytical result above (density curves).

"""

# ╔═╡ eeed4602-2ff5-11eb-3a8e-9749a63f8601
begin
	gr(legend = nothing, grid = false, yaxis = false)
	nDraws = 1000        # Number of posterior draws
	Random.seed!(123)    # Set the seed for reproducibility
	y = [180,230,62,41]  # The cell phone survey data
	α = [15,15,10,10]    # Dirichlet prior hyperparameters
	C = length(y)
	titles = ["iPhone", "Android", "Windows", "Other"]
	xlimits = [0.25 0.45; 0.35 0.5; 0.075 0.18; 0.05 0.14]
	θGrid = range(0, 1, step = 0.001)
	θPost = zeros(nDraws,C)
	for i ∈ 1:nDraws
		θPost[i,:] = rDirichlet(y + α) 
	end
	p = []
	for c ∈ 1:C
		ptmp = histogram(θPost[:,c], normalize = true, title = titles[c], xlims = 				xlimits[c,:])
		push!(p,ptmp)
		margPDF = [pdf(Beta(y[c]+α[c], sum(y)+sum(α) - y[c]-α[c]), θ) for θ ∈ θGrid]
        plot!(θGrid, margPDF, lw = 3, color = colors[2])
	end
	l = @layout [a b;c d]
	plot(p..., layout = l)
	
end

# ╔═╡ ffe7b542-35c1-11eb-3e9b-73daa2f53c3d
begin
		PrAndroidNo1 = mean([θPost[i,2]>=maximum(θPost[i,:]) for i in 1:size(θPost,1)])
		
		md"""The probability that Android has   		largest market share can be approximated by Monte Carlo simulation by checking each simulated $\theta$ vector if Android 		is largest.
		
		Pr(Android largest market share | **y**) = $(PrAndroidNo1)
		"""
end

# ╔═╡ Cell order:
# ╟─3cfb8c20-2fef-11eb-09c1-05434669bc4f
# ╟─91f7ce64-2fef-11eb-1148-e7facd9b65e4
# ╟─cedb5cbe-2ff0-11eb-25be-c95ca9cff11e
# ╠═fafd5c44-2fef-11eb-3f12-c1cb9dfed658
# ╟─dce67264-2ff1-11eb-2569-73616730987e
# ╟─b806c186-2ff0-11eb-159c-7f0b49ea71e9
# ╟─a491956c-2ff3-11eb-072d-89f581341233
# ╟─b8133978-2ff5-11eb-056d-c53f28462190
# ╟─eeed4602-2ff5-11eb-3a8e-9749a63f8601
# ╟─ffe7b542-35c1-11eb-3e9b-73daa2f53c3d
