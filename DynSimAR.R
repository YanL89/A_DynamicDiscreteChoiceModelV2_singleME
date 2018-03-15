#' dynamic variable simulator
#' 
#' use stochastic diffusion process such as AR(1) to simulate dynamic varibles
#' 
#' @param x value of dynamic variable at time t-1
#' @param a slope
#' @param e constant
#' @param s standard deviation of white noise
#' @return value of dynamic variable at time t

dynSimAR = function(x,a,e,s){
  n = length(x)
  a*x + e + rnorm(n,0,s)
}