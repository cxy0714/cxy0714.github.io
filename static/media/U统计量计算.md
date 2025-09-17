---
title: U统计量计算新算法
date: 2025-09
author: 陈星宇
categories:
  - 统计计算
  - 统计软件
tags:
  - U统计量
  - 统计计算
  - Einsum
  - 图论
  - 树宽
---

# U统计量计算新算法

## U统计量的定义
在统计理论中，$U$统计量一直是研究者的“心头好”。它最大的优势在于：能够轻松构造**无偏估计**，名字里的 $U$ 其实就是 “unbiased” 的缩写。  

不过，虽然原理简单，$U$统计量的计算却常常令人头疼。先来看$m$阶$U$统计量的一般形式：  

$$
  \mathbb{U}(h) = \frac{1}{n(n-1)(n-2)\cdots(n-m-1)}\sum_{1 \le i_1 \neq i_2 \neq \cdots \neq i_m \le n} h(X_{i_1}, X_{i_2}, \cdots, X_{i_m}),\qquad\qquad (1)
$$

其中，$X_1, X_2, \cdots, X_n \in \Omega \subseteq \mathbb{R}^{p}$ 是 $n$ 个独立同分布的样本；$h : \Omega^m \to \mathbb{R}$ 称为核函数；指标条件 $i_1 \neq i_2 \neq \cdots \neq i_m$ 表示取的$m$个样本互不相同因此互相独立。  

$U$统计量之所以重要，在于它天然满足无偏性：  

$$
 \mathbb{E} [ \mathbb{U} (h)] = \mathbb{E} [h(X_{1}, X_{2}, \cdots, X_{m}) ],
$$

其中 $X_{1}, X_{2}, \cdots, X_{m}$ 是相互独立同分布的随机变量。换句话说，$U$统计量就是把所有可能的互不相等的$m$元样本组都带入核函数 $h$ 计算，再取平均值，从而得到一个对目标参数的无偏估计。

$U$统计量常常和它的“双胞胎”-$V$统计量一起提及，$m$阶$V$统计量的定义为：
$$
  \mathbb{V}(h) = \frac{1}{n^m}\sum_{1 \le i_1, i_2,\cdots, i_m \le n} h(X_{i_1}, X_{i_2}, \cdots, X_{i_m}).\qquad\qquad (2)
$$

注意$U$和$V$的区别就在于计算中指标是否存在限制，$V$统计量的计算中对指标$(i_1, i_2,\cdots, i_m)$没有任何限制，因此总共有$n^m$个值。

很容易可以看出来，$V$统计量可以表示成一组$U$统计量的线性组合（就是加加减减乘乘），反过来$U$统计量也可以表示成一组$V$统计量的线性组合（例子在稍后展示）。所以只要有一方可以高效计算，另一方就可以通过线性组合得到，我们算法就是这样子做！

---

### 一个例子：方差估计
最常见的例子就是方差的无偏估计。假设维度$p =1$, $X_1, X_2$ 是独立同分布（和$X$同分布）的随机变量，那么：  

$$
\begin{aligned}
  \mathsf{var}(X) &= \frac{1}{2}\mathbb{E}[ (X_1 - X_2)^2] \\[6pt]
                  &= \frac{1}{2}(\mathbb{E}[ X_1^2] + \mathbb{E}[ X_2^2] - 2\mathbb{E}[X_1] \mathbb{E}[X_2] ) \\[6pt]
                  &= \mathbb{E}[ X^2] - (\mathbb{E}[X])^2 \\[6pt]
                  &= \mathbb{E}[ (X -\mathbb{E}[X])^2].
\end{aligned}
$$

因此，基于$U$统计量的方差估计量就是：  

$$
\begin{aligned}
 \widehat{\mathsf{var}}(X) &= \frac{1}{2n(n-1)} \sum_{1 \le i_1 \neq i_2 \le n} (X_{i_1} - X_{i_2})^2  \\[6pt]
  & = \frac{1}{n-1} \sum_{1 \le i \le n} (X_{i} - \bar{X})^2,
 \end{aligned}
$$

其中 $\bar{X} = \frac{1}{n}\sum_{i=1}^n X_i$ 是样本均值。换句话说，我们熟悉的方差无偏估计公式，其实就是一个二阶 $U$ 统计量。

---

