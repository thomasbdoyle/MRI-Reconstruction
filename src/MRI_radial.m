
function acq_img = MRI_radial(img, lines, pointsperline)
    wb = waitbar(0,'Please wait...');
    
    N1 = size(img);
    sampling = (N1(1)/pointsperline);
    N = N1(1)*3*sampling;
    I = zeros(N, N);
    I(1:N1(1), 1:N1(1)) = img;
    F = fftshift(fft2(I));

    waitbar(1/4)
%% Obtain polar points to sample
    i=1;
    j=1;
    delT = lines;

    for r=-N/2:sampling:N/2
       for theta = 0:pi/delT:(pi-pi/delT)
           Rx(i, j) = r*cos(-theta)+ N/2;
           Ry(i, j) = r*sin(-theta)+ N/2;

           i = i+1;
       end
       j = j+1;
       i = 1;
    end

    waitbar(2/4)    
%% Radial sampling

    % interpolate
    Rv = interp2(F, Rx, Ry, 'bicubic');
    Rv(isnan(Rv)) = 0;
% 
%     % plot
%     subplot(1,2,1);
%     imshow(log(abs(F)+1), [0,5]);
%     hold on
%     plot(Rx(4,:), Ry(4,:), 'r.');
%     hold off
%     subplot(1,2,2);
%     imshow(log(abs(Rv)+1)',[0,10])
    waitbar(3/4)
%% Reconstruction

    IR = zeros(size(Rv));

    % 1D ifft
    for i = 1:delT
       IR(i, :) =fliplr(fftshift((abs(ifft((Rv(i, :))))))); 
    end

    % reconstruct from projections
    recons = iradon(IR', 180/delT);
    recons = fliplr(flipud(recons(16:N1+15, 16:N1+15)));

    acq_img = recons;
    waitbar(4/4)
    close(wb)    
end

