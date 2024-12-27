CY=yed;
CY1=yed1;
CY2=yed2;

[a b]=size(CY);

%% CDR

CDR=(My_Diff(CY,CY1)+My_Diff(CY,CY2))/(2*a*b)*100;
fprintf('\n CDR=%3.2f percentage\n',CDR);