out = sim("compare.slx");
%% IMU MEASUREMENTS
x = out.x_;
z = out.z_;
v = out.v_;
a = out.a_;
pitch = out.pitch_;
roll = out.roll_;
yaw = out.yaw_;

meanV1 = mean(v{1}.Values.Data)
varV1 = var(v{1}.Values.Data)
meanV2 = mean(v{2}.Values.Data)
varV2 = var(v{2}.Values.Data)

meanPitch1 = mean(pitch{1}.Values.Data)
varPitch1 = var(pitch{1}.Values.Data)
meanPitch2 = mean(pitch{2}.Values.Data)
varPitch2 = var(pitch{2}.Values.Data)

meanRoll1 = mean(roll{1}.Values.Data)
varRoll1 = var(roll{1}.Values.Data)
meanRoll2 = mean(roll{2}.Values.Data)
varRoll2 = var(roll{2}.Values.Data)

meanYaw1 = mean(yaw{1}.Values.Data)
varYaw1 = var(yaw{1}.Values.Data)
meanYaw2 = mean(yaw{2}.Values.Data)
varYaw2 = var(yaw{2}.Values.Data)

%%
% Utworzenie okna z wykresami (układ 2 wiersze x 3 kolumny)
figure('Name', 'Porównanie parametrów (bez Z)', 'NumberTitle', 'off');

% 1. Pozycja X
subplot(2,3,1);
plot(x{1}.Values.Time, x{1}.Values.Data, 'LineWidth', 1.5); hold on;
plot(x{2}.Values.Time, x{2}.Values.Data, 'LineWidth', 1.5);
title('Pozycja X');
xlabel('t [s]'); ylabel('x [m]');
legend('RL', 'PID', 'Location', 'best');
grid on;

% 2. Prędkość V
subplot(2,3,2);
plot(v{1}.Values.Time, v{1}.Values.Data, 'LineWidth', 1.5); hold on;
plot(v{2}.Values.Time, v{2}.Values.Data, 'LineWidth', 1.5);
title('Prędkość X');
xlabel('t [s]'); ylabel('v [m/s]');
legend('RL', 'PID', 'Location', 'best');
grid on;

% 3. Przyspieszenie A
subplot(2,3,3);
plot(a{1}.Values.Time, a{1}.Values.Data, 'LineWidth', 1.5); hold on;
plot(a{2}.Values.Time, a{2}.Values.Data, 'LineWidth', 1.5);
title('Przyspieszenie X');
xlabel('t [s]'); ylabel('a [m/s^2]');
legend('RL', 'PID', 'Location', 'best');
grid on;

% 4. Pitch
subplot(2,3,4);
plot(pitch{1}.Values.Time, pitch{1}.Values.Data, 'LineWidth', 1.5); hold on;
plot(pitch{2}.Values.Time, pitch{2}.Values.Data, 'LineWidth', 1.5);
title('Kąt Pitch');
xlabel('t [s]'); ylabel('rad');
legend('RL', 'PID', 'Location', 'best');
grid on;

% 5. Roll
subplot(2,3,5);
plot(roll{1}.Values.Time, roll{1}.Values.Data, 'LineWidth', 1.5); hold on;
plot(roll{2}.Values.Time, roll{2}.Values.Data, 'LineWidth', 1.5);
title('Kąt Roll');
xlabel('t [s]'); ylabel('rad');
legend('RL', 'PID', 'Location', 'best');
grid on;

% 6. Yaw
subplot(2,3,6);
plot(yaw{1}.Values.Time, yaw{1}.Values.Data, 'LineWidth', 1.5); hold on;
plot(yaw{2}.Values.Time, yaw{2}.Values.Data, 'LineWidth', 1.5);
title('Kąt Yaw');
xlabel('t [s]'); ylabel('rad');
legend('RL', 'PID', 'Location', 'best');
grid on;
%% Angles
analyze_leg_data(out.knee_angle_dataFL, out.hip_angle_dataFL)
analyze_leg_data(out.knee_angle_dataFR, out.hip_angle_dataFR)
analyze_leg_data(out.knee_angle_dataRL, out.hip_angle_dataRL)
analyze_leg_data(out.knee_angle_dataRR, out.hip_angle_dataRR)

