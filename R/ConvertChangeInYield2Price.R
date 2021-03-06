#' @title Convert change in yield-to-maturity to price for fixed-income securities
#'
#' @description Convert change in yield-to-maturity to price for fixed-income securities, as described in 
#' A. Meucci "Risk and Asset Allocation", Springer, 2005.
#'
#'  @param	Exp_DY         [vector] (N x 1) expected value of change in yield to maturity
#'	@param	Cov_DY         [matrix] (N x N) covariance of change in yield to maturity
#'  @param	Times2Mat      [scalar] time to maturity
#'  @param	CurrentPrices  [vector] (N x 1) current prices
#'  
#'  @return	Exp_Prices     [vector] (N x 1) expected prices
#'  @return	Cov_Prices     [matrix] (N x N) covariance of prices
#'
#' @references
#' A. Meucci - "Exercises in Advanced Risk and Portfolio Management" \url{http://symmys.com/node/170},
#' See Meucci's script for "ConvertChangeInYield2Price.m".
#'
#' A. Meucci - "Risk and Asset Allocation"-Springer (2005). See (6.77)-(6.79).
#'
#' @author Xavier Valls \email{flamejat@@gmail.com}
#' @export

ConvertChangeInYield2Price = function( Exp_DY, Cov_DY, Times2Mat, CurrentPrices )
{
	Mu    = log( CurrentPrices ) - Times2Mat * Exp_DY;
	Sigma = diag( Times2Mat ^ 2, length(Times2Mat) ) %*% Cov_DY;


	Exp_Prices = exp(Mu + (1/2) * diag( Sigma ));
	Cov_Prices = exp(Mu + (1/2) * diag( Sigma )) %*% t(exp(Mu + (1/2) * diag(Sigma))) * ( exp( Sigma ) - 1);

	return( list( Exp_Prices = Exp_Prices, Cov_Prices = Cov_Prices ) );
}