%% Simscape sim of Cart
clear

%% parameters of system

% Lengths
    l_p     = 0.35;      %[m]
    l_p_com = 0.1791;    %[m] pendulum center of mass
    l_t     = 1.72;      %[m] track length 

% damping coeff
    b_c     = 5;         % [N/(m/s)]
    b_p     = 0.0012;    % [N/(m/s)]

% mass
    m_c     = 0.5;       %[kg]
    m_p     = 0.084;     %[kg]
    
% other forces
    g       = 9.82;      %[m/s^2]

%% run simscape

open_system('sim/Pend_cart');