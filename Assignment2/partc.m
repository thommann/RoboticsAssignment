% Forward Kinematics

theta_1 = sym("t1");
theta_2 = sym("t2");
theta_3 = sym("t3");
theta_4 = sym("t4");
theta_5 = sym("t5");

% a_2 = 50;
% a_3 = 300;
% a_4 = 350;
% a_5 = 251;
% 
% d_2 = 358.5;
% d_5 = 35.3;

a_2 = sym("a2");
a_3 = sym("a3");
a_4 = sym("a4");
a_5 = sym("a5");

d_2 = sym("d2");
d_5 = sym("d5");

T_0_1 = [ cos(theta_1), -sin(theta_1),   0,    0; 
          sin(theta_1),  cos(theta_1),   0,    0; 
                     0,             0,   1,    0; 
                     0,             0,   0,    1];

T_1_2 = [ cos(theta_2), -sin(theta_2),   0,   a_2; 
                     0,             0,  -1,  -d_2; 
          sin(theta_2),  cos(theta_2),   0,    0; 
                     0,             0,   0,    1];

T_2_3 = [ cos(theta_3), -sin(theta_3),   0,   a_3; 
          sin(theta_3),  cos(theta_3),   0,    0; 
                     0,             0,   1,    0; 
                     0,             0,   0,    1];

T_3_4 = [ cos(theta_4), -sin(theta_4),   0,   a_4; 
          sin(theta_4),  cos(theta_4),   0,    0; 
                     0,             0,   1,    0; 
                     0,             0,   0,    1];

T_4_5 = [ cos(theta_5), -sin(theta_5),   0,   a_5; 
                     0,             0,   1,   d_5; 
         -sin(theta_5), -cos(theta_5),   0,    0; 
                     0,             0,   0,    1];

T_0_5 = T_0_1 * T_1_2 * T_2_3 * T_3_4 * T_4_5;


% Substitute sines and cosines

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

sines =    [sin(theta_1), ...
            sin(theta_2), ...
            sin(theta_3), ...
            sin(theta_4), ...
            sin(theta_5)];

cosines =  [cos(theta_1), ...
            cos(theta_2), ...
            cos(theta_3), ...
            cos(theta_4), ...
            cos(theta_5)];

substitutes = [sin_1, sin_2, sin_3, sin_4, sin_5, ...
                cos_1, cos_2, cos_3, cos_4, cos_5];

T_0_1_sub = subs(T_0_1, [sines cosines], substitutes);
T_0_1_sub

T_1_2_sub = subs(T_1_2, [sines cosines], substitutes);
T_1_2_sub

T_2_3_sub = subs(T_2_3, [sines cosines], substitutes);
T_2_3_sub

T_3_4_sub = subs(T_3_4, [sines cosines], substitutes);
T_3_4_sub

T_4_5_sub = subs(T_4_5, [sines cosines], substitutes);
T_4_5_sub

T_0_5_sub = subs(T_0_5, [sines cosines], substitutes);
T_0_5_sub


% Inverse Kinematics

x = sym("x");
y = sym("y");
z = sym("z");
phi = sym("ph");
theta = sym("th");
psi = sym("ps");
% theta = 0;
% psi = sym("pi");
% psi = pi;

pos_ori = [x, y, z, phi, theta, psi];


% Position

t = [x;
     y;
     z];


% Orientation

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


% Pose

H = [[R; 0, 0, 0] [t; 1]];


% Substitute theta = 0 and psi = pi

H_sub = ...
    subs(H, [sin(theta), cos(theta), sin(psi), cos(psi)], [0, 1, 0, -1]);
H_sub

% Solve

EQ = T_0_5_sub == H_sub;
EQ

% Theta 1
eqs_1 = EQ(1:2, 1);
sol_1 = solve(eqs_1, [sin_1, cos_1]);
sol_1

sol_1_sin = sol_1.s1;
sol_1_cos = sol_1.c1;

% Theta 2
eqs_2 = EQ(3, 3:4);
sol_2 = solve(eqs_2, [sin_2, cos_2]);
sol_2

sol_2_sin = sol_2.s2;
sol_2_cos = sol_2.c2;

% Theta 3
eqs_3 = EQ(1, 3:4);
sol_3 = solve(eqs_3, [sin_3, cos_3]);
sol_3

