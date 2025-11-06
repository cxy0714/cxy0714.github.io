#import "@preview/clean-math-paper:0.2.4": *
#set par(first-line-indent: 1em)


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
  heading-color: rgb("#0000ff"),
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



= Good title: The unreasonable effectiveness of XX in/of YY

Good title form #link("https://en.wikipedia.org/wiki/The_Unreasonable_Effectiveness_of_Mathematics_in_the_Natural_Sciences")[`The unreasonable effectiveness of mathematics in the natural sciences`] by Eugene Wigner in 1960 @wigner1990unreasonable.

Richard Hamming in computer science, "The Unreasonable Effectiveness of Mathematics".

Arthur Lesk in molecular biology, "The Unreasonable Effectiveness of Mathematics in Molecular Biology"

Peter Norvig in artificial intelligence, "The Unreasonable Effectiveness of Data"

Vela Velupillai in economics, "The Unreasonable Ineffectiveness of Mathematics in Economics"

Terrence Joseph Sejnowski in Artificial Intelligence: The Unreasonable Effectiveness of Deep Learning in Artificial Intelligence".


= Good title: Rebel With a Cause

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

#definition("The Latent structure model")
The observed random variable $X$ is determined by a high dimensional latent variable $Z$ by a map $X = f(Z)$.

#example("Fisher sharp null hypothesis in randomized experiment of causal inference")

- The observed random variable is $(A, Y)$ determined by three independent latent variable $(A, Y(0), Y(1)), A in {0,1}, Y = A Y(1) + (1-A) Y(0)$, consider two submodels:
  - $cal(P)_1$: $Y(1) - Y(0) = 0, Y(1) perp A, Y(0) perp A$
  - $cal(P)_2$: $Y(1) - Y(0) = Z eq.not 0$, but $Y(1) =^d Y(0), Y(1) perp A, Y(0) perp A$.

The model 2 is not empty, take
$ Y(0), epsilon ~ cal(N)(0,1), Y(0) perp epsilon , Z = -1 /2 Y(0) + sqrt(3)/2 epsilon $
then $Y(1) ~ cal(N)(0,1)$ and $Y(1) =^d Y(0)$.

On the observed data level, we can not distinguish these two models since they both have  the same conditional distribution of $Y|A$, therefore they are undistinguishable in modeling stage.

This example is  the reason why the sharp null hypothesis can not be tested in randomized experiment, and also the joint distribution of $(Y(0),Y(1))$ is not identifiable.

@wu2025promises talk about the identification of joint distribution of potential outcomes under some assumptions.

= on cluster analysis

= Numerical calcaulation of influence function
@mukhinkernel


= References

#bibliography("Master.bib")
