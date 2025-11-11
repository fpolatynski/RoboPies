%% Simulation
Tf = 5;
T = 0.025;
% World plane
plane_color = [0.8, 0.7, 1];
density = 500;               % kg/m^3
plane = [25, 10, 0.05];     % m

robot_offset = 0;
%% ROBOT
robot_color = [1, 0.5, 0.5];
% Torso
torso = [0.2, 0.12, 0.03];   % m
% Leg
upper_leg = [0.08, 0.01, 0.01];    % m
lower_leg = [0.08, 0.01, 0.01];    % m
initial_hip_angle = -pi/5;   % rad
hip_max_angle = 0;
hip_min_angle = -pi/2;
initial_knee_angle = pi/2.5;   % rad
knee_max_angle = pi;
knee_min_angle = 0;
init_left = pi/2;
foot_radius = 0.01;

% Motor
motor_damping = 0.1; % Nms/rad

% Contact
contact_stiffness = 5000;
contact_damping = 50;
contact_static_friction = 0.9;
contact_dynamic_friction = 0.7;

% Regulator
k = 0.8;
x = 0.3;

% controller
bias = 0;
%% Observation
max_torque = 0.5;
max_magnitude_force = 60;
max_friction_force = 40;
max_knee_speed = 8;
max_hip_speed = 6;
max_a = 60;
max_v = 1;
%% Training
max_episodes = 5000;
[x, z0] = kinematics(initial_hip_angle, initial_knee_angle);
ground_offset = z0 - foot_radius - plane(3)/2;