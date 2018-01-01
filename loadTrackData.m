function TRACKdef = loadTrackData(filename)

%filename = 'Data-from-2016-Track';
TRACKdef(:,1) = xlsread(filename,'B:B');
TRACKdef(:,2) = xlsread(filename,'G:G');
TRACKdef(:,3) = xlsread(filename,'F:F');
end