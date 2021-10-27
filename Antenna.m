classdef Antenna
    properties
        Gain;%just gain
        centerFreq;
        bandwidth;
        C;              %speed of light
        efficiency;     %is this dependant or constant? look into how to measure/calculate this
    end
    properties (Dependent)
        cutoffFreqs;            %cutoff frequency [lower, higher]
        Vp;
        waveGuideDimensions;    %initalise dimensions for waveguide
        apertureDimensions;     %initalise dimensions for aperture
    end
    
%     properties (Access = private)
%         waveGuideDimensions_mm;    %initalise dimensions for waveguide
%         apertureDimensions_mm;     %initalise dimensions for aperture
%     end
    
    methods
       
        
        function thisAntenna = Antenna(G, CF, BW)    %constructor
            thisAntenna.Gain = G;                       %set desired gain
            thisAntenna.centerFreq = CF;                %set desired center frequency
            thisAntenna.bandwidth = BW;                 %set desired bandwidth
            thisAntenna.C = 2.99792e8;                  %set speed of light
            thisAntenna.efficiency = 0.5;               %set efficiency of horn antenna
            thisAntenna.waveGuideDimensions;
            thisAntenna.apertureDimensions;
        end
        
        function cutoffFreqs = get.cutoffFreqs(thisAntenna)    %calculate upper and lower cutoff frequencies
            centerF = thisAntenna.centerFreq;
            bw = thisAntenna.bandwidth;
            
            lowerFc = centerF -(bw/2);    %calculate lower
            upperFc = centerF +(bw/2);    %calculate upper
            
            cutoffFreqs = [lowerFc, upperFc];  %store as 1x2 vector [lower fc, upper fc]
            
        end
        
        function Vp = get.Vp(thisAntenna)       %
            Vp = thisAntenna.C*0.95;            %multiply speed of light by 0.95 to get velocity of propergation of copper
        end
        
        
        function waveGuideDimensions = get.waveGuideDimensions(thisAntenna)
           V = thisAntenna.Vp;
           lowerFc = thisAntenna.cutoffFreqs(1);
           upperFc = thisAntenna.cutoffFreqs(2);
           
           
           width    = V/(2*upperFc);    %set width to half wavelength of upper cutoff frequency
           height   = V/(4*upperFc);    %set height to quater wavelength of upper cutoff frequency
           len      = V/(lowerFc);      %set height to wave wavelength of lower frequency
           
           %return waveguide Dimensions and convert to mm
           waveGuideDimensions = [width, height, len];
           
        end
        
        function apertureDimensions = get.apertureDimensions(thisAntenna)
           %Appature apWidth_H is A
           %Appature Height is B         
            
           
           eff          = thisAntenna.efficiency;
           wgWidth_H    = thisAntenna.waveGuideDimensions(1);    %a parameter
           wgHeight_E   = thisAntenna.waveGuideDimensions(2);    %b parameter
           gain         = thisAntenna.Gain;                         %get desired gian
           opWavelength = thisAntenna.C/thisAntenna.centerFreq; %calculate opperating frequency's wavelength
           
           
%            disp("eff:          " + eff);
%            disp("wgWidth_H:      " + wgWidth_H);
%            disp("wgHeight_E      " + wgHeight_E);
%            disp("Gain          " + gain);
%            disp("opWavelength: " + opWavelength);


           %calculating coeff's of A (Appature apWidth_H H-Plane)
           A4 = 1;
           A3 = -wgWidth_H;
           A2 = 0;
           A1 = (3*wgHeight_E*gain*opWavelength^2)/(8*pi*eff);
           A0 = -((3*(gain^2)*(opWavelength^4))/(32*(pi^2)*(eff^2)));
           
  
            
           AQuartic = [A4, A3, A2, A1, A0];     %create an array of Pollynomial Coefficients
           r = roots(AQuartic);                 %Calculate Roots of the Quartic Apature width equation
           %disp("");
           %disp("Appature apWidth_H Quartic:");
           %disp(A4 + " A^4 + " + A3 + " A^3 + " + A2 + " A^2 + " + A1 + "A + " + A0 + " = 0");
           
           %disp("");
           %disp("Roots of Appature pollynomial in mm:");                 %When Calculating the roots of Appature pollynomial we can find the width of the apature
           %disp(1000*r + " mm");
           for i = 1:size(r)
 
               if (r(i) > 0 && isreal(r(i))) %determine that r(i) is posative and real 
                   %disp("A should be: " + 1000*r(i) + " mm");
                   apWidth_H = r(i);             %set width of apature
               end
               
           end
           
           
           %Calculate Appature Height
           apHeight_E = 0.5*(wgHeight_E + sqrt(wgHeight_E^2 + (8*apWidth_H*(apWidth_H-wgWidth_H))/3));
           
           %Calculate Aperture Length  
           apLength = apWidth_H*(((apWidth_H-wgWidth_H)/(3*opWavelength)));
           %disp("apLength = " + apLength);
           
           %Calculate Length of slope in E plane 
           Slope_E = sqrt(((apHeight_E-wgHeight_E)/2)^2 + apLength^2);
           %disp("slope_E = " + Slope_E);
           
           %add component of H plane to find edge length
           edgeLength = sqrt(((apWidth_H-wgWidth_H)/2)^2 + Slope_E^2);
           
           %return apature dimension and convert to mm
           apertureDimensions = [apWidth_H, apHeight_E, apLength, edgeLength];
 
%            disp("Appature apWidth_H  A: " + apertureDimensions_mm(1));
%            disp("Appature Height B: " + apertureDimensions_mm(2));
%            disp("Appature Length L: " + apertureDimensions_mm(3));
        end
        


%             waveLength = Vp/obj.fc(1);
%             
%             waveLengthFc = [Vp/obj.fc(1), Vp/obj.fc(2)];
%            
%             
%             efficiency = 0.5;
%                            
%             
%             AQuartic = [1 -a  0 ((3*b*obj.Gain*waveLengthFc(1)^2)/(8*pi*efficiency)) -((3*(obj.Gain^2)*(waveLength(1)^4))/(32*(pi^2)*(efficiency^2)))]; 
%             X = 0:0.01:2;
%             Y = X*AQuartic;
%             plot(X,Y);
%             
%             roots(AQuartic)
%             %A^4-a*A^3+((3*b*Gain*waveLengthFc(1)^2)/(8*pi*efficency))*A-((3*(Gain^2)*(waveLength(1)^4))/(32*(pi^2)*(efficiency^2)))
%             
%             
%         end

    end
    
    
    
    
    methods (Static)
       
    end
    
end
