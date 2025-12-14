function [x, z] = kinematics(hip_angle, knee_angle)
    l1 = evalin('base', 'upper_leg');
    l1 = l1(1);
    l2 = evalin('base', 'lower_leg');
    l2 = l2(1);
    T01 = [1, 0, 0, 0; 0, cos(pi/2), -sin(pi/2), 0; 0, sin(pi/2), cos(pi/2), 0; 0, 0, 0, 1];
    T12 = [cos(hip_angle), -sin(hip_angle), 0, 0; sin(hip_angle), cos(hip_angle), 0, 0; 
        0, 0, 1, 0; 0, 0, 0, 1];
    T23 = [cos(knee_angle), -sin(knee_angle), 0, 0; sin(knee_angle), cos(knee_angle), 0, -l1; 
        0, 0, 1, 0; 0, 0, 0, 1];
    T34 = [1 0 0 0; 0 1 0 -l2; 0 0 1 0; 0 0 0 1];

    T = T01 * T12 * T23 * T34;
    
    x = T(1, 4);
    z = T(3, 4); 
end