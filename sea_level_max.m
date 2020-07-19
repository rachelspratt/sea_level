
clear all
close all

bootstrap=load('pc1_bootstrap_long_all.txt');
%n=1000

%for i=1:n
fifty=prctile(bootstrap,50)

 ninety_seven=prctile(bootstrap,97.5)
 two_pont_five=prctile(bootstrap,2.5)
 
 
 %MIStwo=min
 
 plot((1:799),fifty)
 hold on
 plot((1:799),two_pont_five)
  hold on
   plot((1:799),ninety_seven)
   
[MIS2lower,I] = min(two_pont_five(1,18:25));    
[MIS2med,I] = min(fifty(1,18:25));
[MIS2upper,I] = min(ninety_seven(1,18:25));
MIS2_range=[MIS2lower,MIS2med,MIS2upper]

[MIS6lower,I] = min(two_pont_five(1,135:141));    
[MIS6med,I] = min(fifty(1,135:141));
[MIS6upper,I] = min(ninety_seven(1,135:141));
MIS6_range=[MIS6lower,MIS6med,MIS6upper]


[MIS10lower,I] = min(two_pont_five(1,342:353));    
[MIS10med,I] = min(fifty(1,342:353));
[MIS10upper,I] = min(ninety_seven(1,342:353));
MIS10_range=[MIS10lower,MIS10med,MIS10upper]


[MIS12lower,I] = min(two_pont_five(1,427:458));    
[MIS12med,I] = min(fifty(1,427:458));
[MIS12upper,I] = min(ninety_seven(1,427:458));
MIS12_range=[MIS12lower,MIS12med,MIS12upper]


[MIS16lower,I] = min(two_pont_five(1,625:636));    
[MIS16med,I] = min(fifty(1,625:636));
[MIS16upper,I] = min(ninety_seven(1,625:636));
MIS16_range=[MIS16lower,MIS16med,MIS16upper]

   
[MIS5elower,I] = max(two_pont_five(1,119:126));    
[MIS5emed,I] = max(fifty(1,119:126));
[MIS5eupper,I] = max(ninety_seven(1,119:126));
MIS5e_range=[MIS5elower,MIS5emed,MIS5eupper]

[MIS7aclower,I] = max(two_pont_five(1,197:214));    
[MIS7acmed,I] = max(fifty(1,197:214));
[MIS7acupper,I] = max(ninety_seven(1,197:214));
MIS7ac_range=[MIS7aclower,MIS7acmed,MIS7acupper]


   
[MIS7elower,I] = max(two_pont_five(1,236:255));    
[MIS7emed,I] = max(fifty(1,236:255));
[MIS7eupper,I] = max(ninety_seven(1,236:255));
MIS7e_range=[MIS7elower,MIS7emed,MIS7eupper]

   

[MIS9lower,I] = max(two_pont_five(1,315:331));    
[MIS9med,I] = max(fifty(1,315:331));
[MIS9upper,I] = max(ninety_seven(1,315:331));
MIS9_range=[MIS9lower,MIS9med,MIS9upper]


[MIS11lower,I] = max(two_pont_five(1,399:408));    
[MIS11med,I] = max(fifty(1,399:408));
[MIS11upper,I] = max(ninety_seven(1,399:408));
MIS11_range=[MIS11lower,MIS11med,MIS11upper]


[MIS13lower,I] = max(two_pont_five(1,486:502));    
[MIS13med,I] = max(fifty(1,486:502));
[MIS13upper,I] = max(ninety_seven(1,486:502));
MIS13_range=[MIS13lower,MIS13med,MIS13upper]


[MIS17lower,I] = max(two_pont_five(1,682:697));    
[MIS17med,I] = max(fifty(1,682:697));
[MIS17upper,I] = max(ninety_seven(1,682:697));
MIS17_range=[MIS17lower,MIS17med,MIS17upper]



[MIS19lower,I] = max(two_pont_five(1,761:782));    
[MIS19med,I] = max(fifty(1,761:782));
[MIS19upper,I] = max(ninety_seven(1,761:782));
MIS19_range=[MIS19lower,MIS19med,MIS19upper]

