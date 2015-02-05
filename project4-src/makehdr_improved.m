function hdr = makehdr_improved(ldrs, exposures)
    % ldrs is an m x n x 3 x k matrix which can be created with ldrs = cat(4, ldr1, ldr2, ...);
    % exposures is a vector of exposure times (in seconds) corresponding to ldrs
    [exposures,sortexp] = sort(reshape(exposures,1,1,1,[]));
    ldrs = ldrs(:,:,:,sortexp); %Sort exposures from dark to light

    %Create naive HDR here
    [m, n, dim, k] = size(ldrs);
    ldrs_scaled = ldrs;
    for i = 1:k
        ldrs_scaled(:, :, :, i) = ldrs(:, :, :, i) / exposures(i);
    end
    
    ldrs = im2uint8(ldrs);
    
    w = @(z) double(128-abs(z - 128));
    
    hdr = zeros(m, n, dim);
    for i = 1:m
        for j = 1:n
            for d = 1:dim
                weight_sum = 0;
                for t = 1:k
                    weight = w(ldrs(i, j, d, t));
                    hdr(i, j, d) = hdr(i, j, d) + weight * ldrs_scaled(i, j, d, t);
                    weight_sum = weight_sum + weight;
                end
                hdr(i, j, d) = hdr(i, j, d) / weight_sum;
            end
        end
    end
end