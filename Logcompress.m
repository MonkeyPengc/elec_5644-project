% Program Logcompress.m
% Logarithmically compress the results to 45 dB of dynamic range for final display

[m,n] = size(canvas);
 
y1 = 10^(45/20);         % get the intensity value = 45dB  
x1 = max(max(canvas));   % get the max intensity value of the image
 
s = y1/x1;               % get the scale factor
 
% compress each pixel value to desired one
for i=1:m
    for j=1:n
         bmode(i,j) = s * (double(canvas(i,j)));
    end
end

figure(6);
imagesc(bmode, [0 45]);               % compress image to 45dB of dynamic range
colormap(gray);
colorbar
set(gca,'XTick',1:499:1000);         
set(gca,'XTickLabel',{'-50','0','50'});     % adjust x-axis coordinates 
set(gca,'YTick',0:200:1200); 
set(gca,'YTickLabel',{'0','20','40','60','80','100','120'});   % adjust y-axis coordinates
title('Final image displayed in 45 dB of dynamic range');



