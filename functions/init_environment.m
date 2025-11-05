%% AGENT
initOptions = rlAgentInitializationOptions();
% DDPG
agentOptions = rlDDPGAgentOptions();

% specify the options
agentOptions.SampleTime = T;
agentOptions.MiniBatchSize = 256;
agentOptions.ExperienceBufferLength = 1e6;
agentOptions.MaxMiniBatchPerEpoch = 200;

% optimizer options
agentOptions.ActorOptimizerOptions.LearnRate = 1e-3;
agentOptions.ActorOptimizerOptions.GradientThreshold = 1;
agentOptions.CriticOptimizerOptions.LearnRate = 1e-3;
agentOptions.CriticOptimizerOptions.GradientThreshold = 1;

% exploration options
agentOptions.NoiseOptions.StandardDeviation = 0.1;
agentOptions.NoiseOptions.MeanAttractionConstant = 1.0; 

% % TD3
% agentTD3Options = rlTD3AgentOptions();
% agentTD3Options.SampleTime = T;
% agentTD3Options.MiniBatchSize = 256;
% agentTD3Options.ExperienceBufferLength = 1e7;
% % Set additional TD3 options
% agentTD3Options.ActorOptimizerOptions.LearnRate = 1e-3;
% 
% %Exploration
% agentTD3Options.ExplorationModel.StandardDeviation = 0.4; % Increase for more exploration
% agentTD3Options.ExplorationModel.StandardDeviationDecayRate = 0; % Decay rate



%% TRAINING
trainOptions = rlTrainingOptions();

trainOptions.MaxEpisodes = 5000;
trainOptions.MaxStepsPerEpisode = floor(Tf/T);
trainOptions.ScoreAveragingWindowLength=200;
trainOptions.StopTrainingCriteria = "none";   

% % parallelization
trainOptions.UseParallel = true;
trainOptions.ParallelizationOptions.Mode = "async";

%% OBSERVATION AND ACTION
numObs = 43;
numAct = 8;
obsInfo = rlNumericSpec([numObs, 1]);
actInfo = rlNumericSpec([numAct, 1], "UpperLimit", 1, "LowerLimit", -1);

%% EVALUATOR
evaluator = rlEvaluator(NumEpisodes=5, EvaluationFrequency=25);
