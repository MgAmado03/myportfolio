**Raceline optimization**
This project is motivated by the challenge proposed in the following GitHub repository: https://github.com/mathworks/MATLAB-Simulink-Challenge-Project-Hub/tree/main/projects/Path%20Planning%20for%20Autonomous%20Race%20Cars .
The goal is to find the optimal raceline for any given track that gives the fastest lap time.

**Solution**
The solution is based on defining and solving a QP (quadratic programming) problem that describes this challenge to obtain the minimum curvature path along the track. Afterwards, a velocity profile is calculated by identifying the maximum curvature points in the raceline and assigning critical speeds to those points.

**Results**
This solution was tested for the Spa circuit and the results speak for themselves considering lap time and average velocity is greatly improved in the scenario where the car    follows the optimal raceline vs the centerline. They are as follows:

	- Centerline avg. velocity: 31.56 m/s
	- Optimal raceline avg. velocity: 52.14 m/s

	- Centerline lap time: 315.71 s
	- Optimal raceline lap time: 178.44 s

The graphical representation of the results obtained is in the “Results” folder. 

**References and credit**
The solution and    all the code used is either a direct copy or a rearrangement of the code in the following GitHub repository: https://github.com/putta54/MW208_Raceline_Optimization/tree/main 
All credit of this solution goes to the owner of said repository, I have only studied and rearranged it for personal learning purposes. 