function analyze_leg_data(knee_data_in, hip_data_in)
% ANALYZE_LEG_DATA Plots knee/hip angles and foot trajectory for RL vs PID.
%
%   Inputs:
%       knee_data_in: Cell array or struct containing {1} (RL) and {2} (PID) values
%       hip_data_in:  Cell array or struct containing {1} (RL) and {2} (PID) values
%
%   Note: This function assumes the existence of a 'kinematics(hip_angle, knee_angle)'
%   function in your path.

    %% Configuration (Time Windows)
    % Define the specific time slices for trajectory analysis here
    t_rl_start = 1.3;
    t_rl_end   = 1.57;
    
    t_pid_start = 3.0;
    t_pid_end   = 3.39;

    %% Data Extraction
    % Extracting Values assuming input format matches 'out.knee_angle_data'
    % Adjust indices {1} or {2} if your input order changes.
    knee_rl  = knee_data_in{1}.Values;
    knee_pid = knee_data_in{2}.Values;
    
    hip_rl  = hip_data_in{1}.Values;
    hip_pid = hip_data_in{2}.Values;

    %% Plot 1: Joint Angles
    figure('Name', 'Joint Angles Comparison', 'Color', 'w');
    
    % Subplot 1: Knee
    subplot(2,1,1)
    hold on;
    plot(knee_rl.Time, knee_rl.Data, 'LineWidth', 1.5)
    plot(knee_pid.Time, knee_pid.Data, 'LineWidth', 1.5)
    hold off
    title("Kąt złącza kolanowego")
    legend("RL", "PID")
    grid on;
    ylabel('Angle (rad)');

    % Subplot 2: Hip
    subplot(2,1,2)
    hold on;
    plot(hip_rl.Time, hip_rl.Data, 'LineWidth', 1.5)
    plot(hip_pid.Time, hip_pid.Data, 'LineWidth', 1.5)
    hold off
    title("Kąt złącza biodrowego")
    legend("RL", "PID")
    grid on;
    ylabel('Angle (rad)');
    xlabel('Time (s)');

    %% Kinematics Calculation
    
    % 1. Process RL Data
    k_rl = get_ts(knee_rl, t_rl_start, t_rl_end);
    h_rl = get_ts(hip_rl, t_rl_start, t_rl_end);
    
    [X1, Z1] = calculate_trajectory(h_rl.Data, k_rl.Data);

    % 2. Process PID Data
    k_pid = get_ts(knee_pid, t_pid_start, t_pid_end);
    h_pid = get_ts(hip_pid, t_pid_start, t_pid_end);
    
    [X2, Z2] = calculate_trajectory(h_pid.Data, k_pid.Data);

    %% Plot 2: Trajectories
    figure('Name', 'Foot Trajectory', 'Color', 'w'); 
    hold on; grid on; axis equal;
    
    % Plot RL (Red)
    plotTrajectoryWithArrows(X1, Z1, 10, 0.5, 'r', 'r');
    
    % Plot PID (Blue)
    plotTrajectoryWithArrows(X2, Z2, 10, 0.5, 'b', 'b');
    
    xlabel('X [m]');
    ylabel('Z [m]');
    title('Trajektoria stopy');
    % Create dummy lines for correct legend appearance regarding arrows
    h_rl_leg = plot(nan, nan, 'r', 'LineWidth', 2);
    h_pid_leg = plot(nan, nan, 'b', 'LineWidth', 2);
    legend([h_rl_leg, h_pid_leg], {'RL', 'PID'});

end

function [X, Z] = calculate_trajectory(hip_data, knee_data)
    % Loop through data points and call external kinematics function
    N = numel(knee_data);
    X = zeros(N,1);
    Z = zeros(N,1);
    for n = 1:N
        % NOTE: This requires your external 'kinematics.m' file
        [X(n), Z(n)] = kinematics(hip_data(n), knee_data(n));
    end
end

function t = get_ts(ts, min_t, max_t)
    % Slices a timeseries object based on time window
    mask = ts.Time >= min_t & ts.Time <= max_t;
    newTime = ts.Time(mask);
    newData = ts.Data(mask, :);
    t = timeseries(newData, newTime); 
end

function plotTrajectoryWithArrows(X, Z, K, arrow_scale, line_color, arrow_color)
    % Plots the line and adds direction arrows
    
    % ---- Direction vectors ----
    U = [diff(X); 0];
    V = [diff(Z); 0];
    
    % ---- Normalize arrows for equal size ----
    L = sqrt(U.^2 + V.^2);
    
    % Avoid division by zero
    with_len = L > 1e-6; 
    U_norm = zeros(size(U));
    V_norm = zeros(size(V));
    
    U_norm(with_len) = U(with_len) ./ L(with_len);
    V_norm(with_len) = V(with_len) ./ L(with_len);
    
    % ---- Arrow indices ----
    % Ensure we don't exceed bounds
    idx = 1:K:numel(X);
    if idx(end) > numel(U_norm)
        idx(end) = [];
    end
    
    % ---- Draw trajectory ----
    plot(X, Z, 'Color', line_color, 'LineWidth', 2);
    
    % ---- Draw arrows ----
    quiver(X(idx), Z(idx), U_norm(idx), V_norm(idx), arrow_scale, ...
           'Color', arrow_color, 'MaxHeadSize', 2, 'AutoScale', 'off');
end