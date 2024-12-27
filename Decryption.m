%Performs chaos-based decryption
clc

%%secret data extracting and separating
                                        IR_Chinese_embedded_received=[];
                                        
                                       Q=g(1,3);
                                       lambda3=g(3,3);

                                            for h=1:Tr   
                                                Q=lambda3*Q*(1-Q);
                                            end
                                      Q_seq2=[];
                                      
                                      n=length(WatermarkedImage_8bit_OneD);
                                      
                                      WatermarkedImage_8bit_OneD_received=[];
                               for i=1:n       
                                     Q=lambda3*Q*(1-Q);
                                     Q_norm=mod(floor(alfa*Q),256);
                                     Q_seq2(i)=Q_norm;
                                     WatermarkedImage_8bit_OneD_received(i)=bitxor(WatermarkedImage_8bit_OneD(i),Q_seq2(i));
                               end      
                                      
                                n=length(WatermarkedImage_8bit_OneD_received);
                                
                                bitSequence=[];
                                for i=1:n
                                    
                                    
                                    
                                    bits=dec2bin(WatermarkedImage_8bit_OneD_received(i),8);  
                                    bitSequence=[bitSequence bits];
                                end
                                
                                n=length(bitSequence);
                                
                                for i=1:n/18
                                   bits= bitSequence((i-1)*18+1:i*18);
                                   IR_Chinese_embedded_received(i)= bin2dec(bits);
                                end

                                IR_Chinese_embedded=IR_Chinese_embedded_received;
L=length(IR_Chinese_embedded);


secretDataExtracted=boolean([]);
EncrptedPixelExtracted=[];

%---------secret data için olan chaotic fonksiyonu çalýþtýrmaya hazýr hale
Q=[];
   Q=g(1,3);
   lambda3=g(3,3);

        for h=1:Tr 
            Q=lambda3*Q*(1-Q);
        end
         
%----------------

for i=1:L
         Q=lambda3*Q*(1-Q);
         Q_seqq(i)=Q;
         
          CR_value=IR_Chinese_embedded(i);
        
     if(Q_seqq(i)>=0.667)
         Modlar=Modlar1;
        P1=mod(CR_value,Modlar(1));
        P2=mod(CR_value,Modlar(2));
        SecretBit=mod(CR_value,Modlar(3));
    
     elseif(Q_seqq(i)>=0.333)
         Modlar=Modlar2;
        P1=mod(CR_value,Modlar(1));
        SecretBit=mod(CR_value,Modlar(2));          
        P2=mod(CR_value,Modlar(3));
      
        
     else
        Modlar=Modlar3;
        SecretBit=mod(CR_value,Modlar(1));          
        P1=mod(CR_value,Modlar(2));
        P2=mod(CR_value,Modlar(3));
      
     end
   

    if SecretBit==1 
             EncrptedPixelExtracted(i,:)=[P1-1 P2-1]; 
               if(EncrptedPixelExtracted(i,1)==-1)
                   EncrptedPixelExtracted(i,1)=0;
                                     
               end
               if(EncrptedPixelExtracted(i,2)==-1)
                   EncrptedPixelExtracted(i,2)=0;
                                     
               end               
               
             secretDataExtracted(i)=boolean(SecretBit);

        else 

                EncrptedPixelExtracted(i,:)=[P1 P2];  
                secretDataExtracted(i)=boolean(SecretBit); 

    end
end

[a,b]=size(imge);
IR_Extracted_oneD=reshape(EncrptedPixelExtracted',1,a*b);
IR_Extracted=reshape(IR_Extracted_oneD,a,b)';
        
  n=length(secretBinImage_OneD);
  for i=1:n
     Q=Q_seqq(i);
        
     if(Q>=0.5)
         secretDataExtracted(i)=bitxor(secretDataExtracted(i),1);
     else
         secretDataExtracted(i)=bitxor(secretDataExtracted(i),0);
     end
  end

[a,b]=size(secretBinImage);
SecretDataImage_Extracted=reshape(secretDataExtracted',b,a);
SecretDataImage_Extracted=SecretDataImage_Extracted';

IR=IR_Extracted_oneD;
I0_decrypted=[];

%%
L=length(IR);
R=2;
d=14;
Ib=ones(R,L);
r=R; F=L-2;Ib(R,:)=IR;
alfa=10^d;
V=zeros(1,L);


while(r>0)
    r;
   i=2; S=L-1; 
   
    X=g(1,r);
    Z=g(2,r); 
    lambda1=g(3,r);
    lambda2=g(4,r);
    Tr=g(5,r);
    lambda3=g(6,r);
    Y=g(7,r);     
    
     %discarding first 300 iteration results
      for h=1:Tr
        X=lambda1*X*(1-X);
        Z=lambda2*Z*(1-Z);  
        Y=lambda3*Y*(1-Y);
      end
    
   while (i<L-2)
       X=lambda1*X*(1-X);
       Z=lambda2*Z*(1-Z); 
       Y=lambda3*Y*(1-Y);
         Z_norm=mod(floor(alfa*Z),256);
         Z_norm_seq(i+1)=Z_norm;
         
        if(Ib(r,i)>Ib(r,i-1)) 
            j=1+mod(floor(alfa*X),i-1);
            jf=i+2+mod(floor(alfa*Y),L-i-1); 
            
        else
            j=1+mod(floor(alfa*Y),i-1);
            jf=i+2+mod(floor(alfa*X),L-i-1);             
        end
        
       Z1=Ib(r,i+1);
       Z2=Ib(r,j);        

       V(i+1)=j;
       VV(i+1)=jf;
       i=i+1;
       S=S-1;
   end
   j=L-3;
   
   while(j>=2)
       
       i=V(j+1);
       ii=VV(j+1);
       Z1=Ib(r,j+1);
       Z2=Ib(r,i);
       Z4=Ib(r,ii);
       
          if(j>0)
               Z1_prev=Ib(r,j); 
          else
              Z1_prev=0;
          end

         Z_norm=Z_norm_seq(j+1);
        
        Z1=My_rotate(Z1,8-1-mod(Z_norm,8));

       Z1=uint8(Z1);
       Z2=uint8(Z2);
       Z4=uint8(Z4);
       Z_norm=uint8(Z_norm);
       Z1_prev=uint8(Z1_prev);
       
       Z3=bitxor(bitxor(bitxor(bitxor(Z1,Z2),Z4),Z_norm),Z1_prev);

       Ib(r,j+1)=Z3;
       j=j-1;
       
   end
   r=r-1; 
  if(r>0)
      Ib(r,:)=Ib(r+1,:);
  end
end

r;
I0_decrypted=Ib(1,:);
   

%% 256x256 test imgeyi bit dizisi haline getirme

[a,b]=size(imge);
bits=8;

imge_decrypted=[];
k=0;

imge_decrypted=reshape(I0_decrypted,a,b);

figure
title('Decrpted')
subplot(1,2,1)
imshow(imge_decrypted,[0 255]);
subplot(1,2,2)
imshow(SecretDataImage_Extracted,[0 1]);





