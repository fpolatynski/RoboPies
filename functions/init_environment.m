%% AGENT
initOptions = rlAgentInitializationOptions();

%% TRAINING
trainOptions = rlTrainingOptions();
trainOptions.MaxEpisodes = max_episodes;
trainOptions.MaxStepsPerEpisode = floor(Tf/T);
trainOptions.ScoreAveragingWindowLength=200;
trainOptions.StopTrainingCriteria = "none";   


%% OBSERVATION AND ACTION
numObs = 43;
numAct = 8;
obsInfo = rlNumericSpec([numObs, 1]);
actInfo = rlNumericSpec([numAct, 1], "UpperLimit", 1, "LowerLimit", -1);

%% EVALUATOR
evaluator = rlEvaluator(NumEpisodes=5, EvaluationFrequency=25);

%% LOGGER
logger = rlDataLogger();
logger.LoggingOptions.MaxEpisodes = max_episodes;
logger.LoggingOptions.LoggingDirectory = "logs\logs";
%logger.AgentLearnFinishedFcn = @myEpisodeFinishedFcn;
logger.EpisodeFinishedFcn    = @myEpisodeFinishedFcn;

%% FUNCTIONS

function dataToLog = myEpisodeFinishedFcn(data)
    dataToLog.Experience = data.Experience;
    dataToLog.Agent = data.Agent;
end