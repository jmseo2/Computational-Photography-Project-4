function out = panoramic_transform(hdr)
    [n, n, dim] = size(hdr);
    mid = floor(n / 2);
    
    normals = zeros(n, n, dim);
    reflections = zeros(n, n, dim);
    phi_theta = zeros(n, n, dim);
    cnt = 0;
    for i = 1:n
        for j = 1:n
            [x, y, z] = get_normal(j, i, mid);
            normals(i, j, 1) = x;
            normals(i, j, 2) = y;
            normals(i, j, 3) = z;
            
            [x, y, z] = get_reflection(j, i, mid);
            reflections(i, j, 1) = x;
            reflections(i, j, 2) = y;
            reflections(i, j, 3) = z;
            
            phi = atan2(x, -z);
            theta = acos(-y);

            if (x == 0 && y == 0 && z == 0)
                phi_theta(i, j, 1) = 0;
                phi_theta(i, j, 2) = 0;
                phi_theta(i, j, 3) = 0;
            else
                phi_theta(i, j, 1) = (phi + pi);
                phi_theta(i, j, 2) = theta;
                phi_theta(i, j, 3) = 0;
                cnt = cnt + 1;
            end
        end
    end

    X = zeros(cnt, 1);
    Y = zeros(cnt, 1);
    R = zeros(cnt, 1);
    G = zeros(cnt, 1);
    B = zeros(cnt, 1);
    
    k = 1;
    for i = 1:n
        for j = 1:n
            if phi_theta(i, j, 1) == 0 && phi_theta(i, j, 2) == 0
                continue;
            end
            X(k, 1) = phi_theta(i, j, 1);
            Y(k, 1) = phi_theta(i, j, 2);
            R(k, 1) = hdr(i, j, 1);
            G(k, 1) = hdr(i, j, 2);
            B(k, 1) = hdr(i, j, 3);
            k = k + 1;
        end
    end
    
    F_R = scatteredInterpolant(X, Y, R);
    F_G = scatteredInterpolant(X, Y, G);
    F_B = scatteredInterpolant(X, Y, B);
    
    [phis, thetas] = meshgrid(0:pi/360:2*pi, 0:pi/360:pi);
    
    Q_R = F_R(phis, thetas);
    Q_G = F_G(phis, thetas);
    Q_B = F_B(phis, thetas);
    
    Q = cat(3, Q_R, Q_G, Q_B);
    Q(Q < 0) = 0;
    out = Q;
end

function [x, y, z] = get_normal(col, row, mid)
    x = (col - mid) / mid;
    y = (row - mid) / mid;
    if 1 - x^2 - y^2 < 0
        x = 0;
        y = 0;
        z = 0;
    else
        z = sqrt(1 - x^2 - y^2);
    end
end

function [x, y, z] = get_reflection(col, row, mid)
    [nx, ny, nz] = get_normal(col, row, mid);
    N = [nx, ny, nz];
    if nx == 0 && ny == 0 && nz == 0
        x = 0;
        y = 0;
        z = 0;
    else
        V = [0; 0; -1];
        R = V - 2 * N * V * N.';
        x = R(1, 1) / norm(R);
        y = R(2, 1) / norm(R);
        z = R(3, 1) / norm(R);
    end
end