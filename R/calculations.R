# Calculations

# TO DO LIST
# escfish
#  * clairify the lables for d.prime, dx & check for propagation to other functions



#' Calculate the angle inside the triangle made by the fish's escape path,
#'    the line perpendicular to the net boundary, and the net boundary itself.
#'    This is necessary for escape time calculations.
#'
#'  @param anglevec A vector of angles in radians
#'  @return A vector of angles (in radians) relative to the escape path
#'  @exmaples
#'  adjustangle(3*pi/2)
adjustangle <- function(anglevec){
  angle <- anglevec
  #0:90* = 0 : pi/2
  angle.prime <- angle
  # 90*:180* = pi/2 : pi
  angle.prime[angle>pi/2 & angle<pi] <- pi - angle[angle>pi/2 & angle<pi]
  # 180*:270* = pi : 3pi/2
  angle.prime[angle>pi & angle<3*pi/2] <- angle[angle>pi & angle<3*pi/2] - pi
  # 270*:360 = 3pi/2 : 2pi
  angle.prime[angle>3*pi/2] <- 2*pi - angle[angle>3*pi/2]

  return(angle.prime)
}



#' Calculates which fish escape the net.
#'
#' @param fish A data.frame of fish information, created by mkfish
#' @param pop A data.frame of tow information, created by mktow
#' @param swim.fail Numeric [0, 1]. Proportion of fish that fail to swim.
#' @return Returns the original fish data.frame with new columns for
#' pop values, fish position, and caught status
#' @examples
#' escfish(fish3, tow3)
escfish <- function(fish, pop, swim.fail = 0.4){
  fish2 <- merge(fish, pop,
                 by = "pop",
                 all.x = TRUE)
  # calculate the angle inside the triangle made by the fish's escape path,
  #  the line perpendicular to the net boundary, and the net boundary itself
  fish2$angle.prime <- adjustangle(fish2$angle)

  # CALCULATE ACTUAL DISTANCE TRAVELED BY FISH:
  d.prime <- fish2$distance/as.numeric(cos(fish2$angle.prime))

  # CALCULATE ESCAPE TIME:
  # When does the fish cross the edge of the path of the net?
  #  t=0 is when the fish sees the net.
  #  esc.time = time (sec) it takes for a fish to swim out of the path of the net
  esc.time <- d.prime/fish2$fish.vel

  # CALCULATE ESCAPE BASED ON RELATIVE DISTANCE INSTEAD OF TIME
  # How far does the fish travel in the X direction (ie in relation to the net)?
  dx <- fish2$distance*as.numeric(tan(fish2$angle.prime))
  # fish that swim towards the net go in the negative direction:
  dx[which(fish2$angle>pi)] <- 0 - dx[which(fish2$angle>pi)]

  # How long does it take the net to travel to where the fish escaped (dx+rxn.dist)?
  net.time <- (fish2$rxn.dist + fish2$dx)/fish2$net.vel

  # Does the net get to the fish before the fish gets out? ####
  time.diff <- net.time - fish2$esc.time
  fish2$caught <- as.numeric(time.diff < 0) # TRUE = caught

  #Adjust for swimming failures:
  #  binomial w/ p=0.4 --> 0 if fish swim, 1 if they don't.
  #  if they fail to swim, they get caught (caught)
  #  add catches from swimming failure to catches from slowness
  #  change that to a binomial: if caught = 1 or 2, it's 1; if caught = 0, it stays a 0.
  fish2$caught <- fish2$caught + rbinom(n = length(fish2$caught), size = 1, prob = swim.fail)
  fish2$caught <- as.numeric(fish2$caught > 0)
  fish2$escaped <- as.numeric(fish2$caught == 0)
  fish2 <- cbind(fish2, net.time, time.diff, d.prime, dx, esc.time)

  return(fish2)
}





#' Summarizes the proportion of fish caught.
#' @param fish A data.frame of fish information, created by mkfish and modifed by escfish.
#' @param pop A data.frame of tow information, created by mktow.
#' @param n.fish Numeric. Tumber of fish to place in the path of the gear for each population.
#' @return Returns a data.frame of pop with catch and catch.p appended to it
#' @examples
#' escfish(fish3, tow3, n.fish = 1000)
sumcatch <- function(fish, pop, n.fish){
  catch <- summaryBy(caught ~ pop, data = fish, FUN = sum)[,2]
  catch.p <- catch/n.fish
  return(cbind(pop, catch, catch.p))
}
