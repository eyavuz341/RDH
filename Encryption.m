%Performs chaos-based encryption
clc
load RDH_dataset
close all hidden
%% 256x256 test imgeyi oluþturma
I0=[];
%imge=double(saat);
imge=double(airplane256); %256*256

%imge=double(GrayLena); %512*512
%imge(128,128)=bitxor(imge(128,128),255);
%imge=double(elaine); %512*512
%imge=double(peppers); %512*512
%imge=double(gray21); %512*512
%imge=double(adam); %1024*1024
%imge=double(airport); %1024*1024
%imge=double(kidAlper); %1024*1024


imaj=imge;

%%  bit dizisini 256x256 imge haline getirme 
[a,b]=size(imge);
bits=8;
k=0;
I0=reshape(imge,1,a*b);


%%
% Require I0, L, R , g1...gr;
L=length(I0);
R=2;
d=floor(log10(L))+11;
d=14;
%initialize 
Ib=ones(R,L);
r=1; F=L-2;Ib(1,:)=I0;
alfa=10^d;



while(r<=R)
   
    i=2;
    S=L-1;
    X=g(1,r);  %g is the matrix variable containing the keys used for starting chaotic functions
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
    Z1_prev=0;
    while (i<L-2)
        
        
       X=lambda1*X*(1-X);
       Z=lambda2*Z*(1-Z); 
       Y=lambda3*Y*(1-Y);
         Z_norm=mod(floor(alfa*Z),256);
        
       if(Ib(r,i)>Ib(r,i-1))
            j=1+mod(floor(alfa*X),i-1);
            jf=i+2+mod(floor(alfa*Y),L-i-1);
       else
            j=1+mod(floor(alfa*Y),i-1);
            jf=i+2+mod(floor(alfa*X),L-i-1);           
       end
       
       
       Z1=Ib(r,i+1);
       Z2=Ib(r,j);
       
       Z4=Ib(r,jf);
       
            if(i>0)
               Z1_prev=Ib(r,i); 
            end

      Z3=bitxor(bitxor(bitxor(bitxor(Z1,Z2),Z4),Z_norm),Z1_prev);

       Z3=My_rotate(Z3,1+mod(Z_norm,8));    
     
       
       Ib(r,i+1)=(Z3);
      
       i=i+1;
       S=S-1;
    end
    
   r=r+1;
   Ib(r,:)=Ib(r-1,:);
    
end



IR=Ib(R,:);


%% 256x256 test imgeyi bit dizisi haline getirme

[a,b]=size(imge);
bits=8;


imge_encrypted=[];
k=0;
for i=1:a
  for j=1:b
        k=k+1;
        imge_encrypted(i,j)=IR(k);

  end
    
end

%%
%figure
figure
subplot(2,3,1)
    imshow(imge,[0 255]);
    title('original image')
subplot(2,3,2:3)    
    imhist(uint8(imge))
     title('histogram of the original image')
subplot(2,3,4)
    imshow(imge_encrypted,[0 255]);
    title('encrypted image')

subplot(2,3,5:6)
    imhist(uint8(imge_encrypted))
    title('histogram of the encrypted image')


