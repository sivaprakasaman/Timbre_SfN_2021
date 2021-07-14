clear all
addpath('Sound_Samples/Part C/')

addpath('Functions')
instrument = "violin";
pitch = 'A4';
cond = 'resynth';

timewindow = [0,1];
nfft = 2048;
F0 = 440;

CF_ind = 1;
CF = [125, F0, 2*F0, 9*F0];


%Load a sound
filename = strcat(instrument,'_',pitch,'_',cond,'.wav')
[sig, fsHz] = audioread(filename); 

%Put through Gammatone Filterbank
[bankedSig] = cochlearFilterBank(sig, fsHz, CF, 10);
bankedSig = bankedSig(CF_ind,:);

%[DFTsig, DFTfreq_Hz, dataStruct, ~] = compute_dft(bankedSig,timewindow(1),timewindow(2),nfft,'dB');
% fs = dataStruct.fs_Hz;
% sig = dataStruct.sig;
% sig = sig(timewindow(1)*fs+1:timewindow(2)*fs);

%Compute either ENV or TFS
    input_env = abs(hilbert(bankedSig'));
    input_tfs = cos(angle(hilbert(bankedSig')));

% hold on
% plot(DFTfreq_Hz,DFTsig,'LineWidth',1.5);
% hold off
% sound(sig,fs);
getSpect(input_env,40,fsHz,70,'dB',strcat(instrument,' - A4'))

%Put through filterbank

%Compute envelope/tfs 


%Look at spectral properties 