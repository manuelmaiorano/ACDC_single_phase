classdef ACDC_single_phase_controller < handle
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        outer_controller
        inner_controller
        current_detector
        voltage_detector
    end
    
    methods
        function obj = ACDC_single_phase_controller(outer_controller, inner_controller,...
                                                    current_detector, voltage_detector)
          
            obj.outer_controller = outer_controller;
            obj.inner_controller = inner_controller;
            obj.current_detector = current_detector;
            obj.voltage_detector = voltage_detector;
        end
        
        function [ur, ui] = step(obj, x, t, v, V_rif, phi_rif)
            global x1ms x1phis vms vphis t_step Irifs u_hatrs u_hatis urs uis verr ir_err iI_err
            
            [x1r, x1i] = obj.current_detector.step(x(1), t);%calcolo componenti fase e quadratura x1
            [vr, vi] = obj.voltage_detector.step(v, t);%calcolo componenti fase e quadratura Va
        
            I_rif = obj.outer_controller.step(V_rif -x(2));%controllore loop esterno
            
            %componenti fase e quadratura corrente riferimento 
            I_i = I_rif * cos(phi_rif);
            I_r = I_rif * sin(phi_rif);
            
            u_hat = obj.inner_controller.step([I_r-x1r; I_i-x1i]);%controllore loop interno
            
            %linerizzazione via feedback
            ur = (-u_hat(1) + vr)/x(2);
            ui = (-u_hat(2) + vi)/x(2);
            
            
            %segnali
            k = round(t/t_step) +1;
            x1ms(k) = 2*sqrt(x1r^2 + x1i^2);
            x1phis(k) = atan2(x1r, x1i);
            vms(k) = 2*sqrt(vr^2 + vi^2);
            vphis(k) = atan2(vr, vi);
            Irifs(k) = I_rif;
            verr(k) = V_rif -x(2);
            ir_err(k) = I_r-x1r; 
            iI_err(k) = I_i-x1i;
            u_hatrs(k) = u_hat(1);
            u_hatis(k) = u_hat(2);
            urs(k) = ur;
            uis(k) = ui;
            
        end
    end
end

