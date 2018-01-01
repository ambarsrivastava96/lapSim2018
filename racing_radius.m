% Calculates optimum racing radius for given track and turn
function r=racing_radius(ro, ri, theta, track)
r=ri + track/2 + (ro-ri-track)/(1-cosd(theta/2));
end