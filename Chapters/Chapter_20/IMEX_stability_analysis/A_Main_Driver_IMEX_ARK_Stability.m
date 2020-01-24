%---------------------------------------------------------------------%
%This code plots the Stability of Time-Differencing Schemes.
%Written by F.X. Giraldo on 10/07
%           Department of Applied Mathematics
%           Naval Postgraduate School
%           Monterey, CA 93943-5216
%Variables:
%---------------------------------------------------------------------%

clear; clear all; clf; 
close all;

%Read Number of Files
iplot=0;
% delta=input(' 0=Explicit \n 1=Implicit \n Enter delta: ');
%method=input(' Enter SDIRK Method: ');
method=input(' 1=ARK(1,2,1) \n 2=ARKA(2,3,2) \n 21=ARKB(2,3,2) \n 3=ARK(3,4,3) \n 4=ARK(4,6,4) \n 5=ARK(5,8,5) \n 6=ARK(6,10,6) \n 7=ARK437L2SA1 \n 8=ARK(7,8,5) \n 9=ARK548L2SA2 \n Enter Method: ');
delta=input(' Enter delta (=0 explicit and =1 IMEX): ');
% delta=1;
   
%setup TDS coefficients
text=['ARK' num2str(method)];

ns=500;
nf=500;
csmax=2;
cfmax=20;
ksdtmin=-csmax;
ksdtmax=+csmax;
dksdt=(ksdtmax-ksdtmin)/(ns-1);
kfdtmin=0;
kfdtmax=+cfmax;
dkfdt=(kfdtmax-kfdtmin)/(nf-1);
amp=zeros(ns,nf);
kfdt=zeros(nf,1);
ksdt=zeros(ns,1);

if (method == 0)
    ARK_s=2;
elseif (method == 1)
    ARK_s=2; %Forward-Backward Euler with b=btilde
elseif (method == 2)
    ARK_s=3;   %ARK(2,3,2) a32=0.97  
elseif (method == 21)
    ARK_s=3;   %ARK(2,3,2) a32=0.5
elseif (method == 3)
    ARK_s=4;  %ARK(3,4,3) 
elseif (method == 4)
    ARK_s=6;  %ARK(4,6,4)
elseif (method == 5)
    ARK_s=8;  %ARK(5,8,5)
elseif (method == 6)
    ARK_s=10; %ARK(6,10,6): Brian Vermiere method
elseif (method == 7)
    ARK_s=7; %ARK(6,7,4): Kennedy-Carpenter ARK437L2SA1 in CLIMA
elseif (method == 8)
    ARK_s=8; %ARK(7,8,5): Kennedy-Carpenter
elseif (method == 9)
    ARK_s=8; %ARK(7,8,5): Kennedy-Carpenter ARK548L2SA2
end

ARK_A=zeros(ARK_s,ARK_s);
ARK_At=zeros(ARK_s,ARK_s);
ARK_b=zeros(ARK_s,1);
ARK_bt=zeros(ARK_s,1);
ARK_c=zeros(ARK_s,1);

if (method == 0)
    %ARK(1,2,1)
    ARK_A(2,1)=1;
    ARK_At(2,2)=1;
    ARK_b(1:ARK_s)= [0,1];
    ARK_bt(1:ARK_s)= [0,1];
elseif (method == 1)
    %ARK(1,2,1) is ARK(1,1,1) but modified to satisfy b=bt.
    ARK_A(1,1)=0;
    ARK_A(1,2)=0;
    ARK_A(2,1)=1;
    ARK_A(2,2)=0;
    ARK_At(2,1)=0;
    ARK_At(2,2)=1;
    ARK_b(1:ARK_s)= ARK_At(ARK_s,1:ARK_s);
    ARK_bt(1:ARK_s)= ARK_b(1:ARK_s);
