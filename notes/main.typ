#import "@preview/clean-math-paper:0.2.4": *
#set par(first-line-indent: 1em)
#set page(margin: 1.75in)
#set par(leading: 0.55em, first-line-indent: 1.8em, justify: true)
#set text(font: "New Computer Modern")
#show par: set par(spacing: 0.55em)
#show heading: set block(above: 1.4em, below: 1em)

#let date = datetime.today().display("[month repr:long] [day], [year]")

// Modify some arguments, which can be overwritten in the template call
#page-args.insert("numbering", "1/1")
#text-args-title.insert("size", 2em)
#text-args-title.insert("fill", black)
#text-args-authors.insert("size", 12pt)

#show: template.with(
  title: "Notes",
  authors: (
    (name: "Xingyu Chen", affiliation-id: 1, orcid: "https://orcid.org/0009-0008-0823-4406"),
  ),
  // affiliations: (
  //   (id: 1, name: ""),
  // ),
  date: date,
  heading-color: rgb("#000000"),
  link-color: rgb("#008002"),
  // Insert your abstract after the colon, wrapped in brackets.
  // Example: `abstract: [This is my abstract...]`
  // abstract: lorem(10),
  // keywords: ("First keyword", "Second keyword", "etc."),
  // AMS: ("65M70", "65M12"),
  // Pass page-args to change page settings
  // page-args: page-args,
  // Pass text-args-authors to change author name text settings
  // text-args-authors: text-args-authors,
  // Pass text-args-title to change title text settings
  // text-args-title: text-args-title,
)



#outline()

#pagebreak()

= Tpyst symbols

#link("https://typst.app/docs/reference/symbols/sym/")[`Tpyst symbols`].


= Random effects model for election polls

Andrew Gelman's recent blog post, #link("https://statmodeling.stat.columbia.edu/2025/11/04/polls-betting-odds-nonsampling-errors-win-probabilities-vote-margins/")[`Polls & Betting Odds & Nonsampling Errors & Win Probabilities & Vote Margins`], discusses how to estimate winning probabilities based on polling data. A ChatGPT summary is available here: #link("https://chatgpt.com/share/690ae758-d5cc-8006-9220-df6c8243e103")[`chatgpt-history`].


He presents three examples: the New Jersey governor race, the Virginia governor race, and the New York City mayoral race. Individual polls are often unreliable, so systematic differences between polls must be considered. A simple random-effects model can capture this phenomenon:


$ Y_(i,t) = theta + eta_(i,t) + epsilon_i $


Here, $Y_(i,t)$ is the $t$-th poll for the $i$-th media, $theta$ is the true underlying support level, $epsilon_i$ represents the systematic error for poll $i$, and $eta_(i,t)$ represents the sampling error of the poll.


When focusing on a single media's polls (fixing $i = i_0$), Gelman uses historical information to estimate $epsilon_t$, assuming $epsilon_t ~ cal(N)(0, 2%)$. He then uses polling data of media $i_0$ to estimate the sample variance $sigma_(i_0)^2$ of $eta_(i,i_0)$.


Let $overline(Y_(i_0)) = 1/n sum_(i=1)^n Y_(i,i_0)$. Under his Bayesian viewpoint, the posterior distribution of $theta$ is approximated by:


$ theta | Y ~ cal(N)( overline(Y_(i_0)), sqrt(sigma_(i_0)^2 + 2%) ) $


The winning probability can then be computed as:


$ Pr(theta > 0.5 | Y). $


= Writing

== Good title: The unreasonable effectiveness of XX in/of YY

Good title form #link("https://en.wikipedia.org/wiki/The_Unreasonable_Effectiveness_of_Mathematics_in_the_Natural_Sciences")[`The unreasonable effectiveness of mathematics in the natural sciences`] by Eugene Wigner in 1960 @wigner1990unreasonable.

Richard Hamming in computer science, "The Unreasonable Effectiveness of Mathematics".

Arthur Lesk in molecular biology, "The Unreasonable Effectiveness of Mathematics in Molecular Biology"

Peter Norvig in artificial intelligence, "The Unreasonable Effectiveness of Data"

Vela Velupillai in economics, "The Unreasonable Ineffectiveness of Mathematics in Economics"

Terrence Joseph Sejnowski in Artificial Intelligence: The Unreasonable Effectiveness of Deep Learning in Artificial Intelligence".


== Good title: Rebel With a Cause

Form the famous movie #link("https://en.wikipedia.org/wiki/Rebel_Without_a_Cause")[`Rebel Without a Cause`].

The special issue Volume 8, Issue 2, 2022
Issue of #emph("Observational Studies") titleed #link("https://en.wikipedia.org/wiki/Rebel_with_a_Cause_(book)")[`Rebel With a Cause`]


= On the undistinguishable or identification of statistical models

Based on talk with Ruiqi Zhang, Lin Liu and #link("https://chatgpt.com/c/6909b181-bcc8-8322-a73c-84d4573d26b4")[`Chatgpt`].

The undistinguishable means you can not distinguish two models form data. Which will corresponds to $3$ cases.

One and two are both in the modeling stage. When you consider one model $P_(theta)$, this corresponds to non-identifiable model. When you consider two models, this corresponds to two models sharing some common distributions.

