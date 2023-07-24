close all
figure;
plot(t, x, 'LineWidth', 2);
hold on;
plot(t, Va*cos(omega*t), 'LineWidth', 2);
legend('Corrente x_1', 'Tensione x_2', 'Corrente x_3', 'Tensione in ingresso');
xlabel('Tempo [s]');
set (gca,'XMinorTick','on','XMinorGrid','on','YMinorTick','on',...
'YMinorGrid','on','GridLineStyle',':');
grid on; box on; set (gca,'FontSize',12);

global tempo1
tempo1 = t(1:end);
tempo1(end+1) = tempo1(end)+h;

figure;
plot(tempo1, x1ms, 'LineWidth', 2);
xlabel('Tempo [s]');
set (gca,'XMinorTick','on','XMinorGrid','on','YMinorTick','on',...
'YMinorGrid','on','GridLineStyle',':');
grid on; box on; set (gca,'FontSize',12);

figure;
plot(tempo1, x1phis, 'LineWidth', 2);
xlabel('Tempo [s]');
set (gca,'XMinorTick','on','XMinorGrid','on','YMinorTick','on',...
'YMinorGrid','on','GridLineStyle',':');
grid on; box on; set (gca,'FontSize',12);

t_start = Ts*100; t_end = t_start + 2* Ts;
idx = round(t_start/t_step) +1;
tau = conts(idx)*Ts;
tau0 = Ts-tau;
middle = t_start + Ts;

tau1 = conts(idx+floor(Ts/t_step))*Ts;
tau01 = Ts-tau;

figure;
subplot(2,1,1);
plot(tempo1, qas, 'LineWidth', 2); hold on;
plot([middle, middle], [0, 1], 'black--', 'LineWidth', 2);

title('Segnale q_a');
xlabel('tempo[s]');
xlim([t_start, t_end]);
set (gca,'XMinorTick','on','XMinorGrid','on','YMinorTick','on',...
'YMinorGrid','on','GridLineStyle',':');
grid on; box on; set (gca,'FontSize',11);

subplot(2,1,2);
plot(tempo1, qbs, 'LineWidth', 2); hold on;
plot([middle, middle], [0, 1], 'black--', 'LineWidth', 2);

title('Segnale q_b');
xlabel('tempo[s]');
xlim([t_start, t_end]);
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
plot(tempo1, ums);
hold on;
plot(tempo1, uphis);
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