function [x, z] = leg_inverse_kinematics(hip_angle, knee_angle)
    z1 = upper_leg(1) * cos(hip_angle);
    x1 = upper_leg(1) * sin(hip_angle);
    z = z1 + lower_leg(1) * cos(knee_angle - hip_angle) - feet_radius;
    x = x1 + lower_leg(2) * sin(knee_angle - hip_angle);
end