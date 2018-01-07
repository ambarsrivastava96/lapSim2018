function tyreData = compileRun24_25()
% Compile run 24 and 25 data

load B1654run24.mat
tyreData.channel = channel;
tyreData.source = source;
tyreData.testid = testid;
tyreData.tireid = tireid;

tyreData.AMBTMP = AMBTMP;
tyreData.ET = ET;
tyreData.FX = FX;
tyreData.FY = FY;
tyreData.FZ = FZ;
tyreData.IA = IA;
tyreData.MX = MX;
tyreData.MZ = MZ;
tyreData.N = N;
tyreData.NFX = NFX;
tyreData.NFY = NFY;
tyreData.P = P;
tyreData.RE = RE;
tyreData.RL = RL;
tyreData.RST = RST;
tyreData.RUN = RUN;
tyreData.SA = SA;
tyreData.SL = SL;
tyreData.SR = SR;
tyreData.TSTC = TSTC;
tyreData.TSTI = TSTI;
tyreData.TSTO = TSTO;
tyreData.V = V;

clearvars -except tyreData
load B1654run25.mat

tyreData.AMBTMP = AMBTMP;
tyreData.ET = [tyreData.ET;ET];
tyreData.FX = [tyreData.FX;FX];
tyreData.FY = [tyreData.FY;FY];
tyreData.FZ = [tyreData.FZ;FZ];
tyreData.IA = [tyreData.IA;IA];
tyreData.MX = [tyreData.MX;MX];
tyreData.MZ = [tyreData.MZ;MZ];
tyreData.N = [tyreData.N;N];
tyreData.NFX = [tyreData.NFX;NFX];
tyreData.NFY = [tyreData.NFY;NFY];
tyreData.P = [tyreData.P;P];
tyreData.RE = [tyreData.RE;RE];
tyreData.RL = [tyreData.RL;RL];
tyreData.RST = [tyreData.RST;RST];
tyreData.RUN = [tyreData.RUN;RUN];
tyreData.SA = [tyreData.SA;SA];
tyreData.SL = [tyreData.SL;SL];
tyreData.SR = [tyreData.SR;SR];
tyreData.TSTC = [tyreData.TSTC;TSTC];
tyreData.TSTI = [tyreData.TSTI;TSTI];
tyreData.TSTO = [tyreData.TSTO;TSTO];
tyreData.V = [tyreData.V;V];

