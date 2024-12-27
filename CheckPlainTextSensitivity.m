
%CY=imge_encrypted;
%CY_=yed;
%RandomPoz=zeros(2,100);
%UACIs=zeros(1,100);
%PCRs=zeros(1,100);
%nnn=0;

%%
                        CY=imge_Watermarked8bit;
                        %CY_=yed2;
[a b]=size(CY);
%% NPCR
Pcr=(My_Diff(CY,CY_)/(a*b))*100;

fprintf('\n NPCR=%3.2f percentage\n',Pcr);


%% UACI 

toplam=0;
for i=1:a
   for j=1:b
      toplam=toplam+(abs(CY(i,j)-CY_(i,j))/255);
       
   end
end

UACI=1/(a*b)*toplam*100;

fprintf('\n UACI=%3.2f percentage\n',UACI);


UACIs(nnn)=UACI;
PCRs(nnn)=Pcr;
