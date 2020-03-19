# Tows

# TO DO LIST ----------------
# vel
# * make vel adjustable - values are currently specific to FMWT
# *

#' Convenience function that calculates tow velocity from volume data.
#'
#' @param x Numeric. A tow volume (in units?).
#' @return A tow velocity, assuming a 12-minute tow for the IEP FMWT net dimensions.
#' @examples
#' vel(100)
vel<-function(x) {
  x*100/(10.704*720)
  }

#' Creates a dataset of tow information.
#'
#' @param n.pops Numeric. The number of tows to complete (or fish populations to simulate)
#' @param net.vel Numeric. The velocity of the gear moving through the water.
#' @param n.fish Numeric. Tumber of fish to place in the path of the gear for each population.
#' @param secchi Numeric. A Secchi depth (cm) or the reaction distance of the fish.
#' @return A data.frame with one row for each population or tow. Columns
#' n.pops = number of tows to complete (or fish populations to simulate)
#' net.vel = velocity for the tows; constant
#' n.fish = number of fish to place in the path of the gear
#' secchi = secchi depth or reaction distance in cm

mktow <- function(n.pops, net.vel, n.fish, secchi){
  pop <- data.frame(pop = 1:n.pops,
                    secchi = secchi,
                    net.vel = net.vel,
                    n.fish = n.fish)
  return(pop)
}

