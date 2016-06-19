% Program Beamform.m 
% Step1: Beamform the raw RF data using a single receive focus coincident with the single transmit focus 

c = 1540;                % [m/s] Speed of sound
r0 = 70/1000;            % [m] focal depth
f0 = 5e6;                % center frequency 5MHz
fs = 5e7;                % sampling frequency 50MHz
dt = 1/fs;               % delta t in the receive RF data
load ('cystdata.mat');
xn = ri/1000;            % [m] element's x coordinates
scannum = max(size(theta));
rfdata = cell(1,scannum);   % creat a storage cell
tranducer = length(ri);
a = length(theta);

% load rfdata and store them into cell
for i = 1:scannum
    rfname=strcat('rfline',int2str(i),'.mat'); 
    load(rfname);
    rfdata{1,i} = pr;  
end

%% delayed A-vectors part
% calculate the delay time for each element at each angle    
for j = 1:a
    for k = 1:tranducer
       tn(j,k) = -xn(k)*sin(theta(j))/c+(xn(k)^2)*((cos(theta(j)))^2)/(2*c*r0);  
    end
end

  z=tn/dt;
  nz=round(abs(z));   % calculate the amount of padding zeros 
  
% pad zeros afer each element at each angle  
for i = 1:scannum
    anglerf = rfdata{1,i};           % extract data from a specific angle
    for j = 1:tranducer
        numz = nz(i,j);      
        vecz = zeros(1,numz);        % convert value to number of zeros 
        colrf = (anglerf(:,j))';     % load received data of each element
        padrf{i,j} = [colrf,vecz];  
    end
end

% obtain the data number of each element at each angle
for i = 1:scannum
    for j = 1:tranducer
        comp(i,j) = length(padrf{i,j});   
    end    
end

% find the maxima of elements number at each angle
for i = 1: scannum
       maxima(i,1) = max(comp(i,:));
end

% calculate the numbers of zeros padded in front of each element
for i = 1:scannum
    for j = 1:tranducer
      zeze(i,j) = maxima(i,1) - comp(i,j);
    end
end

% pad zeros before each element for different angle
for i = 1:scannum
    for j = 1:tranducer
        head = zeros(1,zeze(i,j));
        finalrf{i,j} = [head,padrf{i,j}];
    end
end

% convert cell dimension
for i = 1:scannum
    anglemat = zeros(maxima(i),tranducer);
    for j = 1:tranducer
       anglemat(:,j) = finalrf{i,j};
    end
    collect{i,1} = anglemat;
end

% transpose each matrix in cell
for i = 1:scannum
        zz = collect{i,1}; 
        transpose = zz';
        tcollect{i,1} = transpose;
end

% summation each element for each angle
for i = 1:scannum
        lines{i,1} = sum(tcollect{i,1});
end

% calculate the amount of zeros to be padded in front of each line
for i = 1:scannum
        nzl(i,1) = max(maxima) - maxima(i);
end

z = max(maxima);
onepiece = zeros(z,scannum);

% beamform by padding zeros in front of each line
for i = 1:scannum
        top = zeros(1,nzl(i));
        onepiece(:,i) = [top,lines{i,1}]';
end

%% undelayed A-vectors part
undelay = zeros(length(pr),scannum);
for i = 1:scannum
        yy = rfdata{1,i}; 
        utranspose = yy';
        utcollect{i,1} = utranspose;
end

% summation each element for each angle
for i = 1:scannum
        unlines{i,1} = sum(utcollect{i,1});
        undelay(:,i) = unlines{i,1}';
end

%% display two figures
figure(1)
imagesc(undelay);
colormap(gray);
colorbar
title('Undelayed A-vectors')

figure(2);
imagesc(onepiece);
colormap(gray); 
colorbar
title('Delayed A-vectors')




            





       
         




















    
    
    
    
    

        
        
        
    
    
    
    
    
    
    
    
    
    
    
    
        
        
        
        
        
        
        