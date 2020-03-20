# Fish

# TO DO LIST ----------------
# mkfish



#' Create a dataset of fish information.
#'
#' @param n.pops Numeric. The number of tows to complete (or fish populations to simulate)
#' @param n.fish Numeric. Tumber of fish to place in the path of the gear for each population.
#' @param width.path Numeric. The width of the path of the gear (in cm).
#' @param mean.angle Numeric. The mean escape angle (radians).
#' @param sd.angle Numeric. The standard deviation of the escape angle.
#' @param mean.fishvel Numeric. The mean fish swimming velocity (cm/sec).
#' @param sd.fishvel Numeric. The standard deviation of fish swimming velocity.
#' @return
#' A data.frame with one row for each fish and columns
#' width.path = width of the gear/net in cm,
#' pop = a population of fish for each tow of the net,
#' distance = distance in cm from edge of net,
#' angle = angle in radians
#' @examples
#' mkfish(n.pops = 1, n.fish = 100, width.path = 100)
mkfish <- function(n.pops, n.fish, width.path,
                   mean.angle = 1.32296, sd.angle = 0.5555139,
                   mean.fishvel = 27.6, sd.fishvel = 5.1){
  #
  #  Returns a data.frame with one row for each fish
  #  width.path = width of the gear/net in cm
  #  pop = a population of fish for each tow of the net
  #  distance = distance in cm from edge of net = random uniform
  #  angle = angle in radians = WRAPPED NORMAL DISTRIBUTION;
  #    mu = (165.8-90)*(pi/180); adjust for rotation between Meager and the simulation
  #    Meager et al 2006: Escape trajectory mean=165.8*, SE=3.7*, n=74; sigma2=1013.06
  fish <- data.frame(pop = rep(1:n.pops, each=n.fish),
                     distance = runif(n.fish*n.pops, min = 0, max = width.path),
                     #angle = runif(n.fish*n.pops, min=0, max=2*pi), #uniform, full circle
                     angle = rwrpnorm(n = n.fish*n.pops,
                                      mu = mean.angle,
                                      sd = sd.angle),
                     fish.vel = rnorm(n.fish*n.pops, m = mean.fishvel, sd = sd.fishvel),
                     fish.id = rep(1:n.fish, n.pops))
  return(fish)
}
