#'This script script familiarizes the user with the evaluation of an estimator replicability, loss, error, bias and inefficiency
#', as described in A. Meucci, "Risk and Asset Allocation", Springer, 2005,  Chapter 4.
#'
#' @references
#' A. Meucci - "Exercises in Advanced Risk and Portfolio Management" \url{http://symmys.com/node/170},
#'
#' See Meucci's script for "S_Estimator.R"
#'
#' @author Xavier Valls \email{flamejat@@gmail.com}

##################################################################################################################
### Inputs
T     = 52; # number of observations in time series
Mu    = 0.1;
Sigma = 0.2;
    
##################################################################################################################
### Plain vanilla estimation
# unknown functional of the distribution to be estimated, in this case the expected value
G_fX = exp( Mu + 0.5 * Sigma^2 );
print( G_fX );

i_T = matrix( rlnorm( T, Mu, Sigma ), 1, T);  # series generated by "nature": do not know the distribution

G_Hat_1 = function(X) X[ , 1 ] * X[ ,3 ]; # estimator of unknown functional G_1=x(1)*x(3)
G_Hat_2 = function(X) apply( X, 1,mean);  # estimator of unknown functional G_1=sample mean

G1 = G_Hat_1( i_T );
G2 = G_Hat_2( i_T );
print( G1 );
print( G2 );

##################################################################################################################
### Replicability vs. "luck"
# unknown functional of the distribution to be estimated, in this case the expected value
G_fX = exp( Mu + 0.5 * Sigma^2 );

nSim = 10000;
I_T = matrix( rlnorm( nSim * T, Mu, Sigma ), nSim, T); # randomize series generated by "nature" to check replicability

G1 = G_Hat_1( I_T ); # estimator of unknown functional G_1=x(1)*x(3)
G2 = G_Hat_2( I_T ); # estimator of unknown functional G_2=sample mean

Loss_G1 = (G1 - G_fX)^2;
Loss_G2 = (G2 - G_fX)^2;

Err_G1 = sqrt(mean(Loss_G1));
Err_G2 = sqrt(mean(Loss_G2));

Bias_G1 = abs(mean(G1) - G_fX);
Bias_G2 = abs(mean(G2) - G_fX);

Ineff_G1 = sd( G1 );
Ineff_G2 = sd( G2 );

##################################################################################################################
### printlay results
dev.new()
NumBins = round( 10 * log( nSim ) );
par( mfrow = c(2,1) );
hist(G1, NumBins);
points(G_fX, 0, pch = 21, bg = "red", main = "estimator: x(1)*x(3)");
#set(h, 'markersize', 20, 'col', 'r');

hist(G2, NumBins);
points(G_fX, 0,  pch = 21, bg = "red", main = "estimator: sample mean" );
#set(h, 'markersize', 20, 'col', 'r');


# loss
dev.new();
par( mfrow = c(2,1) );
hist(Loss_G1, NumBins,  main = "estimator: x(1)*x(3)");

hist(Loss_G2, NumBins,  main = "estimator: sample mean" );


##################################################################################################################
### Stress test replicability
Mus = seq( 0, 0.7, 0.1 );

Err_G1sq   = NULL;
Err_G2sq   = NULL;
Bias_G1sq  = NULL;
Bias_G2sq  = NULL;
Ineff_G1sq = NULL;
Ineff_G2sq = NULL;

for( j in 1 : length(Mus) )
{
    Mu = Mus[ j ];

    # unknown functional of the distribution to be estimated, in this case the expected value
    G_fX = exp( Mu + 0.5 * Sigma^2);
    I_T = matrix( rlnorm( nSim * T, Mu, Sigma ), nSim, T);  # randomize series generated by "nature" to check replicability

    G1 = G_Hat_1(I_T);        # estimator of unknown functional G_1=x(1)*x(3)
    G2 = G_Hat_2(I_T);        # estimator of unknown functional G_2=sample mean

    Loss_G1 = ( G1 - G_fX )^2;
    Loss_G2 = ( G2 - G_fX )^2;

    Err_G1   = sqrt(mean(Loss_G1));
    Err_G2   = sqrt(mean(Loss_G2));
    Err_G1sq = cbind( Err_G1sq, Err_G1^2 ); ##ok<*AGROW> #store results
    Err_G2sq = cbind( Err_G2sq, Err_G2^2 );

    Bias_G1   = abs( mean( G1 )- G_fX );
    Bias_G2   = abs( mean( G2 )- G_fX );
    Bias_G1sq = cbind( Bias_G1sq, Bias_G1^2 ); #store results
    Bias_G2sq = cbind( Bias_G2sq, Bias_G2^2 );

    Ineff_G1   = sd(G1);
    Ineff_G2   = sd(G2);
    Ineff_G1sq = cbind(Ineff_G1sq, Ineff_G1^2); #store results
    Ineff_G2sq = cbind(Ineff_G2sq, Ineff_G2^2);

    dev.new();
    NumBins = round(10*log(nSim));
	par( mfrow = c(2,1) );
	
	hist(G1, NumBins);
	points(G_fX, 0, pch = 21, bg = "red", main = "estimator: x(1)*x(3)");
	
	hist(G2, NumBins);
	points(G_fX, 0,  pch = 21, bg = "red", main = "estimator: sample mean" );

}

dev.new();
par( mfrow = c(2,1) );

b = barplot(Bias_G1sq + Ineff_G1sq, col = "red", main = "stress-test of estimator: x(1)*x(3)");
barplot( Ineff_G1sq, col="blue", add = TRUE);
lines( b, Err_G1sq);
legend( "topleft", 1.9, c( "bias^2", "ineff^2", "error^2" ), col = c( "red","blue", "black" ),
     lty=1, lwd=c(5,5,1),bg = "gray90" );


b=barplot( Bias_G2sq + Ineff_G2sq , col = "red", main = "stress-test of estimator sample mean");
barplot( Ineff_G2sq, col="blue", add = TRUE);
lines(b, Err_G2sq);
legend( "topleft", 1.9, c( "bias^2", "ineff^2", "error^2" ), col = c( "red","blue", "black" ),
     lty=1, lwd=c(5,5,1),bg = "gray90" );
