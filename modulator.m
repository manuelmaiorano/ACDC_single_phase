function [qa, qb] = modulator(u, t, h)
    
    t_rel = t - (floor(t/h) * h);
    u = bound(u, -1, 1);
    
    if u > 0
        if t_rel< u*h
            qa = 1;
            qb = 0;
        else
            qa = 0;
            qb = 0;
        end
    else
        if t_rel< -u*h
            qa = 0;
            qb = 1;
        else
            qa = 0;
            qb = 0;
        end
    end
end

