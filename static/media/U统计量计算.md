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
  \mathbb{U}_{m}(h) = \frac{1}{n(n-1)(n-2)\cdots(n-m-1)}\sum_{1 \le i_1 \neq i_2 \neq \cdots \neq i_m \le n} h(X_{i_1}, X_{i_2}, \cdots, X_{i_m}),\qquad\qquad (1)
$$

其中，$X_1, X_2, \cdots, X_n \in \Omega \subseteq \mathbb{R}^{p}$ 是 $n$ 个独立同分布的样本；$h : \Omega^m \to \mathbb{R}$ 称为核函数；指标条件 $i_1 \neq i_2 \neq \cdots \neq i_m$ 表示取的$m$个样本互不相同因此互相独立。  

$U$统计量之所以重要，在于它天然满足无偏性：  

$$
 \mathbb{E} [ \mathbb{U}_{m} (h)] = \mathbb{E} [h(X_{1}, X_{2}, \cdots, X_{m}) ],
$$

其中 $X_{1}, X_{2}, \cdots, X_{m}$ 是相互独立同分布的随机变量。换句话说，$U$统计量就是把所有可能的互不相等的$m$元样本组都带入核函数 $h$ 计算，再取平均值，从而得到一个对目标参数的无偏估计。

$U$统计量常常和它的“双胞胎”-$V$统计量一起提及，$m$阶$V$统计量的定义为：
$$
  \mathbb{V}_{m}(h) = \frac{1}{n^m}\sum_{1 \le i_1, i_2,\cdots, i_m \le n} h(X_{i_1}, X_{i_2}, \cdots, X_{i_m}).\qquad\qquad (2)
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

由于这个递推规律，我们可以直接关心$h^{HOIF}_{m}$对应的$U$统计量的计算。我们设计了一套新算法。结果令人惊喜：在 $m=3,4,5,6,7$ 时，计算复杂度居然都只是 **$O(n^3)$**(更一般的规律在阅读完本文后你就会明白) ，$n=10000, m=7$时，$\mathbb{U}_{7} [h^{HOIF}_{7}]$在一张RTX4090上只需要跑$12$秒。

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

读到这里，大家应该已经发现了Einsum和$V$统计量的一致之处了，所有的V统计量都可以直接通过Einsum来计算，但是需要$V$统计量的核函数$h$有一个乘法分解（分解不了的话，就是一个张量，无法降低复杂度，当然有分解也不一定可以降低复杂度，继续读！我们会有一个答案：什么时候可以降低复杂度，什么时候不可以），$h^{HOIF}_{m}$就有一个分解结构：

$$
\begin{aligned}
 h^{HOIF}_{j}(X_1,X_2,\cdots,X_m) & = X_1^{\top}X_2 \cdot X_2^{\top}X_3 \cdots X_{m-1}^{\top}X_{m} \\
& = f(X_1,X_2) \cdot f(X_2,X_3) \cdots f(X_{m-1},X_{m}).
\end{aligned}
$$

这里$f(X,Y) = X^{\top}Y$是标量函数，对于数据$X_1,X_2,\cdots,X_n$,我们可以构造一个$n \times n$矩阵$T$:

$$
 T_{ij}  = f(X_i,X_j)= X_i^{\top}X_j,
