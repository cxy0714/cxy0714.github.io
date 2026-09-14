---
title: "Mathematica Pitfalls: Symbolic Matrix Computation"
date: 2023-03-17T18:34:35+08:00
updated: 2023-04-19T19:11:00+08:00
author: Xingyu Chen
categories:
  - Programming
tags:
  - Mathematica
  - Symbolic Computation
  - Matrix Tensor Product
  - Kronecker Product
  - Outer Product
  - KroneckerProduct
  - Direct Product
  - Matrix Vectorisation
  - vec
  - Mathematica Vector to Matrix
  - Commutation Matrix
  - Whether the Difference of Expressions Is Zero
slug: mathematica-matrix-symbolic
translationKey: mathematica-matrix-symbolic
---

## Where the problem came from

Lately, in order to derive some formulas, I needed to verify the inner-product results of a number of high-dimensional matrices (more than twenty of them, each taking anywhere from one to eight hours by hand), and I needed a reliable tool to help me check my computations. So I thought of Mathematica.

My computation was roughly this: take two $k^2\times k^5$ matrices $A,B$ and compute their inner product $Tr(A \cdot B^T)$. Using the cyclic property of $Tr$, this can be turned into a sort of "inner product" between a $1 \times k^2$ row vector, a $k^2\times k^5$ matrix and a $k^5\times 1$ column vector — that is, adding up a pile of ($k^2\times k^5$) numbers. But $A$ and $B$ are not scalar matrices: their entries are all symbolic, and the dimensions grow with the order of the formula.

