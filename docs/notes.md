# Error-Correcting Code

SEC = single error code.

HD between 2 $n$ bit $w_1,w_2$ = number of bit they differ, so $0 \le HD(w_1,w_2) \le n$.

min HD $= D$.

$S$ = set of codeword.

BSC = input ${1,0}^n$ output ${1,0}^n$, prob 1 bit flipped wrong is $p$, independent.

**Theorem 5.1:** A code with min HD $D$ can **DETECT** any pattern of $D-1$ or fewer error. $\exists$ 1 error pattern with $D$ errors that cant be **DETECT** reliably.

We can embed $w_1$ to a bigger space, s.t. $D$ is atleast 1 more than number of errors.

Let's limit element in $S$ s.t. $HD(w_i,w_j) \ge 2,\ i \ne j,\ w_i,w_j \in S$ (if $=1$, say if $w_1$ and $w_2$ as our code word differ by 1 bit and the error is that bit, yeah pretty cooked).

But $HD \ge 2$, ${00,11}$ kinda cooked, so we have to move to bigger space.

Suppose $HD \ge 3$. Let $E_x$ be set of string s.t. differ from $x$ in 1 bit, ex:

$$
E_{000} = \{100,010,001\}
$$

$HD(w_i,x)=1,\ x\in E_{w_i}$.

Now nothing is inside both $E_{w_i}$ and $E_{w_j}$. Suppose $w_k$ exist, and $HD(w_i,w_k)=HD(w_j,w_k)=1$, this imply $HD(w_i,w_j)\le2$, so doesnt exist.

now fix data is easy, 2-1 means `111`, 1 one means `000`, else simple.

**Theorem 5.2:** HD obey triangle ineq.

$$
HD(x,y)+HD(y,z)\ge HD(x,z)
$$

**Theorem 5.3:** if $p\le\frac12$, the best decode strategy is to map received word to the code word with smallest HD, tie = arbitrary.

**Theorem 5.4:** A code with HD $D$ can **CORRECT** code that has

$$
\left\lfloor\frac{D-1}{2}\right\rfloor
$$

error. higher cant reliably.

The check for the nearest codeword is exponential in bit (duh).

To transmit 4 bit, we need to find set of string in $S = 2^4$ s.t. all of them has $HD \ge 3$ (SEC) as the codeword, size $2^n$ for a bijective mapping.

Exhaustive search give $n=7$, and the set were: (yeah not too keen on writing that)

There are 2 class of way to construct $S$, which are algebraic and graphical code (cba). Now study linear block code, subclass of algebraic: rectangular parity and hamming code.

## Linear Block Code

take $k$ bit message and output set of $2^k$ codeword, each $n$ bit long ($n\ge k$). Block cause can break long code into $k$-bit long block, which then is expanded to $n$-bit code word and sent. such are called $(n,k)$, $n-k$ redundancy. often use $(n,k,d)$, with $d$ as HD of the block code. The rate of block is $k/n$, with more $n$ mean more redun, yeah duh.

linear code = produce code using linear func.

BLC: use arithmetic mod 2, called galois field order 2, $\mathbb F_2$. add and mul simple (no carry over). add inverse of 0 is 0, of 1 is 1. mul inverse of 0 $\not\exists$, mul inverse of 1 is 1. May reference Reed Solomon later (over $2^q$).

**Theorem 5.5:** code linear $\Longleftrightarrow$ sum of 2 codeword is another codeword.

$$
f(a)+f(b)=f(a+b)
$$

sounds duh af.

**Corollary:** $0^n$ is always in codeword, since for any codeword $x$,

$$
x+x=0^n
$$

**Theorem 5.6:** weight of codeword as num of 1. min HD = min weight (dif to $0^n$).

More proper: property of HD:

$$
HD(w_1,w_2)=\operatorname{wt}(w_1+w_2)
$$

same len, since $0+1$ and $1+0$ produce 1 only. since $w_1+w_2$ = cw, min weight = min HD.

Def parity

$$
\operatorname{pari}(x_1,\ldots,x_n)
=
\left(\sum_{i=1}^{n} x_i\right)\bmod 2
$$

same as XOR $n$ bit. even = even num of 1, odd otherwise.

Let $M$ be word,

$$
w = M \mathbin{\|} \operatorname{pari}(M)
$$

where $|$ = concat. $\operatorname{pari}(w)=0$ ($1+1=0+0$). this is called even parity code. Can **DETECT** cause ${w_i}$ has HD 2 min (dif by 1 bit in $M$ and the last parity bit is min, if dif by more then job good). Let $r$ be recieved word, compute $\operatorname{pari}(r)$ to detect 1 bit error ($\operatorname{pari}(r)=1$ = 1 bit error, called parity error). Job = construct ${w}$.

Suppose we want to sent $M$, $k$ bit. shape into $r$ row and $c$ col, $k=rc$. each bit inhabit cell (maybe mat even) $d_{ij}$. $R$ array $\operatorname{pari}_{row}(i)$, $C$ same def for col.

$$
w = M \mathbin{\|} R \mathbin{\|} C
$$

len $=rc+r+c$. this code is linear cause all the parity bit are linear func (verified by linear func prop). rate:

$$
\frac{rc}{rc+r+c}
$$

### Proof of SEC

consider $M_i,M_j$. if $HD(M_i,M_j)=1$, row and col will give diff val, by exactly 1 (the miss placed bit at $(i,j)$ make row $i$ and col $j$ parity diff). so diff total $=3$ which min HD $=3$ (and can even **CORRECT**).

if 2 differing bits are in same row, row parity same but 2 col parity dif, so total HD $=4$. if same col then pari col same but 2 pari row diff, also HD $=4$. else 2 col + 2 row parity dif, so HD even bigger.

else $HD\ge3$ by default.

### Decode

upon recieve $w$, check parity for every row together with its row parity bit, and every col together with its col parity bit.

if all row/col check $=0$, just use first $rc$ bit.

if there is 1 row and 1 col error, flip that bit at $(i,j)$ and use as it.

if there is 1 bad row and no bad col, error is in that row parity bit, so data is already good. similarly 1 bad col and no bad row means error is in that col parity bit.

otherwise, just detected, cant reliably **CORRECT** (As theorem 5.4, and if you think more than one sec that there is no bijective func).

The number of parity grow as fast as $O(\sqrt{k})$, smallest parity number when $r=c$, i will take for granted, cba.
