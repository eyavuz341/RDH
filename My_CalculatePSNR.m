function y=My_CalculatePSNR(A,B)

[a,b]=size(A);

MSE=0;
    for i=1:a
       for j=1:b
         d=(A(i,j)-B(i,j));
         
             MSE=MSE+d^2;
         
           
       end
    end
   MSE=(MSE/(a*b));
  PSNR=10*log10((255^2)/MSE);
  y=PSNR;
end