clear all;

% Part B

syms s1 s2 s3 s4 s5 c1 c2 c3 c4 c5 d1 a1 a2 a3 d4 d5;


T_0_1 = [ c1, -s1,   0,     0; 
          s1,  c1,   0,     0; 
           0,   0,   1,    d1; 
           0,   0,   0,     1];

T_1_2 = [ c2, -s2,   0,    a1; 
           0,   0,   1,     0; 
         -s2, -c2,   0,     0; 
           0,   0,   0,     1];

T_2_3 = [ c3, -s3,   0,    a2; 
          s3,  c3,   0,     0; 
           0,   0,   1,     0; 
           0,   0,   0,     1];

T_3_4 = [ c4, -s4,   0,    a3; 
          s4,  c4,   0,     0;
           0,   0,   1,    d4; 
           0,   0,   0,     1];

T_4_5 = [ c5, -s5,   0,     0; 
           0,   0,  -1,   -d5; 
          s5,  c5,   0,     0; 
           0,   0,   0,     1];

T_0_5 = T_0_1 * T_1_2 * T_2_3 * T_3_4 * T_4_5;
T_0_5

% Part C

% Position
syms x y z;

t = [x;
     y;
     z];

% Orientation ZYX Euler
syms phi theta psi;

R_z = [   cos(phi), -sin(phi),           0;
          sin(phi),  cos(phi),           0;
                 0,         0,           1];

R_y = [ cos(theta),         0,  sin(theta);
                 0,         1,           0;
       -sin(theta),         0,  cos(theta)];

R_x = [          1,         0,           0;
                 0,  cos(psi),   -sin(psi);
                 0,  sin(psi),    cos(psi)];

R = R_z * R_y * R_x;

% Substitute theta = 0 and psi = pi
R = subs(R, ...
         [sin(theta), cos(theta), sin(psi), cos(psi)], ...
         [0, 1, 0, -1]);

% Pose
H = [[R; 0, 0, 0] [t; 1]];
H

% Equations
EQ = T_0_5 == H;
EQ

% solution = solve(EQ, [s1, s2, s3, s4, s5, c1, c2, c3, c4, c5]);
% solution





