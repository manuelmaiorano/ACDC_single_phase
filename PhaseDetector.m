classdef PhaseDetector < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        past_samples
        fs
        T
    end
    
    methods
        function obj = PhaseDetector(N, fs, T)
            obj.past_samples = zeros([N, 1]);
            obj.fs = fs;
            obj.T = T;
        end
        
        function [xr, xi] = step(obj, sample, t)
            obj.past_samples(1: end-1) = obj.past_samples(2: end);
            obj.past_samples(end) = sample;
            
            %segnali seno e coseno 
            times = t-obj.T:1/obj.fs:t;
            waves = sin(2*pi*1/obj.T*times);
            wavec = cos(2*pi*1/obj.T*times);
            
            %calcolo componenti in fase e quadratura correnti a partire dal
            %vettore di campioni precedenti
            xr = mean(obj.past_samples .* wavec(numel(times)-numel(obj.past_samples)+1: end)')*2;
            xi = mean(obj.past_samples .* waves(numel(times)-numel(obj.past_samples)+1: end)')*2;
        end
    end
end

