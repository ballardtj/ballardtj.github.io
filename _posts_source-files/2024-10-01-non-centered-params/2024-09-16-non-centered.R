# Load required libraries
library(cmdstanr)
library(posterior)
library(bayesplot)
library(tidyverse)
library(truncnorm)

# Set random seed for reproducibility
set.seed(123)

# Simulate data
N <- 2500  # Total number of observations
J <- 500    # Number of participants
n_j <- N / J  # Number of observations per participant

# Generate participant IDs and predictor variables
participant_id <- rep(1:J, each = n_j)
X1 <- rnorm(N, mean = 0, sd = 1)
X2 <- rnorm(N, mean = 0, sd = 1)

# Population parameter values
beta0_mean <- 2.5   # Intercept population mean
beta1_mean <- 1.5   # Effect of X1 population mean
beta2_mean <- -0.2  # Effect of X2 population mean
beta0_sd <- 1.5     # Intercept population SD
beta1_sd <- 1.3     # Effect of X1  population SD
beta2_sd <- 0.7     # Effect of X2 population SD
sigma_mean <- 0.7   # Residual mean
sigma_sd <- 0.3     # Residual SD

# Simulate variability in parameters across participants
beta0 <- rnorm(n = J, mean = beta0_mean, sd = beta0_sd)
beta1 <- rnorm(n = J, mean = beta1_mean, sd = beta1_sd)
beta2 <- rnorm(n = J, mean = beta2_mean, sd = beta2_sd)
sigma <- rtruncnorm(n = J, a = 0, b = Inf, mean = sigma_mean, sd = sigma_sd)

# Generate response variable
Y <- rep(beta0, each = n_j) + 
  rep(beta1, each = n_j) * X1 + 
  rep(beta2, each = n_j) * X2 + 
  rnorm(N, mean = 0, sd = rep(sigma, each = n_j))

# Prepare data for Stan
stan_data <- list(
  N = N,
  J = J,
  X1 = X1,
  X2 = X2,
  Y = Y,
  participant_id = participant_id
)

########### ORIGINAL MODEL ############


# Define Stan model
stan_model <- "
data {
  int<lower=0> N;               // Number of observations
  int<lower=0> J;               // Number of participants
  vector[N] X1;                 // Predictor 1
  vector[N] X2;                 // Predictor 2
  vector[N] Y;                  // Response variable
  array[N] int participant_id;  // Participant IDs
}

parameters {
  real beta0_mean;            // Intercept population mean
  real beta1_mean;            // Effect of X1 population mean
  real beta2_mean;            // Effect of X2 population mean
  real<lower=0> beta0_sd;     // Intercept population SD
  real<lower=0> beta1_sd;     // Effect of X1 population SD
  real<lower=0> beta2_sd;     // Effect of X2 population SD
  real<lower=0> sigma_mean;   // Residual mean
  real<lower=0> sigma_sd;     // Residual SD
  vector[J] beta0;            // Participant intercepts
  vector[J] beta1;            // Participant X1 effects
  vector[J] beta2;            // Participant X2 effects
  vector<lower=0>[J] sigma;   // Participant residuals
}

model {
  // Population-level Priors
  beta0_mean ~ normal(0, 5);
  beta1_mean ~ normal(0, 5);
  beta2_mean ~ normal(0, 5);
  beta0_sd ~ normal(0, 2.5);
  beta1_sd ~ normal(0, 2.5);
  beta2_sd ~ normal(0, 2.5);
  sigma_mean ~ normal(0, 2.5);
  sigma_sd ~ normal(0, 2.5);
  
  // Participant-level Priors
  beta0 ~ normal(beta0_mean,beta0_sd);
  beta1 ~ normal(beta1_mean,beta1_sd);
  beta2 ~ normal(beta2_mean,beta2_sd);
  sigma ~ normal(sigma_mean,sigma_sd);
  
  // Likelihood
  Y ~ normal(beta0[participant_id] + beta1[participant_id] .* X1 + beta2[participant_id] .* X2, sigma[participant_id]);
}
"

# Compile the model
mod <- cmdstan_model(write_stan_file(stan_model))

# Fit the model
fit <- mod$sample(
  data = stan_data,
  seed = 123,
  chains = 4,
  parallel_chains = 4,
  refresh = 1000
)

# Print summary of the posterior distributions
print(fit$summary())

