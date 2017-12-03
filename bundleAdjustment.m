function [M2, P] = bundleAdjustment(K1, M1, p1, K2, M2_init, p2, P_init)
% bundleAdjustment:
% Inputs:
%   K1 - 3x3 camera calibration matrix 1
%   M1 - 3x4 projection matrix 1
%   p1 - Nx2 matrix of (x, y) coordinates
%   K2 - 3x3 camera calibration matrix 2
%   M2_init - 3x4 projection matrix 2
%   p2 - Nx2 matrix of (x, y) coordinates
%   P_init: Nx3 matrix of 3D coordinates
%
% Outputs:
%   M2 - 3x4 refined from M2_init
%   P - Nx3 refined from P_init
    R2_init = M2_init(:,1:3);
    r2_init = invRodrigues(R2_init);
    T2_init = M2_init(:,4);
    x0 = [P_init(:);r2_init;T2_init];
    x_adjustment = lsqnonlin(@(x)rodriguesResidual(K1, M1, p1, K2, p2,x),x0);
    N = size(p1,1);
    P = x_adjustment(1:3*N);
    P = reshape(P,[N,3]);
    r2 = x_adjustment(3*N+1:3*N+3);
    R2 = rodrigues(r2);
    t2 = x_adjustment(3*N+4:3*N+6);
    M2 = [R2 t2];
end