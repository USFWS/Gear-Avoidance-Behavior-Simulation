# Gear Avoidance Behavior Simulation (gabs)

<img src="/images/hex_blue.png" alt="hex sticker for gabs" width="200"/>

## Project Description
This is an R package (in development) that simulates a fish behavioral response to sampling gear that is similar to a response to predators. The purpose of this project is to investigate the effect of individual behavioral response on sampling results. 

A version of this code was originally developed for a journal article [Simulated Fishing to Untangle Catchability and Availability in Fish Abundance Monitoring](dx.doi.org/10.20944/preprints202002.0177.v1), which is available as a preprint while it undergoes peer review. The code available in this repository is meant to extend the application of the code from its original purpose to additional species and gear types.

## What's here? (Or what will be here soon?)
* R code to simulate a behavioral response to sampling gear that is similar to a response to predators. The user can set parameters for the fish such as swimming speed and ability to swim.
* R code to generate random samples of any number of fish, as determined by the user
* R code to define the parameters of the sampling gear of interest (size of the swath covered by the gear, speed of the gear, etc.)

## Conceptual Models
The code in this package is based on several conceptual models, including a fish behavior model, a fish distribution model, and a model of how sampling gear is towed through the water. These models are conceputalized for two-dimensional space, although future versions may extend the models to three-dimensional space.

### Behavior Model
The underlying model of fish behavior was based on a model of predator response behavior (Domenici 2010).
<img src="/images/PredAvoidModel2.png" alt="Predator Avoidance Model" width = "500"/>

### Fish Model
<img src="/images/FishModel.png" alt="Fish Model" width = "500"/>

In the fish model, the user can set parameters that influence the swimming speed of the fish. The distance is set randomly, based on the width of the sampling gear and the escape angle is randomly chosen, based on published values (Domenici & Batty 1994, 1997; Meager et al. 2006).

### Tow Model
<img src="/images/TowModel.png" alt="Tow Model" width = "500"/>

In the tow model, a user can set the speed of the net and the reaction distance for the fish. 

### Calculation Model
<img src="/images/CalculationModel.png" alt="Tow Model" width = "500"/>

The calculation model reduces the two-dimensional geometry of fish placement to a one-dimensional comparison of the time it takes for a fish to escape to the time it takes for the gear to reach the fish. A fish is caught if the calculated time to escape is longer than the time it takes for the net to reach the fish. (I.e., if the fish is too slow, it gets caught.)

## Disclaimer & Licensing
Code for this project is under development. It is provided without warantee. The findings and conclusions of this article are those of the author and do not necessarily represent the views of the U.S. Fish and Wildlife Service.

Code and associated documentation are distributed with a [CC-BY 4.0](https://creativecommons.org/licenses/by/4.0/) license, which allows use of this product with attribution.

## References
Domenici P, Batty RS (1994) Escape manoeuvres of schooling Clupea harengus. Journal of Fish Biology 45(Supplement A): 97-110.

Domenici P, Batty RS (1997) Escape behavior of solitary herring (Clupea harengus) and comparisons with schooling individuals. Marine Biology 128: 29-38.

Domenici, P (2010) Escape Responses in fish: kinematics, performance, and behavior. In: Domenici P, B Kapoor (Eds) Fish Locomotion: An Eco-Ethological Perspective. CRC Press, Enfield. ISBN: 9781439843123

Meager JJ, Domenici P, Shingles A, Utne-Palm AC (2006) Escape responses in juvenile Atlantic cod Gadus morhua L.: the effects of turbidity and predator speed. The journal of Experimental Biology 209:4171-4184. DOI: 10.1242/jeb.02489.

Tobias, V. Simulated Fishing to Untangle Catchability and Availability in Fish Abundance Monitoring. Preprints 2020, 2020020177 (doi: 10.20944/preprints202002.0177.v1).


