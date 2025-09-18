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

## U统计量和V统计量
在统计理论中，$U$统计量一直是研究者的“心头好”。它最大的优势在于：能够轻松构造**无偏估计**，名字里的 $U$ 其实就是 “unbiased” 的缩写。  

不过，虽然原理简单，$U$统计量的计算却常常令人头疼。先来看$m$阶$U$统计量的一般形式：  

$$
  \mathbb{U}_{m}(h) = \frac{1}{n(n-1)(n-2)\cdots(n-m-1)}\sum_{1 \le i_1 \neq i_2 \neq \cdots \neq i_m \le n} h(X_{i_1}, X_{i_2}, \cdots, X_{i_m}),\qquad\qquad (1)
$$

其中，$X_1, X_2, \cdots, X_n \in \Omega \subseteq \mathbb{R}^{p}$ 是 $n$ 个独立同分布的样本；$h : \Omega^m \to \mathbb{R}$ 称为核函数；指标条件 $i_1 \neq i_2 \neq \cdots \neq i_m$ 表示取的$m$个样本**互不相同**因此互相独立。  

$U$统计量之所以重要，在于它天然满足无偏性：  

$$
 \mathbb{E} [ \mathbb{U}_{m} (h)] = \mathbb{E} [h(X_{1}, X_{2}, \cdots, X_{m}) ],
$$

其中 $X_{1}, X_{2}, \cdots, X_{m}$ 是相互独立同分布的随机变量。换句话说，$U$统计量就是把所有可能的互不相等的$m$元样本组都带入核函数 $h$ 计算，再取平均值，从而得到一个对目标参数的无偏估计。

$U$统计量常常和它的“双胞胎”-$V$统计量一起提及，$m$阶$V$统计量的定义为：
$$
  \mathbb{V}_{m}(h) = \frac{1}{n^m}\sum_{1 \le i_1, i_2,\cdots, i_m \le n} h(X_{i_1}, X_{i_2}, \cdots, X_{i_m}).\qquad\qquad (2)
$$

注意$U$和$V$的区别就在于计算中指标是否存在限制，$V$统计量的计算中对指标$(i_1, i_2,\cdots, i_m)$**没有任何限制**，因此总共有$n^m$个值。

很容易可以看出来，$V$统计量可以表示成一组$U$统计量的线性组合（就是加加减减乘乘），反过来$U$统计量也可以表示成一组$V$统计量的线性组合（例子在稍后展示）。所以只要有一方可以高效计算，另一方就可以通过线性组合得到，我们的算法正是这个朴素的想法。

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
回到公式 (1)和(2)。如果直接用 for 循环枚举$m$阶组合来计算，那么复杂度是 $O(n^m)$（假设$h$的计算复杂度与$n$无关）。 作为对比，矩阵乘法或矩阵求逆的复杂度是 $O(n^3)$，因此，一旦阶数 $m > 3$，$U$统计量和$V$统计量的计算往往会变得难以承受。   

而偏偏，我们关注的统计量就是高阶$U$统计量。James M. Robins 等人在 2008 年提出的 **高阶影响函数（Higher Order Influence Function, HOIF）**，在各种假设下均能达到最优估计速率。HOIF 是一个高阶 $U$统计量，最优阶数大约是 $m \sim \sqrt{\log(n)}$。这意味着，HOIF 的实际应用必须直面高阶 $U$ 统计量的计算挑战。

m ($m \ge 2$) 阶HOIF的计算可以化简为核函数为$\{ h^{HOIF}_{j} \}_{j=2}^{m}$的$U$统计量的线性组合，核函数$h^{HOIF}_{j}$可以简化为以下形式:

$$
 h^{HOIF}_{j}(X_1,X_2,\cdots,X_j) = X_1^{\top}X_2 \cdot X_2^{\top}X_3 \cdots X_{j-1}^{\top}X_{j}, \qquad (3)
$$

由于这个递推规律，我们可以直接关心$h^{HOIF}_{m}$对应的$U$统计量的计算。我们设计了一套新算法。结果令人惊喜：在 $m=3,4,5,6,7$ 时，计算复杂度居然都只是 **$O(n^3)$**(更一般的规律在阅读完本文后你就会明白) ，$n=10000, m=7$时，$\mathbb{U}_{7} [h^{HOIF}_{7}]$在一张RTX4090上只需要跑$12$秒。

