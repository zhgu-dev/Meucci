\name{MaxRsqCS}
\alias{MaxRsqCS}
\title{Solve for G that maximises sample r-square of X*G'*B' with X under constraints A*G<=D
and Aeq*G=Deq}
\usage{
  MaxRsqCS(X, B, W, A = NULL, D = NULL, Aeq = NULL, Deq,
    lb = NULL, ub = NULL)
}
\arguments{
  \item{X}{: [matrix] (T x N)}

  \item{B}{: [matrix] (T x K)}

  \item{W}{: [matrix] (N x N)}

  \item{A}{: [matrix] linear inequality constraints}

  \item{D}{: [matrix]}

  \item{Aeq}{: [matrix] linear equality constraints}

  \item{Deq}{: [matrix]}

  \item{lb}{: [vector] lower bound}

  \item{ub}{: [vector] upper bound}
}
\value{
  G : [matrix] (N x K)
}
\description{
  Solve for G that maximises sample r-square of X*G'*B'
  with X under constraints A*G<=D and Aeq*G=Deq (A,D,
  Aeq,Deq conformable matrices),as described in A. Meucci,
  "Risk and Asset Allocation", Springer, 2005.
}
\note{
  Initial code by Tai-Ho Wang
}
\author{
  Xavier Valls \email{flamejat@gmail.com}
}
\references{
  A. Meucci - "Exercises in Advanced Risk and Portfolio
  Management" \url{http://symmys.com/node/170}. Used in "E
  123 - Cross-section factors: generalized cross-section
  industry factors".

  See Meucci's script for "MaxRsqCS.m"
}