elseif (method == 2) 
    %ARK2A(2,3,2)
    ARK_A(1,1)=0;
    ARK_A(1,2)=0;
    ARK_A(1,3)=0;
    ARK_A(2,1)=0.5857864376269049511983112757903019214303281246230519;
    ARK_A(2,2)=0;
    ARK_A(2,3)=0;
    ARK_A(3,1)=0.02859547920896831706610375859676730714344270820768398;
    ARK_A(3,2)=0.9714045207910316829338962414032326928565572917923160;
    ARK_A(3,3)=0;
    ARK_At(2,1)=0.292893218813452475599155637895150960715164062311526;
    ARK_At(2,2)=0.2928932188134524755991556378951509607151640623115260;
    ARK_At(3,1)=0.3535533905932737622004221810524245196424179688442370;
    ARK_At(3,2)=0.3535533905932737622004221810524245196424179688442370;
    ARK_At(3,3)=0.2928932188134524755991556378951509607151640623115260;
    ARK_b(1:ARK_s)= ARK_At(ARK_s,1:ARK_s);
    ARK_bt(1:ARK_s)= ARK_b(1:ARK_s);
elseif (method == 21)
    %ARK2B(2,3,2)
    ARK_A(1,1)=0;
    ARK_A(1,2)=0;
    ARK_A(1,3)=0;
    ARK_A(2,1)=0.5857864376269049511983112757903019214303281246230519;
    ARK_A(2,2)=0;
    ARK_A(2,3)=0;
    ARK_A(3,1)=0.5;
    ARK_A(3,2)=0.5;
    ARK_A(3,3)=0;
    ARK_At(2,1)=0.292893218813452475599155637895150960715164062311526;
    ARK_At(2,2)=0.2928932188134524755991556378951509607151640623115260;
    ARK_At(3,1)=0.3535533905932737622004221810524245196424179688442370;
    ARK_At(3,2)=0.3535533905932737622004221810524245196424179688442370;
    ARK_At(3,3)=0.2928932188134524755991556378951509607151640623115260;
    ARK_b(1:ARK_s)= ARK_At(ARK_s,1:ARK_s);
    ARK_bt(1:ARK_s)= ARK_b(1:ARK_s);
elseif (method == 3)  
    %ARK(3,4,3)
    ARK_A(2,1)=1767732205903.0/2027836641118.0;
    ARK_A(3,1)=5535828885825.0/10492691773637.0;
    ARK_A(3,2)=788022342437.0/10882634858940.0;
    ARK_A(4,1)=6485989280629.0/16251701735622.0;
    ARK_A(4,2)=-4246266847089.0/9704473918619.0;
    ARK_A(4,3)=10755448449292.0/10357097424841.0;   
    ARK_At(2,1)=1767732205903.0/4055673282236.0;
    ARK_At(2,2)=1767732205903.0/4055673282236.0;
    ARK_At(3,1)=2746238789719.0/10658868560708.0;
    ARK_At(3,2)=-640167445237.0/6845629431997.0;
    ARK_At(3,3)=ARK_At(2,2);
    ARK_At(4,1)=1471266399579.0/7840856788654.0;
    ARK_At(4,2)=-4482444167858.0/7529755066697.0;
    ARK_At(4,3)=11266239266428.0/11593286722821.0;
    ARK_At(4,4)=ARK_At(2,2);
    ARK_b(1:ARK_s)= ARK_At(ARK_s,1:ARK_s);
    ARK_bt(1:ARK_s)= ARK_b(1:ARK_s);
