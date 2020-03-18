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
These are visual representations of the ideas on which the code is based.

### Behavior Model
The underlying model of fish behavior was based on a model of predator response behavior (Domenici 2010).
<img src="/images/PredAvoidModel2.png" alt="Predator Avoidance Model" width = "500"/>

### Fish Model
<img src="/images/FishModel.png" alt="Fish Model" width = "500"/>

### Tow Model
<img src="/images/TowModel.png" alt="Tow Model" width = "500"/>

### Calculation Model
<img src="/images/CalculationModel.png" alt="Tow Model" width = "500"/>

## Disclaimer & Licensing
Code for this project is provided without guantee as to its accuracy or useability.
Code and associated documentation are distributed with a [CC-BY 4.0](https://creativecommons.org/licenses/by/4.0/) license, which allows use of this product with attribution.

## References
Domenici, P (2010) Escape Responses in fish: kinematics, performance, and behavior. In: Domenici P, B Kapoor (Eds) Fish Locomotion: An Eco-Ethological Perspective. CRC Press, Enfield. ISBN: 9781439843123

Tobias, V. Simulated Fishing to Untangle Catchability and Availability in Fish Abundance Monitoring. Preprints 2020, 2020020177 (doi: 10.20944/preprints202002.0177.v1).


