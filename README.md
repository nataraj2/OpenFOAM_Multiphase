# Multiphase simulations of liquid jet in crossflow in OpenFOAM

This repository contains files for incompressible, multiphase simulations of 
a liquid jet in crossflows in OpenFOAM using the interFOAM multiphase flow solver.

# Simulations
Direct numerical simulations and Reynolds Averaged Navier-Stokes (RANS) ($k-\epsilon$) simulations of a water jet in air crossflow 
are perfomed using interFOAM. The domain, boundary conditions and the simulation parameters are shown in the section below.

## Setup 

<img src="Images/JICF_Setup.png?raw=true&v=50" alt="your_alternative_text" width="50%" height="50%" loop="true" autoplay="true"><img src="Images/JICF_Table.png?raw=true&v=50" alt="your_alternative_text" width="50%" height="50%">   

## Running
The ```DNS``` and ```RANS_k-epsilon``` directories contain the ```0```, ```constant``` and ```system``` directories required to run the simulations 
for the direct numerical simulations and the RANS cases respectively.

## Visualization 
Contours of volume fraction rendered using ray casting in VisIt and contours of streamwise velocity 

<img src="Images/JICF_DNS.gif?raw=true&v=50" alt="your_alternative_text" width="50%" height="50%" loop="true" autoplay="true"><img src="Images/JICF_Contours.png?raw=true&v=50" alt="your_alternative_text" width="50%" height="50%" loop="true" autoplay="true">    

## Comparison 
The comparison of the liquid penetration with correlations in literature

<img src="Images/JICF_DNS_Comparison.png?raw=true&v=50" alt="your_alternative_text" width="50%" height="50%" loop="true" autoplay="true"><img src="Images/JICF_RANS_Comparison.png?raw=true&v=50" alt="your_alternative_text" width="43%" height="43%" loop="true" autoplay="true">    

# I/O and post processing
Binary Visualization Toolkit (VTK) format is used to output the files. The ```PostProcess``` directory consists of post processing tools to extract data, write the 
files required for visulization and rendering
1. ```PostProcess``` contains routines to read the binary VTK output file and extract the data
2. ```PythonScripts``` contains python scripts for the comparison
3. ```Movies``` contains the Python scripts for visualization using ray casting in VisIt

