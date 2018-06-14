%identification of regions of interest
filename='ds-task-accelerometer.txt';
A=load(filename);
ncl=5;
%acceleration for each dimension
Ax=A(:,1);
Ay=A(:,2);
Az=A(:,3);
%threshold
epsilon=10;
%abs of derivative of acceleration
ln=length(Ax);
dAx=Ax(2:ln)-Ax(1:ln-1);
dAy=Ay(2:ln)-Ay(1:ln-1);
dAz=Az(2:ln)-Az(1:ln-1);
dA=abs(sqrt(dAx.*dAx+dAy.*dAy+dAz.*dAz));

figure
plot(dA);
title('absolute value of derivative of acceleration');
%indeces of events of shaking
idx=dA>epsilon;
dA(dA<=epsilon)=0;
dA(dA>epsilon)=1;

figure
plot(dA);
title('events of shaking');
%k-means clustering
%time of events
tevents=0*dA;
for k=1:ln-1
    if dA(k)==1
        tevents(k)=k;
    end;
end;
%defining 5 clusters
tevents(tevents<1)=[];
idxcl=kmeans(tevents,ncl);
dA(idx)=idxcl;

figure
plot(dA);
title('clusterized events');
%defining regions of interests
figure
plot(dAx)
hold on;
plot(dAy)
hold on;
plot(dAz)

for k=1:ncl
    n=find(dA==k,1,'first');
    m=find(dA==k,1,'last');
    dA(n:m)=repmat(k,1,m-n+1);
    hold on;
    line([n n],[-150 150]);
    hold on;
    line([m m],[-150 150]);
end;
title('regions of interest');