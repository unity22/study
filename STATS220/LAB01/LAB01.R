#QUESTION1
x <- seq(200,400,2)
x

#QUESTION2
remainder <- x %% 3
remainder

#QUESTION3
x2 <- x[remainder == 0]
x2

#QUESTION4
n_x2 <- length(x2)
n_x2

#QUESTION5
mean <- mean(x2)
mean
sd <- sd(x2)
sd
two_sd <- 2 * sd
two_sd
num_2 <- two_sd + mean
num_2
num_3 <- mean - two_sd
num_3
rng_x <- c(num_3, num_2)
rng_x

