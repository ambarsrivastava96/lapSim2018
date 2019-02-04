clear all
tyreData = compileRun24_25();
c = linspace(min(tyreData.TSTC),max(tyreData.TSTC),length(tyreData.ET));
T = (tyreData.TSTC-min(tyreData.TSTC))./(max(tyreData.TSTC)-min(tyreData.TSTC));
scatter3(tyreData.FZ,tyreData.NFY,tyreData.TSTC,[],tyreData.TSTC);
hold on
xlabel('FZ');
ylabel('Mu_Y');
zlabel('Temp');
colormap jet
grid on
colorbar
