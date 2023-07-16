classdef AvgFilter < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        samples
        b
    end
    
    methods
        function obj = AvgFilter(N)
            obj.samples = zeros([1, N]);
            obj.b = ones([1, N])/N;
        end
        
        function out = step(obj,sample)
            obj.samples(2: end) = obj.samples(1: end-1);
            obj.samples(1) = sample;
            out = obj.samples * obj.b';
        end
    end
end

