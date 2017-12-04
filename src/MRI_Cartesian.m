function [acq_img, mask] = MRI_Cartesian(img, klines, kpoints, maskType, maskPercent, invert)
    wb = waitbar(0,'Please wait...');
    
    N = length(img);
    k = [N/klines, N/kpoints];
    M = floor(N*k);
    I = zeros(M(1), M(2));
    I(1:N, 1:N) = img;
    F = fftshift(fft2(I));
    F2 = zeros(M(1),M(2));

    waitbar(1/4)
    
    %G = fspecial('gaussian', 5, 1);
    %F = imfilter(F, G);
    
    % sampling intervals 
    Sample = interp2(F, (M(2)/2-N/2:k(2):M(2)/2+N/2-1)',(M(1)/2-N/2:k(1):M(1)/2+N/2-1));
    S = size(Sample);
    maskedSample = zeros(S(1), S(2));
    
    mask = getMask(S, maskType, maskPercent, invert);
    
    for i=1:1:S(1)
        for j=1:1:S(2)
            if mask(i,j) == 1
                maskedSample(i, j) = Sample(i,j);
            end
        end
    end
    
%     r = [randi(S(1)), randi(S(2))]
%     Sample(r(1), r(2)) = Sample(r(1), r(2)) * 100;
%     for i=1:S(1)
%         for j=1:S(2)
%             Sample(i, j) = Sample(i, j) * randi(10);
%         end
%     end
    
    waitbar(2/4)
    
    F2(M(1)/2-S(1)/2+1:(M(1)/2+S(1)/2),  M(2)/2-S(2)/2+1:(M(2)/2+S(2)/2)) = maskedSample;
    F2(isnan(F2)) = 0;
    
    IF2 = (ifft2(fftshift(F2)));
    IF2 = abs((IF2));
        
    %res_IF2 = imresize(IF2((N/2+1):N*2.5, (N/2+1):N*2.5), 0.5);
    
    waitbar(3/4)
    
    res_IF2 = imresize(IF2, size(IF2)./k);
    acq_img = res_IF2;
    
    acq_img = acq_img/(max(acq_img(:))) * 255;

    waitbar(4/4)    
    close(wb)
end