The third case is in the hypothesis testing stage, two models can not be distinguished by data since they are too close.

In a word, two models $cal(P)_1$ and $cal(P)_2$ as two distribution calsses are undistinguishable if $cal(P)_1 inter cal(P_2) eq.not emptyset$ or they are too close under some metric.

== On latent structure models

The potential outcome model is an example of latent structure model. The observed random variable is determined by some unobservable/latent variable is in this calss.

#definition("The Latent structure model")[
  The observed random variable $X$ is determined by a high dimensional latent variable $Z$ by a map $X = f(Z)$.]

#example("Fisher sharp null hypothesis in randomized experiment of causal inference")[
  The observed random variable is $(A, Y)$ determined by three latent variable $(A, Y(0), Y(1)), A in {0,1}, Y = A Y(1) + (1-A) Y(0)$, consider two submodels:
  - $cal(P)_1$: $Y(1) - Y(0) = 0, Y(1) perp A, Y(0) perp A$
  - $cal(P)_2$: $Y(1) - Y(0) = Z eq.not 0$, but $Y(1) =^d Y(0), Y(1) perp A, Y(0) perp A$.

  The model 2 is not empty, take
  $ Y(0), epsilon ~ cal(N)(0,1), Y(0) perp epsilon , Z = -1 /2 Y(0) + sqrt(3)/2 epsilon $
  then $Y(1) ~ cal(N)(0,1)$ and $Y(1) =^d Y(0)$.

  On the observed data level, we can not distinguish these two models since they both have  the same conditional distribution of $Y|A$, therefore they are undistinguishable in modeling stage.

  This example is  the reason why the sharp null hypothesis can not be tested in randomized experiment, and also the joint distribution of $(Y(0),Y(1))$ is not identifiable. ]

@wu2025promises talk about the identification of joint distribution of potential outcomes under some assumptions.

= On the cluster analysis




= Causal Inference

== Causal Example

=== Yule–Simpson’s Paradox

==== Healty worker effect

=== Smoke cause lung cancer

==== Mediation analysis

==== Sensitivity analysis

== Identification

=== G-formula

=== Joint distribution of potential outcomes

@wu2025promises consider a case with multiple randomized controlled trials(RCTs), where data are $(G,A,Y)$, $G$ is the indicator of RCTs, $A$ is the treatment, $Y$ is the outcome.

Under consistency, positivity, and exchangeability. Adding one assumption called "transportability":
$ Y(1) perp G | Y(0) $

We can then identify the conditional distribution $Y(1) | Y(0)$.

$ serif(Pr)(Y(1) = b | G = g) & = sum_(a) serif(Pr)(Y(1) = b, Y(0) = a | G = g) serif(Pr)(Y(0) = a | G = g  ) \
&  = sum_(a) serif(Pr)(Y(1) = b |  Y(0) = a) serif(Pr)( Y(0) = a | G = g) $

Here $serif(Pr)(Y(1) = b | G = g)$ and $serif(Pr)( Y(0) = a | G = g)$ can be identified form data by the consistency assumption, using them to solve the above equation system, we can identify $serif(Pr)(Y(1) = b |  Y(0) = a)$.

== The equivalence between DAG and potential outcome framework

=== The equivalence between nonparametric structural equation model(NPSEM) and potential outcome framework

=== The equivalence between SWIG and FFRCISTG

== ADMG : the inequility constraints

=== Bell inequality


== Instrumental variable

@levis2025covariate 
- data are $(X,A,Z,Y)$ only assume consistency, positivity, unconfounder, exculusion, no monotonicity, provide a bound estimation on ATE.

- The identification assumption of IV:
#quote([ Critically, under the four assumptions introduced in the previous section, the ATE is not point
identified. Analysts typically take one of two approaches for point identification. The first
approach invokes some type of homogeneity assumptions and places various restrictions on
how the effects of A and Z vary from unit to unit in the study population. See Hernan and
Robins (2019) and Wang and Tchetgen Tchetgen (2018) for prominent examples. However,
homogeneity assumptions are often implausible or difficult to verify in specific applications.
The second approach invokes an assumption known as monotonicity, which has the following
form: A(z = 1) ≥ A(z = 0), i.e., if A(z = 0) = 1 then A(z = 1) = 1 (Imbens and Angrist,
1994). Under monotonicity, the target estimand is no longer the ATE, but instead is the local
average treatment effect (LATE):])

- The lower bound and upper bound is not a differentiable functional, thus an assumption is invoked to make the bound functional differentiable and thus have inference function to faster convergence rate.

= Semiparametric theory

== Parametric theory

=== Efficiency

==== Convolution theorem

== nonparametric theory

== Regularity

== Influence function

=== Numerical calcaulation of influence function
@mukhinkernel

=== Von mise representation

=== Tangent space
S8 in @graham2024towards

Formulation in @van1991differentiable


=== Higher order influence function

= U statistics

== Computation

=== Motif counts


- For GPU:
  - Gunrock @wang2016gunrock
  - Cugraph @fender2022rapids

- For CPU:
  - Peregrine @jamshidi2020peregrine
  - Automine @mawhirter2019automine

#bibliography("Master.bib")