elseif (method == 4)   
    %ARK(4,6,4)
    ARK_A(2,1)=1.0/2.0;
    ARK_A(3,1)=13861.0/62500.0;
    ARK_A(3,2)=6889.0/62500.0;
    ARK_A(4,1)=-116923316275.0/2393684061468.0;
    ARK_A(4,2)=-2731218467317.0/15368042101831.0;
    ARK_A(4,3)=9408046702089.0/11113171139209.0;
    ARK_A(5,1)=-451086348788.0/2902428689909.0;
    ARK_A(5,2)=-2682348792572.0/7519795681897.0;
    ARK_A(5,3)=12662868775082.0/11960479115383.0;
    ARK_A(5,4)=3355817975965.0/11060851509271.0;
    ARK_A(6,1)=647845179188.0/3216320057751.0;
    ARK_A(6,2)=73281519250.0/8382639484533.0;
    ARK_A(6,3)=552539513391.0/3454668386233.0;
    ARK_A(6,4)=3354512671639.0/8306763924573.0;
    ARK_A(6,5)=4040.0/17871.0;
    ARK_At(2,1)=1.0/4.0;
    ARK_At(2,2)=1.0/4.0;
    ARK_At(3,1)=8611.0/62500.0;
    ARK_At(3,2)=-1743.0/31250.0;
    ARK_At(3,3)=ARK_At(2,2);
    ARK_At(4,1)=5012029.0/34652500.0;
    ARK_At(4,2)=-654441.0/2922500.0;
    ARK_At(4,3)=174375.0/388108.0;
    ARK_At(4,4)=ARK_At(2,2);
    ARK_At(5,1)=15267082809.0/155376265600.0;
    ARK_At(5,2)=-71443401.0/120774400.0;
    ARK_At(5,3)=730878875.0/902184768.0;
    ARK_At(5,4)=2285395.0/8070912.0;
    ARK_At(5,5)=ARK_At(2,2);
    ARK_At(6,1)=82889.0/524892.0;
    ARK_At(6,2)=0.0;
    ARK_At(6,3)=15625.0/83664.0;
    ARK_At(6,4)=69875.0/102672.0;
    ARK_At(6,5)=-2260.0/8211.0;
    ARK_At(6,6)=ARK_At(2,2);
    ARK_b(1:ARK_s)= ARK_At(ARK_s,1:ARK_s);
    ARK_bt(1:ARK_s)=ARK_b(1:ARK_s);    
elseif (method == 5) 
    %ARK(5,8,5)
    ARK_A(2,1)=41.0/100.0;
    ARK_A(3,1)=367902744464.0/2072280473677.0;
    ARK_A(3,2)=677623207551.0/8224143866563.0;
    ARK_A(4,1)=1268023523408.0/10340822734521.0;
    ARK_A(4,2)=0.0;
    ARK_A(4,3)=1029933939417.0/13636558850479.0;
    ARK_A(5,1)=14463281900351.0/6315353703477.0;
    ARK_A(5,2)=0.0;
    ARK_A(5,3)=66114435211212.0/5879490589093.0;
    ARK_A(5,4)=-54053170152839.0/4284798021562.0;
    ARK_A(6,1)=14090043504691.0/34967701212078.0;
    ARK_A(6,2)=0.0;
    ARK_A(6,3)=15191511035443.0/11219624916014.0;
    ARK_A(6,4)=-18461159152457.0/12425892160975.0;
    ARK_A(6,5)=-281667163811.0/9011619295870.0;
    ARK_A(7,1)=19230459214898.0/13134317526959.0;
    ARK_A(7,2)=0.0;
    ARK_A(7,3)=21275331358303.0/2942455364971.0;
    ARK_A(7,4)=-38145345988419.0/4862620318723.0;
    ARK_A(7,5)=-1.0/8.0;
    ARK_A(7,6)=-1.0/8.0;
    ARK_A(8,1)=-19977161125411.0/11928030595625.0;
    ARK_A(8,2)=0.0;
    ARK_A(8,3)=-40795976796054.0/6384907823539.0;
    ARK_A(8,4)=177454434618887.0/12078138498510.0;
    ARK_A(8,5)=782672205425.0/8267701900261.0;
    ARK_A(8,6)=-69563011059811.0/9646580694205.0;
    ARK_A(8,7)=7356628210526.0/4942186776405.0;
    ARK_At(2,1)=41.0/200.0;
    ARK_At(2,2)=41.0/200.0;
    ARK_At(3,1)=41.0/400.0;
    ARK_At(3,2)=-567603406766.0/11931857230679.0;
    ARK_At(3,3)=ARK_At(2,2);
    ARK_At(4,1)=683785636431.0/9252920307686.0;
    ARK_At(4,2)=0.0;
    ARK_At(4,3)=-110385047103.0/1367015193373.0;
    ARK_At(4,4)=ARK_At(2,2);
    ARK_At(5,1)= 3016520224154.0/10081342136671.0;
    ARK_At(5,2)=0.0;
    ARK_At(5,3)=30586259806659.0/12414158314087.0;
    ARK_At(5,4)=-22760509404356.0/11113319521817.0;
    ARK_At(5,5)=ARK_At(2,2);
    ARK_At(6,1)=218866479029.0/1489978393911.0;
    ARK_At(6,2)=0.0;
    ARK_At(6,3)=638256894668.0/5436446318841.0;
    ARK_At(6,4)=-1179710474555.0/5321154724896.0;
    ARK_At(6,5)=-60928119172.0/8023461067671.0;
    ARK_At(6,6)=ARK_At(2,2);
    ARK_At(7,1)=1020004230633.0/5715676835656.0;
    ARK_At(7,2)=0.0;
    ARK_At(7,3)=25762820946817.0/25263940353407.0;
    ARK_At(7,4)=-2161375909145.0/9755907335909.0;
    ARK_At(7,5)=-211217309593.0/5846859502534.0;
    ARK_At(7,6)=-4269925059573.0/7827059040749.0;
    ARK_At(7,7)=ARK_At(2,2);
    ARK_At(8,1)=-872700587467.0/9133579230613.0;
    ARK_At(8,2)=0.0;
    ARK_At(8,3)=0.0;
    ARK_At(8,4)=22348218063261.0/9555858737531.0;
    ARK_At(8,5)=-1143369518992.0/8141816002931.0;
    ARK_At(8,6)=-39379526789629.0/19018526304540.0;
    ARK_At(8,7)=32727382324388.0/42900044865799.0;
    ARK_At(8,8)=ARK_At(2,2);
    ARK_b(1:ARK_s)= ARK_At(ARK_s,1:ARK_s);
    ARK_bt(1:ARK_s)=ARK_b(1:ARK_s);
