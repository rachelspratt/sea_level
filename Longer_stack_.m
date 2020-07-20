%% loading all the files

clear all
close all

xi=[0:1:430]';

sk=load('d18Osw_stack.txt');%starts at 0
newsk=interp1(sk(:,1),((-1*(sk(:,2))/.01)-73),xi);%Subtract 73 from all SSH's
newsk2=interp1(sk(:,1),((-1*(sk(:,2))/.01)-73+20.5367),xi);%Subtract 73 from all SSH's

bt=load('bintanja.txt');% Starts at 0 recheck the graph of this one
newbt=interp1(bt(:,1),bt(:,3),xi);

sd=load('sosdian2009_with_piston_core_and_zero_LR04_age.txt');%sosdian to short from the front; data does not start at 0
newsd=interp_with_averages(sd(:,1),sd(:,6),xi);%Starts at 153??

wb=load('waelbroeck2002_LR04age_revised.txt');%aligned Waelbroeck's sea level estimate to PC1 instead of aligning to LR04.
newb=interp1(wb(:,2),wb(:,4),xi);%says there is Nan

el=load('elderfield_sea_level_with_zero.txt');%add a start value of 0 m at 0 kyr
newel=interp_with_averages(el(:,1), -1*el(:,2)/.01, xi);% otherwise starts at 7

RL=load('medsealev_nosap_LR04.txt');%Mediterranean sea level data on an LR04 age model.
newRL=interp_with_averages(RL(:,2),RL(:,3),xi);%columns C and D from original data set

RRed=load('redsea_LR04age.txt');%%file with the red sea data on a new age model which should be consistent with LR04.
newRR=interp_with_averages(RRed(:,1),RRed(:,2),xi);%columns A and C from original data set--Starts at .069

LR=load('lisiecki2005.txt');%x values are discrete
newLR=interp1(LR(:,1),-1*LR(:,2),xi);

precession=load('orb_params.txt'); 
newprecession=interp1(-1*precession(:,1),-1*precession(:,4),xi);

labels = {'Bintanja','Elderfield','Waelbroeck','Shakun',' Med (Roh.)','Red (Roh.)','Sosdian'};

labels2 = {'Bint.','Eld.','Waelb', 'Shak.',' Med','Red','Sosd.'};

colors =[ 'b','r','g','m','c','k', 'k'];
						
%% figure 1 plotting the interpolated files

figure (1)

hold on
sea_level=[newbt,newel ,newb, newsk, newRL, newRR, newsd];
sea_level2=[newbt,newel ,newb, newsk2, newRL, newRR, newsd];
n=7;
for i=1:n
scaled(:,i) = (sea_level2(:,i) - mean(sea_level2(:,i)))/std(sea_level2(:,i)); %gives a mean of 0 and standard deviation of one
end
plot(xi,scaled)
xlabel('0-430kya')
xlim([0 430])
legend(labels,'Location','Southoutside')
title('Centered and scaled Sea Level Rise Data from 0-430 kya')



%%  figure 2 how the files correlate with one another
figure (2)

imagesc(corrcoef(sea_level(:,1:n)))  %could also feed in 'scaled' and get the same graph
colorbar

set(gca,'XTickLabel', labels2)
set(gca,'YTickLabel', labels)
title('Correlation between variables')
%%

[scaled_loads, scaled_scores, scaled_variances] = princomp(scaled);
% part b
for i = 1:n scaled_var_PC(i) = 100*scaled_variances(i)/sum(scaled_variances); % percent variance
% explained by PC1
end
scaled_var_PC 



%% figure 3 graph of the loads

figure(3)
hold on
 for i=1:3
plot(scaled_loads(:,i),colors(i),'LineWidth',2)
 end
for i=4:n
plot(scaled_loads(:,i),colors(i),'LineWidth',1)
set(gca,'XTick',[1:n] ) % label each x tick mark
set(gca,'XTickLabel',labels2)
ylabel('PC loads')
title('centered and scaled load percent values')
ylabel('PC loads')

