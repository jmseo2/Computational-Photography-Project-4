function hdr = makehdr_naive(ldrs, exposures)
    % ldrs is an m x n x 3 x k matrix which can be created with ldrs = cat(4, ldr1, ldr2, ...);
    % exposures is a vector of exposure times (in seconds) corresponding to ldrs
    [exposures,sortexp] = sort(reshape(exposures,1,1,1,[]));
    ldrs = ldrs(:,:,:,sortexp); %Sort exposures from dark to light

    %Create naive HDR here
    [m, n, d, k] = size(ldrs);
    for i = 1:k
        ldrs(:, :, :, i) = ldrs(:, :, :, i) / exposures(i);
    end
    hdr = squeeze(sum(ldrs, 4)) / k;
end