sol_3_sin = sol_3.s3;
sol_3_cos = sol_3.c3;

% Theta 4
eqs_4 = EQ(2, 3:4);
sol_4 = solve(eqs_4, [sin_4, cos_4]);
sol_4

sol_4_sin = sol_4.s4;
sol_4_cos = sol_4.c4;

% Theta 5
eqs_5 = EQ(1:2, 2);
sol_5 = solve(eqs_5, [sin_5, cos_5]);
sol_5

sol_5_sin = sol_5.s5;
sol_5_cos = sol_5.c5;

% Substitute

% Theta 1
sin_2_sub = subs(sol_2_sin, [sin_1, cos_1], [sol_1_sin, sol_1_cos]);
cos_2_sub = subs(sol_2_cos, [sin_1, cos_1], [sol_1_sin, sol_1_cos]);

sin_3_sub = subs(sol_3_sin, [sin_1, cos_1], [sol_1_sin, sol_1_cos]);
cos_3_sub = subs(sol_3_cos, [sin_1, cos_1], [sol_1_sin, sol_1_cos]);

sin_4_sub = subs(sol_4_sin, [sin_1, cos_1], [sol_1_sin, sol_1_cos]);
cos_4_sub = subs(sol_4_cos, [sin_1, cos_1], [sol_1_sin, sol_1_cos]);

sin_5_sub = subs(sol_5_sin, [sin_1, cos_1], [sol_1_sin, sol_1_cos]);
cos_5_sub = subs(sol_5_cos, [sin_1, cos_1], [sol_1_sin, sol_1_cos]);


% Theta 2
sin_1_sub = subs(sol_1_sin, [sin_2, cos_2], [sin_2_sub, cos_2_sub]);
cos_1_sub = subs(sol_1_cos, [sin_2, cos_2], [sin_2_sub, cos_2_sub]);

sin_3_sub = subs(sin_3_sub, [sin_2, cos_2], [sin_2_sub, cos_2_sub]);
cos_3_sub = subs(cos_3_sub, [sin_2, cos_2], [sin_2_sub, cos_2_sub]);

sin_4_sub = subs(sin_4_sub, [sin_2, cos_2], [sin_2_sub, cos_2_sub]);
cos_4_sub = subs(cos_4_sub, [sin_2, cos_2], [sin_2_sub, cos_2_sub]);

sin_5_sub = subs(sin_5_sub, [sin_2, cos_2], [sin_2_sub, cos_2_sub]);
cos_5_sub = subs(cos_5_sub, [sin_2, cos_2], [sin_2_sub, cos_2_sub]);

sin_1_sub = simplify(sin_1_sub);
cos_1_sub = simplify(cos_1_sub);
sin_2_sub = simplify(sin_2_sub);
cos_2_sub = simplify(cos_2_sub);
sin_3_sub = simplify(sin_3_sub);
cos_3_sub = simplify(cos_3_sub);
sin_4_sub = simplify(sin_4_sub);
cos_4_sub = simplify(cos_4_sub);
sin_5_sub = simplify(sin_5_sub);
cos_5_sub = simplify(cos_5_sub);

sin_1_sub
cos_1_sub
sin_2_sub
cos_2_sub
sin_3_sub
cos_3_sub
sin_4_sub
cos_4_sub
sin_5_sub
cos_5_sub


% Theta 3
sin_1_sub = subs(sin_1_sub, [sin_3, cos_3], [sin_3_sub, cos_3_sub]);
cos_1_sub = subs(cos_1_sub, [sin_3, cos_3], [sin_3_sub, cos_3_sub]);

sin_2_sub = subs(sin_2_sub, [sin_3, cos_3], [sin_3_sub, cos_3_sub]);
cos_2_sub = subs(cos_2_sub, [sin_3, cos_3], [sin_3_sub, cos_3_sub]);

sin_4_sub = subs(sin_4_sub, [sin_3, cos_3], [sin_3_sub, cos_3_sub]);
cos_4_sub = subs(cos_4_sub, [sin_3, cos_3], [sin_3_sub, cos_3_sub]);

sin_5_sub = subs(sin_5_sub, [sin_3, cos_3], [sin_3_sub, cos_3_sub]);
cos_5_sub = subs(cos_5_sub, [sin_3, cos_3], [sin_3_sub, cos_3_sub]);

