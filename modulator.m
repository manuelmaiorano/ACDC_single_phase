function [qa, qb] = modulator(u, t, h)
    %dato l'ingresso u corrente restituisce i segnali di controllo degli
    %switch
    
    t_rel = t - (floor(t/h) * h);%istante di tempo relativo
    u = bound(u, -1, 1);%limitare tra 1 e -1 il segnale u
    
    if u > 0
        if t_rel< u*h%percentuale u del tempo
            qa = 1;
            qb = 0;
        else%percentuale 1-u del tempo
            qa = 0;
            qb = 0;
        end
    else
        if t_rel< -u*h%percentuale abs(u) del tempo
            qa = 0;
            qb = 1;
        else%percentuale 1-abs(u) del tempo
            qa = 0;
            qb = 0;
        end
    end
end

