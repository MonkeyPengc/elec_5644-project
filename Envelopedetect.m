% Program EnvelopeDetect.m
% Step2: Extract the envelopes of the beamformed data via a discrete Hilbert transform


onepiece = abs(hilbert(onepiece));

figure(3);
imagesc(onepiece);
colormap(gray);
colorbar
title('B-mode image frames')
