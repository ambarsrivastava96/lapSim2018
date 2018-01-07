load B1654run24.mat
c = linspace(min(TSTC),max(TSTC),length(ET));
T = (TSTC-min(TSTC))./(max(TSTC)-min(TSTC));
scatter3(FZ,NFY,TSTC,[],TSTC);
hold on
xlabel('FZ');
ylabel('Mu_Y');
zlabel('Temp');
load B1654run25.mat
c = linspace(min(TSTC),max(TSTC),length(ET));
T = (TSTC-min(TSTC))./(max(TSTC)-min(TSTC));
scatter3(FZ,NFY,TSTC,[],TSTC);
