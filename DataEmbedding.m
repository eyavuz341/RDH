%Performs data embedding 

%% 256x256 test imgeyi oluþturma
imge_original=imge;

imge=[];
I0=[];

imge=uint8(imge_encrypted);
secretBinImage=Logo256;


figure
subplot(1,2,1)
imshow(imge, [0 255]);
title('Encrypted image')
subplot(1,2,2)
imshow(secretBinImage, [0 1]);
title('Secret image')


%%  bit dizisini 256x256 imge haline getirme 

windowSize=2;

[a,b]=size(imge);
I00=reshape(imge',1,a*b);


[a,b]=size(secretBinImage);
secretBinImage_OneD=reshape(secretBinImage',1,a*b);

%Modifying the secret image by a random sequence

   Q=g(1,3);
   lambda3=g(3,3);

        for h=1:Tr   
            Q=lambda3*Q*(1-Q);
        end
        
  n=length(secretBinImage_OneD);
  Q_seq=[];
  for i=1:n
     Q=lambda3*Q*(1-Q);
     Q_seq(i)=Q;
        
     if(Q>=0.5)
         secretBinImage_OneD(i)=bitxor(secretBinImage_OneD(i),1);
     else
         secretBinImage_OneD(i)=bitxor(secretBinImage_OneD(i),0);
     end
  end


%%
IRR=I00;

L=length(IRR);

Modlar1=[257 259 2];
Modlar2=[257 2 259];
Modlar3=[2 259 257];

Modlar=Modlar1;
n=size(Modlar,2)-1;

BKs=[];
IR_Chinese_embedded=[];
IR_Chinese=[];



for i=1:L/n
   k1=(i-1)*n+1;
   k2=i*n;  
   
   if(Q_seq(i)>=0.667)
       
        kalanlar=[double(IRR(k1:k2)) secretBinImage_OneD(i)];
   elseif(Q_seq(i)>=0.333)
               
           kalanlar=[double(IRR(k1)) secretBinImage_OneD(i) double(IRR(k2))];
   else
        kalanlar=[secretBinImage_OneD(i) double(IRR(k1:k2))];
   end
   
   BKs(i,1:n+1)=kalanlar;

   
   IR_Chinese(i)= My_ChineseRemainder(double(IRR(k2)),[257 259]);  

   
      if(Q_seq(i)>=0.667)
       
       
           kalanlar(1)=kalanlar(1)+double(secretBinImage_OneD(i));
           kalanlar(2)=kalanlar(2)+double(secretBinImage_OneD(i)); 
           Modlar=Modlar1;
      elseif(Q_seq(i)>=0.333)
           kalanlar(1)=kalanlar(1)+double(secretBinImage_OneD(i));
           kalanlar(3)=kalanlar(3)+double(secretBinImage_OneD(i)); 
           Modlar=Modlar2;               
       else
           kalanlar(2)=kalanlar(2)+double(secretBinImage_OneD(i));
           kalanlar(3)=kalanlar(3)+double(secretBinImage_OneD(i));
           Modlar=Modlar3;
      end
       
   
   IR_Chinese_embedded(i)= My_ChineseRemainder(kalanlar,Modlar);
   
   diferans=abs(IR_Chinese_embedded(i)-IR_Chinese(i));
   if diferans>1
       
      if(Q_seq(i)>=0.667)
       CR1=My_ChineseRemainder([double(IRR(k1:k2)) 0] ,Modlar(1:3));
       CR2=My_ChineseRemainder([double(IRR(k1:k2)) 1] ,Modlar(1:3)); 
       
      elseif(Q_seq(i)>=0.333)
       CR1=My_ChineseRemainder([double(IRR(k1)) 0 double(IRR(k2))] ,Modlar(1:3));
       CR2=My_ChineseRemainder([double(IRR(k1)) 1 double(IRR(k2))] ,Modlar(1:3));               
      else
       CR1=My_ChineseRemainder([0 double(IRR(k1:k2))] ,Modlar(1:3));
       CR2=My_ChineseRemainder([1 double(IRR(k1:k2))] ,Modlar(1:3));            
      end
      

       
       if abs(IR_Chinese_embedded(i)-CR1)<abs(IR_Chinese_embedded(i)-CR2)
           IR_Chinese(i)=CR1;
       else
           IR_Chinese(i)=CR2;
       end
   end
   BKs(i,n+2)=IR_Chinese(i);  
   
   BKs(i,n+3)=IR_Chinese_embedded(i);
   BKs(i,n+4:n+5)=[fix((i-1)/64)+1 mod(i-1,64)+1]; % encrypted pixel position
end

CRT_essiz=unique(IR_Chinese)';
CRT_essiz_diff=CRT_essiz(2:end)-CRT_essiz(1:end-1);
CRT_embedded_essiz=unique(IR_Chinese_embedded)';


I0_bits_CRT=boolean([]);



%%
n=length(IR_Chinese_embedded);
[a,b]=size(imge);

bitSequence=[];

for i=1:n
    bits=dec2bin(IR_Chinese_embedded(i),18);  
    %bits_bool=boolean(bits);
    bitSequence=[bitSequence bits];
end
n=length(bitSequence);

%eðer bit dizisi 8 in katlarý deðilse zero padding ekleme
kalan=mod(n,8);
if(kalan)
    for i=1:kalan
        bitSequence=[bitSequence '0'];
        n=n+1;
    end
end

                                       Q=g(1,3);
                                       lambda3=g(3,3);

                                            for h=1:Tr   
                                                Q=lambda3*Q*(1-Q);
                                            end
WatermarkedImage_8bit_OneD=[];
                                            Q_seq2=[];
    for i=1:(n/8)
        bits=bitSequence((i-1)*8+1:i*8);
        WatermarkedImage_8bit_OneD(i)=bin2dec(bits);
        
                                     Q=lambda3*Q*(1-Q);
                                     Q_norm=mod(floor(alfa*Q),256);
                                     Q_seq2(i)=Q_norm;
                                     WatermarkedImage_8bit_OneD(i)=bitxor(WatermarkedImage_8bit_OneD(i),Q_seq2(i));

    end

n=length(IR_Chinese);
[a,b]=size(imge);

bitSequence=[];

for i=1:n
    bits=dec2bin(IR_Chinese(i),18);  
    %bits_bool=boolean(bits);
    bitSequence=[bitSequence bits];
end
n=length(bitSequence);

%eðer bit dizisi 8 in katlarý deðilse zero padding ekleme
kalan=mod(n,8);
if(kalan)
    for i=1:kalan
        bitSequence=[bitSequence '0'];
        n=n+1;
    end
end

                                       Q=g(1,3);
                                       lambda3=g(3,3);

                                            for h=1:Tr   
                                                Q=lambda3*Q*(1-Q);
                                            end

EncryptedImage_8bit_OneD=[];
                                            Q_seq2=[];


    for i=1:(n/8)
        bits=bitSequence((i-1)*8+1:i*8);
        EncryptedImage_8bit_OneD(i)=bin2dec(bits);
        
                                     Q=lambda3*Q*(1-Q);
                                     Q_norm=mod(floor(alfa*Q),256);
                                     Q_seq2(i)=Q_norm;
                                     EncryptedImage_8bit_OneD(i)=bitxor(EncryptedImage_8bit_OneD(i),Q_seq2(i));
 
    end
    
disp('8-bit')    


    
IR_Chinese_embedded_Encrypted_imge=reshape(IR_Chinese,b/2,a)';
IR_Chinese_embedded_Watermarked_imge=reshape(IR_Chinese_embedded,b/2,a)';




figure
title('Histogram comparison')
subplot(1,2,1)
    imhist(uint8(EncryptedImage_8bit_OneD))
    title('Encrypted image')
subplot(1,2,2)    
    imhist(uint8(WatermarkedImage_8bit_OneD))
     title('Watermarked image')
     
     %%  one dimensional to image for watermarked image
      %  one dimensional to image for the cover image
     
     n=length(WatermarkedImage_8bit_OneD);
     a=ceil(sqrt(n));
     WI=fix(256*rand(1,a*a));
     WI(1:n)=WatermarkedImage_8bit_OneD;
     imge_Watermarked8bit=reshape(WI,[a,a])';
     
     
     n=length(EncryptedImage_8bit_OneD);
     a=ceil(sqrt(n));
     WI=fix(256*rand(1,a*a));
     WI(1:n)=EncryptedImage_8bit_OneD;
     imge_EncryptedCover8bit=reshape(WI,[a,a])';     
     
     

%% entropy
  
  E_weatermarked=entropy(uint8(imge_Watermarked8bit));
  E_cover=entropy(uint8(imge_EncryptedCover8bit));
  
fprintf('\n\n-------------Entropy analysis--------------');
fprintf('\nCover image  Watermarked Image ');  
fprintf('\n\t %f \t %f \n', E_cover,E_weatermarked);


%%
figure
subplot(3,3,1)
    imshow(imge_original,[0 255]);
    title('original image')
subplot(3,3,2:3)    
    imhist(uint8(imge_original))
     title('histogram of the original image')

subplot(3,3,4)
    imshow(imge_EncryptedCover8bit,[0 255]);
    title('cover image')

subplot(3,3,5:6)
    imhist(uint8(imge_EncryptedCover8bit))
    title('histogram of the cover image')
    
subplot(3,3,7)
    imshow(imge_Watermarked8bit,[0 255]);
    title('watermarked image')

subplot(3,3,8:9)
    imhist(uint8(imge_Watermarked8bit))
    title('histogram of the watermarked image')    
    abs_diff_image=abs(imge_EncryptedCover8bit-imge_Watermarked8bit);
    figure
    imshow(abs_diff_image,[0 255])
    
    %%
    figure
    imhist(uint8(imge_EncryptedCover8bit))
    hold on
     imhist(uint8(imge_Watermarked8bit))
     legend('Encoded cover image','Watermarked image')
    

