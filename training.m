% Generate seed
% Check if GPU is available and set training options accordingly
rng(990)

% Initialise all variables
addpath("functions\");
addpath("logs\")
init_param;
init_environment;

% Open model
mdl = "RoboPies";
open_system(mdl)

env = rlSimulinkEnv("RoboPies", "RoboPies/Agent", obsInfo, actInfo);
%in = Simulink.SimulationInput(mdl);
env.ResetFcn = @(in) reset_height(in);
%env.ResetFcn = @(in) setVariable(in, 'robot_offset', 10);
%agent = rlDDPGAgent(obsInfo, actInfo, initOptions, agentOptions);
% Create the DDPG agent
%agent = createTD3Agent(numObs, obsInfo, numAct, actInfo, T);
%%

trainOptions.UseParallel = true;
trainOptions.ParallelizationOptions.Mode = "async";
trainingStats = train(agent, env, trainOptions, Evaluator=evaluator, Logger=logger);

%%
simOptions = rlSimulationOptions(MaxSteps=floor(Tf/T));
experiences = sim(env,agent,simOptions);
%%
%agent = episodeData.Agent{1};
