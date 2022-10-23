clear all;

% Forward Kinematics

sin_1 = sym("s1");
sin_2 = sym("s2");
sin_3 = sym("s3");
sin_4 = sym("s4");
sin_5 = sym("s5");
cos_1 = sym("c1");
cos_2 = sym("c2");
cos_3 = sym("c3");
cos_4 = sym("c4");
cos_5 = sym("c5");

a_2 = sym("a2");
a_3 = sym("a3");
a_4 = sym("a4");
a_5 = sym("a5");

d_2 = sym("d2");
d_5 = sym("d5");


T_0_1 = [ cos_1, -sin_1,   0,     0; 
          sin_1,  cos_1,   0,     0; 
              0,      0,   1,     0; 
              0,      0,   0,     1];

T_1_2 = [ cos_2, -sin_2,   0,   a_2; 
              0,      0,  -1,  -d_2; 
          sin_2,  cos_2,   0,     0; 
              0,      0,   0,     1];

T_2_3 = [ cos_3, -sin_3,   0,   a_3; 
          sin_3,  cos_3,   0,     0; 
              0,      0,   1,     0; 
              0,      0,   0,     1];

T_3_4 = [ cos_4, -sin_4,   0,   a_4; 
          sin_4,  cos_4,   0,     0; 
              0,      0,   1,     0; 
              0,      0,   0,     1];

T_4_5 = [ cos_5, -sin_5,   0,   a_5; 
              0,      0,   1,   d_5; 
         -sin_5, -cos_5,   0,     0; 
              0,      0,   0,     1];

T_0_5 = T_0_1 * T_1_2 * T_2_3 * T_3_4 * T_4_5;

T_0_1
T_1_2
T_2_3
T_3_4
T_4_5
T_0_5


% Inverse Kinematics

% Position
x = sym("x");
y = sym("y");
z = sym("z");

t = [x;
     y;
     z];


% Orientation ZYX Euler
phi = sym("ph");
theta = sym("th");
psi = sym("ps");

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

R_z
R_y
R_x
R


% Substitute theta = 0 and psi = pi
R_sub = subs(R, ...
             [sin(theta), cos(theta), sin(psi), cos(psi)], ...
             [0, 1, 0, -1]);

R_sub

% Pose
H = [[R_sub; 0, 0, 0] [t; 1]];
H


% Solve

EQ = T_0_5 == H;
EQ

% solution = solve(EQ, [sin_1, sin_2, sin_3, sin_4, sin_5, ...
%                       cos_1, cos_2, cos_3, cos_4, cos_5]);
% solution
