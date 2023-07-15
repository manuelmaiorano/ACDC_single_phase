classdef Modulator_with_state < handle
    
    properties
        state
        state_first_tau0
    end
    
    methods
        function obj = Modulator_with_state()
            obj.state = [0, 0];
            obj.state_first_tau0 = [0, 0];
        end
        
        function [qa, qb] = step(obj, u, t, h)
            t_rel = t - (floor(t/h) * h);%istante di tempo relativo all interno di h
            u = bound(u, -1, 1);%limita la u tra -1 e 1
            
            tau = abs(u) * h;%percentuale  del tempo in cui qa qb = 1 0 o 0 1
            tau0 = h-tau;%intervallo di tempo rimanenete qa qb 1 1 o 0 0
            if t_rel < tau0/2%primo intervallo
                obj.state = obj.state;%lasciamo invariati gli q
                obj.state_first_tau0 = obj.state;%salviamo gli stati nel primo intervallo
            elseif t_rel > tau0/2 && t_rel < tau0/2+tau%intervallo intermedio
                
                if u > 0
                    obj.state = [1, 0];
                else
                    obj.state = [0, 1];
                end
            else%intervallo finale
                %cummutiamo gli switch rispetto al primo intervallo
                if isequal(obj.state_first_tau0, [0, 0])
                    obj.state = [1, 1];
                else
                    obj.state = [0, 0];
                end
            end
               
            qa = obj.state(1);
            qb = obj.state(2);
               
        end
    end
end

