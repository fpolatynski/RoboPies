clear;
addpath("..\functions\");
addpath("..\agents\");
init_param;
init_environment;

% Open model
mdl = "compare";
open_system(mdl)

% Load agent
load("run.mat");

% Init PID points
z0 = -0.11;
x = 0.25;
k=2;
d0 = -0.016;
dx = 0.04;
dz = 0.04;

time = 0.08;

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
figure;
hold on
plot([d0 d0-dx d0 d0+dx], [z0 z0 z0+dz z0], "ok", "LineWidth", 3)
xlim()
hold off

color2 = [0.5, 0.5, 1];