# Plot traces and posterior distributions
mcmc_trace(fit$draws(c("beta0_mean", "beta1_mean","beta2_mean", "beta0_sd", "beta1_sd","beta2_sd","sigma_mean","sigma_sd")))

mcmc_pairs(fit$draws(c("beta0_mean", "beta1_mean","beta2_mean", "beta0_sd", "beta1_sd","beta2_sd","sigma_mean","sigma_sd")))

mcmc_dens_overlay(fit$draws(c("beta0_mean", "slope_mean", "beta0_sd", "slope_sd", "sigma")))

########### NON-CENTERED MODEL ############


# Define Stan model
stan_model_nc <- "
data {
  int<lower=0> N;               // Number of observations
  int<lower=0> J;               // Number of participants
  vector[N] X1;                 // Predictor 1
  vector[N] X2;                 // Predictor 2
  vector[N] Y;                  // Response variable
  array[N] int participant_id;  // Participant IDs
}

parameters {
  real beta0_mean;            // Intercept population mean
  real beta1_mean;            // Effect of X1 population mean
  real beta2_mean;            // Effect of X2 population mean
  real<lower=0> beta0_sd;     // Intercept population SD
  real<lower=0> beta1_sd;     // Effect of X1 population SD
  real<lower=0> beta2_sd;     // Effect of X2 population SD
  real<lower=0> sigma_mean;   // Residual mean
  real<lower=0> sigma_sd;     // Residual SD
  vector[J] beta0_z;          // Participant intercepts (z-score)
  vector[J] beta1_z;          // Participant X1 effects (z-score)
  vector[J] beta2_z;          // Participant X2 effects (z-score)
  vector<lower=0>[J] sigma;   // Participant residuals
}

transformed parameters {
  vector[J] beta0 = beta0_mean + beta0_sd * beta0_z;
  vector[J] beta1 = beta1_mean + beta1_sd * beta1_z;
  vector[J] beta2 = beta2_mean + beta2_sd * beta2_z;
}

model {
  // Population-level Priors
  beta0_mean ~ normal(0, 5);
  beta1_mean ~ normal(0, 5);
  beta2_mean ~ normal(0, 5);
  beta0_sd ~ normal(0, 2.5);
  beta1_sd ~ normal(0, 2.5);
  beta2_sd ~ normal(0, 2.5);
  sigma_mean ~ normal(0, 2.5);
  sigma_sd ~ normal(0, 2.5);
  
  // Participant-level Priors
  beta0 ~ std_normal();
  beta1 ~ std_normal();
  beta2 ~ std_normal();
  sigma ~ normal(sigma_mean,sigma_sd);
  
  // Likelihood
  Y ~ normal(beta0[participant_id] + beta1[participant_id] .* X1 + beta2[participant_id] .* X2, sigma[participant_id]);
}
"

# Compile the model
mod_nc <- cmdstan_model(write_stan_file(stan_model_nc))

# Fit the model
fit_nc <- mod_nc$sample(
  data = stan_data,
  seed = 123,
  chains = 4,
  parallel_chains = 4
)

# Print summary of the posterior distributions
print(fit_nc$summary())

mcmc_trace(fit_nc$draws(c("beta0_mean", "slope_mean", "beta0_sd", "slope_sd", "sigma")))
mcmc_dens_overlay(fit_nc$draws(c("beta0_mean", "slope_mean", "beta0_sd", "slope_sd", "sigma")))


##### SIGMA DEMO'S #####

n = 10000                  #number of samples
sigma_mean = rnorm(n)      #sample sigma mean
sigma_sd = rtruncnorm(n)   #sample sigma sd
sigma_z = rnorm(n)
sigma = exp(sigma_mean + sigma_sd * sigma_z)
hist(sigma)



########### NON-CENTERED SIGMA MODEL ############


# Define Stan model
stan_model_ncs <- "
data {
  int<lower=0> N;               // Number of observations
  int<lower=0> J;               // Number of participants
  vector[N] X1;                 // Predictor 1
  vector[N] X2;                 // Predictor 2
  vector[N] Y;                  // Response variable
  array[N] int participant_id;  // Participant IDs
}