elseif (method == 6)  
    %ARK(6,10,6) %Brian Vermiere method
    ARK_A(2,1)=0.2928932188134525;
    ARK_A(3,1)=0.3602847895715037;
    ARK_A(3,2)=0.02099677689026724;
    ARK_A(4,1)=0.4267095308101442;
    ARK_A(4,3)=0.04296038329994516;
    ARK_A(5,1)=0.4901881062634202;
    ARK_A(5,4)=0.06787015549498755;
    ARK_A(6,1)=0.548902422602367;
    ARK_A(6,5)=0.09754418680435926;
    ARK_A(7,1)=0.6003576019251088;
    ARK_A(7,6)=0.1344773551299359;
    ARK_A(8,1)=0.6404229388942057;
    ARK_A(8,7)=0.1828003658091574;
    ARK_A(9,1)=0.6612274743186617;
    ARK_A(9,8)=0.2503841780330199;    
    ARK_A(10,1)=0.3942428457889902;
    ARK_A(10,9)=0.6057571542110098;
    ARK_At(2,2)=0.2928932188134525;
    ARK_At(3,2)=0.3812815664617709;
    ARK_At(4,2)=0.4696699141100893;
    ARK_At(5,2)=0.5580582617584078;
    ARK_At(6,2)=0.6464466094067263;
    ARK_At(7,2)=0.7348349570550446;
    ARK_At(8,2)=0.8232233047033631;
    ARK_At(9,2)=0.9116116523516815;
    ARK_At(10,2)=0.7071067811865476;
    ARK_At(10,10)=0.2928932188134525;
    ARK_b(1:ARK_s)= ARK_At(ARK_s,1:ARK_s);
    ARK_bt(1:ARK_s)=ARK_b(1:ARK_s);
