function [ud, uq] = get_feedforward(Vrif, phi_rif, R1, R2, L1, omega, Va, e)

x1m = 1/(2*R1)*(Va*cos(phi_rif)-sqrt(Va^2*cos(phi_rif)^2 - 8*R1*Vrif*(Vrif-e)/R2));
xd = x1m*cos(phi_rif);
xq = x1m*sin(phi_rif);

ud = -(omega*L1*xq-Va+R1*xd)/Vrif;
uq = -(-omega*L1*xd+R1*xq)/Vrif;

end

