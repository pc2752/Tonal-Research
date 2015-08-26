 
[in,fs]=audioread('GTN.wav');
hopsize=64;
nfft=4096;
M=1024;
w=hann(M);

%TWM parameters
p=0.5;
q=1.4;
r=0.5;
ro=0.33;

%Frequency search parameters
Minfreq=50;
Maxfreq=700;
Steps=1.06946;


%Equal loudness filter downloaded from
%http://replaygain.hydrogenaud.io/proposal/equal_loudness.html
[a1,b1,a2,b2]=equalloudfilt(fs);
in=filter(b1,a1,in);
in=filter(b2,a2,in);
%audiowrite('filtered.wav',in,fs)
%Get STFT 


[S,F,T] =spectrogram(in,w,hopsize,nfft,fs,'yaxis');
S1=abs(S); %

bins=size(S,1); %Number of frequency bins
time=size(S,2); %Time frames
%peakfpre=zeros(bins,time);
%peakapre=zeros(bins,time);


% Make sine model

%Sine model parameters
minlength=0.5; %minimum sine length in seconds
threshold=3; %difference in sine frequency in hertz
maxf=3000; %Max frequency to consider for sine analysis
threshold=1;


[peaka peakf]=findpeaks(S,threshold,nfft,fs,maxf);


% add condition for stability of sinusoid TBD -seems quite important
% use peakfpre and peakapre to calculate peaka and peakf
% 
% 
% % Calculate the candidate set


[cands nofcands]=findcandidates(Maxfreq,Minfreq,Steps);

%Find F0 using TWM

F0=TWM(peaka,peakf,nofcands,cands,time,p,q,r,ro);
 


windowSize = 5;

b = (1/windowSize)*ones(1,windowSize);
a = 1;
y = filter(b,a,F0);
plot(T,y);

  




%salience function as defined in
%http://mtg.upf.edu/system/files/publications/SalamonGomezMelodyTASLP2012.pdf

totalbins=600;
numberofharmonics=20;

alpha=0.8;
gamma=40;
beta=1;

[Salience,bins]=findsalience(peaka,peakf,totalbins,numberofharmonics,alpha,gamma,beta,time);

F1=zeros(time,1);

%Filter saliences
taup=0.7;
taua=0.9;

[salplus salminus]=findsaliencepeaks(Salience,bins,totalbins,taup,taua,time,threshold);


%Make HPCP

l=4/3; %Parameter of HPCP, determines how many HPCP bins 
       % a single frequency bin contributes to. (for 4/3=3)
minfreq=100; %Frequency range with maximum pitch prevalance
maxfreq=5000;
H_size=12; %HPCP size
Tuning=440; %Reference Tuning Frequency

PCPCP=pcpcp(salplus+salminus,bins,H_size, Tuning, l, nfft, fs,time);

figure; bar((PCPCP));
aux=(1:12);
set(gca,'ytick',aux); set(gca,'YTickLabel',{'A';'#';'B';'C';'#';'D';'#';'E';'F';'#';'G';'#'; });
set(gca,'XTickLabel',T)