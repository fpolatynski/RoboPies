function in = reset_height(in)
    z0 = evalin('base', 'z0');
    r = rand;
    bound = [-0.03 0.01];
    robot_offset = r * (bound(2) - bound(1)) + bound(1);
    [phi1, phi2] = inverse_kinematics(-z0 + robot_offset);
    disp(robot_offset);
    in = setVariable(in, 'robot_offset', robot_offset);
    in = setVariable(in, 'initial_hip_angle', phi1);
    in = setVariable(in, 'initial_knee_angle', phi2);
end