parameters {
  real beta0_mean;            // Intercept population mean
  real beta1_mean;            // Effect of X1 population mean
  real beta2_mean;            // Effect of X2 population mean
  real<lower=0> beta0_sd;     // Intercept population SD
  real<lower=0> beta1_sd;     // Effect of X1 population SD
  real<lower=0> beta2_sd;     // Effect of X2 population SD
  real sigma_mean;            // Residual mean (before transformation)
  real<lower=0> sigma_sd;     // Residual SD (before transformation)
  vector[J] beta0_z;          // Participant intercepts (z-score)
  vector[J] beta1_z;          // Participant X1 effects (z-score)
  vector[J] beta2_z;          // Participant X2 effects (z-score)
  vector[J] sigma_z;          // Participant residuals (z-score, before transformation)
}

transformed parameters {
  vector[J] beta0 = beta0_mean + beta0_sd * beta0_z;
  vector[J] beta1 = beta1_mean + beta1_sd * beta1_z;
  vector[J] beta2 = beta2_mean + beta2_sd * beta2_z;
  vector[J] sigma = log1p_exp(sigma_mean + sigma_sd * sigma_z);
}

model {
  // Population-level Priors
  beta0_mean ~ normal(0, 5);
  beta1_mean ~ normal(0, 5);
  beta2_mean ~ normal(0, 5);
  beta0_sd ~ normal(0, 2.5);
  beta1_sd ~ normal(0, 2.5);
  beta2_sd ~ normal(0, 2.5);
  sigma_mean ~ normal(0, 2.5);
  sigma_sd ~ normal(0, 2.5);
  
  
  // Participant-level Priors
  beta0_z ~ std_normal();
  beta1_z ~ std_normal();
  beta2_z ~ std_normal();
  sigma_z ~ std_normal();
  
  // Likelihood
  Y ~ normal(beta0[participant_id] + beta1[participant_id] .* X1 + beta2[participant_id] .* X2, sigma[participant_id]);
}
"

# Compile the model
mod_ncs <- cmdstan_model(write_stan_file(stan_model_ncs))

# Fit the model
fit_ncs <- mod_ncs$sample(
  data = stan_data,
  seed = 123,
  chains = 4,
  parallel_chains = 4
)

# Print summary of the posterior distributions
print(fit_ncs$summary())

mcmc_trace(fit_ncs$draws(c("beta0_mean", "beta1_mean","beta2_mean", "beta0_sd", "beta1_sd","beta2_sd","sigma_mean","sigma_sd","lp__")))


############ SIMULATED DATA WITH CORRELATED INDIVIDUAL-SPECIFIC PARAMETERS ###########

# Set random seed for reproducibility
set.seed(123)

# Simulate data
N <- 10000  # Total number of observations
J <- 100    # Number of participants
n_j <- N / J  # Number of observations per participant

# Generate participant IDs and predictor variables
participant_id <- rep(1:J, each = n_j)
X1 <- rnorm(N, mean = 0, sd = 1)
X2 <- rnorm(N, mean = 0, sd = 1)

# Population parameter values
beta0_mean <- 2.5   # Intercept population mean
beta1_mean <- 1.5   # Effect of X1 population mean
beta2_mean <- -0.2  # Effect of X2 population mean
beta0_sd <- 1.5     # Intercept population SD
beta1_sd <- 1.3     # Effect of X1  population SD
beta2_sd <- 0.7     # Effect of X2 population SD
sigma_mean <- 0.7   # Residual mean
sigma_sd <- 0.3     # Residual SD
Rho <- matrix(c(1,0.5,-0.45,
                0.5,1,0.3,
               -0.45,0.3,1),nrow=3,byrow=3) #Correlation matrix of random effects

#Diagonal matrix of population standard deviations
D <- diag(c(beta0_sd,beta1_sd,beta2_sd)) 

#Population covariance matrix
Sigma = D %*% Rho %*% D

#Vector of population means
Mu = c(beta0_mean,beta1_mean,beta2_mean)

# Generate correlated participant-specific parameters
theta <- MASS::mvrnorm(J, Mu, Sigma)

# Check correlation
cor(theta)

# Calculate participant-specific beta0s and slopes
beta0 <- theta[,1]
beta1 <- theta[,2]
beta2 <- theta[,3]

# Simulate variability in sigma
sigma <- rtruncnorm(n = N, a = 0, b = Inf, mean = sigma_mean, sd = sigma_sd)

# Generate response variable
Y <- rep(beta0, each = n_j) + 
  rep(beta1, each = n_j) * X1 + 
  rep(beta2, each = n_j) * X2 + 
  rnorm(N, mean = 0, sd = rep(sigma, each = n_j))

#Y_prob = 1/(1+exp(-Y_logit))

#Y <- rbinom(n=N,size=1,prob=Y_prob)

