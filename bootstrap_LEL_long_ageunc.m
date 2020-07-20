%% loading all the files

%clear all
%close all
rng('default');
xi=[0:1:798]';
lin=[]; scaled=[];
indI=[[3:799 799 799]', [2:799 799]', [1:799]', [1 1:798]', [1 1 1:797]'];

sk=load('d18Osw_stack_.txt');%starts at 0
newsk=interp1(sk(:,1),-1*(sk(:,2)),xi);%Subtract 73 from all SSH's

bt=load('bintanja.txt');% Starts at 0 recheck the graph of this one
newbt=interp1(bt(:,1),bt(:,3),xi);

sd=load('sosdian2009_with_piston_core_and_zero_LR04_age.txt');%sosdian to short from the front; data does not start at 0
newsd=interp_with_averages(sd(:,1),sd(:,6),xi);%Starts at 153??

% wb=load('waelbroeck2002_LR04age_revised.txt');%aligned Waelbroeck's sea level estimate to PC1 instead of aligning to LR04.
% newb=interp1(wb(:,2),wb(:,4),xi);%says there is Nan

el=load('elderfield_sea_level_with_zero.txt');%add a start value of 0 m at 0 kyr
newel=interp_with_averages(el(:,1), -1*el(:,2)/.01, xi);% otherwise starts at 7

RL=load('medsealev_nosap_LR04_floor.txt');%Mediterranean sea level data on an LR04 age model.
newRL=interp_with_averages(RL(:,2),RL(:,3),xi);%columns C and D from original data set

% RRed=load('redsea_LR04age.txt');%%file with the red sea data on a new age model which should be consistent with LR04.
% newRR=interp_with_averages(RRed(:,1),RRed(:,2),xi);%columns A and C from original data set--Starts at .069

labels = {'Bintanja','Elderfield','Sosdian','Shakun',' Med (Roh.)'};

labels2 = {'Bint.','Eld.','Sosd.', 'Shak.',' Med'};


colors =[ 'b','r','g','m','k','c', 'y'];
%colors2=[ [.6 .4 .2]', [.8 .4 .9], [.2 .2 .2]];

%% figure 1 plotting the interpolated files


%hold on
%sea_level=[newbt, newel , newsd,  newsk, newRL];

y=newbt; %assign a designation to each record of sea level
z=newel;
x=newsd;
f=newsk;
r=newRL;


lin=[y, z, x, f, r];
for i=1:5
    scaled(:,i) = (lin(:,i) - mean(lin(:,i)))/std(lin(:,i)); %gives a mean of 0 and standard deviation of one
    
end
[scaled_loads, scaled_scores, scaled_variances] = princomp(scaled);

sc=scaled_scores(:,1);
sc=sc-sc(6);
pc1=-130*(sc/min(sc(20:35)));



m=[];

for j=1:1000  %loop thru the bootstrap this # of times
    
        
    O=5;
    vector=randi(O,1,O);%makes a vector 5 units long with integersfrom 1-5
    ageshift=randi(5,1,5);%makes a vector 5 units long with integersfrom 1-5
    lin=[]; %make a vector to put the sea level records into
    for q=1:5  %this loop substitutes sea level records for the random integers in 'vector', and puts them into the empty vector 'lin'
        if vector(1,q)==1
            lin(:,q)=y(indI(:,ageshift(1)));
        end
        if vector(1,q)==2
            lin(:,q)=z(indI(:,ageshift(2)));
        end
        if vector(1,q)==3
            lin(:,q)=x(indI(:,ageshift(3)));
        end
        if vector(1,q)==4
            lin(:,q)=f(indI(:,ageshift(4)));
        end
        if vector(1,q)==5
            lin(:,q)=r(indI(:,ageshift(5)));
        end
        
    end
    
    
    
    
    n=5;
    for i=1:n
        scaled(:,i) = (lin(:,i) - mean(lin(:,i)))/std(lin(:,i)); %gives a mean of 0 and standard deviation of one
        
    end
    %m(:,j)=scaled(:,i)%puts the PC1 bootstrap values into a matrix, 'm'
%     figure (12)%graphs the sea level records chosen by the bootstrap
%     plot(xi,scaled,'LineWidth',2)
%     xlabel('0-430kya')
%     xlim([0 430])
%     %legend(labels,'Location','Southoutside','LineWidth',2)
%     title('Centered and scaled Sea Level Rise Data from 0-430 kya')
%     hold on
    
    
    [scaled_loads, scaled_scores, scaled_variances] = princomp(scaled);

   sc=scaled_scores(:,1);
   sc=sc-sc(randi(7,1,1));
   score_sealev=-1*(randn(1,1)*2+132)*((sc)/min(sc(20:35)));
    
    %compiles a matrix of all the bootstrapped PC1 scores
    m(:,j)=score_sealev;
    
%     figure(3)%graphs all PC1 scores
%     scaled_a = scaled_scores(:,1); %scaled_b = scaled_scores(:,2); scaled_c = scaled_scores(:,3);
%     %subplot(3,1,1)
%     plot(xi,scaled_a,'LineWidth',1)
%     xlabel('time in kyr')
%     ylabel('Scores 1')
%     hold on
%     title('Centered and Scaled scores')
    
end
%%

ci=[prctile(m',2.5)' prctile(m',25)' prctile(m',50)' prctile(m',75)' prctile(m',97.5)'];
mean(ci(:,end)-ci(:,1))
ci_long2=ci;

figure (7)%plots the matrix of bootstrapped PC1 values 'm'
clf
subplot(211)
plot (xi,prctile(m',50))
hold on
%plot (xi,mean(m'))
plot(xi,ci(:,end))
plot(xi,ci(:,1))
plot(xi,ci(:,2))
plot(xi,ci(:,4))
plot(xi, pc1, 'k')
hold off
axis tight
subplot(212)
plot (xi,std(m'))
axis tight

results=[xi pc1 std(m')' ci];
mywrite('pc1_bootstrap_long.txt', results, 8, 2);

%%


% B=sort(m,2);%Sorts values of matrix 'm' by timestep
% 
% 
% 
% figure (5)%Plots the new matrix of sea level values from high to low
% plot (B)
% %%
% 
% 
% Y = prctile(B',97); %Creates a percentile value
% Z=prctile(B',3);
% 
% 
% figure (6)%Plots percentile values designated
% plot (Y)
% hold on
% 
% plot (Z)
% title('97 and 3rd percentile')