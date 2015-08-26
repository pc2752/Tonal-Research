% TWM http://ems.music.uiuc.edu/beaucham/papers/JASA.04.94.pdf
function F0=TWM(peaka,peakf,nofcands,cands,time,p,q,r,ro)

F0=zeros(1,time);
for i = 1:time
    freq=peakf(:,i); %select the peak (sine) frequencies for the given time frame
    amp=peaka(:,i); % along with amplitude
    Amax=max(amp); %Max amplitude in frame
    Fmax=max(freq); %max frequence in framce
    K=length(freq); %The number of sinusoids in the frame
    
    Etot=zeros(nofcands,1);
    
    for cyc=1:nofcands
        
        fund=cands(cyc);  %select a candidate frequency
        N=ceil(Fmax/fund);  %Number of harmonics to be calculated
        if (Fmax==0)
                N=1;
        end
        harmonics=zeros(N,1);
        
        EPM=0; %Error predicted to measured
        EMP=0; %Error measured to predicted
        
        %Predicted harmonics for the given candidate
        for j=1:N
            harmonics(j)=j*fund;
        end
        
        for j=1:N
            %Error predicted to measured
            fn=harmonics(j); 
            
            %Choose the closest sine to the given predicted harmonic
            dif=abs(freq-fn);
            [deltaf idx]=min(dif); %difference between chosen harmonis and closest sine
            fk=freq(idx);
            an=amp(idx);
            
            EPM=EPM+deltaf*fn^(-p)+((an/Amax)*(q*deltaf*fn^(-p)-r));
        end
            %Error measured to predicted
         for k=1:K   
            %Find sine closest to predicted harmonic
            fk=freq(k);
            if fk>0
            dif2=abs(harmonics-fk);
            [deltaf2 idx]=min(dif2); %difference between chosen harmonis and closest sine
            fn2=harmonics(idx);
            an2=amp(k);
            EMP=EMP+deltaf2*fk^(-p)+((an2/Amax)*(q*deltaf2*fk^(-p)-r));
        
            end
         end
        Etot(cyc)=ro*EMP/K+EPM/N;
    end
    %plot(cands,Etot,'b--o');
    
    [minerror idx]=min(Etot);
    F0(i)=cands(idx);
    if (Fmax==0)
        F0(i)=0;
    end
end