elseif (method == 7)  
    %ARK(6,7,4) %Kennedy and Carpenter called ARK437 in CLIMA
    
    gamma=1235 / 10000;
    
    ARK_A=zeros(ARK_s,ARK_s);
    ARK_At=zeros(ARK_s,ARK_s);
    ARK_b=zeros(ARK_s,1);
    ARK_bt=zeros(ARK_s,1);

    % the main diagonal
    for i = 2:ARK_s
        ARK_At(i,i)=gamma;
    end
   
    %Implicit A matrix 
    ARK_At(3,2)=624185399699 / 4186980696204;
    ARK_At(4,2)=1258591069120 / 10082082980243;
    ARK_At(4,3)=-322722984531 / 8455138723562;
    ARK_At(5,2)=-436103496990 / 5971407786587;
    ARK_At(5,3)=-2689175662187 / 11046760208243;
    ARK_At(5,4)=4431412449334 / 12995360898505;
    ARK_At(6,2)=-2207373168298 / 14430576638973;
    ARK_At(6,3)=242511121179 / 3358618340039;
    ARK_At(6,4)=3145666661981 / 7780404714551;
    ARK_At(6,5)=5882073923981 / 14490790706663;

    %Explicit A matrix
    ARK_A(3,1)=247 / 4000;
    ARK_A(3,2)=2694949928731 / 7487940209513;
    ARK_A(4,1)=464650059369 / 8764239774964;
    ARK_A(4,2)=878889893998 / 2444806327765;
    ARK_A(4,3)=-952945855348 / 12294611323341;
    ARK_A(5,1)=476636172619 / 8159180917465;
    ARK_A(5,2)=-1271469283451 / 7793814740893;
    ARK_A(5,3)=-859560642026 / 4356155882851;
    ARK_A(5,4)=1723805262919 / 4571918432560;
    ARK_A(6,1)=6338158500785 / 11769362343261;
    ARK_A(6,2)=-4970555480458 / 10924838743837;
    ARK_A(6,3)=3326578051521 / 2647936831840;
    ARK_A(6,4)=-880713585975 / 1841400956686;
    ARK_A(6,5)=-1428733748635 / 8843423958496;
    ARK_A(7,2)=760814592956 / 3276306540349;
    ARK_A(7,3)=-47223648122716 / 6934462133451;
    ARK_A(7,4)=71187472546993 / 9669769126921;
    ARK_A(7,5)=-13330509492149 / 9695768672337;
    ARK_A(7,6)=11565764226357 / 8513123442827;

    %b vector
    ARK_b(2) = 0;
    ARK_b(3) = 9164257142617 / 17756377923965;
    ARK_b(4) = -10812980402763 / 74029279521829;
    ARK_b(5) = 1335994250573 / 5691609445217;
    ARK_b(6) = 2273837961795 / 8368240463276;
    ARK_b(7) = 247 / 2000;

    %c vector
    ARK_c(1)=0;
    ARK_c(2)=247 / 1000;
    ARK_c(3)=4276536705230 / 10142255878289;
    ARK_c(4)=67 / 200;
    ARK_c(5)=3 / 40;
    ARK_c(6)=7 / 10;
    ARK_c(7)=1.0;
    
    for i = 2:ARK_s
      ARK_At(i,1) = ARK_At(i,2);
    end

    for i = 1:ARK_s-1
        ARK_At(ARK_s,i)= ARK_b(i);
    end

    ARK_b(1) = ARK_b(2);
    ARK_A(2,1) = ARK_c(2);
    ARK_A(ARK_s,1) = ARK_A(ARK_s,2);
    ARK_bt(1:ARK_s)=ARK_b(1:ARK_s);
    
 elseif (method == 8)  
    %ARK(7,8,5) %Kennedy and Carpenter

      ARK_A(2,1)=41.0/100.0;
      ARK_A(3,1)=367902744464.0/2072280473677.0;
      ARK_A(3,2)=677623207551.0/8224143866563.0;
      ARK_A(4,1)=1268023523408.0/10340822734521.0;
      ARK_A(4,2)=0.0;
      ARK_A(4,3)=1029933939417.0/13636558850479.0;
      ARK_A(5,1)=14463281900351.0/6315353703477.0;
      ARK_A(5,2)=0.0;
      ARK_A(5,3)=66114435211212.0/5879490589093.0;
      ARK_A(5,4)=-54053170152839.0/4284798021562.0;
      ARK_A(6,1)=14090043504691.0/34967701212078.0;
      ARK_A(6,2)=0.0;
      ARK_A(6,3)=15191511035443.0/11219624916014.0;
      ARK_A(6,4)=-18461159152457.0/12425892160975.0;
      ARK_A(6,5)=-281667163811.0/9011619295870.0;
      ARK_A(7,1)=19230459214898.0/13134317526959.0;
      ARK_A(7,2)=0.0;
      ARK_A(7,3)=21275331358303.0/2942455364971.0;
      ARK_A(7,4)=-38145345988419.0/4862620318723.0;
      ARK_A(7,5)=-1.0/8.0;
      ARK_A(7,6)=-1.0/8.0;
      ARK_A(8,1)=-19977161125411.0/11928030595625.0;
      ARK_A(8,2)=0.0;
      ARK_A(8,3)=-40795976796054.0/6384907823539.0;
      ARK_A(8,4)=177454434618887.0/12078138498510.0;
      ARK_A(8,5)=782672205425.0/8267701900261.0;
      ARK_A(8,6)=-69563011059811.0/9646580694205.0;
      ARK_A(8,7)=7356628210526.0/4942186776405.0;

      ARK_At(2,1)=41.0/200.0;
      ARK_At(2,2)=41.0/200.0;
      ARK_At(3,1)=41.0/400.0;
      ARK_At(3,2)=-567603406766.0/11931857230679.0;
      ARK_At(3,3)=ARK_At(2,2);
      ARK_At(4,1)=683785636431.0/9252920307686.0;
      ARK_At(4,2)=0.0;
      ARK_At(4,3)=-110385047103.0/1367015193373.0;
      ARK_At(4,4)=ARK_At(2,2);
      ARK_At(5,1)= 3016520224154.0/10081342136671.0;
      ARK_At(5,2)=0.0;
      ARK_At(5,3)=30586259806659.0/12414158314087.0;
      ARK_At(5,4)=-22760509404356.0/11113319521817.0;
      ARK_At(5,5)=ARK_At(2,2);
      ARK_At(6,1)=218866479029.0/1489978393911.0;
      ARK_At(6,2)=0.0;
      ARK_At(6,3)=638256894668.0/5436446318841.0;
      ARK_At(6,4)=-1179710474555.0/5321154724896.0;
      ARK_At(6,5)=-60928119172.0/8023461067671.0;
      ARK_At(6,6)=ARK_At(2,2);
      ARK_At(7,1)=1020004230633.0/5715676835656.0;
      ARK_At(7,2)=0.0;
      ARK_At(7,3)=25762820946817.0/25263940353407.0;
      ARK_At(7,4)=-2161375909145.0/9755907335909.0;
      ARK_At(7,5)=-211217309593.0/5846859502534.0;
      ARK_At(7,6)=-4269925059573.0/7827059040749.0;
      ARK_At(7,7)=ARK_At(2,2);
      ARK_At(8,1)=-872700587467.0/9133579230613.0;
      ARK_At(8,2)=0.0;
      ARK_At(8,3)=0.0;
      ARK_At(8,4)=22348218063261.0/9555858737531.0;
      ARK_At(8,5)=-1143369518992.0/8141816002931.0;
      ARK_At(8,6)=-39379526789629.0/19018526304540.0;
      ARK_At(8,7)=32727382324388.0/42900044865799.0;
      ARK_At(8,8)=ARK_At(2,2);

      ARK_b(1:ARK_s)= ARK_At(ARK_s,1:ARK_s);
      ARK_bt(1:ARK_s)=ARK_b(1:ARK_s);
      
 elseif (method == 9)  
    %ARK(7,8,5) %Kennedy and Carpenter

    gamma = 2/9;
    
    ARK_A=zeros(ARK_s,ARK_s);
    ARK_At=zeros(ARK_s,ARK_s);
    ARK_b=zeros(ARK_s,1);
    ARK_bt=zeros(ARK_s,1);

    % the main diagonal
    for i = 2:ARK_s
        ARK_At(i,i)=gamma;
    end

    %Implicit A matrix 
    ARK_At(3,2)=2366667076620 /  8822750406821;
    ARK_At(4,2)=-257962897183 / 4451812247028;
    ARK_At(4,3)=128530224461 / 14379561246022;
    ARK_At(5,2)=-486229321650 / 11227943450093;
    ARK_At(5,3)=-225633144460 / 6633558740617;
    ARK_At(5,4)=1741320951451 / 6824444397158;
    ARK_At(6,2)=621307788657 / 4714163060173;
    ARK_At(6,3)=-125196015625 / 3866852212004;
    ARK_At(6,4)=940440206406 / 7593089888465;
    ARK_At(6,5)=961109811699 / 6734810228204;
    ARK_At(7,2)=2036305566805 / 6583108094622;
    ARK_At(7,3)=-3039402635899 / 4450598839912;
    ARK_At(7,4)=-1829510709469 / 31102090912115;
    ARK_At(7,5)=-286320471013 / 6931253422520;
    ARK_At(7,6)=8651533662697 / 9642993110008;

    %Explicit A matrix
    ARK_A(3,1)=1 / 9;
    ARK_A(3,2)=1183333538310 / 1827251437969;
    ARK_A(4,1)=895379019517 / 9750411845327;
    ARK_A(4,2)=477606656805 / 13473228687314;
    ARK_A(4,3)=-112564739183 / 9373365219272;
    ARK_A(5,1)=-4458043123994 / 13015289567637;
    ARK_A(5,2)=-2500665203865 / 9342069639922;
    ARK_A(5,3)=983347055801 / 8893519644487;
    ARK_A(5,4)=2185051477207 / 2551468980502;
    ARK_A(6,1)=-167316361917 / 17121522574472;
    ARK_A(6,2)=1605541814917 / 7619724128744;
    ARK_A(6,3)=991021770328 / 13052792161721;
    ARK_A(6,4)=2342280609577 / 11279663441611;
    ARK_A(6,5)=3012424348531 / 12792462456678;
    ARK_A(7,1)=6680998715867 / 14310383562358;
    ARK_A(7,2)=5029118570809 / 3897454228471;
    ARK_A(7,3)=2415062538259 / 6382199904604;
    ARK_A(7,4)=-3924368632305 / 6964820224454;
    ARK_A(7,5)=-4331110370267 / 15021686902756;
    ARK_A(7,6)=-3944303808049 / 11994238218192;
    ARK_A(8,1)=2193717860234 / 3570523412979;
    ARK_A(8,2)=ARK_A(8,1);
    ARK_A(8,3)=5952760925747 / 18750164281544;
    ARK_A(8,4)=-4412967128996 / 6196664114337;
    ARK_A(8,5)=4151782504231 / 36106512998704;
    ARK_A(8,6)=572599549169 / 6265429158920;
    ARK_A(8,7)=-457874356192 / 11306498036315;

    %b vector
    ARK_b(2) = 0;
    ARK_b(3) = 3517720773327 / 20256071687669;
    ARK_b(4) = 4569610470461 / 17934693873752;
    ARK_b(5) = 2819471173109 / 11655438449929;
    ARK_b(6) = 3296210113763 / 10722700128969;
    ARK_b(7) = -1142099968913 / 5710983926999;
    ARK_b(1) = ARK_b(2);
    ARK_b(ARK_s) = gamma;

    %c vector
    ARK_c(1)=0;
    ARK_c(2)=4 / 9;
    ARK_c(3)=6456083330201 / 8509243623797;
    ARK_c(4)=1632083962415 / 14158861528103;
    ARK_c(5)=6365430648612 / 17842476412687;
    ARK_c(6)=18 / 25;
    ARK_c(7)=191 / 200;
    ARK_c(8)=1.0;

    for i = 2:ARK_s
        ARK_At(i,1) = ARK_At(i,2);
    end

    for i = 1:ARK_s-1
        ARK_At(ARK_s,i)= ARK_b(i);
    end
  
    ARK_A(2,1) = ARK_c(2);
    ARK_A(ARK_s,1) = ARK_A(ARK_s,2);
    ARK_bt(1:ARK_s)=ARK_b(1:ARK_s);
