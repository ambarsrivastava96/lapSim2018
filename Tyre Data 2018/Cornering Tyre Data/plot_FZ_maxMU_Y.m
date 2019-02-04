function [] = plot_FZ_maxMU_Y(IA_select,P_select)
tyreData = compileRun24_25();
ET = tyreData.ET;
FY = tyreData.FY;
FZ = tyreData.FZ; 
SA = tyreData.SA;
IA = tyreData.IA; 
P = tyreData.P;


P_buffer = 5;
IA_buffer = 0.2;

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
MU_Y_200 = FY_200(i_200)./FZ_200(i_200);
FZ_200 = FZ_200(i_200);
[max_MU_Y_200,I_200] = max(abs(MU_Y_200));
FZ_max_MU_200 = FZ_200(I_200);

i_400 = (FY_400~=0);
MU_Y_400 = FY_400(i_400)./FZ_400(i_400);
FZ_400 = FZ_400(i_400);
[max_MU_Y_400,I_400] = max(abs(MU_Y_400));
FZ_max_MU_400 = FZ_400(I_400);

i_600 = (FY_600~=0);
MU_Y_600 = FY_600(i_600)./FZ_600(i_600);
FZ_600 = FZ_600(i_600);
[max_MU_Y_600,I_600] = max(abs(MU_Y_600));
FZ_max_MU_600 = FZ_600(I_600);

i_900 = (FY_900~=0);
MU_Y_900 = FY_900(i_900)./FZ_900(i_900);
FZ_900 = FZ_900(i_900);
[max_MU_Y_900,I_900] = max(abs(MU_Y_900));
FZ_max_MU_900 = FZ_900(I_900);

i_1100 = (FY_1100~=0);
MU_Y_1100 = FY_1100(i_1100)./FZ_1100(i_1100);
FZ_1100 = FZ_1100(i_1100);
[max_MU_Y_1100,I_1100] = max(abs(MU_Y_1100));
FZ_max_MU_1100 = FZ_1100(I_1100);

max_MU = [max_MU_Y_200, max_MU_Y_400, max_MU_Y_600, max_MU_Y_900, max_MU_Y_1100];
max_MU_Z = [FZ_max_MU_200, FZ_max_MU_400, FZ_max_MU_600, FZ_max_MU_900, FZ_max_MU_1100];

% plot(abs(max_MU_Z),max_MU);
% xlabel('FZ');
% ylabel('MU_Y');

figure
FY_actual = abs(max_MU.*max_MU_Z);
plot(abs(max_MU_Z),FY_actual);
%legend('FZ=200N','FZ=400N','FZ=600N','FZ=900N','FZ=1100N');