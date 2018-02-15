% Aero Sensitivity Graphs
CLA_sens_c = 10*1.215;
CDA_sens_c = 10*2.401;
Mass_sens_c = 1.19;
COG_sens_c = 100*3.737;

startCLA = 3.62;
startCDA = 1.34;
startMass = 30;

CLA = 0:0.1:3; % Iterate Over

%% L/D Ratio
L_D_Ratio_base = CDA_sens_c/CLA_sens_c;
L_D_Ratio = L_D_Ratio_base:0.5:5;

figure
hold on
for i = 1:length(L_D_Ratio)
    pts = (CLA)*CLA_sens_c-CDA_sens_c*(CLA)/L_D_Ratio(i);
    str = sprintf('L/D Ratio = %.2f',L_D_Ratio(i));
    plot(CLA,pts,'DisplayName',str)
end
% legend('show')
xlabel('CLA')
ylabel('Increase in Dynamic competition points')
legend('show')
legend('Location','northwest')
grid minor 
title('Aero sensitivity for various lift on drag ratios')

%% Mass
mass_ratio_base = Mass_sens_c/CLA_sens_c;
mass_ratio = mass_ratio_base:0.1:0.5;

figure
hold on
for i = 1:length(mass_ratio)
    pts = (CLA)*CLA_sens_c-Mass_sens_c*(CLA)/mass_ratio(i);
    str = sprintf('Lift/Mass Ratio = %.2f',mass_ratio(i));
    plot(CLA,pts,'DisplayName',str)
end
% legend('show')
xlabel('CLA')
ylabel('Increase in Dynamic competition points')
legend('show')
legend('Location','northwest')
grid minor 
title('Aero sensitivity for various Lift on Mass ratios')

%% CoG
COG_ratio_base = COG_sens_c/CLA_sens_c;
COG_ratio = COG_ratio_base:2:40;

figure
hold on
for i = 1:length(COG_ratio)
    pts = (CLA)*CLA_sens_c-COG_sens_c*(CLA)/COG_ratio(i);
    str = sprintf('Lift/CoG Ratio = %.2f',COG_ratio(i));
    plot(CLA,pts,'DisplayName',str)
end
% legend('show')
xlabel('CLA')
ylabel('Increase in Dynamic competition points')
legend('show')
legend('Location','northwest')
grid minor 
title('Aero sensitivity for various CoG on Mass ratios')