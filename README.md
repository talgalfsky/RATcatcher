# RATcatcher
Matlab code to calculate Reflection, Absorption, Transmission of thin film stacks
Code was written in MATLAB 2011a

%%%%%%%%% 'Reflectance, Absorbance, Transmittance catcher' %%%%%%%%%%%%%%%
 
 Copyright 2016 T. Galfsky, V. Menon, City College of the City University
 of New York

     This program is free software: you can redistribute it and/or modify
     it under the terms of the GNU General Public License as published by
     the Free Software Foundation, either version 3 of the License, or
     (at your option) any later version.
 
     This program is distributed in the hope that it will be useful,
     but WITHOUT ANY WARRANTY; without even the implied warranty of
     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
     GNU General Public License for more details.
 
     You should have received a copy of the GNU General Public License
     along with this program.  If not, see <http://www.gnu.org/licenses/>.

 This code calculates the Reflectance, Transmission, and Absorption of a
 multilayer thin-film using dispersive or non-dispersive materials.

 The function RAT catcher outputs:
 1) Selected polarization: "TE" or "TM"
 2) R,T,A = Reflection, Transmission, Absorption matrix data

 3) lambda and angles, lambda is the y-axis: wavelength vector in nm
 and angles is the x-axis: angles in deg, for the R,T,A matrix data.

 The materials to be used for the multilayer structure can be defined 
 inside the "Select Materials" tab as either non-disperesive (enter 
 a number for refractive index) or as dispersive (load index from file - 
 Row 1: wavelength in nm, Row 2: n, Row 3: k).
 
 At this point in time (3.21.16) the code does not accept dispersive
 materials for the input medium.