$$
这样$h^{HOIF}_{m}$对应的$V$统计量可以用Einsum来表示：
$$
\begin{aligned}
\mathbb{V}_{m}[ h^{HOIF}_{m}] & = \frac{1}{n^m} \sum_{1\le i_1,i_2,\cdots,i_m \le n} T_{i_1,i_2}\cdot T_{i_2,i_3} \cdots T_{i_{m-1},i_{m}} \\
& = \frac{1}{n^m} \mathsf{Einsum}( ``i_1i_2,i_2i_3,\cdots,i_{m-1}i_m -> ", T,T,\cdots,T ).
\end{aligned}
$$

如前所述，只要$U$统计量和$V$统计量有一个可以高效计算，另一个就也可以了，现在感谢Einsum的实现，我们可以做到便捷高效地计算$V$统计量了。在工程上，一个计算$U$统计量的算法就有了，只需要把$U$统计量拆成$V$统计量就好，那么我们能不能找到一个公式呢？

### U拆V
我们来找一找规律，先来看2阶：

$$
\begin{aligned}
 n(n-1)\cdot \mathbb{U}_{2}[h] & = \sum_{1 \le i_1 \neq i_2 \le n} h(X_{i_1},X_{i_2}) \\
 & = (\sum_{1 \le i_1, i_2 \le n} - \sum_{1 \le i_1=i_2 \le n} ) h(X_{i_1},X_{i_2}) \\
 & = n^2 \mathbb{V}_{2}[h] - n \mathbb{V}_{1,1=2}[h]
\end{aligned}
$$

这里我们暂且用$\mathbb{V}_{1,1=2}[h]$代表求和$\frac{1}{n}\sum_{1 \le i_1=i_2 \le n}  h(X_{i_1},X_{i_2})$, 它变成了一个1阶$V$统计量。然后看看3阶,我们就先把指标的范围$1$到$n$,以及**为了平均除掉的数量因子$n(n-1)(n-2),n^3$等等先省略**了：

$$
\begin{aligned}
 \mathbb{U}_{3}[h] & = \sum_{i_1 \neq i_2 \neq i_3} h(X_{i_1},X_{i_2},X_{i_3}) \\
 & = (\sum_{ i_1, i_2, i_3} - \sum_{(i_1=i_2) \ne i_3 } - \sum_{(i_1=i_3) \ne i_2 } - \sum_{(i_2=i_3) \ne i_1 }  - \sum_{i_1=i_2 = i_3 }) h(X_{i_1},X_{i_2},X_{i_3}) \\
 & = \mathbb{V}_{3}[h]- \mathbb{U}_{2,1=2}[h] -\mathbb{U}_{2,1=3}[h] - \mathbb{U}_{2,2=3}[h]- \mathbb{U}_{1,1=2=3}[h]. \qquad (5)
\end{aligned}
$$
我们先分到这一步，这里$(i_1=i_2) \ne i_3$代表$i_1=i_2=i$但是$i\neq i_3$.也就是说，这里只剩下2个指标$i,i_3$了，对应了一个$2$阶$U$统计量, 我们把它记作$\mathbb{U}_{2,1=2}$（忽略了因子$\frac{1}{n(n-1)}$），另外几个记号同理，注意$1$阶$U$统计量和$1$阶$V$统计量一样。因此$\mathbb{U}_{3}$拆成了$\mathbb{V}_{3}$和比他低阶的$U$统计量，低阶的$U$统计量我们已经推导过，所以按照这个递推关系我们可以得到一个$U$拆$V$的算法。我们继续写出来：
$$
\begin{aligned}
 \mathbb{U}_{3}[h] 
 & = \mathbb{V}_{3}[h]- \mathbb{U}_{2,1=2}[h] -\mathbb{U}_{2,1=3}[h] - \mathbb{U}_{2,2=3}[h]- \mathbb{U}_{1,1=2=3}[h] \\
  & = \mathbb{V}_{3}[h]- (\mathbb{V}_{2,1=2} - \mathbb{V}_{1,1=2=3})[h] -(\mathbb{V}_{2,1=3} - \mathbb{V}_{1,1=2=3})[h] \\
 &  - (\mathbb{V}_{2,2=3} - \mathbb{V}_{1,1=2=3})[h]- \mathbb{V}_{1,1=2=3}[h] \\
 & = \mathbb{V}_{3}[h]- \mathbb{V}_{2,1=2}[h] -\mathbb{V}_{2,1=3}[h] - \mathbb{U}_{2,2=3}[h]+2 \mathbb{V}_{1,1=2=3}[h].
\end{aligned}
$$

但是，我们再仔细看看，能不能有个更优雅的数学刻画呢？ 先来看公式$(5)$, 它其实代表了$V$统计量可以拆成$U$统计量的组合,而且系数都是1：
$$
 \mathbb{V}_{3}[h]= \mathbb{U}_{3}[h] + \mathbb{U}_{2,1=2}[h] +\mathbb{U}_{2,1=3}[h] + \mathbb{U}_{2,2=3}[h]+ \mathbb{U}_{1,1=2=3}[h].
$$
再仔细看我们的符号，这其实对应了遍历所有的$\{1,2,3\}$上的划分$\pi$,一个有限集合上的划分就是他的所有分组方式，$\{1,2,3\}$上的所有划分可以这样表示：
$$
\{\{1\},\{2\},\{3\}\}, \quad \{\{1, 2\},\{3\}\}, \quad \{\{1, 3\},\{2\}\}, \quad \{\{2, 3\},\{1\}\}, \quad \{\{1, 2, 3\}\}
$$
比如$\{\{1, 2\},\{3\}\}$代表把$1$和$2$分在一组，$3$单独一组，如果两个指标在一组里，我们就让这两个指标相等视作一个新指标，我们来定义一个由划分$\pi$限制的$U$统计量$\mathbb{U}[\pi](h)$和$V$统计量$\mathbb{V}[\pi](h)$的记号（忽略掉数量因子）：
$$
\begin{aligned}
 \pi = \{\{1\},\{2\},\{3\}\}, \mathbb{V}[\pi](h) & = \sum_{i_1,i_2,i_3} h ,\quad \mathbb{U}[\pi](h) & = \sum_{i_1\neq i_2 \neq i_3} h \\
 \pi = \{\{1,2\},\{3\}\}, \mathbb{V}[\pi](h) & = \sum_{i_1 = i_2,i_3} h,\quad \mathbb{U}[\pi](h) & = \sum_{(i_1 = i_2)\neq i_3} h \\
 \pi = \{\{1,3\},\{2\}\}, \mathbb{V}[\pi](h) & = \sum_{i_1=i_3, i_2} h,\quad \mathbb{U}[\pi](h) & = \sum_{(i_1= i_3) \neq i_2} h \\
  \pi = \{\{2,3\},\{1\}\}, \mathbb{V}[\pi](h) & = \sum_{i_2=i_3, i_1} h,\quad \mathbb{U}[\pi](h) & = \sum_{(i_2= i_3) \neq i_1} h \\
   \pi = \{\{1,2,3\}\}, \mathbb{V}[\pi](h) & = \sum_{i_1=i_2= i_3} h,\quad \mathbb{U}[\pi](h) & = \sum_{i_1= i_2=i_3} h \\
\end{aligned}
$$
这套定义可以完美推广出去，并且有了这个形式化，我们会发现一个漂亮的公式，首先是一般的$m$阶$V$统计量表示成$U$统计量的公式（从此以后，说$V$统计量和$U$统计量时，我们都抛掉平均因子）:

$$
\mathbb{V}_{m}[h] = \mathbb{V}[\pi_{m}](h) = \sum_{\pi \in \Pi_m} \mathbb{U}[\pi](h)
$$

这里$\Pi_{m}$代表所有$\{1,2,\cdots,m\}$上的划分组成的集合，$\pi_{m} = \{ \{ 1\},\{ 2 \},\cdots,\{m\}\} $是把所有指标都单独分一个组的那个分组方式，$\Pi_{m}$上有一个天然的偏序（就是一个比大小的关系），谁分的更精细，谁就更大，什么是精细的意思呢？你应该可以自己猜出来了，比如说
$$
\pi_2 = \{ \{ 1\},\{ 2 \} \} > \{ \{ 1, 2\} \},\\
\pi_3 = \{ \{ 1\},\{ 2 \}, \{3\} \} > \{ \{ 1, 2\}, \{3\} \} > \{ \{1,2,3\} \}.
$$
所以精细的意思是，本来某个组里还可以再分，他却没有分，如果你把这一组又继续细分了，你就更精细，你就更大。但是并不是所有的分组方式都可以比较，比如：
$$
\{ \{ 1, 2\}, \{3\} \},\{ \{ 1, 3\}, \{2\} \},\{ \{ 2, 3\}, \{1\} \} 均无法互相比较
$$
但是我们注意到$\pi_{m} = \{ \{ 1\},\{ 2 \},\cdots,\{m\}\} $是可以和任何划分比较的，它比任何划分都更大，他是最精细的划分，于是，我们的公式可以写成：

$$
\mathbb{V}_{m}[h] = \mathbb{V}[\pi_{m}](h) = \sum_{\pi \in \Pi_m} \mathbb{U}[\pi](h) = \sum_{\pi \le \pi_m} \mathbb{U}[\pi](h)
$$

并且很容易可以证明不只是$\pi_m$, 对任意的$\pi \in \Pi_m$, 都有这个关系：
$$
\mathbb{V}[\pi](h) = \sum_{\rho \le \pi} \mathbb{U}[\rho](h), \forall \pi \in \Pi_m. \qquad (6)
$$

到了这一步之后，组合的数学家们已经为我们准备好了一切--[莫比乌斯反演公式(Möbius inversion formula)](https://en.wikipedia.org/wiki/M%C3%B6bius_inversion_formula#On_posets):

懒得check维基的同志们，可以不点链接直接看我讲了：
对于任何一个有限的偏序集合（有一个大小关系的集合，在我们这里就是$\Pi_m$，所有的分组方式的集合），先通过递归可以定义一个莫比乌斯函数$\mu$:
$$
\mu(\pi,\pi) = 1, \mu(\pi,\rho) = - \sum_{\pi \le \sigma < \rho } \mu(\pi, \sigma), \pi, \rho \in \Pi_m, \rho \neq \pi.
$$
$\Pi_m$上的这个莫比乌斯函数$\mu$早就有公式了，我们不必再计算。这时候如果有函数$f,g$满足：
$$
g(\pi) = \sum_{\rho \le \pi} f(\rho), \forall \pi \in \Pi_m.
$$
那么一定有：
$$
f(\pi) = \sum_{\rho \le \pi} g(\rho) \mu(\rho, \pi), \forall \pi \in \Pi_m.
$$
所以由我们的关系$(6)$,令$g(\pi) = \mathbb{V}[\pi](h), f(\pi) = \mathbb{U}[\pi](h)$, 我们可以得到：
$$
\mathbb{U}[\pi](h) = \sum_{\rho \le \pi} \mathbb{V}[\rho](h) \mu(\rho,\pi), \forall \pi \in \Pi_m. \qquad (7)
$$
而我们只关心的只是$\pi = \pi_{m}$的情况：
$$
\mathbb{U}_m[h] = \mathbb{U}[\pi_m](h) = \sum_{\pi \le \pi_m} \mathbb{V}[\pi](h) \mu(\pi,\pi_m) = \sum_{\pi \in \Pi_{m}} \mu_{\pi} \mathbb{V}[\pi](h) .
$$
这样$U$拆$V$的公式我们就给出了一个确切的公式，当$\pi = \{ \pi_1, \pi_2, \cdots, \pi_K\}$且$\pi_i$有$n_i$个指标时:
$$
\mu(\pi,\pi_m) = \mu_{\pi} = (-1)^{m - K} (n_1 -1)! (n_2 -1)! \cdots (n_K -1)!
$$
比如回到$m=3$的例子，
$$
\begin{aligned}
 \pi = \{\{1\},\{2\},\{3\}\}, \quad & \mu_{\pi} = (-1)^{3-3} (1 -1)! (1 -1)! (1 -1)! = + 1\\
 \pi = \{\{1,2\},\{3\}\}, \quad  &\mu_{\pi} = (-1)^{3-2} (2 -1)! (1 -1)! = - 1\\
 \pi = \{\{1,3\},\{2\}\},\quad   &\mu_{\pi} = (-1)^{3-2} (2 -1)! (1 -1)! = - 1\\
  \pi = \{\{2,3\},\{1\}\}, \quad  &\mu_{\pi} = (-1)^{3-2} (2 -1)! (1 -1)! = - 1\\
   \pi = \{\{1,2,3\}\}, \quad  & \mu_{\pi} = (-1)^{3-1} (3 -1)!  = + 2\\
\end{aligned}
$$