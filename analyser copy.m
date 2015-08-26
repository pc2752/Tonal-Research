rate=44100; %sampling rate is assumed to be 44100
samples=[rate*0,rate*2]; 
[in,fs]=audioread('Guitar Samples-single note e');
hopsize=64;
nfft=4096;
w=hann(nfft/2);
minfreq=100;
maxfreq=5000;
H_size=12; %HPCP size
Tuning=440; %Reference Tuning Frequency

%s=spectogram(in,fs,nfft/fs*1000,hopsize/fs*1000);
%s = spectrogram(in,1024,hopSize,nfft,fs);

%Get STFT and filter
[S,F,T] = spectrogram(in,w,hopsize,nfft,fs);

