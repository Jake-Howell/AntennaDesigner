classdef Antenna
    properties
        Gain;%just gain
        centerFreq;
        bandwidth;
        C;              %speed of light
        efficiency;     %is this dependant or constant? look into how to measure/calculate this
        name;
    end
    properties (Dependent)
        cutOff;                 %cutoff frequency struct [Lower, Upper]
        Vp;
        waveGuide;    %initalise dimensions for waveguide
        aperture;     %initalise dimensions for aperture
        element;
    end
   
    methods
       
        
        function thisAntenna = Antenna(G, CF, BW, name)    %constructor
            thisAntenna.Gain = G;                       %set desired gain
            thisAntenna.centerFreq = CF;                %set desired center frequency
            thisAntenna.bandwidth = BW;                 %set desired bandwidth
            thisAntenna.C = 2.99792e8;                  %set speed of light
            thisAntenna.efficiency = 0.5;               %set efficiency of horn antenna
            thisAntenna.name = name;                    %give antenna a name
            thisAntenna.waveGuide;
            thisAntenna.aperture;
            thisAntenna.printDimensions;
            thisAntenna.display3D;
            
        end
        
        function cutOff = get.cutOff(thisAntenna)    %calculate upper and lower cutoff frequencies
            centerF = thisAntenna.centerFreq;
            bw = thisAntenna.bandwidth;
            
            lowerFc = centerF -(bw/2);    %calculate lower
            upperFc = centerF +(bw/2);    %calculate upper
            
            cutOff.Lower = lowerFc;  %store values in struct
            cutOff.Upper = upperFc;
            
        end
        
        function Vp = get.Vp(thisAntenna)       %
            Vp = thisAntenna.C*0.95;            %multiply speed of light by 0.95 to get velocity of propergation of copper
        end
        
        function element = get.element(thisAntenna)
           element.waveLength = (thisAntenna.Vp)/(thisAntenna.centerFreq);
            
           element.length = element.waveLength/4;
           element.distance = ((element.waveLength)/sqrt(1-(thisAntenna.cutOff.Lower/thisAntenna.centerFreq)^2))/4;
           
        end
        
        function waveGuide = get.waveGuide(thisAntenna)
           V = thisAntenna.Vp;
           lowerFc = thisAntenna.cutOff.Lower;
           
           
           width    = V/(2*lowerFc);    %set width to half wavelength of upper cutoff frequency
           height   = V/(4*lowerFc);    %set height to quater wavelength of upper cutoff frequency
           len      = V/(lowerFc);      %set length to full wavelength of lower frequency
           
           %return waveguide Dimensions and convert to mm
           waveGuide.width = width;
           waveGuide.height = height;
           waveGuide.length = len;
           
        end
        
        function aperture = get.aperture(thisAntenna)
           %Appature apWidth_H is A
           %Appature Height is B         
            
           
           eff          = thisAntenna.efficiency;
           wgWidth_H    = thisAntenna.waveGuide.width;    %a parameter
           wgHeight_E   = thisAntenna.waveGuide.height;    %b parameter
           gain         = thisAntenna.Gain;                         %get desired gian
           opWavelength = thisAntenna.C/thisAntenna.centerFreq; %calculate opperating frequency's wavelength
           

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
           
           %Calculate Aperture Depth  
           apDepth = apWidth_H*(((apWidth_H-wgWidth_H)/(3*opWavelength)));
           %disp("apDepth = " + apDepth);
           
           %Calculate Length of slope in E plane 
           Slope_E = sqrt(((apHeight_E-wgHeight_E)/2)^2 + apDepth^2);
           %disp("slope_E = " + Slope_E);
           Slope_H = sqrt(((apWidth_H-wgWidth_H)/2)^2 + apDepth^2);
           
           %add component of H plane to find edge length
           edgeLength = sqrt(((apWidth_H-wgWidth_H)/2)^2 + Slope_E^2);
           
           %return apature dimension
           %apertureDimensions = [apWidth_H, apHeight_E, apDepth, edgeLength, Slope_E, Slope_H];
           aperture.width       = apWidth_H;
           aperture.height      = apHeight_E;
           aperture.depth       = apDepth;
           aperture.edgeLength  = edgeLength;
           aperture.slope_E     = Slope_E;
           aperture.slope_H     = Slope_H;
        end
    
        %function to display horn antenna in 3D
        function display3D(thisAntenna)
            thisAntenna.waveGuide;
            x = [0 0 0];
            y = [0 0 0];
            z = [0 0 0];

            x(1) = 0;
            x(2) = thisAntenna.waveGuide.length;
            x(3) = x(2) + thisAntenna.aperture.depth;
            
            y(1) = 0;
            y(2) = thisAntenna.waveGuide.width;
            y(3) = (thisAntenna.aperture.width - y(2))/2; %create correct off set for y(3)
            
            z(1) = 0;
            z(2) = thisAntenna.waveGuide.height;
            z(3) = (thisAntenna.aperture.height - z(2))/2; %create correct offset got z(3)
            
            x = x*100;
            y = y*100;
            z = z*100;
            
            f = figure;
            %back wall of wave guide
            x1 = [x(1),x(1),x(1),x(1)];
            y1 = [y(1),y(1),y(2),y(2)];
            z1 = [z(1),z(2),z(2),z(1)];
            patch(x1, y1, z1,'red');

            %front side of waveguide
            x4 = [x(1),x(1),x(2),x(2)];
            y4 = [y(1),y(1),y(1),y(1)];
            z4 = [z(1),z(2),z(2),z(1)];
            patch(x4, y4, z4, 'green');
            %back of waveguide
            x5 = [x(1),x(1),x(2),x(2)];
            y5 = [y(2),y(2),y(2),y(2)];
            z5 = [z(1),z(2),z(2),z(1)];
            patch(x5, y5, z5, 'green');
            %top of wave guide
            x6 = [x(1),x(1),x(2),x(2)];
            y6 = [y(1),y(2),y(2),y(1)];
            z6 = [z(2),z(2),z(2),z(2)];
            patch(x6, y6, z6, 'black');
            %bottom of waveguide
            x7 = [x(1),x(1),x(2),x(2)];
            y7 = [y(1),y(2),y(2),y(1)];
            z7 = [z(1),z(1),z(1),z(1)];
            patch(x7, y7, z7, 'black');

            %front side of aperture
            x8 = [x(2),x(2),x(3),x(3)];
            y8 = [y(1),y(1),-y(3),-y(3)];
            z8 = [z(1),z(2),(z(2)+z(3)),-z(3)];
            patch(x8, y8, z8, 'blue');

            %back side of aperture
            x9 = [x(2),x(2),x(3),x(3)];
            y9 = [y(2),y(2),(y(2)+y(3)),(y(2)+y(3))];
            z9 = [z(1),z(2),(z(2)+z(3)),-z(3)];
            patch(x9, y9, z9, 'blue');

            %top side of aperture
            x10 = [x(2),x(2),x(3),x(3)];
            y10 = [y(1),y(2),(y(2)+y(3)),-y(3)];
            z10 = [z(2),z(2),(z(2)+z(3)),(z(2)+z(3))];
            patch(x10, y10, z10, 'red');

            %botom side of aperture
            x10 = [x(2),x(2),x(3),x(3)];
            y10 = [y(1),y(2),(y(2)+y(3)),-y(3)];
            z10 = [z(1),z(1),-z(3),-z(3)];
            patch(x10, y10, z10,'red')
            %patch(x10, y10, z10, 'EdgeColor','blue', 'FaceColor','black');

            %setup figure

            g = thisAntenna.Gain;
            cf = thisAntenna.centerFreq/1e9;
            bw = thisAntenna.bandwidth/1e6;
            title(thisAntenna.name,'Gain: ' + string(g) + 'dB  ' + 'CF: ' + string(cf) + 'GHz   BW: ' + string(bw) + 'MHz');
            xlabel('Direction of Propagation (cm)');
            ylabel('H-Plane (cm)');
            zlabel('E-Plane (cm)');
            axis padded;
            camlight('headlight');
            view([37.5,30]);    %set camera position for plot
        end
        function printDimensions(thisAntenna)
                disp("---------------------------------");
                disp(thisAntenna.name + " Properties:");
                disp("Gain                 : " + thisAntenna.Gain);
                disp("Opperating Frequency : " + thisAntenna.toGHz(thisAntenna.centerFreq) + " GHz");
                disp("Bandwidth            : " + thisAntenna.toMHz(thisAntenna.bandwidth) + " MHz");
                disp("Lower Cutoff Freq    : " + thisAntenna.toGHz(thisAntenna.cutOff.Lower) + " GHz");
                disp("Upper Cutoff Freq    : " + thisAntenna.toGHz(thisAntenna.cutOff.Upper) + " GHz");
                disp(" ");
                disp("Waveguide Width      : " + thisAntenna.to_cm(thisAntenna.waveGuide.width) + " cm");
                disp("Waveguide Height     : " + thisAntenna.to_cm(thisAntenna.waveGuide.height) + " cm");
                disp("Waveguide Length     : " + thisAntenna.to_cm(thisAntenna.waveGuide.length) + " cm");
                disp(" ");
                disp("Element length       : " + thisAntenna.to_cm(thisAntenna.element.length) + "cm");
                disp("Element distance     : " + thisAntenna.to_cm(thisAntenna.element.distance) + "cm");
                disp(" ");
                disp("Apature Width  A     : " + thisAntenna.to_cm(thisAntenna.aperture.width) + " cm");
                disp("Apature Height B     : " + thisAntenna.to_cm(thisAntenna.aperture.height) + " cm");
                disp("Apature Length       : " + thisAntenna.to_cm(thisAntenna.aperture.depth) + " cm");
                disp("Apature Edge Length  : " + thisAntenna.to_cm(thisAntenna.aperture.edgeLength) + " cm");
                disp("Apature Slope_E      : " + thisAntenna.to_cm(thisAntenna.aperture.slope_E) + " cm");
                disp("Apature Slope_H      : " + thisAntenna.to_cm(thisAntenna.aperture.slope_H) + " cm");
        end
        
        %some functions to convert from Hz to KHz, MHz, GHz
        function GHz = toGHz(~,Hz)
            GHz = Hz/1e9; %devide MHz by 1000 to get GHz
        end

        function MHz = toMHz(~, Hz)
            MHz = Hz/1e6;                   %devide KHz by 1000 to get MHz
        end

        function KHz = toKHz(~, Hz)
            KHz = Hz/1e3;               %devide Hz by 1000 to get KHz
        end

        %convert meters to mm
        function mm = to_mm(~, m)
            mm = m*1000;
        end

        function cm = to_cm(~, m)
            cm = m*100;
        end
    end
   
end

