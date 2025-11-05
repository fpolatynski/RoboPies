function [criticNetwork1, criticNetwork2, actorNetwork] = createNetworks(numObs, numAct)
% Walking Robot -- Neural Network Setup Script
% Copyright 2020 The MathWorks, Inc.

% Network structure inspired by original 2015 DDPG paper 
% "Continuous Control with Deep Reinforcement Learning", Lillicrap et al.
% https://arxiv.org/pdf/1509.02971.pdf

%% CRITIC
% Create the critic network layers
clsz = [400 300]; % Critic layer sizes

%% First Critic network
statePath1 = [
    featureInputLayer(numObs,Name="ObsInLyr")
    fullyConnectedLayer(clsz(1), ... 
            Weights=2/sqrt(numObs)*(rand(clsz(1),numObs)-0.5), ...
            Bias=2/sqrt(numObs)*(rand(clsz(1),1)-0.5))
    reluLayer
    fullyConnectedLayer(clsz(2), Name="CriticStateFC2", ...
            Weights=2/sqrt(clsz(1))*(rand(clsz(2),clsz(1))-0.5), ... 
            Bias=2/sqrt(clsz(1))*(rand(clsz(2),1)-0.5))
    ];
actionPath1 = [
    featureInputLayer(numAct,Name="ActInLyr")
    fullyConnectedLayer(clsz(2), Name="CriticActionFC1", ...
            Weights=2/sqrt(numAct)*(rand(clsz(2),numAct)-0.5), ... 
            Bias=2/sqrt(numAct)*(rand(clsz(2),1)-0.5))
    ];
commonPath1 = [
    additionLayer(2,Name="add")
    reluLayer
    fullyConnectedLayer(1, Name="CriticOutLyr",...
            Weights=2*5e-3*(rand(1,clsz(2))-0.5), ...
            Bias=2*5e-3*(rand(1,1)-0.5))
    ];

% Assemble dlnetwork object
criticNetwork1 = dlnetwork;
criticNetwork1 = addLayers(criticNetwork1, statePath1);
criticNetwork1 = addLayers(criticNetwork1, actionPath1);
criticNetwork1 = addLayers(criticNetwork1, commonPath1);
criticNetwork1 = connectLayers(criticNetwork1,"CriticStateFC2","add/in1");
criticNetwork1 = connectLayers(criticNetwork1,"CriticActionFC1","add/in2");

% Initialize network
criticNetwork1 = initialize(criticNetwork1);

%% Second Critic network 
statePath2 = [
    featureInputLayer(numObs,Name="ObsInLyr")
    fullyConnectedLayer(clsz(1), Name="CriticStateFC1", ... 
            Weights=2/sqrt(numObs)*(rand(clsz(1),numObs)-0.5), ...
            Bias=2/sqrt(numObs)*(rand(clsz(1),1)-0.5))
    reluLayer
    fullyConnectedLayer(clsz(2), Name="CriticStateFC2", ...
            Weights=2/sqrt(clsz(1))*(rand(clsz(2),clsz(1))-0.5), ... 
            Bias=2/sqrt(clsz(1))*(rand(clsz(2),1)-0.5))
    ];
actionPath2 = [
    featureInputLayer(numAct,Name="ActInLyr")
    fullyConnectedLayer(clsz(2), Name="CriticActionFC1", ...
            Weights=2/sqrt(numAct)*(rand(clsz(2),numAct)-0.5), ... 
            Bias=2/sqrt(numAct)*(rand(clsz(2),1)-0.5))
    ];
commonPath2 = [
    additionLayer(2,Name="add")
    reluLayer
    fullyConnectedLayer(1, Name="CriticOutLyr",...
            Weights=2*5e-3*(rand(1,clsz(2))-0.5), ...
            Bias=2*5e-3*(rand(1,1)-0.5))
    ];

% Assemble dlnetwork object
criticNetwork2 = dlnetwork;
criticNetwork2 = addLayers(criticNetwork2, statePath2);
criticNetwork2 = addLayers(criticNetwork2, actionPath2);
criticNetwork2 = addLayers(criticNetwork2, commonPath2);
criticNetwork2 = connectLayers(criticNetwork2,"CriticStateFC2","add/in1");
criticNetwork2 = connectLayers(criticNetwork2,"CriticActionFC1","add/in2");

% Initialize network
criticNetwork2 = initialize(criticNetwork2);

%% ACTOR
% Create the actor network layers
alsz = [400 300]; % Actor layer sizes
actorNetwork = [
    featureInputLayer(numObs)
    fullyConnectedLayer(alsz(1), Name="ActorFC1", ...
            Weights=2/sqrt(numObs)*(rand(alsz(1),numObs)-0.5), ... 
            Bias=2/sqrt(numObs)*(rand(alsz(1),1)-0.5))
    reluLayer(Name="ActorRelu1")
    fullyConnectedLayer(alsz(2), Name="ActorFC2", ... 
            Weights=2/sqrt(alsz(1))*(rand(alsz(2),alsz(1))-0.5), ... 
            Bias=2/sqrt(alsz(1))*(rand(alsz(2),1)-0.5))
    reluLayer(Name="ActorRelu2")
    fullyConnectedLayer(numAct, Name="ActorFC3", ... 
                       Weights=2*5e-3*(rand(numAct,alsz(2))-0.5), ... 
                       Bias=2*5e-3*(rand(numAct,1)-0.5))                       
    tanhLayer
    ];

% Convert to dlnetwork object and initialize
actorNetwork = initialize(dlnetwork(actorNetwork));

