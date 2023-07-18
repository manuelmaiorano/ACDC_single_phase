L1 = 0.5e-3;
L2 = 6.53e-3;
R1 = 1;
R2 = 7.255;
C2 = 3.2e-3;
e = 50;
Va = 220*sqrt(2);
Vp = 1;
i_max = 10e10;

A = [
        [-R1/L1,    0,      0],
        [     0,    0,  -1/C2],
        [     0, 1/L2, -R2/L2]
       ];
   
B = [
        [    0, -1/L1,    0,  1/L1,     0,    0,     0, 0, 0, 0, 0, 0],
        [ 1/C2,     0, 1/C2,     0,  -1/C2,   0, -1/C2, 0, 0, 0, 0, 0],
        [    0,     0,    0,     0,      0,   0,     0, 0, 0, 0, 0, 0]
      ];
  
C = [
    [ 0, 1, 0],
    [-1, 0, 0],
    [ 0, 1, 0],
    [ 1, 0, 0],
    [ 0, -1, 0],
    [0, 0, 0],
    [ 0, -1, 0],
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0],
    ];
D = [ 0 -1 0  0  0 0 0 0 0 0 0 0;
    1  0 0  0 -1 1 0 0 0 0 0 0;
    0  0 0 -1 0 0 0 0 0 0 0 0;
    0 0 1 0 0 0 -1 1 0 0 0 0;
    0 1 0 0 0 0 0 0 1 0 0 0;
    0 -1 0 0 0 0 0 0 0 1 0 0;
    0 0 0 1 0 0 0 0 0 0 1 0;
    0 0 0 -1 0 0 0 0 0 0 0 1;
    0 0 0 0 -1 0 0 0 0 0 0 0;
    0 0 0 0 0 -1 0 0 0 0 0 0;
    0 0 0 0 0 0 -1 0 0 0 0 0;
    0 0 0 0 0 0 0 -1 0 0 0 0];

E = [1/L1, 0;
    0, 0;
    0, -1/L2];

F = zeros([12, 2]);
G = zeros([3, 4]);
    
H = [
        [    0,         0,         0,         0],
        [    0,         0,         0,         0],
        [    0,         0,         0,         0],
        [    0,         0,         0,         0],
        [    0,         0,         0,         0],
        [    0,         0,         0,         0],
        [    0,         0,         0,         0],
        [    0,         0,         0,         0],
        [i_max,         0,         0,         0],
        [    0,     i_max,         0,         0],
        [    0,         0,     i_max,         0],
        [    0,         0,         0,     i_max]
    ];


parameters.L1 = L1;
parameters.L2 = L2;
parameters.R1 = R1;
parameters.R2 = R2;
parameters.C2 = C2;
parameters.e = e;
parameters.Va = Va;


B = [
        [    0, -1/L1,    0,  1/L1],
        [ 1/C2,     0, 1/C2,     0],
        [    0,     0,    0,     0]
      ];




C = [
    [ 0, 1, 0],
    [-1, 0, 0],
    [ 0, 1, 0],
    [ 1, 0, 0]
    ];


D = [ 0 -1 0  0;
    1  0 0  0 ;
    0  0 0 -1 ;
    0 0 1 0 ;];

F = zeros([4, 2]);

G = i_max * [0 0 0 0 ; -1/C2 0 -1/C2 0; 0 0 0 0];


H = i_max * [0 0 0 0 ; -1 1 0 0; 0 0 0 0; 0 0 -1 1];


