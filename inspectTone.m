%Code to inspect stimulus sound properties:

clear all, close all

addpath('Sound_Samples/Part A/')
addpath('Sound_Samples/Part B/Tambourine')
addpath('Sound_Samples/Part C/')

addpath('Functions')

%for Part A:
%instruments = ["banjo","bassoon","cello","clarinet","flute","oboe","trumpet","saxophone","viola","violin"];
%instruments = ["violin","viola","cello"]; %String subset
instruments = ["banjo","bassoon","flute","trumpet","violin"];
%instruments = ["tambourine"];
pitch = '';
pitch = 'A4';
cond = 'resynth';
%cond = "long_cresc-decresc_shaken";
timewindow = [0,1];
nfft = 2048;

for i = 1:length(instruments)
    
    filename = strcat(instruments(i),'_',pitch,'_',cond,'.wav')
    [DFTsig(i,:), DFTfreq_Hz, dataStruct, ~] = compute_dft(filename,timewindow(1),timewindow(2),nfft,'mag');
    fs = dataStruct.fs_Hz;
    sig = dataStruct.sig;
    sig = sig(timewindow(1)*fs+1:timewindow(2)*fs);
    hold on
    plot(DFTfreq_Hz,DFTsig(i,:),'LineWidth',1.5);
    hold off
    sound(sig,fs);
    getSpect(sig,40,fs,70,'mag',strcat(instruments(i),' - A4'))
    cd Figures
    saveas(gcf,strcat('spectrogram_',instruments(i),'_',cond),'epsc')
    cd ../
    close all;
    pause(1);
    
end

legend(instruments)
title("Frequency Response of A4 on Multiple Instruments");
xlim([0 max(DFTfreq_Hz)]);
xlabel("Frequency (Hz)")
ylabel("Amplitude")
xlim([0,8e3]);
set(gca,'FontSize',12);