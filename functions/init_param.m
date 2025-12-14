%% Simulation
Tf = 6;
T = 0.025;
% World plane
plane_color = [0.4, 0.9, 0.4];
density = 500;               % kg/m^3
plane = [25, 10, 0.05];     % m

robot_offset = 0;
%% ROBOT
robot_color = [0.6, 0.1, 0.1];
% Torso
torso = [0.2, 0.12, 0.03];   % m
% Leg
upper_leg = [0.08, 0.01, 0.01];    % m
lower_leg = [0.08, 0.01, 0.01];    % m
initial_hip_angle = -pi/3.5;   % rad
hip_max_angle = -1/8*pi;
hip_min_angle = -7/16*pi;
initial_knee_angle = pi/1.75;   % rad
knee_max_angle = pi;
knee_min_angle = 1/2*pi;
init_left = 3/4*pi;
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
z0 = -0.11;
ground_offset = z0 - foot_radius - plane(3)/2;
[phi1, phi2] = inverse_kinematics(-z0);
initial_hip_angle=phi1;
initial_knee_angle= phi2;

%% Reward
reward;