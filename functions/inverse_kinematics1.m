function [phi1, phi2] = inverse_kinematics1(x, z)
    l1 = evalin('base', 'upper_leg');
    l1 = l1(1);
    l2 = evalin('base', 'lower_leg');
    l2 = l2(1);
    l_sq = z^2 + x^2;
    l = sqrt(l_sq);
    beta = acos((l1^2+l2^2-l_sq)/(2*l1*l2));
    phi2 = pi-beta;
    alfa1 = -l2*sin(beta)/l;
    alfa2 = acos(-z/l);
    if x < 0
        alfa2 =- alfa2;
    end
    phi1 = alfa1 + alfa2;
    [phi1, phi2]
end