sin_1_sub = simplify(sin_1_sub);
cos_1_sub = simplify(cos_1_sub);
sin_2_sub = simplify(sin_2_sub);
cos_2_sub = simplify(cos_2_sub);
sin_3_sub = simplify(sin_3_sub);
cos_3_sub = simplify(cos_3_sub);
sin_4_sub = simplify(sin_4_sub);
cos_4_sub = simplify(cos_4_sub);
sin_5_sub = simplify(sin_5_sub);
cos_5_sub = simplify(cos_5_sub);

sin_1_sub
cos_1_sub
sin_2_sub
cos_2_sub
sin_3_sub
cos_3_sub
sin_4_sub
cos_4_sub
sin_5_sub
cos_5_sub


% Theta 4
sin_1_sub = subs(sin_1_sub, [sin_4, cos_4], [sin_4_sub, cos_4_sub]);
cos_1_sub = subs(cos_1_sub, [sin_4, cos_4], [sin_4_sub, cos_4_sub]);

sin_2_sub = subs(sin_2_sub, [sin_4, cos_4], [sin_4_sub, cos_4_sub]);
cos_2_sub = subs(cos_2_sub, [sin_4, cos_4], [sin_4_sub, cos_4_sub]);

sin_3_sub = subs(sin_3_sub, [sin_4, cos_4], [sin_4_sub, cos_4_sub]);
cos_3_sub = subs(cos_3_sub, [sin_4, cos_4], [sin_4_sub, cos_4_sub]);

sin_5_sub = subs(sin_5_sub, [sin_4, cos_4], [sin_4_sub, cos_4_sub]);
cos_5_sub = subs(cos_5_sub, [sin_4, cos_4], [sin_4_sub, cos_4_sub]);

sin_1_sub = simplify(sin_1_sub);
cos_1_sub = simplify(cos_1_sub);
sin_2_sub = simplify(sin_2_sub);
cos_2_sub = simplify(cos_2_sub);
sin_3_sub = simplify(sin_3_sub);
cos_3_sub = simplify(cos_3_sub);
sin_4_sub = simplify(sin_4_sub);
cos_4_sub = simplify(cos_4_sub);
sin_5_sub = simplify(sin_5_sub);
cos_5_sub = simplify(cos_5_sub);

sin_1_sub
cos_1_sub
sin_2_sub
cos_2_sub
sin_3_sub
cos_3_sub
sin_4_sub
cos_4_sub
sin_5_sub
cos_5_sub


% Theta 5
sin_1_sub = subs(sin_1_sub, [sin_5, cos_5], [sin_5_sub, cos_5_sub]);
cos_1_sub = subs(cos_1_sub, [sin_5, cos_5], [sin_5_sub, cos_5_sub]);

sin_2_sub = subs(sin_2_sub, [sin_5, cos_5], [sin_5_sub, cos_5_sub]);
cos_2_sub = subs(cos_2_sub, [sin_5, cos_5], [sin_5_sub, cos_5_sub]);

sin_3_sub = subs(sin_3_sub, [sin_5, cos_5], [sin_5_sub, cos_5_sub]);
cos_3_sub = subs(cos_3_sub, [sin_5, cos_5], [sin_5_sub, cos_5_sub]);

sin_4_sub = subs(sin_4_sub, [sin_5, cos_5], [sin_5_sub, cos_5_sub]);
cos_4_sub = subs(cos_4_sub, [sin_5, cos_5], [sin_5_sub, cos_5_sub]);

sin_1_sub = simplify(sin_1_sub);
cos_1_sub = simplify(cos_1_sub);
sin_2_sub = simplify(sin_2_sub);
cos_2_sub = simplify(cos_2_sub);
sin_3_sub = simplify(sin_3_sub);
cos_3_sub = simplify(cos_3_sub);
sin_4_sub = simplify(sin_4_sub);
cos_4_sub = simplify(cos_4_sub);
sin_5_sub = simplify(sin_5_sub);
cos_5_sub = simplify(cos_5_sub);

sin_1_sub
cos_1_sub
sin_2_sub
cos_2_sub
sin_3_sub
cos_3_sub
sin_4_sub
cos_4_sub
sin_5_sub
cos_5_sub
%






