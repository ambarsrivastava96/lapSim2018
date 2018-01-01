
function ro=get_ro(r, theta, w, t)
% Function reverse engineers racing radius into outer turn radius
ro=r + w - t/2 -((w-t)/(1-cosd(theta/2)));
end