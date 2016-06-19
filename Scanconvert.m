% Program Scanconvert.m
% Convert delayed rflines in polar coordinates to a B-mode ultrasound image
% in Cartesian coordinates suitable for display.

[m,n] = size(onepiece);

% get r-sintheta coordinates of the delayed rflines image onepiece
for i = 1:scannum
   rt = 0;
   for j = 1:m
       rt = rt + c*dt/2;
       r(j) = rt;
       st(i) = sin(theta(i));
   end
end


% generate x-z coordinate
zmax = m*dt*c/2;
xmax = 2*zmax*sin(max(theta));
hrz = -xmax/2:0.0001:xmax/2;
vtc = 0:0.0001:zmax;


% convert each point to r-sintheta coordinates
x = meshgrid(hrz,vtc);

for i = 1:length(hrz)
    for j = 1:length(vtc)
        nr(j,i) = sqrt(hrz(i).^2 + vtc(j).^2);
        nst(j,i) = x(j,i)./nr(j,i);
    end
end

canvas = zeros(1200,1000);             % define a zero matrix for display

for i = 1:length(hrz)
    for j = 1:length(vtc)          
        dtr = abs(r(2) - r(1));        % get intervals of r and sintheta
        dsit = abs(st(2) - st(1));
        
        % get the coordinates of four neighbors
        r1 = dtr*(floor(nr(j,i)/dtr));
        r2 = dtr*(ceil(nr(j,i)/dtr));
        sit1 = dsit*(floor(nst(j,i)/dsit));
        sit2 = dsit*(ceil(nst(j,i)/dsit));
        
        % calculate interpolation coefficients
        a = nr(j,i) - r1;
        b = r2 - nr(j,i);
        c = nst(j,i) - r1;
        d = r2 - nst(j,i);
        
        % identify the neighboring four input pixels
        var1 = abs(r1-r);
        var2 = abs(sit1-st);
        varmin1 = min(var1);
        varmin2 = min(var2);
        h = find(var1==varmin1);
        k = find(var2==varmin2);
        
        % calculate interpolation intensity value
        if( h==m | k==n)
          canvas(j,i) = 0;    
        else if (h==1 | k==1)
          canvas(j,i) = 0;
            else
            p1 = onepiece(h,k);
            p2 = onepiece(h,k+1);
            p3 = onepiece(h+1,k);
            p4 = onepiece(h+1,k+1);
            px = (b*d*p1+b*c*p2+a*d*p3+a*c*p4)/(dtr*dsit);
          
            canvas(j,i) = px;
            end
        end
    end
end

figure(4);
imagesc(canvas);
colormap(gray)
colorbar
title('Image after Scan Conversion')

figure(5);
canvas = abs(hilbert(canvas));
imagesc(canvas);
colormap(gray);
colorbar
title('Image after Scan Conversion and Envelope Detection')

