Horn = Antenna(10, 2.45e9, 100e6);
Horn;

disp("---------------------------------");
disp("Horn Properties:");
disp("Gain                 : " + Horn.Gain);
disp("Opperating Frequency : " + toGHz(Horn.centerFreq) + " GHz");
disp("Bandwidth            : " + toMHz(Horn.bandwidth) + " MHz");
disp("Lower Cutoff Freq    : " + toGHz(Horn.cutoffFreqs(1)) + " GHz");
disp("Upper Cutoff Freq    : " + toGHz(Horn.cutoffFreqs(2)) + " GHz");
disp(" ");
disp("Waveguide Width      : " + to_mm(Horn.waveGuideDimensions(1)) + " mm");
disp("Waveguide Height     : " + to_mm(Horn.waveGuideDimensions(2)) + " mm");
disp("Waveguide Length     : " + to_mm(Horn.waveGuideDimensions(3)) + " mm");
disp(" ");
disp("Apature Width  A     : " + to_mm(Horn.apertureDimensions(1)) + " mm");
disp("Apature Height B     : " + to_mm(Horn.apertureDimensions(2)) + " mm");
disp("Apature Length       : " + to_mm(Horn.apertureDimensions(3)) + " mm");
disp("Apature Edge Length  : " + to_mm(Horn.apertureDimensions(4)) + " mm");





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

