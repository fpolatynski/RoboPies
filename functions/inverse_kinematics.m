function [phi1, phi2] = inverse_kinematics(h)
    l1 = evalin('base', 'upper_leg');
    l1 = l1(1);
    l2 = evalin('base', 'lower_leg');
    l2 = l2(1);


    phi1 = -acos((l1^2+h^2-l2^2)/(2*l1*h));
    phi2 = pi-acos((l1^2+l2^2-h^2)/(2*l1*l2));
end