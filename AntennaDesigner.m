Horn = Antenna(10, 2.45e9, 100e6);
Horn;



display_Dimensions(Horn);

function display_Dimensions(thisAntenna)
disp("---------------------------------");
disp("Horn Properties:");
disp("Gain                 : " + thisAntenna.Gain);
disp("Opperating Frequency : " + toGHz(thisAntenna.centerFreq) + " GHz");
disp("Bandwidth            : " + toMHz(thisAntenna.bandwidth) + " MHz");
disp("Lower Cutoff Freq    : " + toGHz(thisAntenna.cutOff.Lower) + " GHz");
disp("Upper Cutoff Freq    : " + toGHz(thisAntenna.cutOff.Upper) + " GHz");
disp(" ");
disp("Waveguide Width      : " + to_cm(thisAntenna.waveGuide.width) + " cm");
disp("Waveguide Height     : " + to_cm(thisAntenna.waveGuide.height) + " cm");
disp("Waveguide Length     : " + to_cm(thisAntenna.waveGuide.length) + " cm");
disp(" ");
disp("Element length       : " + to_cm(thisAntenna.element.length) + "cm");
disp("Element distance     : " + to_cm(thisAntenna.element.distance) + "cm");
disp(" ");
disp("Apature Width  A     : " + to_cm(thisAntenna.aperture.width) + " cm");
disp("Apature Height B     : " + to_cm(thisAntenna.aperture.height) + " cm");
disp("Apature Length       : " + to_cm(thisAntenna.aperture.depth) + " cm");
disp("Apature Edge Length  : " + to_cm(thisAntenna.aperture.edgeLength) + " cm");
disp("Apature Slope_E      : " + to_cm(thisAntenna.aperture.slope_E) + " cm");
disp("Apature Slope_H      : " + to_cm(thisAntenna.aperture.slope_H) + " cm");
end


%some functions to convert from Hz to KHz, MHz, GHz
function GHz = toGHz(Hz)
    GHz = toMHz(Hz)/1e3; %devide MHz by 1000 to get GHz
end

function MHz = toMHz(Hz)
    MHz = toKHz(Hz)/1e3;                   %devide KHz by 1000 to get MHz
end

function KHz = toKHz(Hz)
    KHz = Hz/1e3;               %devide Hz by 1000 to get KHz
end

%convert meters to mm
function mm = to_mm(m)
    mm = m*1000;
end

function cm = to_cm(m)
    cm = m*100;
end
