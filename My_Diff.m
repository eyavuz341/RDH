function y=My_Diff(A,B)

[a,b]=size(A)

sayici=0;
    for i=1:a
       for j=1:b
         if(A(i,j)~=B(i,j)) 
             sayici=sayici+1;
         end
           
       end
    end


  y=sayici;
end