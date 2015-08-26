function [Salience,bins]=findsalience(peaka,peakf,totalbins,numberofharmonics,alpha,gamma,beta,time)
bins=zeros(totalbins,1);
for i=1:totalbins
    bins(i)=(2^((i-1)*10/1200))*55;
end

Salience=zeros(totalbins,time);

for i = 1:time
    freq=peakf(:,i); %select the peak (sine) frequencies for the given time frame
    amp=peaka(:,i); % along with amplitude
    [Fmax idx]=max(freq); %max frequence in framce
    Amax=max(amp); %Amplitude of highest spectral peak
    
    K=length(freq); %The number of sinusoids in the frame
    
    
    for b=1:totalbins
        for h=1:numberofharmonics
            for j=1:K
                fk=freq(j);
                ak=amp(j);
                B=1200*log2(fk/(h*55))/10+1;
                delta=abs(B-b)/10;
                if delta<=1
                    g=(cos(delta*pi/2))^2*alpha^(h-1);
                else
                    g=0;
                end
                if 20*log10(Amax/ak)<gamma
                    e=1;
                else
                    e=0;
                end
                Salience(b,i)=Salience(b,i)+e*g*ak^beta;
                
            end
        end
    end
    
end