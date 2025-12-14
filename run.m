clear;
addpath("functions\");
addpath("agents\");
init_param;
init_environment;

% Open model
mdl = "RoboPies";
open_system(mdl)
env = rlSimulinkEnv("RoboPies", "RoboPies/Agent", obsInfo, actInfo);

% Load agent
load("run.mat");
%%
% Run simulation
simOptions = rlSimulationOptions(MaxSteps=floor(Tf/T));
experiences = sim(env,agent,simOptions);