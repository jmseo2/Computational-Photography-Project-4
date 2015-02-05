function hdr = makehdr_gsolve(ldrs, exposures)
    % ldrs is an m x n x 3 x k matrix which can be created with ldrs = cat(4, ldr1, ldr2, ...);
    % exposures is a vector of exposure times (in seconds) corresponding to ldrs
    [exposures,sortexp] = sort(reshape(exposures,1,1,1,[]));
    ldrs = ldrs(:,:,:,sortexp); %Sort exposures from dark to light

    %Create naive HDR here
    [m, n, dim, k] = size(ldrs); 
    ldrs = im2uint8(ldrs);
    w = @(z) double(128-abs(z - 128));
    g = compute_g(ldrs, exposures, w, 1);

    y = zeros(256, 1);
    for i = 1:256
        y(i, 1) = i - 1;
    end
    
    figure(9);
    plot(g, y);
    
    hdr = zeros(m, n, dim);
    for i = 1:m
        for j = 1:n
            for d = 1:dim
                num = 0;
                den = 0;
                for t = 1:k
                    intensity = ldrs(i, j, d, t);
                    num = num + w(intensity) * (g(intensity + 1) - log(exposures(1, 1, 1, t)));
                    den = den + w(intensity);
                end
                hdr(i, j, d) = abs(exp(num / den));
            end
        end
    end
end

function g = compute_g(ldrs, exposures, w, channel)
    [m, n, dim, k] = size(ldrs); 
    p = haltonset(2, 'Skip', 1000);
    C = net(p, 500);
    
    Z = zeros(500, k);
    for i = 1:500
        y = ceil(C(i, 2) * m);
        x = ceil(C(i, 1) * n);
        for j = 1:k
            Z(i, j) = ldrs(y, x, channel, j);
        end
    end
    
    B = zeros(k, 1);
    for i = 1:k
        B(i, 1) = log(exposures(1, 1, 1, i));
    end
    
    [g_fun, lE] = gsolve(Z, B, 1, w);
    g = g_fun;
end