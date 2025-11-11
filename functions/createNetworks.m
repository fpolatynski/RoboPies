function [criticNetwork1, criticNetwork2, actorNetwork] = createNetworks(numObs, numAct, actInfo)
% Enhanced TD3 Networks for Quadruped Robot
% Adds LayerNorm, action scaling, and improved structure
% Based on Lillicrap et al. (2015) and Fujimoto et al. (2018)

%% === Configuration ===
criticLayerSizes = [400 300];
actorLayerSizes  = [400 300];
finalInitScale   = 5e-3; % small output init
useLayerNorm     = true; % toggle normalization

%% === Helper for optional normalization ===
if useLayerNorm
    normLyr = @(name) layerNormalizationLayer('Name', name);
else
    normLyr = @(name) [];
end

%% === CRITIC 1 ===
statePath1 = [
    featureInputLayer(numObs, Name="ObsInLyr")
    fullyConnectedLayer(criticLayerSizes(1), ...
        Weights=2/sqrt(numObs)*(rand(criticLayerSizes(1),numObs)-0.5), ...
        Bias=2/sqrt(numObs)*(rand(criticLayerSizes(1),1)-0.5), ...
        Name="Critic1StateFC1")
    reluLayer(Name="Critic1Relu1")
    normLyr("Critic1Norm1")
    fullyConnectedLayer(criticLayerSizes(2), ...
        Weights=2/sqrt(criticLayerSizes(1))*(rand(criticLayerSizes(2),criticLayerSizes(1))-0.5), ...
        Bias=2/sqrt(criticLayerSizes(1))*(rand(criticLayerSizes(2),1)-0.5), ...
        Name="Critic1StateFC2")
    ];

actionPath1 = [
    featureInputLayer(numAct, Name="ActInLyr")
    fullyConnectedLayer(criticLayerSizes(2), ...
        Weights=2/sqrt(numAct)*(rand(criticLayerSizes(2),numAct)-0.5), ...
        Bias=2/sqrt(numAct)*(rand(criticLayerSizes(2),1)-0.5), ...
        Name="Critic1ActionFC1")
    ];

commonPath1 = [
    additionLayer(2, Name="Add1")
    reluLayer(Name="Critic1Relu2")
    normLyr("Critic1Norm2")
    fullyConnectedLayer(1, ...
        Weights=2*finalInitScale*(rand(1,criticLayerSizes(2))-0.5), ...
        Bias=2*finalInitScale*(rand(1,1)-0.5), ...
        Name="Critic1OutLyr")
    ];

criticNetwork1 = layerGraph();
criticNetwork1 = addLayers(criticNetwork1, statePath1);
criticNetwork1 = addLayers(criticNetwork1, actionPath1);
criticNetwork1 = addLayers(criticNetwork1, commonPath1);
criticNetwork1 = connectLayers(criticNetwork1, "Critic1StateFC2", "Add1/in1");
criticNetwork1 = connectLayers(criticNetwork1, "Critic1ActionFC1", "Add1/in2");
criticNetwork1 = dlnetwork(criticNetwork1);

%% === CRITIC 2 ===
statePath2 = [
    featureInputLayer(numObs, Name="ObsInLyr")
    fullyConnectedLayer(criticLayerSizes(1), ...
        Weights=2/sqrt(numObs)*(rand(criticLayerSizes(1),numObs)-0.5), ...
        Bias=2/sqrt(numObs)*(rand(criticLayerSizes(1),1)-0.5), ...
        Name="Critic2StateFC1")
    reluLayer(Name="Critic2Relu1")
    normLyr("Critic2Norm1")
    fullyConnectedLayer(criticLayerSizes(2), ...
        Weights=2/sqrt(criticLayerSizes(1))*(rand(criticLayerSizes(2),criticLayerSizes(1))-0.5), ...
        Bias=2/sqrt(criticLayerSizes(1))*(rand(criticLayerSizes(2),1)-0.5), ...
        Name="Critic2StateFC2")
    ];

actionPath2 = [
    featureInputLayer(numAct, Name="ActInLyr")
    fullyConnectedLayer(criticLayerSizes(2), ...
        Weights=2/sqrt(numAct)*(rand(criticLayerSizes(2),numAct)-0.5), ...
        Bias=2/sqrt(numAct)*(rand(criticLayerSizes(2),1)-0.5), ...
        Name="Critic2ActionFC1")
    ];

commonPath2 = [
    additionLayer(2, Name="Add2")
    reluLayer(Name="Critic2Relu2")
    normLyr("Critic2Norm2")
    fullyConnectedLayer(1, ...
        Weights=2*finalInitScale*(rand(1,criticLayerSizes(2))-0.5), ...
        Bias=2*finalInitScale*(rand(1,1)-0.5), ...
        Name="Critic2OutLyr")
    ];

criticNetwork2 = layerGraph();
criticNetwork2 = addLayers(criticNetwork2, statePath2);
criticNetwork2 = addLayers(criticNetwork2, actionPath2);
criticNetwork2 = addLayers(criticNetwork2, commonPath2);
criticNetwork2 = connectLayers(criticNetwork2, "Critic2StateFC2", "Add2/in1");
criticNetwork2 = connectLayers(criticNetwork2, "Critic2ActionFC1", "Add2/in2");
criticNetwork2 = dlnetwork(criticNetwork2);

%% === ACTOR ===
actorNetwork = [
    featureInputLayer(numObs, Name="ObsInLyr")
    fullyConnectedLayer(actorLayerSizes(1), ...
        Weights=2/sqrt(numObs)*(rand(actorLayerSizes(1),numObs)-0.5), ...
        Bias=2/sqrt(numObs)*(rand(actorLayerSizes(1),1)-0.5), ...
        Name="ActorFC1")
    reluLayer(Name="ActorRelu1")
    normLyr("ActorNorm1")
    fullyConnectedLayer(actorLayerSizes(2), ...
        Weights=2/sqrt(actorLayerSizes(1))*(rand(actorLayerSizes(2),actorLayerSizes(1))-0.5), ...
        Bias=2/sqrt(actorLayerSizes(1))*(rand(actorLayerSizes(2),1)-0.5), ...
        Name="ActorFC2")
    reluLayer(Name="ActorRelu2")
    normLyr("ActorNorm2")
    fullyConnectedLayer(numAct, ...
        Weights=2*finalInitScale*(rand(numAct,actorLayerSizes(2))-0.5), ...
        Bias=2*finalInitScale*(rand(numAct,1)-0.5), ...
        Name="ActorFC3")
    tanhLayer(Name="TanhOutput")
    scalingLayer('Scale', actInfo.UpperLimit, 'Name', 'ActionScaling')
    ];

actorNetwork = dlnetwork(actorNetwork);

end
