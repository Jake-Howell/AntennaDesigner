classdef Antenna
    properties
        Gain = 0;%just gain
        fc;            %cutoff frequency [lower, higher]
        C = 2.99792*10^8;     %speed of light
        Vp = 0.95*C;          %velocity of propargation though copper
        efficiency = 0.5
        
        waveGuideDimensions;
        appatureDimensions;
    end
    methods
        function obj = Antenna(centerFreq, bandwidth)
            fc = [(centerFreq-(bandwidth/2)), (centerFreq+(bandwidth/2))];  %calculate upper and lower cut off frequencys
            waveGuideDimensions = [(Vp/(2*fc(2))),(Vp/(4*fc(2))), (Vp/fc(1))];          %calculate waveguide [width, height, length]
            
            
            wavelengthFc = Vp/fc;
            apertureDimensions = []; %calculate aperture [width, height, length]
            
            
            
            A^4-a*A^3+((3*b*Gain*waveLengthFc(1)^2)/(8*pi*efficency))*A-((3*(Gain^2)*(waveLength(1)^4))/(32*(pi^2)*(efficiency^2)))
            
            
        end
        %some methods
    end
end
