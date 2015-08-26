function PCPCP=pcpcp(salplus,bins,H_size, Tuning, l, nfft, fs,time)

%%Takes spectogram (s) and frequencies (f) of a channel along with the size
%%of the pcpcp (default =12 for each semitone in an octave) and the
%%reference tuning frequency (default= 440 Hz)

%calculate the central frequencies for each semitone/PCPCP step
cfs=zeros(H_size,1);
for i = 1:H_size
    cfs(i)=Tuning*2^(i/H_size);
end



PCPCP=zeros(H_size,time);

for j = 1:time
        frame=salplus(:,j);
        [idxi idxj mag]=find(frame); %Find the spectral peaks
        if mag
            peaks=bins(idxi);
            for i = 1:H_size %Go through central frequencies
                tot_d=log2(peaks/cfs(i)); %Distance in semitones from central frequency
                d1=fix(tot_d);
                d=H_size*abs(tot_d-d1); %Take the fractional part of the distance and multiply by H_size.
                                    %This is because the integer part represents an octave
                w=cos(pi/2*d/(0.5*l)).^2; %Find contribution to each HPCP bin
                w_mask=d<=0.5*l; 
                w=w.*w_mask; %Apply a threshold of d<=0.5 *l as higher distances won't contribute to the bins
        
        
                PCPCP(i,j)=sum(w.*(mag.^2)); % Use magnitude as a weighting function
            end
        end
end
PCPCP= bsxfun(@rdivide,PCPCP,sum(PCPCP)); % Normalize for each time instant
%PCPCP = bsxfun(@rdivide,PCPCP,max(PCPCP,[],1)); % Normalize for each time instant

%imagesc(PCPCP);

%figure; bar((PCPCP));
%aux=(1:12);
%set(gca,'ytick',aux); set(gca,'YTickLabel',{'A';'#';'B';'C';'#';'D';'#';'E';'F';'#';'G';'#'; });
%set(gca,'XTickLabel',T)

%grid    
%    PCPCP = bsxfun(@rdivide,PCPCP,max(PCPCP,[],1));