# Prepare data for Stan
stan_data <- list(
  N = N,
  J = J,
  X1 = X1,
  X2 = X2,
  Y = Y,
  participant_id = participant_id
)

######### CENTRED VERSION WITH COVARIANCE DIRECTLY ESTIMATED ######

stan_model_mvc <- "
data {
  int<lower=0> N;  // Number of observations
  int<lower=0> J;  // Number of participants
  vector[N] X1;    // First predictor variable
  vector[N] X2;    // Second predictor variable
  vector[N] Y;     // Response variable
  array[N] int<lower=1, upper=J> participant_id;  // Participant IDs
}

parameters {
  vector[3] population_means;         // Population means for [beta0, beta1, beta2]
  cov_matrix[3] population_cov;       // Covariance matrix
  array[J] vector[3] theta;  // individual-level parameter estimates
  real<lower=0> sigma_mean;  // Mean of residual SD
  real<lower=0> sigma_sd;    // SD of residual SD
  vector<lower=0>[J] sigma_z;  // Participant-specific residual SDs
}

transformed parameters {
  vector[J] sigma = log1p_exp(sigma_mean + sigma_sd * sigma_z);
  vector[J] beta0 = to_vector(theta[,1]);
  vector[J] beta1 = to_vector(theta[,2]);
  vector[J] beta2 = to_vector(theta[,3]);
}

model {
  // Population-level priors
  population_means ~ normal(0, 5);
  population_cov ~ inv_wishart(4,identity_matrix(3)) ;
  sigma_mean ~ normal(0, 2.5);
  sigma_sd ~ normal(0, 2.5);
  
  // Participant-level priors
  theta ~ multi_normal(population_means, population_cov);
  sigma_z ~ std_normal();
  
  // Likelihood
  Y ~ normal(beta0[participant_id] + beta1[participant_id] .* X1 + beta2[participant_id] .* X2, sigma[participant_id]);
}
generated quantities {
  //Convert population covariance matrix to population correlation matrix
  vector[3] population_sds = sqrt(diagonal(population_cov)); //extract variances and convert to SDs

  //The code below equates to: diag_matrix(population_sds)^-1 *  population_cov * diag_matrix(population_sds)^-1
  corr_matrix[3] population_corr = mdivide_right_spd(mdivide_left_spd(diag_matrix(population_sds),population_cov),diag_matrix(population_sds));
}
"

# Compile the model
mod_mvc <- cmdstan_model(write_stan_file(stan_model_mvc))

# Fit the model
fit_mvc <- mod_mvc$sample(
  data = stan_data,
  seed = 123,
  chains = 4,
  parallel_chains = 4
)

# Print summary of the posterior distributions
print(fit_mvc$summary(variables=c("population_means","population_sds","population_corr","lp__")),n=20)


########## CENTRED VERSION  ######

stan_model_mv <- "
data {
  int<lower=0> N;  // Number of observations
  int<lower=0> J;  // Number of participants
  vector[N] X1;    // First predictor variable
  vector[N] X2;    // Second predictor variable
  vector[N] Y;     // Response variable
  array[N] int<lower=1, upper=J> participant_id;  // Participant IDs
}

parameters {
  vector[3] population_means;  // Population means for [beta0, beta1, beta2]
  vector<lower=0>[3] population_sds;  // Population SDs for [beta0, beta1, beta2]
  corr_matrix[3] population_corr;  // Correlation matrix
  array[J] vector[3] theta;  // individual-level parameter estimates
  real<lower=0> sigma_mean;  // Mean of residual SD
  real<lower=0> sigma_sd;    // SD of residual SD
  vector<lower=0>[J] sigma_z;  // Participant-specific residual SDs
}

transformed parameters {
  vector[J] sigma = log1p_exp(sigma_mean + sigma_sd * sigma_z);
  vector[J] beta0 = to_vector(theta[,1]);
  vector[J] beta1 = to_vector(theta[,2]);
  vector[J] beta2 = to_vector(theta[,3]);
}

model {
  // Population-level priors
  population_means ~ normal(0, 5);
  population_sds ~ normal(0, 2.5);
  population_corr ~ lkj_corr(1);
  
  sigma_mean ~ normal(0, 2.5);
  sigma_sd ~ normal(0, 2.5);
  
  // Participant-level priors
  theta ~ multi_normal(population_means, quad_form_diag(population_corr, population_sds));
  sigma_z ~ std_normal();
  
  // Likelihood
  Y ~ normal(beta0[participant_id] + beta1[participant_id] .* X1 + beta2[participant_id] .* X2, sigma[participant_id]);
}"

