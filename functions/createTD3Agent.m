function agent = createTD3Agent(numObs, obsInfo, numAct, actInfo, Ts)

[criticNetwork1,criticNetwork2,actorNetwork] = createNetworks(numObs,numAct);

criticOptions = rlOptimizerOptions( ...
    Optimizer="adam", ...
    LearnRate=1e-3, ... 
    GradientThreshold=1, ...
    L2RegularizationFactor=2e-4);

actorOptions = rlOptimizerOptions( ...
    Optimizer="adam", ...
    LearnRate=1e-3, ... 
    GradientThreshold=1, ...
    L2RegularizationFactor=1e-5);

critic1 = rlQValueFunction(criticNetwork1,obsInfo,actInfo, ...
    ObservationInputNames="ObsInLyr", ...
    ActionInputNames="ActInLyr");

critic2 = rlQValueFunction(criticNetwork2,obsInfo,actInfo, ...
    ObservationInputNames="ObsInLyr", ...
    ActionInputNames="ActInLyr");

actor  = rlContinuousDeterministicActor(actorNetwork,obsInfo,actInfo);

agentOptions = rlTD3AgentOptions;
agentOptions.SampleTime = Ts;
agentOptions.DiscountFactor = 0.99;
agentOptions.MiniBatchSize = 256;
agentOptions.ExperienceBufferLength = 1e6;
agentOptions.TargetSmoothFactor = 5e-3;
agentOptions.TargetPolicySmoothModel.Variance = 0.2;
agentOptions.TargetPolicySmoothModel.LowerLimit = -0.5;
agentOptions.TargetPolicySmoothModel.UpperLimit = 0.5;

% set up OU noise as exploration noise (default is Gaussian for rlTD3AgentOptions)
agentOptions.ExplorationModel = rl.option.OrnsteinUhlenbeckActionNoise; 
agentOptions.ExplorationModel.MeanAttractionConstant = 1;
agentOptions.ExplorationModel.Variance = 0.1;
agentOptions.ActorOptimizerOptions = actorOptions;
agentOptions.CriticOptimizerOptions = criticOptions;

agent = rlTD3Agent(actor, [critic1,critic2], agentOptions);