更进一步，我们发现这套方法并不局限于 HOIF对应的这一类$U$统计量，而是可以推广到**任意 $U$ 统计量**。借助图论工具，我们能够准确刻画出该算法的“最乐观”复杂度上界。 
更妙的是，实际实现完全可以依赖Numpy和PyTorch 提供的 **Einsum 函数**，天然支持 GPU 和 CPU 并行，从而在工程上也十分高效。  

---
## 新算法

接下来我们介绍新算法的实现。核心的想法已经在前文提到，把$U$统计量拆成$V$统计量的组合，再高效计算$V$统计量。

计算$V$统计量的核心工具是 Python 库中提供的强大函数 [numpy.Einsum](https://numpy.org/doc/stable/reference/generated/numpy.Einsum.html) 和 [torch.Einsum](https://pytorch.org/docs/stable/generated/torch.Einsum.html)。  
这两个函数的底层实现都经过高度优化，尤其是 `torch.Einsum`，可以方便地利用 **CPU 与 GPU 并行**，在工程上极具优势。

---

### Einsum

那么，Einsum 究竟做了什么？  
简单来说，Einsum 是一种针对张量的高效操作方式：输入若干张量，指定索引规则，对部分或全部指标执行**无约束**求和，最终输出一个新的张量或常数。  

下表给出几个常见例子：

| Einsum 调用格式                  | 对应结果                                      |
|:---------------------------------|:---------------------------------------------|
| `Einsum('ij,jk->ik', A, B)`   | $D_{ik} = \sum_j A_{ij} B_{jk}$              |
| `Einsum('ijk->i', X)`         | $D_i = \sum_{j,k} X_{ijk}$                   |
| `Einsum('ij,jk,kl-> ', A,B,C)`| $D = \sum_{i,j,k,l} A_{ij} B_{jk} C_{kl}$    |
| `Einsum('ijk,jjk,kkl-> ', A,B,C)`| $D = \sum_{i,j,k,l} A_{ijk} B_{jjk} C_{kkl}$|

在表达式 `'ij,j->j'` 中，`->` 左边指定输入张量的指标分布，右边表示最终保留的指标。如果某个指标只出现在左边而没出现在右边，它就会被求和“消去”。  
这个记号起源于 **Einstein 求和约定**（1916 年提出），矩阵与高阶张量的绝大多数运算都能通过 Einsum 表达，而在处理三阶及以上张量时，它往往是最简洁、最高效的工具。

---

读到这里，你可能已经注意到 Einsum 和 $V$ 统计量的天然联系。事实上，所有的 $V$ 统计量都可以直接用 Einsum 表示：  
只要核函数 $h$ 能够写成乘法分解形式，$V$ 统计量的计算就可以转化为一个张量求和问题；如果 $h$ 不能分解，那就相当于一个整体张量，复杂度无法进一步降低。  

回到高阶影响函数（HOIF）中关心的核函数：  

$$
\begin{aligned}
 h^{HOIF}_{m}(X_1,X_2,\cdots,X_m) 
 &= X_1^{\top}X_2 \cdot X_2^{\top}X_3 \cdots X_{m-1}^{\top}X_{m} \\
 &= f(X_1,X_2) \cdot f(X_2,X_3) \cdots f(X_{m-1},X_{m}),
\end{aligned}
$$

其中 $f(X,Y) = X^{\top}Y$ 是一个标量函数。  
对数据 $X_1,X_2,\cdots,X_n$，我们可以构造一个 $n \times n$ 矩阵 $T$：

$$
 T_{ij} = f(X_i,X_j) = X_i^{\top}X_j.
$$

于是，$h^{HOIF}_{m}$ 对应的 $V$ 统计量就可以写成：

$$
\begin{aligned}
\mathbb{V}_{m}[ h^{HOIF}_{m}]
&= \frac{1}{n^m} \sum_{1\le i_1,i_2,\cdots,i_m \le n} 
   T_{i_1,i_2}\cdot T_{i_2,i_3} \cdots T_{i_{m-1},i_{m}} \\[6pt]
&= \frac{1}{n^m} \,\mathsf{Einsum}\big( ``i_1i_2,i_2i_3,\cdots,i_{m-1}i_m -> ", T,T,\cdots,T \big).
\end{aligned}
$$

换句话说，Einsum 提供了一种自然而高效的方式来计算 $V$ 统计量。而由于 $U$ 统计量和 $V$ 统计量之间存在可以互相转化的关系（只要能高效算一个，就能高效算另一个），这就为我们建立 $U$ 统计量的高效算法奠定了基础。接下来要做的，就是找到合适的公式，把 $U$ 拆解成 $V$。

### $U$ 拆 $V$

我们先来找规律。先看二阶的情况：

$$
\begin{aligned}
 n(n-1)\cdot \mathbb{U}_{2}[h] & = \sum_{1 \le i_1 \neq i_2 \le n} h(X_{i_1},X_{i_2}) \\[6pt]
 & = \Big(\sum_{1 \le i_1, i_2 \le n} - \sum_{1 \le i_1=i_2 \le n} \Big) h(X_{i_1},X_{i_2}) \\[6pt]
 & = n^2 \mathbb{V}_{2}[h] - n \mathbb{V}_{1,1=2}[h].
\end{aligned}
$$

这里我们暂且用 $\mathbb{V}_{1,1=2}[h]$ 表示求和  
$$
\frac{1}{n}\sum_{1 \le i_1=i_2 \le n} h(X_{i_1},X_{i_2}),
$$  
它退化成了一个一阶 $V$ 统计量。  

接下来看三阶的情况。为了简化符号，我们暂时省略掉指标范围 $1\sim n$ 以及$\mathbb{U}$和$\mathbb{V}$的归一化因子（如 $\frac{1}{n(n-1)(n-2)},\frac{1}{n^3}$ 等）：  

$$
\begin{aligned}
 \mathbb{U}_{3}[h] & = \sum_{i_1 \neq i_2 \neq i_3} h(X_{i_1},X_{i_2},X_{i_3}) \\[6pt]
 & = \Big(\sum_{i_1,i_2,i_3} - \sum_{(i_1=i_2)\ne i_3 } - \sum_{(i_1=i_3)\ne i_2 } - \sum_{(i_2=i_3)\ne i_1 } - \sum_{i_1=i_2=i_3}\Big) h(X_{i_1},X_{i_2},X_{i_3}) \\[6pt]
 & = \mathbb{V}_{3}[h] - \mathbb{U}_{2,1=2}[h] - \mathbb{U}_{2,1=3}[h] - \mathbb{U}_{2,2=3}[h] - \mathbb{U}_{1,1=2=3}[h]. \qquad (4)
\end{aligned}
$$

在这里，$(i_1=i_2)\ne i_3$ 表示 $i_1=i_2=i$ 且 $i\neq i_3$。也就是说只剩下两个指标 $(i,i_3)$，对应一个二阶 $U$ 统计量，记作 $\mathbb{U}_{2,1=2}$（忽略归一化因子 $\tfrac{1}{n(n-1)}$）。其他几个符号同理。注意一阶 $U$ 统计量和一阶 $V$ 统计量是一样的。  

因此，$\mathbb{U}_3$ 被拆成了 $\mathbb{V}_3$ 和更低阶的 $U$ 统计量。而$2$阶 $U$和$1$阶 $U$ 我们已经能写成 $V$ 的组合，所以顺着这个递推关系，就能得到一个一般的“$U$ 拆 $V$”算法。继续推下去：  

$$
\begin{aligned}
 \mathbb{U}_{3}[h] 
 &= \mathbb{V}_{3}[h] - \mathbb{U}_{2,1=2}[h] - \mathbb{U}_{2,1=3}[h] - \mathbb{U}_{2,2=3}[h] - \mathbb{U}_{1,1=2=3}[h] \\[6pt]
 &= \mathbb{V}_{3}[h] - \big(\mathbb{V}_{2,1=2} - \mathbb{V}_{1,1=2=3}\big)[h] - \big(\mathbb{V}_{2,1=3} - \mathbb{V}_{1,1=2=3}\big)[h] \\[6pt]
 &\quad - \big(\mathbb{V}_{2,2=3} - \mathbb{V}_{1,1=2=3}\big)[h] - \mathbb{V}_{1,1=2=3}[h] \\[6pt]
 &= \mathbb{V}_{3}[h] - \mathbb{V}_{2,1=2}[h] - \mathbb{V}_{2,1=3}[h] - \mathbb{V}_{2,2=3}[h] + 2\mathbb{V}_{1,1=2=3}[h].
\end{aligned}
$$

---

#### 更优雅的数学描述

但是，我们再仔细看看，能不能有个更优雅的数学刻画呢？ 仔细观察公式 $(4)$，它其实表明：**一个 $V$ 统计量可以拆成若干 $U$ 统计量的和**，并且系数都是 $1$：

$$
 \mathbb{V}_{3}[h]= \mathbb{U}_{3}[h] + \mathbb{U}_{2,1=2}[h] + \mathbb{U}_{2,1=3}[h] + \mathbb{U}_{2,2=3}[h] + \mathbb{U}_{1,1=2=3}[h].
$$

这里的不同符号，其实对应于 $\{1,2,3\}$ 的不同 **划分**。一个有限集合的划分，就是它的所有分组方式。$\{1,2,3\}$ 的划分有：

$$
\{\{1\},\{2\},\{3\}\}, \quad
\{\{1,2\},\{3\}\}, \quad
\{\{1,3\},\{2\}\}, \quad
\{\{2,3\},\{1\}\}, \quad
\{\{1,2,3\}\}.
$$

例如，划分 $\{\{1,2\},\{3\}\}$ 表示把 $1,2$ 放在一组，$3$ 单独一组；对应的约束就是 $i_1=i_2$作为一个新指标，而 $i_3$ 是另一个独立指标。 

于是我们可以引入一个记号：对每个划分 $\pi$，定义相应的受限 $U$ 统计量和 $V$ 统计量（忽略平均因子）：  

$$
\begin{aligned}
 \pi = \{\{1\},\{2\},\{3\}\},\quad & \mathbb{V}[\pi](h) = \sum_{i_1,i_2,i_3} h, \quad\ \ \ \mathbb{U}[\pi](h) = \sum_{i_1\neq i_2 \neq i_3} h, \\[6pt]
 \pi = \{\{1,2\},\{3\}\},\quad & \mathbb{V}[\pi](h) = \sum_{i_1=i_2,i_3} h, \quad \mathbb{U}[\pi](h) = \sum_{(i_1=i_2)\neq i_3} h, \\[6pt]
 \pi = \{\{1,3\},\{2\}\},\quad & \mathbb{V}[\pi](h) = \sum_{i_1=i_3,i_2} h, \quad \mathbb{U}[\pi](h) = \sum_{(i_1=i_3)\neq i_2} h, \\[6pt]
 \pi = \{\{2,3\},\{1\}\},\quad & \mathbb{V}[\pi](h) = \sum_{i_2=i_3,i_1} h, \quad \mathbb{U}[\pi](h) = \sum_{(i_2=i_3)\neq i_1} h, \\[6pt]
 \pi = \{\{1,2,3\}\},\quad & \mathbb{V}[\pi](h) = \sum_{i_1=i_2=i_3} h, \quad \mathbb{U}[\pi](h) = \sum_{i_1=i_2=i_3} h.
\end{aligned}
$$

---

#### 更优雅的条件描述

上面的定义可以完美推广出去，有了这个数学的形式化，就能写出一个漂亮的恒等式。对任意 $m$ 阶：  

$$
\mathbb{V}_{m}[h] = \mathbb{V}[\pi_{m}](h) = \sum_{\pi \in \Pi_m} \mathbb{U}[\pi](h),
$$

其中：  
- $\Pi_m$ 是集合 $\{1,2,\dots,m\}$ 的所有划分，  
- $\pi_m = \{\{1\},\{2\},\dots,\{m\}\}$ 是每个指标单独成组。  

$\Pi_{m}$上有一个天然的偏序（就是一个比大小的关系），谁分的更精细，谁就更大，什么是精细的意思呢？你应该可以自己猜出来了，比如说
$$
\pi_2 = \{ \{ 1\},\{ 2 \} \} > \{ \{ 1, 2\} \},\\
\pi_3 = \{ \{ 1\},\{ 2 \}, \{3\} \} > \{ \{ 1, 2\}, \{3\} \} > \{ \{1,2,3\} \}.
$$
所以精细的意思是，本来某个组里还可以再分，他却没有分，如果你把这一组又继续细分了，你就更精细，你就更大。在$\{ \{1, 2\}, \{3\} \}$里继续切分$\{1,2\}$得到$\{ \{ 1\},\{ 2 \}, \{3\} \}$,你就得到了更精细的一个划分。但是并不是所有的分组方式都可以比较，比如：
$$
\{ \{ 1, 2\}, \{3\} \},\{ \{ 1, 3\}, \{2\} \},\{ \{ 2, 3\}, \{1\} \} 均无法互相比较
$$
但是我们注意到$\pi_{m} = \{ \{ 1\},\{ 2 \},\cdots,\{m\}\} $是可以和任何划分比较的，它比任何划分都更大，他是最精细的划分，于是，我们的公式可以写成：

$$
\mathbb{V}_{m}[h] = \sum_{\pi \le \pi_m} \mathbb{U}[\pi](h).
$$

并且很容易可以证明不只是$\pi_m$, 对任意的划分$\pi$, 都有这个关系：

$$
\mathbb{V}[\pi](h) = \sum_{\rho \le \pi} \mathbb{U}[\rho](h), \forall \pi \in \Pi_m. \qquad (5)
$$

---

#### 莫比乌斯反演得到最终公式

到了这一步之后，组合的数学家已经为我们准备好了一切--[莫比乌斯反演公式(Möbius inversion formula)](https://en.wikipedia.org/wiki/M%C3%B6bius_inversion_formula#On_posets):  

在有限偏序集（这里就是 $\Pi_m$）上，莫比乌斯函数 $\mu$ 可以递归定义：  

$$
\mu(\pi,\pi) = 1, \quad
\mu(\pi,\rho) = - \sum_{\pi \le \sigma < \rho } \mu(\pi, \sigma), \quad \pi\neq\rho.
$$

$\Pi_m$上的这个莫比乌斯函数$\mu$早就有公式了，我们不必再计算。如果一对函数 $f,g$ 满足  

$$
g(\pi) = \sum_{\rho \le \pi} f(\rho), \quad \forall \pi \in \Pi_m,
$$

那么必有  

$$
f(\pi) = \sum_{\rho \le \pi} g(\rho)\,\mu(\rho,\pi), \quad \forall \pi \in \Pi_m.
$$

套用到我们的情形（令 $g(\pi) = \mathbb{V}[\pi](h), f(\pi) = \mathbb{U}[\pi](h)$），我们已经有了公式$(5)$,由此得到：  

$$
\mathbb{U}[\pi](h) = \sum_{\rho \le \pi} \mathbb{V}[\rho](h)\,\mu(\rho,\pi), \quad \forall \pi \in \Pi_m. \qquad (6)
$$

我们最终关心的是 $\pi=\pi_m$ 的情况：  

$$
\mathbb{U}_m[h] = \mathbb{U}[\pi_m](h) = \sum_{\pi \le \pi_m} \mathbb{V}[\pi](h) \mu(\pi,\pi_m) = \sum_{\pi \in \Pi_{m}} \mu_{\pi} \mathbb{V}[\pi](h).
$$

其中若 $\pi=\{\pi_1,\pi_2,\dots,\pi_K\}$，每个 $\pi_i$ 含有 $n_i$ 个指标，则  

$$
\mu(\pi,\pi_m) = \mu_{\pi} = (-1)^{m-K}\,(n_1-1)!\,(n_2-1)!\cdots(n_K-1)!.
$$

比如回到$m=3$的例子，注意$n! = n(n-1)(n-2)\cdots 1，0! =1，(-1)^{0}=1$.
$$
\begin{aligned}
 \pi = \{\{1\},\{2\},\{3\}\}, \quad & \mu_{\pi} = (-1)^{3-3} (1 -1)! (1 -1)! (1 -1)! = + 1,\\
 \pi = \{\{1,2\},\{3\}\}, \quad  &\mu_{\pi} = (-1)^{3-2} (2 -1)! (1 -1)! = - 1,\\
 \pi = \{\{1,3\},\{2\}\},\quad   &\mu_{\pi} = (-1)^{3-2} (2 -1)! (1 -1)! = - 1,\\
  \pi = \{\{2,3\},\{1\}\}, \quad  &\mu_{\pi} = (-1)^{3-2} (2 -1)! (1 -1)! = - 1,\\
   \pi = \{\{1,2,3\}\}, \quad  & \mu_{\pi} = (-1)^{3-1} (3 -1)!  = + 2.
\end{aligned}
$$

到此，我们的新算法在工程上已经清晰了，对于$m$阶$U$统计量，计算$\Pi_{m}$上的所有划分$\pi$和系数$\mu_{\pi}$，然后把$\mathbb{V}[\pi](h)$表示成Einsum带入 Python 的Einsum 函数，然后再汇合到一起就算出了$\mathbb{U}[h]$的值。

### 复杂度分析

接下里我们分析上述新算法的复杂度，这会将我们导入比莫比乌斯反演更美丽宏大的数学世界，简单图中的顶点消除(vertex elimination)，树宽（treewidth）, 商图（quotien graph）将完美刻画我们的计算过程与最终的计算复杂度。