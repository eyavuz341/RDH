function cr=My_ChineseRemainder(b,m)
% b-> b1, b2, b3, b4... 
% n->number of equations
% m1, m2,...m4  modulo
 n=length(b);
    MM=1;
    for i=1:n
       MM=MM*m(i);   %M=m1*m2*m3*...;
    end
     
    M=[];
    y=[];
    
    for i=1:n
       M(i)=MM/m(i);
       
       y(i)=1;
       while(1)
         if(mod(y(i)*M(i),m(i))==1) 
             break;
         end   
         y(i)=y(i)+1;
       end
       
    end
    
    sonuc=0;
    for i=1:n
       sonuc=sonuc+b(i)*M(i)*y(i);
    end
    
 cr=mod(sonuc,MM);   
 
end