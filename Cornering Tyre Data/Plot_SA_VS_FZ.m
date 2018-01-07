function [] = plot_SA_VS_FZ(IA_select,P_select)
load B1654run24.mat
figure
fig_title = sprintf('Pressure = %.1f kPa, IA = %.1f Degrees',P_select,IA_select);
title(fig_title);

P_buffer = 5;
IA_buffer = 1;

FY_200 = zeros(1,length(ET));
SA_200 = zeros(1,length(ET));
FZ_200 = zeros(1,length(ET));
FY_400 = zeros(1,length(ET));
SA_400 = zeros(1,length(ET));
FZ_400 = zeros(1,length(ET));
FY_600 = zeros(1,length(ET));
SA_600 = zeros(1,length(ET));
FZ_600 = zeros(1,length(ET));
FY_900 = zeros(1,length(ET));
SA_900 = zeros(1,length(ET));
FZ_900 = zeros(1,length(ET));
FY_1100 = zeros(1,length(ET));
SA_1100 = zeros(1,length(ET));
FZ_1100 = zeros(1,length(ET));

for i = 1:length(ET)
    if(IA(i)<IA_select+IA_buffer&&IA(i)>IA_select-IA_buffer)
        if(P(i)<P_select+P_buffer&&P(i)>P_select-P_buffer)
            if(FZ(i)<-100&&FZ(i)>-300)
            FY_200(i) = FY(i);
            SA_200(i) = SA(i);
            FZ_200(i) = FZ(i);
            end
            if(FZ(i)<-300&&FZ(i)>-500)
            FY_400(i) = FY(i);
            SA_400(i) = SA(i);
            FZ_400(i) = FZ(i);
            hold on
            end
            if(FZ(i)<-500&&FZ(i)>-750)
            FY_600(i) = FY(i);
            SA_600(i) = SA(i);
            FZ_600(i) = FZ(i);
            hold on
            end
            if(FZ(i)<-750&&FZ(i)>-1000)
            FY_900(i) = FY(i);
            SA_900(i) = SA(i);
            FZ_900(i) = FZ(i);
            hold on
            end
            if(FZ(i)<-1000)
            FY_1100(i) = FY(i);
            SA_1100(i) = SA(i);
            FZ_1100(i) = FZ(i);
            hold on
            end
        end
    end
end

i_200 = (FY_200~=0);
plot(SA_200(i_200),FY_200(i_200),'*');
hold on

i_400 = (FY_400~=0);
plot(SA_400(i_400),FY_400(i_400),'*');
hold on

i_600 = (FY_600~=0);
plot(SA_600(i_600),FY_600(i_600),'*');
hold on

i_900 = (FY_900~=0);
plot(SA_900(i_900),FY_900(i_900),'*');
hold on

i_1100 = (FY_1100~=0);
plot(SA_1100(i_1100),FY_1100(i_1100),'*');
hold on

xlabel('Slip Angle');
ylabel('FY');
legend('FZ=200N','FZ=400N','FZ=600N','FZ=900N','FZ=1100N');