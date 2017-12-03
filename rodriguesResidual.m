function residuals = rodriguesResidual(K1, M1, p1, K2, p2, x)
% rodriguesResidual:
% Inputs:
%   K1 - 3x3 camera calibration matrix 1
%   M1 - 3x4 projection matrix 1
%   p1 - Nx2 matrix of (x, y) coordinates
%   K2 - 3x3 camera calibration matrix 2
%   p2 - Nx2 matrix of (x, y) coordinates
%   x - (3N + 6)x1 flattened concatenation of P, r_2 and t_2

% Output:
%   residuals - 4Nx1 vector
    N = size(p1,1);
    P = x(1:3*N);
    P = reshape(P,[N,3]);
    r2 = x(3*N+1:3*N+3);
    t2 = x(3*N+4:3*N+6);
    R2 = rodrigues(r2);
    M2 = [R2 t2];
    C1 = K1*M1;
    C2 = K2*M2;
    P_h = [P';ones(1, N)];
    p1_hat = C1*P_h;
    p1_hat = p1_hat(1:2,:)'./p1_hat(3,:)';
    p2_hat = C2*P_h;
    p2_hat = p2_hat(1:2,:)'./p2_hat(3,:)';
    residuals = reshape([p1-p1_hat;p2-p2_hat],[],1);
end
