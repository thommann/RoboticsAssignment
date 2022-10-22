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


% Equations

EQ = T_0_5 == H;

angles = [theta_1, theta_2, theta_3, theta_4, theta_5];


% Substitute

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

EQ_sub = subs(EQ, [sines cosines], substitutes);
EQ_sub


% Theta 5

EQ_5 = EQ_sub(1:3, :);
eq_5 = EQ_5(3, 1:2);
sol_5 = solve(eq_5, [sin_5, cos_5]);

sol_5

sol_sin_5 = sol_5.s5;
sol_cos_5 = sol_5.c5;


% Theta 1

EQ_1 = subs(EQ_5, [sin_5, cos_5], [sol_sin_5, sol_cos_5]);
eq_1 = EQ_1(1:2, 4);
sol_1 = solve(eq_1, [sin_1, cos_1]);

sol_1

sol_sin_1 = sol_1.s1;
sol_cos_1 = sol_1.c1;


% Theta 2

EQ_2 = subs(EQ_1, [sin_1, cos_1], [sol_sin_1, sol_cos_1]);
eq_2 = EQ_2(1:2, 3);
sol_2 = solve(eq_2, [sin_2, cos_2]);

sol_2

sol_sin_2 = sol_2.s2;
sol_cos_2 = sol_2.c2;


% Theta 3

EQ_3 = subs(EQ_2, [sin_2, cos_2], [sol_sin_2, sol_cos_2]);
eq_3 = EQ_3(1:2, 1);
sol_3 = solve(eq_3, [sin_3, cos_3]);

sol_3

sol_sin_3 = sol_3.s3;
sol_cos_3 = sol_3.c3;


% Theta 4

EQ_4 = subs(EQ_3, [sin_3, cos_3], [sol_sin_3, sol_cos_3]);
eq_4 = EQ_4(3, 3:4);
sol_4 = solve(eq_4, [sin_4, cos_4]);

sol_4

sol_sin_4 = sol_4.s4;
sol_cos_4 = sol_4.c4;

