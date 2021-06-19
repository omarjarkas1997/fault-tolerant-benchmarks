fault-tolerant-benchmarks
=========================

A few fault-tolerant distributed algorithms encoded in parametric Promela.
The modeling decisions are illustrated in our
[Spin'13 paper](http://forsyte.at/wp-content/uploads/spin13.pdf), where we
checked the benchmarks with [Spin](http://spinroot.com):

    Annu John, Igor Konnov, Ulrich Schmid, Helmut Veith, Josef Widder.
    Towards Modeling and Model Checking Fault-Tolerant Distributed Algorithms.
    SPIN, volume 7976 of LNCS, pages 209-226, 2013.

A more detailed exposition can be found in the [SFM'14
tutorial](http://forsyte.at/download/GKSVW14.pdf).
A recent overview of the techniques is available at
[PSI'15](http://forsyte.at/download/kvw-psi15.pdf).

After SPIN'13 we collected new benchmarks and extended them for parameterized
model checking with [NuSMV](http://nusmv.fbk.eu/) and
[FAST](http://www.lsv.ens-cachan.fr/Software/fast/). The benchmarks are using
symbolic expressions like ```assume(...)``` that cannot be directly translated
into standard [Promela](http://spinroot.com/spin/Man/promela.html).  We used the
benchmarks to evaluate the techniques presented at
[SPIN'13](http://forsyte.at/wp-content/uploads/spin13.pdf),
[FMCAD'13](http://www.cs.utexas.edu/users/hunt/FMCAD/FMCAD13/papers/10-Model-Checking-Fault-Tolerant-Distributed-Algo.pdf),
[CONCUR'14](http://forsyte.at/wp-content/uploads/concur14-reachability.pdf),
[CAV'15](http://forsyte.at/download/konnov-cav15.pdf),
[POPL'17](http://forsyte.at/wp-content/uploads/popl17main-main116-p-9d29769-29971-final.pdf),
and [FMSD'17](https://link.springer.com/article/10.1007/s10703-017-0297-4).

Feel free to use the benchmarks, as long as you are citing us :-)

You can generate standard (non-parameterized) Promela code using our
tool [ByMC](http://forsyte.tuwien.ac.at/software/bymc)

Directory [spin13](./spin13) contains both parameterized benchmarks and
fixed-size benchmarks in standard Promela.

If you have any questions about the benchmarks, ask
[Igor Konnov](http://forsyte.at/people/konnov)

"# Fault-tolerant-Distributed-Algorithms" 
