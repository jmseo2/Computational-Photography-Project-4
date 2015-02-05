function res = normalize(A)
    min_i = min(min(min(A)));
    max_i = max(max(max(A)));
    res = A;
    [imh, imw, dim] = size(A);
    for i = 1:imh
        for j = 1:imw
            for k = 1:dim
                res(i, j, k) = (A(i, j, k) - min_i) / (max_i - min_i);
            end
        end
    end
end