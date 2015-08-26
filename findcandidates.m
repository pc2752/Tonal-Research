function [cands nofcands]=findcandidates(Maxfreq,Minfreq,Steps)
nofcands=floor((Maxfreq-Minfreq)/Steps);
cands=zeros(nofcands,1);
cands(1)=Minfreq;
for i=2:nofcands
     cands(i)=cands(i-1)+Steps;
end