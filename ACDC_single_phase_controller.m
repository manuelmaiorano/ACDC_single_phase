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
            [x1m, x1phi] = obj.current_detector.step(x(1), t);
            [vm, vphi] = obj.voltage_detector.step(v, t);
            x1ms(floor(t/t_step) +1) = x1m;
            x1phis(floor(t/t_step) +1) = x1phi;
            vms(floor(t/t_step) +1) = vm;
            vphis(floor(t/t_step) +1) = vphi;
            I_rif = obj.outer_controller.step(V_rif -x(2));Irifs(floor(t/t_step) +1) = I_rif;
            verr(floor(t/t_step) +1) = V_rif -x(2);
            I_i = I_rif * cos(phi_rif);
            I_r = I_rif * sin(phi_rif);
            u_hat = obj.inner_controller.step([I_r-x1m*sin(x1phi); I_i-x1m*cos(x1phi)]);
            ir_err(floor(t/t_step) +1) = I_r-x1m*sin(x1phi); iI_err(floor(t/t_step) +1) = I_i-x1m*cos(x1phi);
            u_hatrs(floor(t/t_step) +1) = u_hat(1);u_hatis(floor(t/t_step) +1) = u_hat(2);
            
            ur = (-u_hat(1) + vm*sin(vphi))/x(2);
            ui = (-u_hat(2) + vm*cos(vphi))/x(2);

            urs(floor(t/t_step) +1) = ur;
            uis(floor(t/t_step) +1) = ui;
            
        end
    end
end

