#NURUR RAHMAN
#Minimizing Portfolio Risk : Second-order Cone Programming Formulation
#
#
param NW := 470;    #Number of weeks
param T  := 469;    #Number of time zones (470-1)
param A  := 200;    #Number of securities 
param MA :=  12;    #Maximum Number of assets to be allocated
 


# Data Matrix 
param D{1..NW, 1..A}>= 0;

# Percent rate of return of 200 assets in each of 469 weeks 
param Return{t in 1..T, a in 1..A} := 100 * (D[t+1,a] - D[t,a])/D[t,a];

#Arithmetic mean of percent rate return of 200 assets 
param mu{a in 1..A} := (sum{t in 1..T}(Return[t,a]))/T;


# Covariance Matrix of 200 Assets
param q{t in 1..T, a in 1..A} := Return[t,a] - mu[a];
param Q{i in 1..A, j in 1..A} := (sum{t in 1..T}( q[t,i]*q[t,j]))/T;



# Decision Variables 
var W{1..A} >= 0;
var t       >= 0;
var Y{1..A} binary;



# Objective function 
minimize portfolioRisk : t; 



#### General Constraints 
# All available assets must be invested  
subject to portfolioBudget: sum{i in 1..A} W[i] = 1;

# Portfolio return must be at least 5% annually (0.0962% weekly)
subject to portfolioReturn: sum{i in 1..A} (mu[i]*W[i]) >= 0.0962;


#### SOC Constraint 
subject to socConstraint: t >=  sum{i in 1..A, j in 1..A} (Q[i,j]*W[i]*W[j]) ;


#### Cardinal Constraints
# The number of assets available for investment is at most 12
subject to cardinality1: sum{i in 1..A} Y[i] <= MA; 


# Maximum amount of one asset that can be used in the portfolio
# Any value larger the inverse of the number of available assets
subject to cradinality2 {i in 1..A}: W[i] <= 1.0*Y[i];


# Maximum amount of an asset that can be used in the portfolio
# Any value close to zero 
subject to cradinality3 {i in 1..A}: W[i] >= 0.0*Y[i];
