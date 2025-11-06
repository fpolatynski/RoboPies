function agent = createTD3Agent(numObs, obsInfo, numAct, actInfo, Ts)
% Enhanced TD3 agent setup for quadruped robot locomotion
% Based on Lillicrap et al. (2015) and Fujimoto et al. (2018)
% Adds noise decay, improved initialization, and LayerNorm networks

%% === Create Neural Networks ===
[criticNetwork1, criticNetwork2, actorNetwork] = createNetworks(numObs, numAct, actInfo);

%% === Critic Optimizer Options ===
criticOpts = rlOptimizerOptions( ...
    Optimizer = "adam", ...
    LearnRate = 2e-3, ...                 % Slightly faster critic learning
    GradientThreshold = 1, ...
    L2RegularizationFactor = 2e-4);

%% === Actor Optimizer Options ===
actorOpts = rlOptimizerOptions( ...
    Optimizer = "adam", ...
    LearnRate = 1e-4, ...                 % Actor learns faster (typical TD3 ratio ~5:1)
    GradientThreshold = 1, ...
    L2RegularizationFactor = 1e-5);

%% === Define Critics ===
critic1 = rlQValueFunction(criticNetwork1, obsInfo, actInfo, ...
    ObservationInputNames = "ObsInLyr", ...
    ActionInputNames = "ActInLyr");

critic2 = rlQValueFunction(criticNetwork2, obsInfo, actInfo, ...
    ObservationInputNames = "ObsInLyr", ...
    ActionInputNames = "ActInLyr");

%% === Define Actor ===
actor = rlContinuousDeterministicActor(actorNetwork, obsInfo, actInfo, ...
    ObservationInputNames = "ObsInLyr");

%% === Agent Options ===
agentOpts = rlTD3AgentOptions;
agentOpts.SampleTime = Ts;

% --- Learning parameters ---
agentOpts.DiscountFactor = 0.997;         % Long-horizon reward (for stable gait)
agentOpts.MiniBatchSize = 256;
agentOpts.ExperienceBufferLength = 1e6;
agentOpts.TargetSmoothFactor = 5e-3;      % Soft target update
agentOpts.TargetUpdateFrequency = 2;      % TD3 delayed policy updates
agentOpts.MaxMiniBatchPerEpoch = 500;
agentOpts.NumWarmStartSteps = 10000;

% --- Target policy smoothing ---
agentOpts.TargetPolicySmoothModel.Variance = 0.2;
agentOpts.TargetPolicySmoothModel.LowerLimit = -0.5;
agentOpts.TargetPolicySmoothModel.UpperLimit = 0.5;

% --- Exploration noise (OU process) ---
ouNoise = rl.option.OrnsteinUhlenbeckActionNoise;
ouNoise.Mean = 0;
ouNoise.MeanAttractionConstant = 0.15;    % Slow drift → smoother motion
ouNoise.Variance = 0.3;                   % Initial exploration intensity
ouNoise.VarianceDecayRate = 1e-5;         % Gradually reduce noise
ouNoise.VarianceMin = 0.05;               % Keep small exploration for fine-tuning
agentOpts.ExplorationModel = ouNoise;

% --- Assign optimizer options ---
agentOpts.ActorOptimizerOptions = actorOpts;
agentOpts.CriticOptimizerOptions = criticOpts;

%% === Build TD3 Agent ===
agent = rlTD3Agent(actor, [critic1, critic2], agentOpts);

%% === Display summary ===
disp("✅ TD3 Quadruped Agent created with:");
disp(" - Actor: [400, 300] with LayerNorm + tanh scaling");
disp(" - Critics: Two independent [400, 300] networks");
disp(" - OU noise decay for smooth exploration");
disp(" - Gamma = 0.997, Batch = 256, Replay = 1e6");
disp(" - Actor LR = 1e-3, Critic LR = 2e-4");

end