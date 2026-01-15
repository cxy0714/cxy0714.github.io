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

== Words

#quote("Nonparametric identification and estimation of the ATE with non-binary IVs are more  involved.") in @dong2025marginal. #emph("involved") means complicated, difficult, complex.


== Fun example

=== On overparameterized models

Form comment in #link("https://statmodeling.stat.columbia.edu/2025/11/14/how-is-it-that-this-problem-with-its-21-data-points-is-so-much-easier-to-handle-with-1-predictor-than-with-16-predictors/")[`Impossible statistical problems`] of Andrew Gelman by Phil, November 14, 2024.

#quote(
  "I’m imagining a political science student coming in for statistical advice:
Student: I’m trying to predict the Democratic percentage of the two-party vote in U.S. Presidential elections, six months before Election Day. I want to use just the past ten elections because I think the political landscape was too different before that.
Statistician: Sounds interesting. What predictive variables do you have?
Student: I’ve got the Democratic share in the last election, and the change in unemployment rate over the past year and the past three years, and the inflation rate over the past year and the past three years, and the change in median income over the past year and past three years.
Statistician: That’s a lot of predictors for not many elections, we are going to have some issues, but maybe we can use lasso or a regularization scheme or something. Let’s get started.
Student: I also own an almanac.
Statistician: Oh. Sorry, I can’t help you, your problem is impossible.",
)

With only 10 data points and 7 predictors, there is still some room for analysis. However, when using an almanac with over 1,000 predictors, the problem becomes unsolvable: the model is overparameterized and loses all predictive power for future observations.

Therefore, in scenarios with extremely small sample sizes, an excess of irrelevant predictors can contaminate the data—rather than enriching it—and render meaningful analysis impossible.

But it now an empirical observation, can we theoretically explain this phenomenon?

#question(
  "Theoretical explanation for overparameterized models with small sample size",
)[For sample siez $n = 200$, outcome $Y in RR$ and predictors $X in RR^(p)$, $p / n = c in (0, infinity)$, $Y$ is independent of $X$, under what condition? We will see that a machine learning algorithm can still predict $Y$ well from $X$?.]

Well, this is just the global null hypothesis testing problem in high dimension models. We can use a nonparametric regression view to see this problem.

$ Y = f(X) + epsilon, f in cal(H) $

$ "H"_0 : f = 0 , "H"_1 : f eq.not 0 $

Using a base function of $cal(H)$ and truncating at $k$ terms, it should be answered well as a hypothesis testing problem, the signal noise ratio, sparsity and the constant $p/n$ will give the detection boundary, also the local minimax rate.

Well, that's asymptotic theory, there still is the question for tiny $n$, say $n = 10$ or $20$. Can we give any answer for this? Can we know anything useful form so tiny sample size? This case may be called #link("https://en.wikipedia.org/wiki/Knightian_uncertainty")[Knightian uncertainty]?

#quote(
  "In economics, Knightian uncertainty is a lack of any quantifiable knowledge about some possible occurrence, as opposed to the presence of quantifiable risk (e.g., that in statistical noise or a parameter's confidence interval). The concept acknowledges some fundamental degree of ignorance, a limit to knowledge, and an essential unpredictability of future events.",
)

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

=== ATT ATU

=== Mediation

@xu2022deepmed, @tchetgen2012semiparametric
(X,D,M,Y), $D$ and $Y$ are binary, $X in bb(R)^(p)$ is high-dimensional covariates, $M in bb(R)$ is mediator, estimating the natural direct effect(NDE) and natural indirect effect(NIE) can be reduced to estimate  $theta(d,d') = EE[ Y(d, M(d')] $ for $d, d' in {0,1}$.