end
 
for i=1:ARK_s
    sum_E=sum(ARK_A(i,:));
    sum_I=sum(ARK_At(i,:));
    disp(['i=  ',num2str(i),' sum_E= ',num2str(sum_E),' sum_I= ',num2str(sum_I),' c= ',num2str(ARK_c(i))]);
end

for l=1:nf
   kfdt(l)=kfdtmin + (l-1)*dkfdt;
   for k=1:ns
      ksdt(k)=ksdtmin + (k-1)*dksdt;
      q=ones(ARK_s,1);
      for i=2:ARK_s
          %Explicit Part
          for j=1:i-1
            q(i)=q(i) + 1i*( ARK_A(i,j)*ksdt(k) + ARK_At(i,j)*kfdt(l) )*q(j);
          end
          %Implicit Part
          q(i)=q(i)/(1 - delta*1i*kfdt(l)*ARK_At(i,i));
      end
      temp=1;
      for i=1:ARK_s
          temp=temp + 1i*ARK_b(i)*q(i)*(ksdt(k) + kfdt(l));
      end
      amp1d(k,l)=sqrt( temp*conj(temp) );
      amp(k,l)=amp1d(k,l);
      if (amp(k,l) > 1 + 1e-6) 
          amp(k,l)=nan;
      end
   end       
