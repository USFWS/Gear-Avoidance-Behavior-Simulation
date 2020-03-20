# Examples

# Set Values ####
#  Fish
n.fish <- 1000  # number of fish in the path of each net tow #was 500
n.pops <- 1000   # number of populations to simulate # was 100
width.path = 365.8
#  Tows
secchi = round(runif(n.pops, 1, 450), 0) #round(runif(n.pops, 1, 1200), 0)
net.vel = runif(n.pops, 61.9, 84.5)
#c(rep(84.5, 333), rep(72.8, 333), rep(61.89, 334)) #, #72.8,#*0.75, #rnorm(n.pops, 72.8, 19.6), #net.vel,


# Create Data ####

fish3 <- mkfish(n.pops, n.fish, width.path)
tow3 <- mktow(n.pops, net.vel, n.fish, secchi)
fish4 <- escfish(fish3, tow3)
