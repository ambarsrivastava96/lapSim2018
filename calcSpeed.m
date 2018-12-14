RPM = 10000; 
convertRPM = 2*pi/60;
tyreRadius = (18*25.4/2)/1000;
primaryDrive = 76/33;
sixth = 21/26;
fdr = 38/12;
msToKmh = 3.6; 

radPerS = RPM*convertRPM;
wheelRadPerS = radPerS/(primaryDrive*sixth*fdr);
speed = wheelRadPerS*tyreRadius*msToKmh

