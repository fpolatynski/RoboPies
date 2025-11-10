% Generate seed
% Check if GPU is available and set training options accordingly
rng(960)

% Initialise all variables
addpath("functions\");
addpath("logs\")
init_param;
init_environment;

% Open model
mdl = "RoboPies";
open_system(mdl)

env = rlSimulinkEnv("RoboPies", "RoboPies/Agent", obsInfo, actInfo);
%agent = rlDDPGAgent(obsInfo, actInfo, initOptions, agentOptions);
% Create the DDPG agent
%agent = createTD3Agent(numObs, obsInfo, numAct, actInfo, T);
%%

trainOptions.UseParallel = true;
trainOptions.ParallelizationOptions.Mode = "async";
trainingStats = train(agent, env, trainOptions, Evaluator=evaluator, Logger=logger);

%%
simOptions = rlSimulationOptions(MaxSteps=floor(Tf/T));
experience = sim(env,agent,simOptions);
