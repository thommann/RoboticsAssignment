% Forward Kinematics

theta_1 = sym("t1");
theta_2 = sym("t2");
theta_3 = sym("t3");
theta_4 = sym("t4");
theta_5 = sym("t5");

a2 = 50;
a3 = 300;
a4 = 350;
a5 = 251;

d2 = 358.5;
d5 = 35.3;

T_0_1 = [ cos(theta_1), -sin(theta_1),   0,    0; 
          sin(theta_1),  cos(theta_1),   0,    0; 
                     0,             0,   1,    0; 
                     0,             0,   0,    1];

T_1_2 = [ cos(theta_2), -sin(theta_2),   0,   a2; 
                     0,             0,  -1,  -d2; 
          sin(theta_2),  cos(theta_2),   0,    0; 
                     0,             0,   0,    1];

T_2_3 = [ cos(theta_3), -sin(theta_3),   0,   a3; 
          sin(theta_3),  cos(theta_3),   0,    0; 
                     0,             0,   1,    0; 
                     0,             0,   0,    1];

T_3_4 = [ cos(theta_4), -sin(theta_4),   0,   a4; 
          sin(theta_4),  cos(theta_4),   0,    0; 
                     0,             0,   1,    0; 
                     0,             0,   0,    1];

T_4_5 = [ cos(theta_5), -sin(theta_5),   0,   a5; 
                     0,             0,   1,   d5; 
         -sin(theta_5), -cos(theta_5),   0,    0; 
                     0,             0,   0,    1];

T_0_5 = T_0_1 * T_1_2 * T_2_3 * T_3_4 * T_4_5;


% Inverse Kinematics

x = sym("x");
y = sym("y");
z = sym("z");
phi = sym("ph");
% theta = sym("th");
% psi = sym("ps");
theta = 0;
psi = 0;

pos_ori = [x, y, z, phi, theta, psi];

% position

M_translation = [1, 0, 0, x;
                 0, 1, 0, y;
                 0, 0, 1, z;
                 0, 0, 0, 1];

% orientation

M_rot_x = [         1,         0,           0, 0;
                    0,  cos(phi),    sin(phi), 0;
                    0, -sin(phi),    cos(phi), 0;
                    0,         0,           0, 1];

M_rot_y = [cos(theta),         0, -sin(theta), 0;
                    0,         1,           0, 0;
           sin(theta),         0,  cos(theta), 0;
                    0,         0,           0, 1];

M_rot_z = [  cos(psi), -sin(psi),           0, 0;
             sin(psi),  cos(psi),           0, 0;
                    0,         0,           1, 0;
                    0,         0,           0, 1];



M_pos_ori = M_rot_x * M_rot_y * M_rot_z * M_translation;


% Solve

EQ = T_0_5 == M_pos_ori;
EQ