The influence function of $theta(d,d')$ is:

$ serif("EIF")_(theta(d,d')) & = Phi(d,d') - theta(d,d') \
 Phi(d,d')  & = underbrace(frac( bb(1){ D = d} f(M|X, d'), a(d|X) f(M|X,d)) (Y - mu(X,d,M)), A(d,d'))\
 & + underbrace((1 - frac(bb(1){D = d'}, a(d' | X) ) ) integral_(m in cal(M)) mu(X,d,m) f(m|X,d') dif m, B(d,d')) \
 & + underbrace(frac(bb(1)(D = d'), a(d'|X) ) mu(X,d,M), C(d,d')). $


Let us verify that $bb(E)[ serif("EIF")_(theta(d,d')) ] = 0$, here $\#( dot )$ means the function unimportant in the calcaulation that only depends on the variable in the bracket.

$ EE[A(d,d') ] & = EE[ \#(X,M) bb(1){D = d}(Y - mu(X,d,M) )] \
& = EE[EE[ \#(X,M) bb(1){D = d}(Y - mu(X,d,M) )| X, D = d, M]] \
& = EE[\#(X,M)  EE[ bb(1){D = d}(Y - mu(X,d,M) )| X, D = d, M]] \
& = EE[\#(X,M) (integral_(D) bb(1){D = d} integral_(Y) Y frac(p(X,D,M,Y), p(X,D,M)) dif D dif Y - mu(X,d,M)) ] \
& = EE[\#(X,M) dot 0] \
& = 0 . $

$ EE[B(d,d') ] &= EE[ ( 1 - frac(bb(1){ D= d'}, a(d' | X))) \#(X)] \
& = EE[ ( 1 - frac(bb(1){ D= d'}, a(d' | X))) \#(X) | X] \
& = EE[\#(X) EE[ ( 1 - frac(bb(1){ D= d'}, a(d' | X)))  | X] ] \
& = EE[\#(X) (1 - frac(1, a(d' | X)) integral_(D) bb(1){ D= d'} frac(p(D,X), p(X)))] \
& = EE[\#(X) (1 - frac(a(d' | X), a(d' | X)) )] \
& = 0. $

$ EE[C(d, d')] & = EE[ frac(bb(1)(D = d'), a(d'|X) ) mu(X,d,M) ] \
& = integral_(X,D,M) frac(bb(1)(D = d'), a(d'|X) ) mu(X,d,M) p(X,D,M) dif (X,D,M) \
& = integral_(X,M) frac(1, a(d'|X) ) mu(X,d,M) p(X,d',M) dif (X,M) \ 
& = integral_(X,M) mu(X,d,M) f(M|X,d')p(X) dif (X,M) \
& = theta(d, d'). $
=== Joint distribution of potential outcomes

@wu2025promises consider a case with multiple randomized controlled trials(RCTs), where data are $(G,A,Y)$, $G$ is the indicator of RCTs, $A$ is the treatment, $Y$ is the outcome.

Under consistency, positivity, and exchangeability, Adding one assumption called "transportability":
$ Y(1) perp G | Y(0) $

We can then identify the conditional distribution $Y(1) | Y(0)$.

$
  serif(Pr)(Y(1) = b | G = g) & = sum_(a) serif(Pr)(Y(1) = b, Y(0) = a | G = g) serif(Pr)(Y(0) = a | G = g ) \
                              & = sum_(a) serif(Pr)(Y(1) = b | Y(0) = a) serif(Pr)( Y(0) = a | G = g)
$

Here $serif(Pr)(Y(1) = b | G = g)$ and $serif(Pr)( Y(0) = a | G = g)$ can be identified form data by the consistency, positivity and unconfounder assumption, using them to solve the above equation system, we can identify $serif(Pr)(Y(1) = b | Y(0) = a)$.


=== Instrumental variable

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

@dong2025marginal

- talk about the indenfication of ATE with continuous or multiple-category IVs with binary treatment.


- data are $(X,D,Z,Y)$
#image("media/image.png")

- The identification assumption:
  + Stable Unit Treatment Value  Assumption (SUTVA) for potential outcomes:
    - Consistency and no interference between units:
    $
      Y = Y (D) & = D Y(1) + (1-D) Y(0) \
              D & = D(Z)
    $
  + IV relevance (version 1): $Z cancel(perp) D | X$ almost surely.
  + IV independence : $Z perp U | X$
  + IV exclusion restriction : $Z perp Y | D, X$
  + Unconfounderness/d-separation : $(Z, D) perp Y(d) | X, U$ for $d = 0,1$

As @levis2025covariate mentioned, under these assumptions, the ATE is not point identified, homogeneity assumptions are :
+ Version 1, for binary $Z$ : Either $ EE[D | Z = 1, X , U] - EE[D | Z = 0, X , U] $ or $ EE[ Y(1) - Y(0) | X , U] $ does not depend on $U$.
  - #quote(
      [Assumption 5′ rules out additive effect modification by $U$ of the $Z-D$ relationship or $d-Y (d)$  relationship within levels of $X$. A weaker alternative is the no unmeasured common  effect modifier assumption (Cui and Tchetgen Tchetgen, 2021, Hartwig et al., 2023), which  stipulates that no unmeasured confounder acts as a common effect modifier of both the  additive effect of the IV on the treatment and the additive treatment effect on the outcome:],
    )
+ Version 2, weaker alternative for binary $Z$, following equation holds almost surely:
  $ "Cov"(EE(D| Z= 1, X, U)- EE(D|Z=0, X, U), EE(Y(1) - Y(0) | X, U) | X ) = 0 $
+ Final version, for continuous or multiple-category $Z$, for any $z$ in the support of $Z$, following equation holds almost surely:
  $ "Cov"(EE(D| Z= z, X, U)- EE(D| X, U), EE(Y(1) - Y(0) | X, U) | X ) = 0 $
  for any $z, z'$ in the support of $Z$.


- The real-data applicationis combine many genetic variants as weak IVs to a strong and continuous IV to solve the "obesity paradox" in oncology.
  - #quote(
      "Obesity is typically associated with poorer oncology outcomes. Paradoxically, however,  many observational studies have reported that non-small cell lung cancer (NSCLC) patients  with higher body mass index (BMI) experience lower mortality, a phenomenon often referred  to as the “obesity paradox” (Zhang et al., 2017).",
    )

- Using the ratio of conditional weighted average treatment effect, for multiple-category (CWATE) or conditional weighted average derivative effect (CWADE) to identify the ATE.

  - Using semiparametric theory to provide the efficient influence function and build a triply robust estimator.

  - The tangent space is strange such that second-order parametric submodels are needed to validate the efficient influence function.

@chen2025identification

== The equivalence between DAG and potential outcome framework

@wang2025causal

=== The equivalence between nonparametric structural equation model(NPSEM) and potential outcome framework

=== The equivalence between SWIG and FFRCISTG

== ADMG : the inequility constraints

=== Bell inequality


= Semiparametric theory

== Parametric theory

=== Efficiency

==== Convolution theorem

== nonparametric theory

== Regularity


== Influence function

=== The smoothness needed for influence function

Formulation in @van1991differentiable

=== Numerical calcaulation of influence function
@mukhinkernel
@jordan2022empirical
@agrawal2024automated


Automatic differentiation is remarkable! By building in all basic differentiable operations such as addition, multiplication, sine, and exponential functions, it calculates every derivative value and uses the chain rule to combine them, yielding derivatives equivalent to those computed by exact formulas.
@paszke2017automatic @baydin2018automatic

A conversation with #link("https://chat.qwen.ai/s/91761ba1-a011-4804-8f3d-38eadcc90472?fev=0.1.10")[Qwen]. The delta method used to estimate the variance of coefficients in our work @chen2024method requires computing numerical derivatives of a complex mapping involving nonlinear function solving and integration. This can be made differentiable using "AD"-friendly functions in the implementation. Therefore, #link("https://github.com/cxy0714/Method-of-Moments-Inference-for-GLMs/blob/main/demo_glm_MoM/function_of_glm_mom.R")[our R code] could be replaced with more powerful Python code.

=== Von mise representation

=== Tangent space
S8 in @graham2024towards

==== Nuisance tangent space


== Neyman orthogonality

@wang2024multi used a little different neyman orthogonality. Their problem can be summarized by following:

When the model is $X ~ PP_( theta, overline(eta))$ where $overline(eta)$ is the (nuisance) parameter and $theta$ is the finite dimensional parameter of interest and $theta = R( overline(eta) ) = limits("max")_(eta) R( eta )$ where $R(eta) = EE_(X)L(X;eta)$ and $L$ is a loss function.

$ theta = EE_(X) L(X; overline(eta) ) = limits("max")_(eta) EE_(X) L(X; eta) $

Then $psi (X;eta) := L(X;eta)$ naturally satisfies that the Gâteaux derivative of $eta$ is always zero in $overline(eta)$:

$ & frac(partial EE_(X) [psi (X; eta_0 + t(eta - eta_0))], partial t) |_(t = 0) =0, forall eta. \ $

The parameterization need to check, if in above setting, $theta$ is totally determined by $overline(eta)$.

Their paper mentioned the indenfication of $theta$, need to check.

=== Higher order influence function

= U statistics

== Computation

== The lower bound of the complexity of computing U statistics

=== Testing statistics


=== Motif counts


- For GPU:
  - Gunrock @wang2016gunrock
  - Cugraph @fender2022rapids

- For CPU:
  - Peregrine @jamshidi2020peregrine
  - Automine @mawhirter2019automine

== Occurrence

=== Energy function in N particle system

The interaction energy function in N particle system can be written as a U statistic.

= Applications

== Umbrella review

See #link("https://statmodeling.stat.columbia.edu/2025/11/12/belief-in-the-law-of-small-numbers-as-a-way-to-understand-the-replication-crisis-and-silly-researchers-who-continue-to-cite-discredited-behavioral-research/")[`Belief in the law of small numbers as a way to understand the replication crisis and silly researchers who continue to cite discredited behavioral research`] by Andrew Gelman, but I just see the paper involved a title "umbrella review" @lin2025role, so I search more about umbrella review.

Umbrella review consider the evidence form multiple meta-analysis and system review studies on the same topic.

using @shea2017amstar(10K+ citation!) to assess the quality of included meta-analysis/system review studies, but they did not provide a way to aggregate the quality scores and just give a subjective criteria, the overall confidence is rating as "high", "moderate", "low", "critically low". Produce an conclusion such that "In the 60 meta-analyses/systematic reviews included on the treatment for type 2 diabetes, treatments A have 5 strong evidence to support its effectiveness, while treatment B has only 1 moderate evidence to support its effectiveness..."

= multiple testing

== Varibale selection

A talk given by Zhong Wei: #link("https://www.cmstatistics.org/RegistrationsV2/EcoSta2025/viewSubmission.php?in=1158&token=472n51nsro843q0p0s3sn1663po5rsrr")[` A unified stability approach to false discovery rate control`]

Knockoff is a randomized method for variable selection controlling false discovery rate(FDR) @barber2015controlling. The key idea is to construct knockoff variables $tilde(X) in R^p$ that mimic the correlation structure of the original variables $X in R^p$, such that for any subset $S subset {1, ..., p}$, swapping the variables in $S$ with their knockoffs does not change the joint distribution of $(X, tilde(X))$, while also ensuring that the knockoff variables are conditionally independent of the response variable $Y$ given the original variables $X$.

randomized method have a problem in reproduciblity, e-value developed by @vovk2021values is a way to solve this problem, the e-value is a function of data that has an expected value at most 1 under the null hypothesis, thus can be used to control type I error in multiple testing, it can combine evidence from multiple independent tests easily, by running the knockoff procedure multiple times and averaging the resulting e-values for each variable, we can obtain a more stable measure of evidence against the null hypothesis for each variable, that's the work in @ren2024derandomised.

Zhong Wei proposed a general framework of stability for FDR control, which includes derandomized knockoff as a special case, and provide theoretical guarantee for FDR control under this framework.

Their another work is consider the inference after variable selection, using the same sample for variable selection and inference will lead to selection bias @zrnic2023post.

#question(
  "Criteria for variable selection controlling FDR",
)[A quesition is deose there have some minimax optimal method or other criteria for variable selection controlling FDR? e-value BH method or p-value BH method? or here derandomized knockoff BH method? Which is best?]

#link("https://rinafb.github.io/")[Rina Foygel Barber]是2025年新任美国科学院院士，今年统计方向的两位美国科学院（National Academy of Sciences）院士，另一位是刘军，Rina Foygel Barber是2020年COPSS总统奖（12年phd毕业 at U of Chicago，postdoc under Emmanuel Candès）获得者，颁奖理由是：

#quote(
  "For fundamental contributions to statistical sparsity and selective inference in high-dimensional problems, for the creative and novel knockoff filter to cope with correlated coefficients, for contributions to compressed sensing, the jackknife, and conformal predictive inference; for the encouragement and training of graduate and undergraduate students.",
)

e-valuede 的#link("https://sas.uwaterloo.ca/~wang/")[王若度]（U of Waterloo，  Chair profess） 曾经是星际争霸职业选手。


= Machine Learning

== Why named black box model?

#link("https://slds-lmu.github.io/iml_methods_limitations/introduction.html")[Introduction of #emph("Limitations of ML Interpretability")] give a good review to ML Interpretability. Black box model is because the model is based algorithm not as generalized linear model have a simple representation. As @breiman2001statistical saying, two cultures of modeling.

== Varibale importance

=== Leave-One-Covariate-Out(LOCO)

@lei2018distribution give a measure named loco:
$ I_x = l( y, f(x,z) ) - l( y, f(z) ) $
to measure the importance of variable $x$ by comparing the loss when including $x$ versus excluding $x$.

@wang2024multi proposed an extension of LOCO under multiple source data and using semiparametric theory to provide the inference of their measure.



== Ensemble learning

Ensemble learning, as the name suggests, combines multiple basde models to improve prediction performance. Common ensemble learning methods include bagging, boosting, and stacking.

=== Bagging
BoostrapAggregating (bagging) is proposed by Leo Breiman @breiman1996bagging (4 w + citations). The key idea is to generate multiple boostrap samples from the original data and train the base model on each boostrap sample then aggragate the predictions from all models, such as by averaging for regression or majority voting for classification.

==== Theory properties of bagging

- @breiman1996bagging Bagging can reduce the variance of unstable base models.
- Peter Bühlmann and Bin Yu @buhlmann2002analyzing (1.2 k + citations) give some convergence rate analysis for bagging.
- In the 2000s, many works on the theoretical understanding of bagging, seems no more work needed now.

==== Random forest

- Leo Breiman @breiman2001random (17 w + citations) proposed random forest, an ensemble learning method that builds multiple decision trees and merges their results to improve accuracy.

==== Causal forest

- @athey2016recursive(2.5 k + citations) proposed causal tree to estimate heterogeneous treatment effects namely the conditional average treatment effect (CATE) by extending decision tree, then @wager2018estimation(4.3 k + citations) using random forest to improve the estimation accuracy and provide asymptotic normality for inference.

- @cattaneo2025honest establishes an inconsistency lower bound on the point wise convergence rate of causal tree, and challenges the $alpha$-regularity condition (each split leaves at least a fraction $alpha$ of available samples on each side) needed to establish the convergence rate in @wager2018estimation.

=== Boosting

- XGBoost 

=== Stacking


#bibliography("Master.bib")
