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
  # Define parameters:
  y <- fish2$distance
  z <- fish2$height
  turn <- fish2$angle.prime
  pitch <- fish2$angle.pitch
  # Parameters to calculate:
  # x = distance the fish travels relative to the movement direction of the net
  #     x > 0 ==> moving away from the net; x < 0 ==> moving toward the net
  # w = distance traveled by the fish (swimming distance to escape);
  #     also the hypotenuse of the triangle on the turned vertical plane
  # u = hypotenuse of the triangle on the horizontal plane
  # s = distance the fish travels in the vertical direction to the edge of the net

  # Assume fish escape out the side of the path of the net:
  # Calculate the sides of the triangle on the horizontal plane:
  u <- y * cos(turn)
  x <- y * tan(turn)
  # Calculate the sides of the triangle on the turned vertical plane:
  w <- u / sin(pitch)
  #s <- u / tan(pitch)

  # Assume the fish escapes out the bottom of the path of the net:
  wb <- z / cos(pitch)
  ub <- tan(pitch) / z
  xb <- ub * sin(turn)

  # Does the fish escape to the side or the bottom?
  side <- (u > y)

  fish2 <- cbind(fish2, x, w, side)
  # fish2$u[which(side == FALSE)] <- ub[which(side == FALSE)]
  fish2$x[which(side == FALSE)] <- xb[which(side == FALSE)]
  fish2$w[which(side == FALSE)] <- wb[which(side == FALSE)]
  names(fish2)[12:14] <- c("x.dist", "swim.dist", "side")

  # How long goes it take the fish to swim to safety?
  fish2$esc.time <- fish2$swim.dist / fish2$fish.vel

  # Where is the net when the fish escapes?
  fish2$net.pos <- fish2$esc.time * fish2$net.vel

  # The fish is caught if the net has moved past its escape position at the time when it reaches
  #   the edge of the path of the net
  fish2$caught <- as.numeric(fish2$net.pos > (fish2$rxn.dist + fish2$x.dist))

  return(fish2)
}
#
# test1 <- escfish2(fish3, tow3,
#                   width.path = width.path,
#                   height.path = width.path)
# names(test1)