## 计算难题
回到公式 (1)。如果直接用 for 循环枚举$m$阶组合来计算，那么复杂度是 $O(n^m)$（假设$h$的计算复杂度与$n$无关）。 作为对比，矩阵乘法或矩阵求逆的复杂度是 $O(n^3)$，因此，一旦阶数 $m > 3$，$U$统计量的计算往往会变得难以承受。   

而偏偏，我们关注的统计量就是高阶$U$统计量。James M. Robins 等人在 2008 年提出的 **高阶影响函数（Higher Order Influence Function, HOIF）**，在各种假设下均能达到最优估计速率。HOIF 是一个高阶 $U$统计量，最优阶数大约是 $m \sim \sqrt{\log(n)}$。这意味着，HOIF 的实际应用必须直面高阶 $U$ 统计量的计算挑战。

m ($m \ge 2$) 阶HOIF的计算可以化简为核函数为$\{ h^{HOIF}_{j} \}_{j=2}^{m}$的$U$统计量的线性组合，核函数$h^{HOIF}_{j}$可以简化为以下形式:

$$
 h^{HOIF}_{j}(X_1,X_2,\cdots,X_j) = X_1^{\top}X_2 \cdot X_2^{\top}X_3 \cdots X_{j-1}^{\top}X_{j}, \qquad (3)
$$

由于这个递推规律，我们可以直接关心$h^{HOIF}_{m}$对应的$U$统计量的计算。我们设计了一套新算法。结果令人惊喜：在 $m=3,4,5,6,7$ 时，计算复杂度居然都只是 **$O(n^3)$**(更一般的规律在阅读完本文后你就会明白) ，$n=10000, m=7$时，$\mathbb{U} [h^{HOIF}_{7}]$在一张RTX4090上只需要跑$12$秒。

更进一步，我们发现这套方法并不局限于 HOIF对应的这一类$U$统计量，而是可以推广到**任意 $U$ 统计量**。借助图论工具，我们能够准确刻画出该算法的“最乐观”复杂度上界。 
更妙的是，实际实现完全可以依赖Numpy和PyTorch 提供的 **Einsum 函数**，天然支持 GPU 和 CPU 并行，从而在工程上也十分高效。  

---

## 新算法

接下来我们介绍新算法的实现，这依赖于Python库中的强大函数[Nupmy.einsum](https://numpy.org/doc/stable/reference/generated/numpy.einsum.html) 和 [torch.einsum](https://docs.pytorch.org/docs/stable/generated/torch.einsum.html)。他们的底层实现已经高度优化，torch版本的einsum可以便捷地使用cpu和gpu并行。

### Einsum

Einsum函数实现的是什么呢？网上已经很多帖子（[比如](https://zhuanlan.zhihu.com/p/361209187)）介绍了Einsum，[我们的论文](https://arxiv.org/pdf/2508.12627)中也给了一个更严格的数学定义。简单来说，Einsum是对一系列张量的操作，最主要的功能是输入一列张量，对部分或者全部指标做无约束的求和，最终得到一个张量或者一个常数。

| Einsum 调用格式                  | 对应结果                                      |
|:---------------------------------|:--------------------------------------------------|
| np.einsum('ij,jk ->ik', A, B)         | $D_{ik} = \sum_j A_{ij} B_{jk}$                            |
| np.einsum('ijk->i', X)           | $D_i = \sum_{j,k} X_{ijk}$                              |
| np.einsum('ij,jk,kl-> ', A, B,C)      | $D = \sum_{i,j,k,l} A_{ij} B_{jk} C_{kl}$                            |
| np.einsum('ijk,jjk,kkl-> ', A, B,C)      | $D = \sum_{i,j,k,l} A_{ijk} B_{jjk} C_{kkl}$                            |

像'ij,j -> j'这样的式子叫做einsum表达式，"->"左侧代表了输入张量的指标分布，"->"右侧代表最终的张量剩下来的指标（如果为0，就代表结果为常数），这本来Einstein老爷子（提出该记号时正年轻，1916年）为了方便写公式约定的记号，左侧是全部的指标的分布，右侧是剩余的指标，左侧中出现右侧不出现的指标就是求和求掉了。矩阵的所有运算都可以用Einsum来表示，当需要用3阶以上的张量运算时，Einsum就成了最有效的工具。

读到这里，大家应该已经发现了Einsum和$V$统计量的一致之处了：


