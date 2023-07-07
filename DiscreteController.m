classdef DiscreteController < handle
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        states
        prev_inputs
        coeff_matrix
        ny
        nu
        ns
        dens
    end
    
    methods
        function obj = DiscreteController(transfer_matrix)
            [num, den] = tfdata(transfer_matrix);
            [ny, nu] = size(transfer_matrix);
            ns = numel(cell2mat(num(1,1)));
            dens = cell2mat(den);
            dens = dens(:,1:ns);
            obj.ns = ns;
            obj.nu = nu;
            obj.ny = ny;
            obj.dens = dens;
            obj.states = zeros(ny, ns-1);
            obj.prev_inputs = zeros(nu, ns);
            obj.coeff_matrix = cell2mat(num);
        end
        
        function outputs = step(obj, inputs)
            obj.prev_inputs(:, 2:end) = obj.prev_inputs(:, 1:end-1);
            obj.prev_inputs(:, 1) = inputs;
            outputs = obj.coeff_matrix * reshape(obj.prev_inputs', [obj.ns*obj.nu, 1])...  
                        - sum(obj.dens .* [zeros(obj.ny, 1), obj.states], 2);
            outputs = outputs./obj.dens(:, 1);
            obj.states(:, 2: end) = obj.states(:, 1:end-1);
            obj.states(:, 1) = outputs;
        end
    end
end

