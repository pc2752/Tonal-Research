function [salplus salminus]=findsaliencepeaks(Salience,bins,totalbins,taup,taua,time,threshold)
salpeaks=zeros(size(Salience));
salplus=zeros(size(Salience));

for i =1:time
    
        
        frame=Salience(:,i);
        for j = 2:totalbins-1
            beta=abs(frame(j));
            alpha=abs(frame(j-1));
            gamma=abs(frame(j+1));
            if beta>alpha&&beta>gamma&&beta>threshold;
                salpeaks(j,i)=beta;
            end
        end
end
   
for i =1:time
    frame=salpeaks(:,i);
    maxpeak=max(frame);
    frame(frame<maxpeak*taup)=0;
    salplus(:,i)=frame;
end

mea=mean(salplus(:));
sta=std(salplus(:));
salplus(salplus<(mea-taua*sta))=0;
salminus=salpeaks-salplus;

