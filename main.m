close all;
params;

Nx = 3;
Nz = 12;
%Nz = 4;
Nu = 2;
Nq = 4;
T = 1/50;
omega=2*pi/T;

fs = 2.4e+3;
Ts = 1/fs;
h = Ts/100;
durata_simulazione = 20*T;

% Integrazione del modello con backward Eulero
M1 = inv(eye(Nx)-h*A);
M2 = C*M1*h*B+D;

x_0 = zeros(3, 1);
xprec=x_0;  % Inizializzazione dello stato al passo precedente
ind_fin=round(durata_simulazione/h);
x=zeros(Nx,ind_fin);     % Allocazione matrice di stato (per ogni colonna ho
                        %il valore dello stato x1,x2 all'istante k 
                        %e ho tante colonne quanti sono i passi di integrazione del modello)
z=zeros(Nz,ind_fin);
w = zeros(Nz, ind_fin);
u=zeros(Nu,ind_fin);
sig = zeros(Nq, ind_fin);
portante = zeros(1, ind_fin);
cont = zeros(1, ind_fin);
ums = zeros(1, ind_fin);
uphis = zeros(1, ind_fin);
qas = zeros(1, ind_fin);
qbs = zeros(1, ind_fin);
global x1ms x1phis vms vphis t_step Irifs u_hatds u_hatqs uds uqs verr id_err iq_err
t_step = h;
x1ms = zeros(1, ind_fin);
x1phis = zeros(1, ind_fin);
vms = zeros(1, ind_fin);
vphis = zeros(1, ind_fin);
Irifs = zeros(1, ind_fin);
u_hatds = zeros(1, ind_fin);
u_hatqs = zeros(1, ind_fin);
uds = zeros(1, ind_fin);
uqs = zeros(1, ind_fin);
verr = zeros(1, ind_fin);
id_err = zeros(1, ind_fin);
iq_err = zeros(1, ind_fin);

y(1)=0;
y = zeros(1, ind_fin);
m = zeros(1, ind_fin);

Vrif = 310;
phi_rif = 0.0;
get_controller;
modulator_state = Modulator_with_state();
nper = 1;
xprec=[0, Vrif, 0]';
for k = 2:ind_fin
    if 0%k == floor(ind_fin/2)
%         R2 = R2*2;
%         A = [
%         [-R1/L1,    0,      0],
%         [     0,    0,  -1/C2],
%         [     0, 1/L2, -R2/L2]
%        ];
%         M1 = inv(eye(Nx)-h*A);
%         M2 = C*M1*h*B+D;
        phi_rif = 0.05;
        %Vrif = 250;

    end
    u(1, k) = Va*cos(omega*k*h);
    u(2, k) = e;
 
    [ud, uq] = controller.step(xprec, k*h, u(1, k), Vrif, phi_rif);
        
    u_m = sqrt(ud^2 + uq^2);%ampiezza segnale di controllo
    u_phi = atan2(uq, ud);%fase segnale di controllo
    ums(k) = u_m;
    uphis(k) = u_phi;
    
    cont(k) = u_m * cos(omega*k*h + u_phi);%segnale di controllo
    ums(k) = u_m;
    %[qa, qb] = modulator(cont(k), k*h, Ts);
    [qa, qb] = modulator_state.step(cont(k), k*h, Ts);
    qas(k) = qa;
    qbs(k) = qb;
    
    sig(1, k) = qa;%qa+
    sig(2, k) = 1-qa;%qa-
    sig(3, k) = qb;%qb+
    sig(4, k) = 1-qb;%qb-
    %sig(:, k) = 0;
    
    % Integrazione modello con algoritmo di Lemke
    q_k = C * M1 * xprec + ( C * M1 * h * E + F ) * u(:, k) + [ C * M1 * h * G + H ] * sig(:, k);
    [z(:,k),err] = LEMKE(M2, q_k);
    
    % Aggiornamento dello stato
    x(:,k) = M1 * ( xprec + h * B * z(:,k) + h * E * u(:, k) + h * G * sig(:, k));
    w(:,k)=C*x(:,k)+D*z(:,k)+F*u(:, k)  + H * sig(:, k);
    
    xprec = x(:,k);
