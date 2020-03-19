# Fish

# TO DO LIST ----------------
# mkfish
# * make angle adjustable
# * make fish velocity (fish.vel) adjustable
# * finish list of parameters in roxygen comments


#' Create a dataset of fish information.
#'
#' @param n.pops Numeric. The number of tows to complete (or fish populations to simulate)
#' @param n.fish Numeric. Tumber of fish to place in the path of the gear for each population.
#' @param width.path Numeric. The width of the path of the gear (in cm).
#' @return
#' A data.frame with one row for each fish and columns
#' width.path = width of the gear/net in cm,
#' pop = a population of fish for each tow of the net,
#' distance = distance in cm from edge of net,
#' angle = angle in radians
#' @examples
#' mkfish(n.pops = 1, n.fish = 100, width.path = 100)
mkfish <- function(n.pops, n.fish, width.path){
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
                                      mu = 1.32296,
                                      sd = 0.5555139),
                     fish.vel = rnorm(n.fish*n.pops, m=27.6, sd=5.1),
                     fish.id = rep(1:n.fish, n.pops))
  # calculate the angle inside the triangle made by the fish's escape path,
  #  the line perpendicular to the net boundary, and the net boundary itself
  #0:90* = 0 : pi/2
  fish$angle.prime <- fish$angle
  # 90*:180* = pi/2 : pi
  fish$angle.prime[fish$angle>pi/2 &
                     fish$angle<pi] <- pi - fish$angle[fish$angle>pi/2 &
                                                         fish$angle<pi]
  # 180*:270* = pi : 3pi/2
  fish$angle.prime[fish$angle>pi &
                     fish$angle<3*pi/2] <- fish$angle[fish$angle>pi &
                                                        fish$angle<3*pi/2] - pi
  # 270*:360 = 3pi/2 : 2pi
  fish$angle.prime[fish$angle>3*pi/2] <- 2*pi - fish$angle[fish$angle>3*pi/2]

  # CALCULATE ACTUAL DISTANCE TRAVELED BY FISH:
  d.prime <- fish$distance/as.numeric(cos(fish$angle.prime))

  # CALCULATE ESCAPE TIME:
  # When does the fish cross the edge of the path of the net?
  #  t=0 is when the fish sees the net.
  #  esc.time = time (sec) it takes for a fish to swim out of the path of the net
  esc.time <- d.prime/fish$fish.vel

  # CALCULATE ESCAPE BASED ON RELATIVE DISTANCE INSTEAD OF TIME
  # How far does the fish travel in the X direction (ie in relation to the net)?
  dx <- fish$distance*as.numeric(tan(fish$angle.prime))
  # fish that swim towards the net go in the negative direction:
  dx[which(fish$angle>pi)] <- 0 - dx[which(fish$angle>pi)]

  #Wrap everything together
  fish <- cbind(fish, d.prime, dx, esc.time)

  return(fish)
}
