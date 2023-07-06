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
        
        function [A, phi] = step(obj, sample, t)
            obj.past_samples(1: end-1) = obj.past_samples(2: end);
            obj.past_samples(end) = sample;
%             times = t-obj.T:1/obj.fs:t;
%             waves = sin(2*pi*1/obj.T*times);
%             Fn = obj.fs/2;                                                 
%             L  = length(obj.past_samples);
%             fts = fft(obj.past_samples)/L;                                         
%             Fv = linspace(0, 1, fix(L/2)+1)*Fn;                        
%             Iv = 1:length(Fv);                                          
%             [A, ind] = max(abs(fts(Iv))*2);                                  
%             phi = phdiffmeasure(obj.past_samples, waves);
            times = t-obj.T:1/obj.fs:t;
            waves = sin(2*pi*1/obj.T*times);
            wavec = cos(2*pi*1/obj.T*times);
            xr = mean(obj.past_samples .* waves(1:numel(obj.past_samples))');
            xi = mean(obj.past_samples .* wavec(1:numel(obj.past_samples))');
            A = 2*sqrt(xr^2+xi^2);
            phi = atan2(xi, xr);
            
        end
    end
end

