classdef ACDC_single_phase_controller < handle
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        outer_controller
        inner_controller
        current_detector
        voltage_detector
        x2_filter
    end
    
    methods
        function obj = ACDC_single_phase_controller(outer_controller, inner_controller,...
                                                    current_detector, voltage_detector, x2_filter)
          
            obj.outer_controller = outer_controller;
            obj.inner_controller = inner_controller;
            obj.current_detector = current_detector;
            obj.voltage_detector = voltage_detector;
            obj.x2_filter = x2_filter;
        end
        
        function [ud, uq] = step(obj, x, t, v, V_rif, phi_rif)
            global x1ms x1phis vms vphis t_step Irifs u_hatds u_hatqs uds uqs verr id_err iq_err
            
            [x1d, x1q] = obj.current_detector.step(x(1), t);%calcolo componenti fase e quadratura x1
            [vd, vq] = obj.voltage_detector.step(v, t);%calcolo componenti fase e quadratura Va
            x2_avg = obj.x2_filter.step(x(2));
            
            I_rif = obj.outer_controller.step(V_rif -x2_avg);%controllore loop esterno
            
            %componenti fase e quadratura corrente riferimento 
            I_d = I_rif * cos(phi_rif);
            I_q = I_rif * sin(phi_rif);
            
            u_hat = obj.inner_controller.step([I_d-x1d; I_q-x1q]);%controllore loop interno
            
            %linerizzazione via feedback
            ud = (-u_hat(1) + vd)/x(2);
            uq = (-u_hat(2) + vq)/x(2);
            
            
            %segnali
            k = round(t/t_step) +1;
            x1ms(k) = sqrt(x1d^2 + x1q^2);
            x1phis(k) = atan2(x1q, x1d);
            vms(k) = sqrt(vd^2 + vq^2);
            vphis(k) = atan2(vq, vd);
            Irifs(k) = I_rif;
            verr(k) = V_rif -x2_avg;
            iq_err(k) = I_q-x1q; 
            id_err(k) = I_d-x1d;
            u_hatqs(k) = u_hat(2);
            u_hatds(k) = u_hat(1);
            uqs(k) = uq;
            uds(k) = ud;
            
        end
    end
end

