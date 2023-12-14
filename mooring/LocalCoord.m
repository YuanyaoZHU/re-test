function [x,z,relativeCoord] = LocalCoord(anchorCoord,location,r,spanAngle)

h = 320-70;

fairleadCoord = zeros(2);
fairleadCoord(1) = location(1)+cos(spanAngle)*r;
fairleadCoord(2) = location(2)+sin(spanAngle)*r;

relativeCoord(1) = fairleadCoord(1) - anchorCoord(1);
relativeCoord(2) = fairleadCoord(2) - anchorCoord(2);

x = sqrt(relativeCoord(1).^2+relativeCoord(2).^2);
z = h;