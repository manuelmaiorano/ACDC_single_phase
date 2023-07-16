classdef PhaseDetector < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        past_samplesd
        past_samplesq
        fs
        T
        b
    end
    
    methods
        function obj = PhaseDetector(N, fs, T)
            obj.past_samplesd = zeros([N, 1]);
            obj.past_samplesq = zeros([N, 1]);
            obj.fs = fs;
            obj.T = T;
            obj.b = ones([1, N])/N;
            %obj.b = flip(obj.b);
        end
        
        function [xd, xq] = step(obj, sample, t)
            obj.past_samplesd(2: end) = obj.past_samplesd(1: end-1);
            obj.past_samplesd(1) = sample*cos(2*pi*1/obj.T*t);
            
            obj.past_samplesq(2: end) = obj.past_samplesq(1: end-1);
            obj.past_samplesq(1) = sample*sin(2*pi*1/obj.T*t);
            
%             xd = mean(obj.past_samplesd)*2;
%             xq = -mean(obj.past_samplesq)*2;
            xd = obj.b * obj.past_samplesd*2;
            xq = -obj.b * obj.past_samplesq*2;
        end
    end
end

