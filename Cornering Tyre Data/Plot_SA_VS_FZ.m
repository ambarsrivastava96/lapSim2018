figure
hold on
for i = 1:length(ET)
    if(IA(i)<1&&IA(i)>-1)
        if(P(i)<75&&P(i)>65)
            if(FZ(i)<-100&&FZ(i)>-300)
            plot(SA(i),FY(i),'*');
            hold on
            end
            if(FZ(i)<-300&&FZ(i)>-500)
            plot(SA(i),FY(i),'k*');
            hold on
            end
            if(FZ(i)<-500&&FZ(i)>-700)
            plot(SA(i),FY(i),'b*');
            hold on
            end
            if(FZ(i)<-700&&FZ(i)>-1000)
            plot(SA(i),FY(i),'r*');
            hold on
            end
            if(FZ(i)<-1000)
            plot(SA(i),FY(i),'g*');
            hold on
            end
        end
    end
end
            