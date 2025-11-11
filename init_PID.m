addpath("functions\");
init_param;
% Open model
mdl = "RoboPiesPID";
open_system(mdl)
x = 0.25;
k=2;
d0 = -0.016;
dx = 0.04;
dz = 0.04;

time = 0.1;

[phi1, phi2] = inverse_kinematics1(d0, z0);
point1.phi1 = phi1;
point1.phi2 = phi2;
[phi1, phi2] = inverse_kinematics1(d0-dx, z0);
point2.phi1 = phi1;
point2.phi2 = phi2;
[phi1, phi2] = inverse_kinematics1(d0, z0+dz);
point3.phi1 = phi1;
point3.phi2 = phi2;
[phi1, phi2] = inverse_kinematics1(d0+dx, z0);
point4.phi1 = phi1;
point4.phi2 = phi2;