# Compile the model
mod_mv <- cmdstan_model(write_stan_file(stan_model_mv))

# Fit the model
fit_mv <- mod_mv$sample(
  data = stan_data,
  seed = 123,
  chains = 4,
  parallel_chains = 4
)

# Print summary of the posterior distributions
print(fit_mv$summary(variables=c("population_means","population_sds","population_corr","lp__")),n=20)

#mcmc_trace(fit_mv$draws(c("beta0_mean", "beta1_mean","beta2_mean", "beta0_sd", "beta1_sd","beta2_sd","sigma_mean","sigma_sd")))


########## NONCENTRED VERSION ######

stan_model_mvnc <- "
data {
  int<lower=0> N;               // Number of observations
  int<lower=0> J;               // Number of participants
  vector[N] X1;                 // Predictor 1
  vector[N] X2;                 // Predictor 2
  vector[N] Y;                  // Response variable
  array[N] int participant_id;  // Participant IDs
}

parameters {
  vector[3] population_means;                     // Population means for beta0, beta1, beta2
  vector<lower=0>[3] population_sds;              // Population SDs for beta0, beta1, beta2
  cholesky_factor_corr[3] L_population_corr;      // Cholesky factor of correlation matrix for beta0, beta1, and beta2
  matrix[J,3] theta_z;                            // Individual-level beta0, beta1, and beta2 estimates (z-score)
  real sigma_mean;                                // Residual population mean (before transformation)
  real<lower=0> sigma_sd;                         // Residual population SD (before transformation)
  vector[J] sigma_z;                              // Individual-level residuals (z-score, before transformation)
}

transformed parameters {
  vector[J] sigma = log1p_exp(sigma_mean + sigma_sd * sigma_z);
  matrix[3,3] L_population_cov = diag_pre_multiply(population_sds,L_population_corr);
  matrix[J,3] theta = rep_matrix(population_means',J) + theta_z * L_population_cov';
  vector[J] beta0;
  vector[J] beta1;
  vector[J] beta2;
  
  
  //for (j in 1:J) {
  //  theta[j,] = (population_means +  L_population_cov * theta_z[j,]')';
  //}
  
  beta0 = theta[,1];
  beta1 = theta[,2];
  beta2 = theta[,3];
}

model {
  // Population-level priors
  population_means ~ normal(0, 5);
  population_sds ~ normal(0, 2.5);
  L_population_corr ~ lkj_corr_cholesky(1);
  sigma_mean ~ normal(0, 2.5);
  sigma_sd ~ normal(0, 2.5);
  
  // Participant-level priors
  to_vector(theta_z) ~ std_normal();
  sigma_z ~ std_normal();
  
  // Likelihood
  Y ~ normal(beta0[participant_id] + beta1[participant_id] .* X1 + beta2[participant_id] .* X2, sigma[participant_id]);
}

generated quantities {
  //Compute population correlation matrix from its cholesky factor
  corr_matrix[3] population_corr = multiply_lower_tri_self_transpose(L_population_corr);
}
"

# Compile the model
mod_mvnc <- cmdstan_model(write_stan_file(stan_model_mvnc))

# Fit the model
fit_mvnc <- mod_mvnc$sample(
  data = stan_data,
  seed = 123,
  chains = 4,
  parallel_chains = 4
)

# Print summary of the posterior distributions
print(fit_mvc$summary(variables=c("population_means","population_sds","population_corr","lp__")),n=20)
print(fit_mv$summary(variables=c("population_means","population_sds","population_corr","lp__")),n=20)
print(fit_mvnc$summary(variables=c("population_means","population_sds","population_corr","lp__")),n=20)

mcmc_trace(fit_mv$draws(c("population_means","population_sds","sigma_mean","sigma_sd","population_corr")))

mcmc_trace(fit_mvnc$draws(c("population_means","population_sds","sigma_mean","sigma_sd","population_corr")))


mcmc_pairs(fit_mv$draws(c("population_means","population_sds","sigma_mean","sigma_sd","population_corr")))
mcmc_pairs(fit_mvnc$draws(c("population_means","population_sds","sigma_mean","sigma_sd","population_corr")))

mcmc_trace(fit_mvnc$draws(variables=paste0("theta_z[",1:10,",1]")))

mcmc_trace(fit_mv$draws(c()))