end

tempo = h:h:ind_fin*h;

figure;
plot(tempo, x);
hold on;
plot(tempo, u(1, :));
legend('corrente ingresso', 'tensione capacità', 'corrente induttore', 'tensione ingresso');
xlabel('tempo[s]');
set (gca,'XMinorTick','on','XMinorGrid','on','YMinorTick','on',...
'YMinorGrid','on','GridLineStyle',':');
grid on; box on; set (gca,'FontSize',11);

global tempo1
tempo1 = tempo(1:end);
tempo1(end+1) = tempo1(end)+h;

figure;
plot(tempo1, x1phis);
legend('fase x1');
xlabel('tempo[s]');
set (gca,'XMinorTick','on','XMinorGrid','on','YMinorTick','on',...
'YMinorGrid','on','GridLineStyle',':');
grid on; box on; set (gca,'FontSize',11);

figure;
plot(tempo1, x1ms);
legend('ampiezza x1');
xlabel('tempo[s]');
set (gca,'XMinorTick','on','XMinorGrid','on','YMinorTick','on',...
'YMinorGrid','on','GridLineStyle',':');
grid on; box on; set (gca,'FontSize',11);

figure;
plot(tempo1, vms);
hold on;
plot(tempo1, vphis);
legend('ampiezza v', 'fase v');
xlabel('tempo[s]');
set (gca,'XMinorTick','on','XMinorGrid','on','YMinorTick','on',...
'YMinorGrid','on','GridLineStyle',':');
grid on; box on; set (gca,'FontSize',11);

figure;
plot(tempo1, Irifs);
legend('corrente rif');
xlabel('tempo[s]');
set (gca,'XMinorTick','on','XMinorGrid','on','YMinorTick','on',...
'YMinorGrid','on','GridLineStyle',':');
grid on; box on; set (gca,'FontSize',11);

figure;
plot(tempo, ums);
hold on;
plot(tempo, uphis);
legend('ampiezza controllo', 'fase cotrollo');
xlabel('tempo[s]');
set (gca,'XMinorTick','on','XMinorGrid','on','YMinorTick','on',...
'YMinorGrid','on','GridLineStyle',':');
grid on; box on; set (gca,'FontSize',11);

figure;
plot(tempo1, u_hatds);
hold on;
plot(tempo1, u_hatqs);
legend('uhat_d', 'uhat_q');
xlabel('tempo[s]');
set (gca,'XMinorTick','on','XMinorGrid','on','YMinorTick','on',...
'YMinorGrid','on','GridLineStyle',':');
grid on; box on; set (gca,'FontSize',11);

figure;
plot(tempo1, uds);
hold on;
plot(tempo1, uqs);
legend('u_d', 'u_q');
xlabel('tempo[s]');
set (gca,'XMinorTick','on','XMinorGrid','on','YMinorTick','on',...
'YMinorGrid','on','GridLineStyle',':');
grid on; box on; set (gca,'FontSize',11);

figure;
plot(tempo1, verr);
legend('errore x2');
xlabel('tempo[s]');
set (gca,'XMinorTick','on','XMinorGrid','on','YMinorTick','on',...
'YMinorGrid','on','GridLineStyle',':');
grid on; box on; set (gca,'FontSize',11);

figure;
plot(tempo1, iq_err);
legend('errore iq');
xlabel('tempo[s]');
set (gca,'XMinorTick','on','XMinorGrid','on','YMinorTick','on',...
'YMinorGrid','on','GridLineStyle',':');
grid on; box on; set (gca,'FontSize',11);

figure;
plot(tempo1, id_err);
legend('errore id');
xlabel('tempo[s]');
set (gca,'XMinorTick','on','XMinorGrid','on','YMinorTick','on',...
'YMinorGrid','on','GridLineStyle',':');
grid on; box on; set (gca,'FontSize',11);

