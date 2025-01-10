function [Cl, Cd] = compute_lift_drag(p, tau1, tau2, n1, n2, X, Y)
    % Constants
    alpha_deg = 0;  % Angle of attack in degrees (can be modified)
    alpha_rad = deg2rad(alpha_deg);
    u_inf = 1;
    rho_inf = 1;
    q_inf = 0.5 * rho_inf * u_inf^2;
    S_gamma = 1;
    n_inf = [-sin(alpha_rad), cos(alpha_rad)];
    t_inf = [cos(alpha_rad), sin(alpha_rad)];

    % Number of edges
    num_edges = length(p) - 1;

    % Initialize integrals
    integral_lift = 0;
    integral_drag = 0;

    % Loop over edges
    for i = 1:num_edges
        % Function values on Nodes of the edge
        x1 = X(i); y1 = Y(i);
        x2 = X(i+1); y2 = Y(i+1);
        p1 = p(i); p2 = p(i+1);
        tau1_1 = tau1(i); tau1_2 = tau1(i+1);
        tau2_1 = tau2(i); tau2_2 = tau2(i+1);
        n1_1 = n1(i); n1_2 = n1(i+1);
        n2_1 = n2(i); n2_2 = n2(i+1);

        % Shape functions and Jacobian
        J = sqrt(0.25 * ((x2 - x1)^2) + 0.25 * ((y2 - y1)^2));

        % Stress tensor components
        sigma1_w1 = -p1 * n1_1 + tau1_1;
        sigma1_w2 = -p2 * n1_2 + tau1_2;
        sigma2_w1 = -p1 * n2_1 + tau2_1;
        sigma2_w2 = -p2 * n2_2 + tau2_2;

        % Average stress tensor components
        sigma1_w = (sigma1_w1 + sigma1_w2) / 2;
        sigma2_w = (sigma2_w1 + sigma2_w2) / 2;

        % Contribution to lift and drag integrals
         w = 2;  % Gaussian quadrature weight
         integral_lift = integral_lift + ((sigma1_w * n_inf(1) + sigma2_w * n_inf(2)) * w * J);
         integral_drag = integral_drag + ((sigma1_w * t_inf(1) + sigma2_w * t_inf(2)) * w * J);
    end

    % Compute Cl and Cd
    Cl = -1*integral_lift / (q_inf * S_gamma);
    Cd = -1*integral_drag / (q_inf * S_gamma);
end