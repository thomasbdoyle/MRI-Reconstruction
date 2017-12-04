function mask = getMask(S, maskType, maskPercent, invert)
    switch maskType 
        case 1
            if invert == 0
                mask = zeros(S);
                value = 1;
            else
                mask = ones(S);
                value = 0;
                if maskPercent > .9
                    maskPercent = .9;
                end
            end
            offset = round((min(S)/2) * (1-maskPercent));
            for i=1+offset:S(1)-offset
                for j=1+offset:S(2)-offset
                    mask(i,j) = value;
                end
            end
        case 2
            radius = round(min(S)/2 * maskPercent);
            centerW = S(2)/2;
            centerH = S(1)/2;
            [W,H] = meshgrid(1:S(2),1:S(1));
            if invert == 1
                mask = ((W-centerW).^2 + (H-centerH).^2) > radius^2;
            else
                mask = ((W-centerW).^2 + (H-centerH).^2) < radius^2;
            end
        otherwise
            mask = ones(S);
    end
end