end
grid 
i=1;
s1 = {'PC'};
string2=[i:1:n];
s2=(cellstr(num2str(string2.')))
s3 = {' '};
filesize = [scaled_var_PC];
s4 = (cellstr(num2str(filesize.')))
s5 = {' %'};
  %'# Create a cell array of '
combinedStr = strcat(s1,s2,s3 ,s4,s5)%#    strings
legend(combinedStr{ : },'Location','Northoutside');
  %# Pass the cell array contents to legend
              %#   as a comma-separated list
hold off


%%  figure 4 graphing the 3 highest scores
  
figure(4)
scaled_a = scaled_scores(:,1); scaled_b = scaled_scores(:,2); scaled_c = scaled_scores(:,3);
subplot(3,1,1)
plot(xi,scaled_a,'LineWidth',2)
xlabel('time in kyr')
ylabel('Scores 1')
hold on
title('Centered and Scaled scores')
subplot(3,1,2)
plot(xi,scaled_b,'LineWidth',2)
xlabel('time in kyr')
ylabel('Scores 2')
subplot(3,1,3)
plot(xi(:,1),scaled_c,'LineWidth',2)
xlabel('time in kyr')
ylabel('Scores 3')
hold off



%% figure 5 3d graph of loads

figure (5)

x = scaled_loads(:,1); y = scaled_loads(:,2); z = scaled_loads(:,3);
plot3(x,y,z,'*')
grid
hold on
for i = 1:n
 plot3([x(i) x(i)],[y(i) y(i)],[0 z(i)]) % draw vertical lines
 text(x(i),y(i),z(i),labels(i)) % label each asterisk
end
xlabel('PC1 loads')
ylabel('PC2 loads')
zlabel('PC3 loads')
title('3d graph of loads with centering and scaling')


%% figure 6 Scores with LR04 and Precession landmarks with scaling
figure(6)


scaled_a = scaled_scores(:,1); scaled_b = scaled_scores(:,2); scaled_c = scaled_scores(:,3);
subplot(2,1,1)
plot(xi,scaled_a,'LineWidth',2)
hold on 
std1=std(newLR);
mean1=mean(newLR); 
std2=std(scaled_a); 
mean2=mean(scaled_a); 
scaled_newLR=mean2+(newLR-mean1)*std2/std1;
xlabel('time in kyr')
ylabel('Scores 1')
hold on
title('Centered and Scaled Scores1 with LR04')
old5E=scaled_newLR(122,1);
new5E=scaled_a(125,1);
oldlgmax=scaled_newLR(18,1);
newlgmax=scaled_a(25,1);


new_scaled_newLR=(((old5E-oldlgmax)/(new5E-newlgmax))*scaled_newLR)-((old5E)-(new5E));
plot(xi,new_scaled_newLR,'c')

subplot(2,1,2)
plot(xi,scaled_b,'LineWidth',2)
hold on

std3=std(newprecession);
mean3=mean(newprecession); 
std4=std(scaled_b); 
mean4=mean(scaled_b); 
scaled_newprecession=mean4+(newprecession-mean3)*std4/std3;
plot(xi,scaled_newprecession,'r')
title('Centered and Scaled Scores2 with precession parameter')
xlabel('time in kyr')
ylabel('Scores 2')

%%

figure(7)

scaled_a = scaled_scores(:,1); scaled_b = scaled_scores(:,2); scaled_c = scaled_scores(:,3);
subplot(3,1,1)
plot(xi,scaled_a,'LineWidth',2)
hold on 
std1=std(newLR);
mean1=mean(newLR); 
std2=std(scaled_a); 
mean2=mean(scaled_a); 
scaled_newLR=mean2+(newLR-mean1)*std2/std1;
xlabel('time in kyr')
ylabel('Scores 1')
hold on
title('Centered and Scaled Scores1 with LR04')
old5E=scaled_newLR(122,1);
new5E=scaled_a(125,1);
oldlgmax=scaled_newLR(18,1);
newlgmax=scaled_a(25,1);


new_scaled_newLR=(((old5E-oldlgmax)/(new5E-newlgmax))*scaled_newLR)-((old5E)-(new5E));


plot(xi,new_scaled_newLR,'c')

subplot(3,1,2)
plot(xi,scaled_b,'LineWidth',2)
hold on

std3=std(newprecession);
mean3=mean(newprecession); 
std4=std(scaled_b); 
mean4=mean(scaled_b); 
scaled_newprecession=mean4+(newprecession-mean3)*std4/std3;
plot(xi,scaled_newprecession,'r')
title('Centered and Scaled Scores2 with precession parameter')
xlabel('time in kyr')
ylabel('Scores 2')

subplot(3,1,3)
plot(xi,scaled_c,'LineWidth',2)
hold on

std7=std(newprecession);
mean7=mean(newprecession); 
std8=std(scaled_c); 
mean8=mean(scaled_c); 
scaled_newprecession=mean8+(newprecession-mean3)*std8/std7;
plot(xi,scaled_newprecession,'r')
title('Centered and Scaled Scores3 with precession parameter')
xlabel('time in kyr')
ylabel('Scores 3')


%% figure 8 Scatter plot (centered and scaled) PC1 vs LR04
figure (8)

plot(xi,scaled_c,'LineWidth',2)
hold on

std7=std(newprecession);
mean7=mean(newprecession); 
std8=std(scaled_c); 
mean8=mean(scaled_c); 
scaled_newprecession=mean8+(newprecession-mean3)*std8/std7;
plot(xi,scaled_newprecession,'r')
title('Centered and Scaled Scores3 with precession parameter')
ylim([-2 2.5])
xlabel('time in kyr')
ylabel('Scores 3')


%%
figure(9)

plot(new_scaled_newLR, scaled_a)
xlabel('scaled LR04')
ylabel('Scores 1')
title('Scatter plot PC1 vs. LR04')
%% figure 10 Scatter plot PC1 vs LR04 without lines

figure(10)

plot(new_scaled_newLR, scaled_a, 'o')
xlabel('scaled LR04')
ylabel('Scores 1')
title('Scatter plot PC1 vs. LR04')

%% figure 11 PC1 scaled to sea level with LR04, (checking the graph)


figure(11)

oldh=scaled_a(1,1);
oldLGM=scaled_a(25,1);
newh=5;
newLGM=-127.5;
new_scaled_a=((newh-newLGM)/(oldh-oldLGM))*scaled_a;
adjustment=(new_scaled_a(1,1)-newh);
new_scaled_a=new_scaled_a-(adjustment);
plot (xi,new_scaled_a)
hold on
plot (xi,328+100*newLR,'c')
title('Centered and scaled PC1 scaled to sea-level: 5m holocene, -127.5m LGM')
xlabel('0-430kya')
ylabel('Scores 1 (sea level (m)) and LR04*100')
legend('PC1 scaled to Sea Level', ' 100*LR04 (per mil)','Location','Southoutside')


%% figure 12 best fit quadratic with 2*sigma error bars


xmodel=[-5.0:.1:-3.0];
[P,S,mu]=polyfit(newLR, new_scaled_a, 2);
[ymodel,delta]=polyval(P, xmodel, S, mu);

[y,d]=polyval(P,newLR,S,mu);
Residuals = (new_scaled_a) - polyval(P,newLR,S, mu);
E=std(Residuals)*ones(size(xmodel));
color = ['k','r','g','m','c'];

figure (12)

plot(newLR, new_scaled_a,'o' )
hold on
plot(xmodel, ymodel, color(2))
hold on
plot(xmodel, ymodel+2*E, color(3))
hold on
plot(xmodel, ymodel-2*E, color(3))
hold off
title('2-sigma error with Scatter plot of PC1 vs. LR04')
xlabel('LR04 per mil')
ylabel('Scores 1 (sea level (m))')
legend('scatterplot','best-fit quadratic','y-2*error, y+2*error','Location','Southoutside')




%%  figure 13 Plot after removing outliers
figure(13)

index=find(Residuals > -2*std(Residuals));
LR_no_outliers=newLR(index);
scaled_a_no_outliers=new_scaled_a(index);

[P2,S2,mu2]=polyfit(LR_no_outliers, scaled_a_no_outliers, 2);

[ymodel2,delta2]=polyval(P2, xmodel, S2, mu2);
plot(xmodel,ymodel2)

[y2,d2]=polyval(P2,LR_no_outliers,S2,mu2);
Residuals2 = (scaled_a_no_outliers) - polyval(P2,LR_no_outliers,S2, mu2);
E2=std(Residuals2)*ones(size(xmodel));

plot(LR_no_outliers, scaled_a_no_outliers,'o','Linewidth',2 )
hold on
plot(xmodel, ymodel2, color(2),'Linewidth',2)
title('best-fit quadratic Scatter plot of PC1 vs. LR04 after removing outliers')
xlabel('LR04 per mil')
ylabel('Scores 1 (sea level (m))')
legend('scatterplot after outliers removed','best-fit quadratic after removing outliers','Location','Southoutside')
hold off



%% figure 14 Plot after removing outliers
figure(14)

index=find(Residuals > -2*std(Residuals));
LR_no_outliers=newLR(index);
scaled_a_no_outliers=new_scaled_a(index);

[P2,S2,mu2]=polyfit(LR_no_outliers, scaled_a_no_outliers ,2);

[ymodel2,delta2]=polyval(P2, xmodel, S2, mu2);
plot(xmodel,ymodel2)

[y2,d2]=polyval(P2,LR_no_outliers,S2,mu2);
Residuals2 = (scaled_a_no_outliers) - polyval(P2,LR_no_outliers,S2, mu2);
E2=std(Residuals2)*ones(size(xmodel));
 

plot(newLR, new_scaled_a,'o' ,'Color','m','Linewidth',2)
hold on
plot(LR_no_outliers, scaled_a_no_outliers,'o' ,'Color','b','Linewidth',2)
hold on
plot(xmodel, ymodel2, color(2),'Linewidth',2)
hold on
plot(xmodel, ymodel2+2*E2, 'k','Linewidth',2)
hold on
plot(xmodel, ymodel2-2*E2, 'k','Linewidth',2)

title('excluded outliers: 2-sigma error with Scatter plot of PC1 vs. LR04')

title('Scatter plot of PC1 vs. LR04 with best fit quadratic')
xlabel('LR04 per mil')
ylabel('Scores 1 (sea level (m))')
legend('scatterplot before outliers removed','scatterplot after outliers removed','best-fit quadratic after removing outliers',' y-2*error, y+2*error (after outliers removed(2nd order))','Location','Southoutside')
hold off



%% figure 15 Residuals plot before and after outliers removed, best fit 2nd order

figure (15)

plot(xi,Residuals,'o','Color','m')
hold on
plot(index,Residuals2,'o','Color','b')
title('Residuals vs. time')
xlabel('0-430 kya')
ylabel('Residuals')
legend('Residuals before outliers  removed','Residuals after outliers removed, best fit poly 2nd order','Location','Southoutside')

%% figure 16 Comparison plot, model transformed LR04

figure (16)

plot(index,y2,'c', 'Linewidth',2)
hold on
plot(xi,new_scaled_a,'b','Linewidth',2)
title('Comparison of PC1 scaled to sea level with model transformed LR04')
xlabel('time 0-430 kya')
ylabel('Scores 1 (sea level (m)),LR04')
legend('model-transformed LR04','PC1 ','Location','Southoutside')
hold off

%% Checking that the model holds:

figure (17)

dx=[0:1:798]';

Lis=load('lisiecki2005.txt');%x values are discrete
newLR04=interp1(Lis(:,1),-1*Lis(:,2),dx);

[y3,d3]=polyval(P2,newLR04,S2,mu2);
plot(dx,y3,'c')
hold on
plot(index,y2,'b')
xlabel('0-800 kya')
ylabel('sea level (m)')
title('overlay of 430kyr LR04 transformed model with 800kyr transformed model')
legend('LR04 430 kyr transformed model','LR04 800 kyr transformed model','Location','Southoutside')

%% Redo all the interpolations:

%sh=load('d18Osw_stack.txt');%starts at 0
newsh=interp1(sk(:,1),((-1*(sk(:,2))/.01)-73),dx);%Subtract 73 from all SSH's

newsh2=interp1(sk(:,1),((-1*(sk(:,2))/.01)-73+20.5367),dx);%rescaled


%bin=load('bintanja.txt');% Starts at 0 recheck the graph of this one
newbin=interp1(bt(:,1),bt(:,3),dx);

%sos=load('sosdian2009_with_piston_core_and_zero.txt');%sosdian to short from the front; data does not start at 0
newsos=interp_with_averages(sd(:,1),sd(:,6),dx);%Starts at 153??

%eld=load('elderfield_sea_level_with_zero.txt');%not loading properly
neweld=interp_with_averages(el(:,1), -1*el(:,2)/.01, dx);%Starts at 7


newRoh=interp_with_averages(RL(:,2),RL(:,3),dx);%columns C and D from original data set

prec=load('orb_params.txt'); 
newprec=interp1(-1*prec(:,1),-1*prec(:,4),dx);

labels3 = {'Bintanja','Elderfield','Shakun',' Med (Roh.)','Sosdian'};

labels4 = {'Bint.','Eld.', 'Shak.',' Med','Sosd.'};

%% 800 kyr sl

figure (18)

hold on
longer_sea_level=[ newbin, neweld, newsh2,newRoh,  newsos];
for i=1:5
new_centered(:,i) = longer_sea_level(:,i) - mean(longer_sea_level(:,i));
end
for i=1:5
new_scaled(:,i) = (longer_sea_level(:,i) - mean(longer_sea_level(:,i)))/std(longer_sea_level(:,i));
end
plot(dx,new_scaled)
xlabel('0-800kya')
xlim([0 800])
legend(labels3,'Location','Southoutside')
title('Centered and scaled Sea Level Rise Data from 0-800 kya')

%% corcoef plot
figure (19)

imagesc(corrcoef(longer_sea_level(:,1:5)))
colorbar
set(gca,'XTick',[1:5] ) % label each x tick mark
set(gca,'YTick',[1:5] )
set(gca,'XTickLabel', labels4)
set(gca,'YTickLabel', labels3)
title('Correlation between variables')

scaled_var_PC 
str = num2str(scaled_var_PC )


%%  PC Scores for 800 kyr PCA


j=5;
[new_scaled_loads, new_scaled_scores, new_scaled_variances] = princomp(new_scaled);
% part b
for i = 1:j 
    new_scaled_var_PC(i) = 100*new_scaled_variances(i)/sum(new_scaled_variances); % percent variance
% explained by PC1
end
new_scaled_var_PC 
figure (20)
hold on
 for i=1:3
plot(new_scaled_loads(:,i),colors(i),'LineWidth',2)
 end
for i=4:j
plot(new_scaled_loads(:,i),colors(i),'LineWidth',1)
set(gca,'XTick',[1:j] ) % label each x tick mark
set(gca,'XTickLabel',labels3)
ylabel('PC loads')
%legend(str1(1:7),str1(13:19),str1(24:32),str1(38:45),str1(50:58),'Location','Northoutside')
title('centered and scaled load percent values')
ylabel('PC loads')
end
i=1;
s1 = {'PC'};
string2=[i:1:j];
s2=(cellstr(num2str(string2.')))
s3 = {' '};
filesize2 = [new_scaled_var_PC];
str4 = (cellstr(num2str(filesize2.')))
s5 = {' %'};

  %'# Create a cell array of '
combinedStr2 = strcat(s1,s2,s3 ,str4,s5)%#    strings
legend(combinedStr2{ : },'Location','Northoutside');
  %# Pass the cell array contents to legend
grid               %#   as a comma-separated list
hold off

  %'# Create a cell array of                                               %#    strings
%legend(str2{ : },'Location','Northoutside');
  %# Pass the cell array contents to legend
 
      
 
 %%  figure 21 graphing the 3 highest scores
  
figure(21)

newly_scaled_a = new_scaled_scores(:,1); newly_scaled_b = new_scaled_scores(:,2); newly_scaled_c = new_scaled_scores(:,3);
subplot(3,1,1)
plot(dx,newly_scaled_a,'LineWidth',2)
xlabel('time in kyr')
ylabel('Scores 1')
hold on
title('Centered and Scaled scores to 800 kya')
subplot(3,1,2)
plot(dx,newly_scaled_b,'LineWidth',2)
xlabel('time in kyr')
ylabel('Scores 2')
subplot(3,1,3)
plot(dx,newly_scaled_c,'LineWidth',2)
xlabel('time in kyr')
ylabel('Scores 3')
hold off

%% figure 22 3d graph of loads


figure (22)
x = new_scaled_loads(:,1); y = new_scaled_loads(:,2); z = new_scaled_loads(:,3);
plot3(x,y,z,'*')
grid
hold on
for i = 1:5
 plot3([x(i) x(i)],[y(i) y(i)],[0 z(i)]) % draw vertical lines
 text(x(i),y(i),z(i),labels3(i)) % label each asterisk
end
xlabel('PC1 loads')
ylabel('PC2 loads')
zlabel('PC3 loads')
title('3d graph of loads with centering and scaling')


%% figure 23 Scores with LR04 and Precession landmarks with scaling

figure(23)

newly_scaled_a = new_scaled_scores(:,1); newly_scaled_b = new_scaled_scores(:,2); 
subplot(2,1,1)
 
old_zero=newly_scaled_a(1,1);
o_LGM=newly_scaled_a(25,1);

new_zero=5;
n_LGM=-127.5;
scaled_PC1=((new_zero-n_LGM)/(old_zero-o_LGM))*newly_scaled_a;
adjustment3=scaled_PC1(1,1)-new_zero;
scaled_PC1=scaled_PC1-adjustment3;
plot (dx,scaled_PC1,'b')
xlabel('time in kyr')
ylabel('Scores 1')
title(' Scores1 scaled to sea level (5m at 0kyr, -127.5m at LGM)')


subplot(2,1,2)

plot(dx,newly_scaled_b,'LineWidth',2.5)
hold on

std3=std(newprec);
mean3=mean(newprec); 
std4=std(newly_scaled_b); 
mean4=mean(scaled_b); 
scaled_newprec=mean4+(newprec-mean3)*std4/std3;
plot(dx,scaled_newprec,'r')
title('Centered and Scaled Scores2 with precession parameter')
xlabel('time in kyr')
ylabel('Scores 2 with precession')

%%

figure(24)

newly_scaled_a = new_scaled_scores(:,1); newly_scaled_b = new_scaled_scores(:,2); 
subplot(3,1,1)
 
old_zero=newly_scaled_a(1,1);
o_LGM=newly_scaled_a(25,1);
new_zero=5;
n_LGM=-127.5;
scaled_PC1=((new_zero-n_LGM)/(old_zero-o_LGM))*newly_scaled_a;
adjustment2=scaled_PC1(1,1)-new_zero;
scaled_PC1=scaled_PC1-adjustment2;
plot (dx,scaled_PC1,'b')
xlabel('time in kyr')
ylabel('Scores 1')
title(' Scores1 scaled to sea level (5m at 0kyr, -127.5m at LGM)')


subplot(3,1,2)

plot(dx,newly_scaled_b,'LineWidth',2.5)
hold on

std3=std(newprec);
mean3=mean(newprec); 
std4=std(newly_scaled_b); 
mean4=mean(newly_scaled_b); 
scaled_newprec=mean4+(newprec-mean3)*std4/std3;
plot(dx,scaled_newprec,'r')
title('Centered and Scaled Scores2 with precession parameter')
xlabel('time in kyr')
ylabel('Scores 2 with precession')

subplot(3,1,3)

plot(dx,newly_scaled_c,'LineWidth',2.5)
hold on

std5=std(newprec);
mean5=mean(newprec); 
std6=std(newly_scaled_c); 
mean6=mean(newly_scaled_c); 
scaled_newprec=mean6+(newprec-mean3)*std6/std5;
plot(dx,scaled_newprec,'r')
title('Centered and Scaled Scores3 with precession parameter')
xlabel('time in kyr')
ylabel('Scores 3 with precession')

%%
figure (25)

plot(dx,newly_scaled_c,'LineWidth',2.5)
hold on

std5=std(newprec);
mean5=mean(newprec); 
std6=std(newly_scaled_c); 
mean6=mean(newly_scaled_c); 
scaled_newprec=mean6+(newprec-mean3)*std6/std5;
plot(dx,scaled_newprec,'r')
title('Centered and Scaled Scores3 with precession parameter')
xlabel('time in kyr')
ylabel('Scores 3 with precession')

figure (26)

plot (dx,scaled_PC1,'g')
hold on
plot(xi,new_scaled_a,'b')
xlim([0 430]);
title('Comparison of 400kyr PC1 with 800kyr PC1')
xlabel('time 0-430 kya')
ylabel('Scores 1 (scaled to sea level (m))')
legend('PC1 for 800kyr S.L','PC1 for 400kyr S.L. ','Location','Southoutside')
hold off
%%

figure (27)

plot (dx,scaled_PC1,'b')
hold on
plot(RL(:,2),RL(:,3),'m')
xlim([400 700]);
title('Looking for the sapropel layers in Med. S.l.')
xlabel('time 400-700 kya')

legend('PC1 ','Roh  ','Location','Southoutside')
hold off
%timing 
%1)434-452
%2)543-558
%3)630-663

%% 
figure (28)

newsk;

hold on

%centered = sea_level - mean(sea_level);
scaled_shakun = (newsk - mean(newsk))/std(newsk);

scaledPC1 = (scaled_a - mean(scaled_a))/std(scaled_a);

plot(xi,scaled_shakun,'Color', [0.5 0.5 0.5])
xlabel('0-430kya')
hold on
plot(xi,scaledPC1,'b')
xlim([0 430])
ylim([-4 3])
legend('Shakun','PC1','Location','Southoutside')
title('Centered and scaled Sea Level Rise Data from 0-430 kya')
%%

newbt;

figure (29)

hold on

%centered = sea_level - mean(sea_level);
scaled_bintanja = (newbt - mean(newbt))/std(newbt);

plot(xi,scaled_bintanja,'Color',[.4 0 .4])
xlabel('0-430kya')
hold on
plot(xi,scaledPC1,'Color',[.4 0 1])
xlim([0 430])
ylim([-4 3])
legend('Bintanja','PC1','Location','Southoutside')
title('Centered and scaled Sea Level Rise Data from 0-430 kya')

%%


figure (30)

hold on

%centered = sea_level - mean(sea_level);
scaled_sosdian = (newsd - mean(newsd))/std(newsd);


plot(xi,scaled_sosdian,'Color', [0.5 0.5 0.5])
xlabel('0-430kya')
hold on
plot(xi,scaledPC1,'Color','b' )
xlim([0 430])
ylim([-4 3])
legend('Sosdian','PC1','Location','Southoutside')
title('Centered and scaled Sea Level Rise Data from 0-430 kya')

%%

figure (31)
newb;

hold on

%centered = sea_level - mean(sea_level);
scaled_newb = (newb - mean(newb))/std(newb);


plot(xi,scaled_newb,'Color', 'r')
xlabel('0-430kya')
hold on
plot(xi,scaledPC1,'b')
xlim([0 430])
ylim([-4 3])
legend('Waelbroeck','PC1','Location','Southoutside')
title('Centered and scaled Sea Level Rise Data from 0-430 kya')

%%
figure (32)


hold on

%centered = sea_level - mean(sea_level);
scaled_newel = (newel - mean(newel))/std(newel);


plot(xi,scaled_newel,'Color','g','Linewidth',2)
xlabel('0-430kya')
hold on
plot(xi,scaledPC1,'Color', 'k','Linewidth',2)
xlim([0 430])
ylim([-4 3])
legend('Elderfield','PC1','Location','Southoutside')
title('Centered and scaled Sea Level Rise Data from 0-430 kya')



%%
figure (33)


hold on

%centered = sea_level - mean(sea_level);
scaled_newRL = (newRL - mean(newRL))/std(newRL);



plot(xi,scaled_newRL,'m')
xlabel('0-430kya')
hold on
plot(xi,scaledPC1,'Color', 'b')
xlim([0 430])
ylim([-4 3])
legend('Rohling Med S.L','PC1','Location','Southoutside')
title('Centered and scaled Sea Level Rise Data from 0-430 kya')
newRR;


%%
figure (34)



hold on

%centered = sea_level - mean(sea_level);
scaled_newRR = (newRR - mean(newRR))/std(newRR);


plot(xi,scaled_newRR,'Color',[.1 1 0])
xlabel('0-430kya')
hold on
plot(xi,scaledPC1,'Color', 'b')
xlim([0 430])
ylim([-4 3])
legend('Rohling Red S.L','PC1','Location','Southoutside')
title('Centered and scaled Sea Level Rise Data from 0-430 kya')

%%



%%
figure (35)

newsh;


hold on

%centered = sea_level - mean(sea_level);
scaled_shakun = (newsh - mean(newsh))/std(newsh);


scaledPC1_8ky = (newly_scaled_a - mean(newly_scaled_a))/std(newly_scaled_a);

plot(dx,scaled_shakun,'Color', [0.5 0.5 0.5])
xlabel('0-800kya')
hold on
plot(dx,scaledPC1_8ky,'Color', 'b')
xlim([0 800])
ylim([-4 3])
legend('Shakun','PC1','Location','Southoutside')
title('Centered and scaled Sea Level Rise Data from 0-800 kya')
%%


figure (36)


hold on

%centered = sea_level - mean(sea_level);
scaled_bintanja = (newbin - mean(newbin))/std(newbin);


plot(dx,scaled_bintanja,'Color',[.4 0 .4])
xlabel('0-800kya')
hold on
plot(dx,scaledPC1_8ky,'Color', [.4 0 1])
xlim([0 800])
ylim([-4 3])
legend('Bintanja','PC1','Location','Southoutside')
title('Centered and scaled Sea Level Rise Data from 0-800 kya')

%%


figure (37)

hold on

%centered = sea_level - mean(sea_level);
scaled_sosdian = (newsos - mean(newsos))/std(newsos);

plot(dx,scaled_sosdian,'Color', [0.5 0.5 0.5])
xlabel('0-800kya')
hold on
plot(dx,scaledPC1_8ky,'b')
xlim([0 800])
ylim([-4 3])
legend('Sosdian','PC1','Location','Southoutside')
title('Centered and scaled Sea Level Rise Data from 0-800 kya')


%%

figure (38)

hold on

%centered = sea_level - mean(sea_level);
scaled_newel = (neweld - mean(neweld))/std(neweld);

plot(dx,scaled_newel,'g')
xlabel('0-800kya')
hold on
plot(dx,scaledPC1_8ky,'Color', 'b')
xlim([0 800])
ylim([-4 3])
legend('Elderfield','PC1','Location','Southoutside')
title('Centered and scaled Sea Level Rise Data from 0-800 kya')
%%

figure (39)

hold on

%centered = sea_level - mean(sea_level);
scaled_newRoh = (newRoh - mean(newRoh))/std(newRoh);

plot(dx,scaled_newRoh,'m')
xlabel('0-800kya')
hold on
plot(dx,scaledPC1_8ky,'Color', 'b')
xlim([0 800])
ylim([-4 3])
legend('Rohling Med S.L','PC1','Location','Southoutside')
title('Centered and scaled Sea Level Rise Data from 0-800 kya')
%% 'Mean sea level with raw sea level files'

figure (40)

sea_average=mean(sea_level');
sea_average2=mean(sea_level2');
plot(xi,sea_average)
xlabel('0-430kyr')
ylabel('sea level(m)')
title('Mean sea level with raw sea level files')


%% 'Mean sea level with centered and scaled sea level files'
figure(41)

scaled_sea_average=mean(scaled');
plot(xi,scaled_sea_average)
xlabel('0-430kyr')
title('Mean sea level with centered and scaled sea level files')


%% sea level standard deviation (m) per time point (430 kyr) with raw sea level files'

figure (42)

sea_level_std=std(sea_level');
sea_level_std2=std(sea_level2');
plot(xi,sea_level_std)
xlabel('0-430kyr')
ylabel('sea level standard deviation(m)')
title(' sea level standard deviation (m) per time point (430 kyr) with raw sea level files')

%% ' sea level standard deviation per time point(430 kyr) with centered and scaled sea level files'
figure (43)
sea_level_std_scaled=std(scaled');
plot(xi,sea_level_std_scaled)
xlabel('0-430kyr')
title(' sea level standard deviation per time point(430 kyr) with centered and scaled sea level files')



%% 'Mean sea level with raw sea level files (NaNs removed) 800kyr'
figure (43)

Rohling_with_Nans =load('medsealev_nosap_LR04_NaN_col.txt');
Med_sea_800kyr=Rohling_with_Nans(:,4);
sea_level_800kyr=[ newbin, neweld, newsh2,Med_sea_800kyr,  newsos];

longer_sea_average=nanmean(sea_level_800kyr');
plot(dx,longer_sea_average)
xlabel('0-800kyr')
ylabel('sea level(m)')
title('Mean sea level with raw sea level files (NaNs removed) 800kyr')

%% 'Mean 800 kyr sea level with centered and scaled sea level files'
figure (44)

for i=1:5

scaled_800kyr(:,i) = (sea_level_800kyr(:,i) - nanmean(sea_level_800kyr(:,i)))/std(sea_level_800kyr(:,i));

end

scaled_sea_average_8kyr=nanmean(scaled_800kyr');
plot(dx,scaled_sea_average_8kyr')
xlabel('0-800kyr')
title('Mean 800 kyr sea level with centered and scaled sea level files')


%% 'standard deviation of 800kyr sea level with raw sea level files'

figure (45)

longer_sea_average_std=nanstd(sea_level_800kyr');

plot(dx,longer_sea_average_std)
xlabel('0-800kyr')
ylabel('sea level standard deviation(m)')
title('standard deviation of 800kyr sea level with raw sea level files')


%% 'standard deviation of 800kyr sea level with centered and scaled sea level files'

figure (46)

longer_sea_average_scaled_std=nanstd(scaled_800kyr');
plot(dx,longer_sea_average_scaled_std)
xlabel('0-800kyr')
title('standard deviation of 800kyr sea level with centered and scaled sea level files')

%% 'original NaNs', 'secondarily removed NaNs (datafile+4)'
figure (47)

plot(RL(:,2),RL(:,3),'b')
hold on
plot(dx, 4+Med_sea_800kyr,'r')
hold off
title('making sure the Nans line up')
legend('original NaNs', 'secondarily removed NaNs (datafile+4)','Location','Southoutside')


%%

figure (48)

old_5e=scaled_sea_average(1,122);
o_LGM=scaled_sea_average(1,25);
new_5e=-.1514;
n_LGM=-127.5;
meters_scaled_sea_average=((new_5e-n_LGM)/(old_5e-o_LGM))*scaled_sea_average-53.3785-.1514-.5122-.0206-.1102;

plot(xi,sea_average,'Color', 'r')
hold on
plot (xi,new_scaled_a,'Color', 'b')
plot(xi,meters_scaled_sea_average,'g')
xlabel('0-430kyr')
title('Mean 430 kyr sea level with  scaled PC1')
legend('Mean Sea Level','PC1 scaled to sea level','scaled mean sea level','Location','Southoutside')
%%


%% % sea level without Shakun rescaling
figure (50) %%labels = {'Bintanja','Elderfield','Waelbroeck','Shakun',' Med (Roh.)','Red (Roh.)','Sosdian'};

hold on
sea_level=[newbt,newel ,newb, newsk, newRL, newRR, newsd];

plot(xi,sea_level)
xlabel('0-430kya')
xlim([0 430])
legend(labels,'Location','Southoutside')
title('Sea Level Rise Data from 0-430 kya')


%% Closeup of sea level without Shakun rescaling
figure (51)
hold on
sea_level=[newbt,newel ,newb, newsk, newRL, newRR, newsd];


plot(xi,sea_level)
xlabel('0-430kya')
xlim([117 410])
ylim([-60 60])
set(gca,'XTick',[0:100:800] ) % label each x tick mark

legend(labels,'Location','Southoutside')
title('Sea Level Rise Data from 0-430 kya')
%% Sea level graph with Shakun rescaling

figure (52)


hold on
sea_level=[newbt,newel ,newb, newsk2, newRL, newRR, newsd];

plot(xi,sea_level2)
xlabel('0-430kya')
xlim([0 430])
legend(labels,'Location','Southoutside')
title('Sea Level Rise Data from 0-430 kya with Shakun rescaled')

%% Sea level closeup with Shakun rescaling
figure (53)
hold on

sea_level2=[newbt,newel ,newb, newsk2, newRL, newRR, newsd];

plot(xi,sea_level2)
xlabel('0-430kya')
xlim([117 410])
ylim([-60 60])
set(gca,'XTick',[120:40:410] ) % label each x tick mark

legend(labels,'Location','Southoutside')
title('Sea Level Rise Data from 0-430 kya')

%%
figure (54)
hold on

sea_level3=[ newbin, neweld, newsh2,Med_sea_800kyr,  newsos];

plot(dx,sea_level3)
xlabel('0-800 kya')
xlim([0 800])
ylim([-165 80])
set(gca,'XTick',[0:100:800] ) % label each x tick mark
ylabel('RSL (m)')
legend(labels,'Location','Southoutside')
title('Sea Level Rise Data from 0-800 kya')


%%
figure (55)

plot(xi,new_scaled_a)
hold on
plot(dx,scaled_PC1)
hold off



%% 5e time points


Bintanja_5e=newbt(125,1)
Elderfield_5e=newel(127,1)
Waelbroeck_5e=newb(124,1)
Mediterr_5e=newRL(120,1)
RedSea_5e=newRR(123,1)
Sosdian_5e=newsd(122,1)

%% Shakun 5e without and with rescaling
Shakun_5e=newsk(118,1)
Shakun_5e2=newsk2(118,1)




%% MIS 11 time points


Bintanja_MIS11=newbt(404,1)
Elderfield_MIS11=newel(401,1)
Waelbroeck_MIS11=newb(404,1)
Mediterr_MIS11=newRL(402,1)
RedSea_MIS11=newRR(400,1)
Sosdian_MIS11=newsd(400,1)


%% Shakun MIS11 with and without rescaling
Shakun_MIS11=newsk(404,1)
Shakun_MIS11_2=newsk2(404,1)


%% SL stack values for 5e without and with rescaling

Stack_5e=sea_average(1,122)
Stack_5e_2=sea_average2(1,122)

%% SL stacke values for MIS11 without and with rescaling
Stack_MIS11=sea_average(1,405)
Stack_MIS11_2=sea_average2(1,405)

%% 5e Standard deviation without and with Shakun rescaling

Stack_std_5e=sea_level_std(1,122)
Stack_std_5e_2=sea_level_std2(1,122)

%% MIS 11 Standard deviation without and with Shakun rescaling
Stack_std_MIS11=sea_level_std(1,405)
Stack_std_MIS11_2=sea_level_std2(1,405)

%% New way of taking standard deviation
MIS5e_std=std([Bintanja_5e,Elderfield_5e,Waelbroeck_5e,Shakun_5e2,Mediterr_5e,RedSea_5e,Sosdian_5e])

MIS_11std= std([Bintanja_MIS11,Elderfield_MIS11,Waelbroeck_MIS11,Shakun_MIS11_2,Mediterr_MIS11,RedSea_MIS11,Sosdian_MIS11])
%%
figure (56)

labels7 = {'Bintanja','Elderfield','Shakun',' Med (Roh.)','Sosdian', 'PC1'};

sea_level3=[ newbin, neweld, newsh2,Med_sea_800kyr,  newsos];

plot(dx,sea_level3)
hold on 
plot(dx,scaled_PC1,'k','Linewidth',2)
xlabel('0-800 kya')
hold off
xlim([0 800])
ylim([-165 80])
set(gca,'XTick',[0:100:800] ) % label each x tick mark
ylabel('RSL (m)')
legend(labels7,'Location','Southoutside')
title('Sea Level Rise Data from 0-800 kya')

figure (57)


hold on

%centered = sea_level - mean(sea_level);
scaled_newel = (newel - mean(newel))/std(newel);


plot(xi,newel,'Color','g','Linewidth',2)
xlabel('0-430kya')
hold on
plot(xi,new_scaled_a,'Color', 'k','Linewidth',2)
xlim([0 430])
ylim([-175 65])

legend('Elderfield','PC1','Location','Southoutside')
title('Sea Level Rise Data from 0-430 kya')

figure (58)


hold on

%centered = sea_level - mean(sea_level);
scaled_newel = (newel - mean(newel))/std(newel);


plot(xi,newsd,'Color','m','Linewidth',2)
xlabel('0-430kya')
hold on
plot(xi,new_scaled_a,'Color', 'k','Linewidth',2)
xlim([0 430])
ylim([-175 60])

legend('Sosdian','PC1','Location','Southoutside')
title('Sea Level Rise Data from 0-430 kya')







