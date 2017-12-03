function r = invRodrigues(R)
% invRodrigues
% Input:
%   R: 3x3 rotation matrix
% Output:
%   r: 3x1 vector
    A = (R-R')/2;
    p = [A(3,2) A(1,3) A(2,1)]';
    s = norm(p);
    c = (R(1,1)+R(2,2)+R(3,3)-1)/2;
    if abs(s)<eps && abs(c-1)<eps
        r = zeros(3,1);
    elseif abs(s)<eps && abs(c+1)<eps
        tmp = R+eye(3);
        v = zeros(3,1);
        for i=1:3
            if all(abs(tmp(:,i))>eps)
                v = tmp(:,i);
                break;
            end
        end
        u = v*pi/norm(v);
        u1 = u(1);
        u2 = u(2);
        u3 = u(3);
        if abs(norm(u)-pi)<eps && ((abs(u1)<eps&&abs(u2)<eps&&u3<0)||(abs(u1)<eps&&u2<0)||u1<0)
            u = -u;
        end
        r = u;
    else
        u = p/s;
        theta=atan(s/c);
        r = u*theta;
end