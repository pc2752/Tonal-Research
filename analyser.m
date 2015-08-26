rate=44100; %sampling rate is assumed to be 44100
samples=[rate*0,rate*2]; 
[in,fs]=audioread('Dmajor.wav');
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

tmpl = abs(F-minfreq);
[k,low] = min(tmpl); %index of closest value
tmph = abs(F-maxfreq);
[k high] = min(tmph); %index of closest value
SM=S(low:high,:);

H_size=12; %HPCP size
Tuning=440; %Reference Frequency


bands=8;
lowband=200;
fco=[100,lowband*(maxfreq/2/minfreq).^((0:bands-1)/(bands-1))]/maxfreq*nfft;
fco=round(fco);
rounder=round((high-low)/bands);

cfs=zeros(H_size,1);
for i = 1:H_size
    cfs(i)=Tuning*2^(i/H_size);
end

PCPCP=zeros();
l=4/3;


%for k =1:bands-1
    
    for j = 1:length(T)
        [mag peaks]=findpeaks(abs(SM(:,j)),F(low:high));
        %[mag posi]=findpeaks(abs(S(1+fco(k):1+fco(k+1))));
        %peaks=F(posi);
        for i = 1:H_size
            tot_d=log2(peaks/cfs(i));
            d1=fix(tot_d);
            d=H_size*abs(tot_d-d1);
            w=cos(pi/2*d/(0.5*l)).^2;
            w_mask=d<=0.5*l;
            w=w.*w_mask;
        
        
            PCPCP(i,j)=sum(w.*(mag.^2));
        end
    end  
    %PCPCP(H_size*(k-1)+1:H_size*(k),:) = bsxfun(@rdivide,PCPCP(H_size*(k-1)+1:H_size*(k),:),max(PCPCP(H_size*(k-1)+1:H_size*(k),:),[],1)); %normalize PCPCP
%PCPCP=norm(PCPCP)
PCPCP = bsxfun(@rdivide,PCPCP,max(PCPCP,[],1)); %normalize PCPCP


imagesc(PCPCP);

%figure; bar((PCPCP));
aux=(1:12);
set(gca,'ytick',aux); set(gca,'YTickLabel',{'A';'#';'B';'C';'#';'D';'#';'E';'F';'#';'G';'#'; });
set(gca,'XTickLabel',T)

grid    
        

    
    
%Abso=10*log10(abs(S));
%deri=diff(Abso');

%deri2=diff(deri);
%deri=deri';


%figure(1)
%subplot(2,1,1);
%surf(T(1:end-1),F,deri)
%view([0 90])
%axis tight
%xlabel('Time')
%ylabel('Frequency')
%set(gca,'YScale','log')
%title 'Derivative'

%subplot(2,1,2);
%surf(T,F,Abso)
%view([0 90])
%axis tight
%xlabel('Time')
%ylabel('Frequency')
%set(gca,'YScale','log')
%title 'Absolute'