Below is roughly what the matrices look like (there are longer ones), where $Dimensions[\eta_2^{-1}]=k\times k,Dimensions[\eta_1]=k\times 1$. $I_k$ is the $k$-th order identity matrix, and $K_{k,k}$ is a $k^2\times k^2$ matrix whose technical name is the commutation matrix — an important tool in matrix vectorisation and matrix tensor products. For a quick introduction you can have a look at [交换矩阵 commutation matrix：理论与matlab仿真_B417科研笔记的博客-CSDN博客](https://blog.csdn.net/weixin_39274659/article/details/113747158); to learn more about the commutation matrix, search in English.

$$vec^{T}(\eta_{2}^{-1}\eta_{1}\eta_{1}^{T}\eta_{2}^{-1})\otimes\eta_{2}^{-1}\otimes\eta_{2}^{-1}\cdot I_{k}\otimes K_{k,k}\otimes I_{k}$$

There is also the $vec():\mathbb{R}^{p\times q} \rightarrow \mathbb{R}^{pq\times1}$ operator appearing in $vec^T \eta_2^{-1}$: it reorders a matrix into a column vector, "straightening it out". This is the tool used to define matrix derivatives.

(On differentiating a matrix by a matrix: consider the derivative of a matrix function with respect to a matrix argument — how should the entries of the resulting derivative be arranged? One idea is to straighten all the matrices into vectors, which reduces the problem to differentiating a vector function with respect to a vector argument. That is very familiar from calculus, there are some good layout conventions, and one can prove that matrix derivatives in this form have nice properties, such as a convenient chain rule, and the fact that differentiating $X$ with respect to itself yields an identity matrix. Another idea is to arrange the derivative directly, the way one would for a matrix tensor product; for a start, try to imagine what differentiating $X$ with respect to itself gives — it is not even an identity matrix, though that is only one of the complaints, and I have not read much further. For more, see $\S1.4$ of this book: [Advanced Multivariate Statistics with Matrices | SpringerLink](https://link.springer.com/book/10.1007/1-4020-3419-9). The book also covers the properties of vec and the commutation matrix fairly comprehensively.)

Concretely, $vec(A)=vec([a_1,a_2,…,a_n])=[a_1^T,a_2^T,…,a_n^T]^T$.

The matrix tensor product is $A\otimes B=[a_{i,j}B]_{(i,j)}$. It is also called the Kronecker product, the outer product, or the direct product.

In short, my matrices are stuffed with matrix tensor products, vec operations and commutation matrices $K_{p,q}$. At the same time I had predicted the inner-product results for these matrices, and I wanted to compare them to check my predictions.

### Mathematica

Back in the winter break of my first year I read some articles and watched some videos about Mathematica, and afterwards used it to compute a few formulas for university physics labs? But I seem to have used it purely as a calculator, without any complicated operations — so really it just familiarised me with the basic documentation. (I accidentally deleted and emptied it all, so I can't remember what I actually did.) But I had also seen plenty of its examples, beautiful ones and so on, and I was deeply impressed by its friendly help documentation. Also, [Professor Liu Siqi](http://blog.siqiliu.com/cn/index.html) of the School of Mathematical Sciences at Tsinghua University has a very good [Mathematica video course](https://www.bilibili.com/video/BV1av411N7Xi/?spm_id_from=333.999.0.0&vd_source=d604f008cde1c2b512c49f045d95e4cd).

Earlier I had downloaded a cracked Chinese version of Mathematica 13.0. When I came to use it, I found that a built-in function I needed only appears in 13.1 — and searching around again, free resources were nowhere to be found: it was all "follow our WeChat official account" and "buy with xx coins" links and so on. I have always found that sort of thing repugnant.

So I found the official site, and discovered that new users get a free 15-day trial. Downloading the desktop version required some extra steps, so I didn't bother with the PC version; instead I found that Mathematica has a cloud system that compiles online and stores your files in the cloud: [Wolfram Mathematica (wolframcloud.com)](https://mathematica.wolframcloud.com/). Compiling online fully met my needs. My computations aren't particularly heavy either — the code usually returns in seconds. But it saved me tens of hours of computation!

## Problems I ran into while writing code

### Matrices, row vectors and column vectors in Mathematica

The Mathematica help documentation has [Matrices and Linear Algebra—Wolfram Language Documentation](https://reference.wolfram.com/language/guide/MatricesAndLinearAlgebra.html).

The built-in functions for defining vectors and matrices in Mathematica are Table[] and Array[], which can also be used to construct vectors. But at first I simply could not work out how their dimensions behaved. Now I understand: **anything wrapped in two braces `{{}}` is a matrix**, and **a single pair of braces `{}` is a vector in Mathematica**. A vector in Mathematica is **neither a row vector nor a column vector** — if it sits on the right in an operation it acts as a column vector, and on the left as a row vector, and using the transpose function Transpose[] makes no difference. So this problem left me completely baffled at the start, and I couldn't tell where my matrix multiplications were going wrong.

If you need to define a column vector, define it like this:

`T=Array[b,{2,1}]`

Now it is wrapped in two braces, so it is treated as a $2\times 1$ matrix, i.e. a column vector.

Another problem: **do not append //MatrixForm when defining a matrix.** Normally appending that statement makes your output render as a nice matrix (otherwise you get the `{{}}` list form, which is awkward to read), but if you include it in the definition, every subsequent matrix computation goes wrong. That was the second reason my matrix operations failed at first. Then, in desperation, while listening to a Mathematica video course by Professor Liu Siqi of Tsinghua's school of mathematics, I heard him mention exactly this: [lecture-2-4_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1av411N7Xi?p=9&vd_source=d604f008cde1c2b512c49f045d95e4cd) — which, in my heart, saved Mathematica's life.

Also, the Dimensions[] function tells you the dimensions of a matrix (however many braces it has).

For example, applying Dimensions[] to a $p\times q$ matrix gives `{p,q}`.

### Matrix tensor product

Mathematica has a built-in function for the matrix tensor product (outer product, direct product): KroneckerProduct[].

But at first I somehow failed to find KroneckerProduct[]. What I found first was Outer, the tensor outer product — for two vectors (each with a single pair of braces) it gives you a matrix. But when you take the outer product of two matrices with it, although the form looks the same, you end up with four braces, and Dimensions[] returns something like `{2,2,2,2}`, which is no longer the dimension of a matrix. That was the third problem I hit, though fortunately in the end I discovered that there is a proper matrix outer-product function, KroneckerProduct[].

So for the matrix tensor product, just use KroneckerProduct[] directly.

### Defining the vec operator and the commutation matrix $K_{p,q}$

After a great deal of searching, I found the definitions of both functions in the **application examples** for the permutation matrix PermutationMatrix[]: [PermutationMatrix—Wolfram Language Documentation](https://reference.wolfram.com/language/ref/PermutationMatrix.html).

`vec[m_?MatrixQ] := Flatten[m, {{2, 1}}]`

This stacks the columns of the matrix into a single vector. The problem is that this is a Mathematica vector with a single pair of braces — neither a row nor a column vector — so that was the fourth problem I ran into later on, though by now I am a mature vector user. I searched for things like "how to turn a vector into a matrix in Mathematica" and got my answer.

You only need to add one pair of braces `{}` on the outside of the definition.

`vec[m_?MatrixQ] := {Flatten[m, {{2, 1}}]}`

For the commutation matrix you can just take their code and use it directly; no weird problems there. Though you can give it a shorter function name.

`vecPermutationMatrix[p_, q_] :=  PermutationMatrix[Flatten[Partition[Range[p q], p], {{2, 1}}]]`

### Checking whether two matrix inner products are equal

This was the fifth problem. I had assumed I could simply subtract them, and that zero meant equal, job done. But the difference never came out as zero, even though I could be sure my computation was correct. Then I used **ExpandAll[]**, to strip all the brackets and expand everything, and at last I got 0.

The problem is probably this: my matrix inner products involve nine symbols, twelve symbols multiplied together and then added. Inside there is a great deal of bracketing produced by collecting like terms. For example:

`A=a (b+c+d) B=(a b+a c+a d)`

`A-B=a (b+c+d)-(a b +a c+a d)`

That is: although A and B are the same, it has not expanded them, there are lots of brackets, and subtracting does not cancel anything out — it just writes it out with the like terms collected.

So you need ExpandAll[]: once expanded there are no brackets, and it can collect like terms, cancel them, and give 0.

`ExpandAll[A-B]=0`

## Small tips

### Quit Kernel

Another point I also heard in Professor Liu Siqi's Mathematica course: when you create a new file, it is best to Quit Kernel first. That button clears all the previous data and avoids unnecessary mistakes — you may have assigned a value to some variable and then forgotten about it. Quit Kernel is under the Evaluation menu.

One trick: variables that have not been assigned a value are blue, and variables that have been assigned a value are black.

### Clearing all output in one click, and exporting to PDF

Once the program is written, in order to produce a nice PDF report you can first clear all output in one click (Evaluation → Delete All Outputs), then Quit Kernel. Then evaluate all the cells (Evaluate All cells), and export to PDF (File → Print to PDF).