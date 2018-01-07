clear all
close all
% load B1654run24.mat %12, 10, 14, 8, 12 PSI (82, 68, 96, 55, 82 kPa)
% IA: 0,2,4 Degrees
% P_select = 68;
IA_select = 0;
figure
% fig_title = sprintf('Pressure = %.1f kPa, IA = %.1f Degrees',P_select,IA_select);
% title(fig_title);
for P_select = [55,68,82,96]
    plot_FZ_maxMU_Y(IA_select,P_select)
    hold on
% figure
end
% 
% legend('IA = 0', 'IA = 2', 'IA = 4')
legend('P = 8PSI', 'P = 10PSI', 'P = 12PSI', 'P = 14PSI');
grid on

figure 
             