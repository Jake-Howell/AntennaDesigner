classdef Antenna
    properties
        Gain = 0;%just gain
        fc;            %cutoff frequency [lower, higher]
        C = 2.99792*10^8;     %speed of light
        efficiency = 0.5
        
        waveGuideDimensions;
        appatureDimensions;
    end
    methods
        function obj = Antenna(centerFreq, bandwidth)
            Vp = 0.95*2.99792*10^8;  
            fc = [(centerFreq-(bandwidth/2)), (centerFreq+(bandwidth/2))];  %calculate upper and lower cut off frequencys
            waveGuideDimensions = [(Vp/(2*fc(2))),(Vp/(4*fc(2))), (Vp/fc(1))];          %calculate waveguide [width, height, length]
            
            a = waveGuideDimensions(1);
            b = a/2;
            
            efficiency = 0.5;
            waveLength = Vp/fc(1);
            
            waveLengthFc = [Vp/fc(1), Vp/fc(2)];
            apertureDimensions = []; %calculate aperture [width, height, length]
            
            efficiency = 0.5;
            Gain = 10;
            
            AQuartic = [1 -a  0 ((3*b*Gain*waveLengthFc(1)^2)/(8*pi*efficiency)) -((3*(Gain^2)*(waveLength(1)^4))/(32*(pi^2)*(efficiency^2)))]; 
            
            
            roots(AQuartic)
            %A^4-a*A^3+((3*b*Gain*waveLengthFc(1)^2)/(8*pi*efficency))*A-((3*(Gain^2)*(waveLength(1)^4))/(32*(pi^2)*(efficiency^2)))
            
            
        end
        %some methods
    end
end
