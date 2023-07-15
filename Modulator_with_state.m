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
            t_rel = t - (floor(t/h) * h);%istante di tempo relativo
            u = bound(u, -1, 1);
            
            tau = abs(u) * h;
            tau0 = h-tau;
            if t_rel < tau0/2
                obj.state = obj.state;
                obj.state_first_tau0 = obj.state;
            elseif t_rel > tau0/2 && t_rel < tau0/2+tau
                
                if u > 0
                    obj.state = [1, 0];
                else
                    obj.state = [0, 1];
                end
            else
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

