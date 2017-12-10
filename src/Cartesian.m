function acq_img = Cartesian(img)
    N = length(img);

    F = fftshift(fft2(img));
    F2 = zeros(N, N);
    
    % sampling intervals 
    
    for i = 1:1:N
        for j = 1:2:N
            F2(i,j) = F(i,j);
        end
    end
%     sample = interp2(F, (1:k(2):N)', 1:k(1):N);
%     sampleSize = size(sample);
%     F2(N/2 - sampleSize(1)/2 + 1 : N/2 + sampleSize(1)/2, N/2 - sampleSize(2)/2 + 1 : N/2 + sampleSize(2)/2) = sample;

    MRI = abs(ifft2(F2));

    acq_img = abs(MRI);
end