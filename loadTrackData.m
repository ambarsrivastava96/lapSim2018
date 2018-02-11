function TRACKdef = loadTrackData(filename)

loadedTrackData = csvread(filename,1,0);


% TRACKdef(:,1) = xlsread(filename,'B:B');
% TRACKdef(:,2) = xlsread(filename,'G:G');
% TRACKdef(:,3) = xlsread(filename,'F:F');
TRACKdef(:,1) = loadedTrackData(:,2);
TRACKdef(:,2) = loadedTrackData(:,7);
TRACKdef(:,3) = loadedTrackData(:,6);

end