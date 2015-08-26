function [peaka peakf]=findpeaks(S,threshold,nfft,rate,maxf)
maxind=ceil(maxf*nfft/rate);
time=size(S,2); %Time frames
peaka=zeros(1,time);
peakf=zeros(1,time);

for i = 2:time
    frame=abs(S(1:maxind,i));
    phase=angle(S(1:maxind,i-1:i));
    %plot(F(1:maxind),frame,'b--o');
    count=1;
    for j = 2:maxind-1
        beta=abs(frame(j));
        alpha=abs(frame(j-1));
        gamma=abs(frame(j+1));
        if beta>alpha&&beta>gamma&&beta>threshold;
            
            k=j;
            kh=k+(0.5*(alpha-gamma))/(alpha+gamma-2*beta);
            
            %parabolic interpolation as described in 
            %https://d396qusza40orc.cloudfront.net/audio/lecture_slides/5T2-Sinusoidal-model-2.pdf
            peakf(count,i)=kh*rate/nfft;
            peaka(count,i)=beta-0.25*(alpha-gamma)*(kh-k);
            %peakp=angle(frame(j));
            %peakfpre(j,i)=kh*rate/nfft;
            %peakapre(j,i)=beta-0.25*(alpha-gamma)*(kh-k);
            
            
            %phase vocoder as in 
            %http://mtg.upf.edu/system/files/publications/SalamonGomezMelodyTASLP2012.pdf
            %boffset=nfft/(2*pi*hopsize)*wrapToPi((phase(k,2)-phase(k,1)-(2*pi*hopsize*k)/nfft));
            %peakf(count,i)=(k+boffset)*rate/nfft;
            %peaka(count,i)=beta/(2*w(int64(ceil(M/nfft*abs(boffset))))); %not sure if i got this right
            %peaka(count,i)=beta/(sinc(M/nfft*boffset)/(1-(M/nfft*boffset)^2));
            
            count=count+1;
        end
    end
end