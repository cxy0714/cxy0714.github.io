---
title: Mathematica踩坑-矩阵符号计算
date: 2023-03-17T18:34:35+08:00
updated: 2023-04-19T19:11:00+08:00 
author: 陈星宇
categories:
  - 程序
tags:
  - Mathematica
  - 符号计算
  - 矩阵张量积
  - 克罗内克积
  - 外积
  - KroneckerProduct
  - 直积
  - 矩阵向量化操作
  - vec
  - Mathematica向量转矩阵
  - 交换矩阵
  - Commutation Matrix
  - 表达式之差是否为0
---

## 问题由来

最近为了推导公式，需要验证一些（20多个）高维矩阵的内积结果（手算1-8h不等），而且需要一个靠谱的帮助我检验计算结果的工具。所以想到了Mathematica。

我的计算大概是：$k^2\times k^5$的两个矩阵$A,B$做内积：$Tr(A \cdot B^T)$。通过$Tr$的可交换性质可以转化为$1 \times k^2$的行向量与$k^2\times k^5$的矩阵与$k^5\times 1$的列向量一个"内积"，所以就是一堆（$k^2\times k^5$）数相加，不过矩阵$A,B$都不是标量矩阵，元素都是符号，维数也还会随公式的阶数增高。

下面是矩阵大概的形式（还有更长的），其中$Dimensions[\eta_2^{-1}]=k\times k,Dimensions[\eta_1]=k\times 1$。$I_k$是$k$阶单位阵，$K_{k,k}$是$k^2\times k^2$矩阵，学名叫作交换矩阵（Commutation Matrix），在矩阵向量化操作和矩阵张量积里是一个重要的工具，可以简单看[交换矩阵 commutation matrix：理论与matlab仿真_B417科研笔记的博客-CSDN博客](https://blog.csdn.net/weixin_39274659/article/details/113747158)来了解，要了解更多Commutation Matrix可以搜英文。

$$vec^{T}(\eta_{2}^{-1}\eta_{1}\eta_{1}^{T}\eta_{2}^{-1})\otimes\eta_{2}^{-1}\otimes\eta_{2}^{-1}\cdot I_{k}\otimes K_{k,k}\otimes I_{k}$$

还有这个$vec^T \eta_2^{-1}$中的$vec():\mathbb{R}^{p\times q} \rightarrow \mathbb{R}^{pq\times1}$算子，就是把矩阵重新排序成为列向量，"拉直"，这个是定义矩阵导数的工具。

（关于矩阵对矩阵求导数：考虑矩阵函数对矩阵变元求导，得到的导数的元素如何排列？一个想法就是把矩阵都拉成向量，这样就化为了向量函数对向量变元求导，这是微积分都很熟悉的，有一些好的排布规则，并且可以证明，这种形式的矩阵导数有比较好的性质，比如简便的链式法则，以及$X$对自己求导时得到的是一个单位阵。另一个想法就是直接像矩阵张量积一样的排布导数，首先你可以想象一下$X$对自己求导的结果，它甚至不是一个单位阵，不过这只是槽点之一，我还没有了解更多。更多信息可以看这本书的$\S1.4$节：[Advanced Multivariate Statistics with Matrices | SpringerLink](https://link.springer.com/book/10.1007/1-4020-3419-9)，本书也介绍了vec和Commutation Matrix的性质，比较全面。）

具体地，$vec(A)=vec([a_1,a_2,…,a_n])=[a_1^T,a_2^T,…,a_n^T]^T$。

矩阵张量积（Tensor Product）是$A\otimes B=[a_{i,j}B]_{(i,j)}$。也叫克罗内克积（Kronecker product），外积，直积。

总之我的矩阵里充斥着矩阵张量积，vec操作和交换矩阵$K_{p,q}$。同时我预测出了这些矩阵内积的结果，我希望比较一下他们是否相等，检验我的预测。

### Mathematica

我在大一寒假时看过一些Mathematica的文章和视频，之后用它做了一些大学物理实验的一些公式的计算？但是似乎纯粹当计算器用的，没有太多复杂的操作，等于熟悉了一下基本的文档操作吧。（不小心全给删除清空了，所以记不得到底干过啥了。）但是我也看过许多他的例子，精美的例子之类的，对他友好的帮助文档印象很深，还有就是清华大学数学科学学院[刘思齐老师](http://blog.siqiliu.com/cn/index.html)的[Mathematica网课](https://www.bilibili.com/video/BV1av411N7Xi/?spm_id_from=333.999.0.0&vd_source=d604f008cde1c2b512c49f045d95e4cd)很好。

之前我下载了Mathematica 13.0的中文破解版，然后现在要用它的时候发现我需要的内置函数在13.1版本才出现了，这时候再去搜索一圈，已经找不到免费的资源了，全是加微信公众号关注，xx币购买链接云云，一直就很反感这些东西。

所以我找到了官网，发现新用户可以免费试用15天，但是直接下载电脑版还需要一些操作，就没有下载pc版，发现Mathematica有云系统，可以在线编译，存储云文件，网站:[Wolfram Mathematica (wolframcloud.com)](https://mathematica.wolframcloud.com/)。在线编译已经完全可以满足我的需要了。而且我的运算量也不太大，跑代码基本都是秒出。但是可以帮我省去几十个小时的计算了！

## 写代码时碰到的问题

### Mathematica中的矩阵和行向量、列向量

Mathematica帮助文档里有[矩阵和线性代数—Wolfram 语言参考资料](https://reference.wolfram.com/language/guide/MatricesAndLinearAlgebra.html)。

Mathematica中定义向量和矩阵的内置函数有Table[],Array[],也可以用来构造向量。但是我一开始却始终搞不清楚他们的维数怎么回事。现在我明白了，**两个花括号`{{}}`包住的就是矩阵**，**一个花括号`{}`就是Mathematica里的向量**，Mathematica里的向量**既不是行向量，也不是列向量**，如果向量在运算中放在右边就是列向量，放在左边就是行向量，你使用转置函数Transpose[]也没用。所以这个问题让我一开始搞得一头雾水。算矩阵乘法时不知道哪里出了错。

如果你需要定义列向量，请这样定义：

`T=Array[b,{2,1}]`

这样他就是两个花括号包裹了，将其视为$2\times 1$的矩阵，即列向量。

另一个问题是，在**定义矩阵时不要在后面加上//MartixForm**，一般在后面加上这个语句可以让你的输出变成好看的矩阵形式（否则会输出`{{}}`的列表形式，看起来不方便），但是如果你在定义里加上了这个，后面的矩阵计算会出现各种问题，这是我一开始矩阵运算失败的第二个问题，然后绝望之下在听清华数院的刘思齐老师的一个Mathematica网课中，他提到了这一句：[lecture-2-4_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1av411N7Xi?p=9&vd_source=d604f008cde1c2b512c49f045d95e4cd)，在我心里救了Mathematica一命。

另外用Dimensions[]函数可以查看矩阵（多少个花括号都行）的维数。

比如$p\times q$的矩阵被Dimensions[]作用之后结果是 `{p,q}`。

### 矩阵张量积

矩阵张量积(外积，直积)这个在Mathematica里直接有函数KroneckerProduct[]。

但是一开始我竟然没有搜索到KroneckerProduct[]，先是搜索到了Outer 外积，这个东西是张量外积，两个向量（1个花括号的）可以用这个得到矩阵，但是矩阵和矩阵用这个做外积，虽然形式上是一样的，但是它会出现4个花括号，用Dimensions[]看其维数，会得到类似这样的结果 `{2,2,2,2}`这已经不是矩阵的维数了。这个是我在计算中遇到的第三个问题，好在最后发现了他有正经的矩阵外积函数KroneckerProduct[]

所以矩阵张量积积直接用函数KroneckerProduct[]。

### vec算子的定义和交换矩阵$K_{p,q}$的定义

这两个函数的定义，我在一通搜索之后，置换矩阵PermutationMatrix[]的**应用举例**中：[PermutationMatrix—Wolfram 语言参考资料](https://reference.wolfram.com/language/ref/PermutationMatrix.html)发现了。

`vec[m_?MatrixQ] := Flatten[m, {{2, 1}}]`

它将矩阵的列堆叠成单个向量。问题是这个向量是Mathematica中的向量，只有一个花括号，既不是行向量也不是列向量，所以这是我后面计算中遇到的第四个问题，但是现在我已经是个成熟的向量使用者了。我搜索了"Mathematica怎么把向量变成矩阵"之类的之后得到了回答。

只需要在定义外边加上一个花括号即可`{}`。

`vec[m_?MatrixQ] := {Flatten[m, {{2, 1}}]}`

交换矩阵的定义可以直接拿他他的代码用，没有奇奇怪怪问题。但是你可以改个简短点的函数名。

`vecPermutationMatrix[p_, q_] :=  PermutationMatrix[Flatten[Partition[Range[p q], p], {{2, 1}}]]`

### 比较两个矩阵内积是否相等

这个是第五个问题，我本来以为直接相减，等于0就是相等就ok了。结果减出来都不是0，可是我可以确保我的计算是正确的。然后我使用了**ExpandAll[]**，讲所有括号去掉，展开，终于得到了0。

问题可能是这样的，我的矩阵内积，有9个符号、12个符号相乘，然后再相加。它里面有大量合并同类型搞出来的括号之类的东西。比如：

`A=a (b+c+d) B=(a b+a c+a d)`

`A-B=a (b+c+d)-(a b +a c+a d)`

就是虽然A和B一样，但是他没有展开，有很多括号，减出来他们不会抵消，还是就这样写出来，合并同类项。

所以需要用ExpandAll[]，展开之后，没有括号了，他就可以合并同类型抵消得到0了。

`ExpandAll[A-B]=0`

## 小技巧

### Quit Kernel

还有一个问题也是在刘思齐老师的Mathematica课里听到的，就是如果新建一个文件时，最好要Quit Kernel一下，这个按钮可以把之前的数据全给清楚，避免不必要的错误，有可能你的某个变量赋过了值，结果你把他忘记了。Quit Kernel在Evaluation列表之下。

一个技巧就是未被赋值的变量是蓝色的，已被赋值的变量颜色是黑色的。

### 一键清除输出和导出PDF格式

在程序编写完成后，为了输出一个好的PDF报告，可以先一键清除输出（Evaluation->Delete All Outputs），再Quit Kernel。然后计算所有单元（Evaluate All cells），再导出为PDF（File->Print to PDF）。