end

[X,Y]=meshgrid(ksdt,kfdt);
V=0:0.05:1.05;
amp1=zeros(ns,nf);
amp2=zeros(ns,nf);
amp_max=zeros(ns,nf);
% figure
% subplot(1,2,1);
% plot(ksdt,amp1d(:,1),'r-','LineWidth',2);
% set(gca,'FontSize',18);
% xlabel('k_s \Delta t','FontSize',18); 
% ylabel('|A|','FontSize',18); 
% %axis([-cmax cmax 0 1.5]);
% axis([-1 1 0 1.5]);
% subplot(1,2,2);
% [cs,h]=contourf(X',Y',amp,V);
% hold on
% set(gca, 'CLim', [0,1]);
% colorbar('SouthOutside');
% set(gca,'FontSize',18);
% xlabel('k_s \Delta t','FontSize',18); 
% ylabel('k_f \Delta t','FontSize',18); 
% %set(gca,'XTick',[ksdtmin:1:ksdtmax]);
% %set(gca,'YTick',[kfdtmin:1:kfdtmax]);
% axis([ksdtmin ksdtmax kfdtmin kfdtmax]);
% %axis square
% %title(text);

% figure
% subplot(1,2,1);
% plot(ksdt,amp(:,1),'r-','LineWidth',2);
% set(gca,'FontSize',18);
% xlabel('k_s \Delta t','FontSize',18); 
% ylabel('|A|','FontSize',18); 
% axis([ksdtmin ksdtmax 0 1.75]);
% subplot(1,2,2);
% colormap(jet);
% [cs,h]=contourf(X',Y',amp,V);
% hold on
% set(gca, 'CLim', [0,1]);
% colorbar('SouthOutside');
% set(gca,'FontSize',18);
% xlabel('k_s \Delta t','FontSize',18); 
% ylabel('k_f \Delta t','FontSize',18); 
% set(gca,'XTick',[ksdtmin:1:ksdtmax]);
% set(gca,'YTick',[kfdtmin:10:kfdtmax]);
% axis([ksdtmin ksdtmax kfdtmin kfdtmax]);
% title(text);

figure
colormap(jet);
[cs,h]=contourf(X',Y',amp,V);
hold on
set(gca, 'CLim', [0,1]);
colorbar('SouthOutside');
set(gca,'FontSize',18);
xlabel('k_s \Delta t','FontSize',18); 
ylabel('k_f \Delta t','FontSize',18); 
set(gca,'XTick',[ksdtmin:1:ksdtmax]);
set(gca,'YTick',[kfdtmin:10:kfdtmax]);
axis([ksdtmin ksdtmax kfdtmin kfdtmax]);
title(text);