# Calculations

# TO DO LIST
# escfish
#  * make swimming failures adjustable
#  * remove extra comments re: swimming failures


#' Calculates which fish escape the net.
#'
#' @param fish A data.frame of fish information, created by mkfish
#' @param pop A data.frame of tow information, created by mktow
#' @return Returns the original fish data.frame with new columns for
#' pop values, fish position, and caught status
#' @examples
#' escfish(fish3, tow3)
escfish <- function(fish, pop){
  fish2 <- merge(fish, pop,
                 by = "pop",
                 all.x = TRUE)

  # How long does it take the net to travel to where the fish escaped (dx+secchi)?
  net.time <- (fish2$secchi + fish2$dx)/fish2$net.vel

  # Does the net get to the fish before the fish gets out? ####
  time.diff <- net.time - fish2$esc.time
  fish2$caught <- as.numeric(time.diff < 0) # TRUE = caught

  #Adjust for swimming failures:
  # 60% successfully swim, 40% fail to swim.
  #  binomial w/ p=0.4 --> 0 if fish swim, 1 if they don't.
  #  if they fail to swim, they get caught (caught)
  #  add catches from swimming failure to catches from slowness
  #  change that to a binomial: if caught = 1 or 2, it's 1; if caught = 0, it stays a 0.
  fish2$caught <- fish2$caught + rbinom(n = length(fish2$caught), size = 1, prob = 0.4)
  fish2$caught <- as.numeric(fish2$caught > 0)
  fish2$escaped <- as.numeric(fish2$caught == 0)
  fish2 <- cbind(fish2, net.time, time.diff)

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
