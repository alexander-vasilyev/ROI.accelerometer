%stability of regions of interest
filename='ds-task-accelerometer.txt';
A=load(filename);
ncl=5;
%acceleration for each dimension
Ax=A(:,1);
Ay=A(:,2);
Az=A(:,3);


%abs of derivative of acceleration
ln=length(Ax);
roiprob=repmat(0,ln-1,100);
dAx=Ax(2:ln)-Ax(1:ln-1);
dAy=Ay(2:ln)-Ay(1:ln-1);
dAz=Az(2:ln)-Az(1:ln-1);
dA=abs(sqrt(dAx.*dAx+dAy.*dAy+dAz.*dAz));
dA0=dA;
%calculate probability
for epsilon=1:100;
  prob=repmat(0,ln-1,1);  
 for kl=1:20   
disp(epsilon);
%indeces of events of shaking
dA=dA0;
idx=dA>epsilon;
dA(dA<=epsilon)=0;
dA(dA>epsilon)=1;

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



for k=1:ncl
    n=find(dA==k,1,'first');
    m=find(dA==k,1,'last');
    dA(n:m)=repmat(1,1,m-n+1);
end;
prob=prob+dA;
 end;

roiprob(:,epsilon)=prob/sum(prob);
end;
figure
imagesc((roiprob'));
set(gca,'YDir','normal')