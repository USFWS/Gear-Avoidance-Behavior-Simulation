# Calculations

# TO DO LIST
# escfish
#



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
escfish <- function(fish, pop, swim.fail = 0.4,
                    width.path, height.path = width.path){
  fish2 <- merge(fish, pop,
                 by = "pop",
                 all.x = TRUE)
  # calculate the angle inside the triangle made by the fish's escape path,
  #  the line perpendicular to the net boundary, and the net boundary itself
  fish2$angle.prime <- adjustangle(fish2$angle)

  # CALCULATE ACTUAL HORIZONTAL DISTANCE TRAVELED BY FISH:
  # swim.dist.horiz was formerly called "dist.prime" because it used angle.prime.
  fish2$swim.dist.horiz <- fish2$distance/as.numeric(cos(fish2$angle.prime))

  # CALCULATE ACTUAL PITCHED DISTANCE TRAVELED BY THE FISH
  swim.dist.pitch <- fish2$swim.dist.horiz/as.numeric(cos(abs(fish2$angle.pitch)))
  dist.vertical <- sqrt((swim.dist.pitch^2) - (fish2$swim.dist.horiz^2))
  # adjust adjacent leg of the triangle for calculations if the fish
  #     goes up or down in the water
  adj.dist <- fish2$height
  adj.dist[which(fish2$angle.pitch > 0)] <- height.path - fish2$height[which(fish2$angle.pitch > 0)]
  # adjust escape distance when the fish goes out the top or the bottom
  #      instead of the side of the net path
  swim.dist.pitch[which(dist.vertical > adj.dist)] <- adj.dist[which(dist.vertical > adj.dist)]/as.numeric(cos((pi/2) - abs(fish2$angle.pitch[which(dist.vertical > adj.dist)])))

  # rename the final swim distance to fit the rest of the code
  # !!! Consider making this something the user can select - do they want the horizontal plane
  #        or do they want the fish to be able to swim up and down?
  fish2$swim.dist <- swim.dist.pitch


  # CALCULATE ESCAPE TIME:
  # When does the fish cross the edge of the path of the net?
  #  t=0 is when the fish sees the net.
  #  esc.time = time (sec) it takes for a fish to swim out of the path of the net
  fish2$esc.time <- fish2$swim.dist/fish2$fish.vel

  # CALCULATE ESCAPE BASED ON RELATIVE DISTANCE INSTEAD OF TIME
  # How far does the fish travel in the X direction (ie in relation to the net)?
  # esc.dist2net was formerly called "dx"
  fish2$esc.dist2net <- fish2$distance*as.numeric(tan(fish2$angle.prime))
  # What if the fish goes out the top or the bottom of the net path?
  #  The distance the fish travels in the X direction will be shorter.
  fish2$esc.dist2net[which(dist.vertical > adj.dist)] <- tan((pi/2) - abs(fish2$angle.pitch[which(dist.vertical > adj.dist)])) * fish2$height[which(dist.vertical > adj.dist)]
  # fish that swim towards the net go in the negative direction:
  fish2$esc.dist2net[which(fish2$angle>pi)] <- 0 - fish2$esc.dist2net[which(fish2$angle>pi)]

  # How long does it take the net to travel to where the fish escaped
  #      (esc.dist2net+rxn.dist)?
  fish2$net.time <- (fish2$rxn.dist + fish2$esc.dist2net)/fish2$net.vel

  # Does the net get to the fish before the fish gets out? ####
  fish2$time.diff <- fish2$net.time - fish2$esc.time
  fish2$caught <- as.numeric(fish2$time.diff < 0) # TRUE = caught

  #Adjust for swimming failures:
  #  binomial w/ p=0.4 --> 0 if fish swim, 1 if they don't.
  #  if they fail to swim, they get caught (caught)
  #  add catches from swimming failure to catches from slowness
  #  change that to a binomial:
  #     if caught = 1 or 2, it's 1;
  #     if caught = 0, it stays a 0.
  fish2$caught <- fish2$caught + rbinom(n = length(fish2$caught),
                                        size = 1,
                                        prob = swim.fail)
  fish2$caught <- as.numeric(fish2$caught > 0)
  fish2$escaped <- as.numeric(fish2$caught == 0)
  # fish2 <- cbind(fish2, time.diff) # I put the vars inside fish2 to start

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
