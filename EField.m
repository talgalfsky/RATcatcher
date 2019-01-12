clear all;
load nSilicon;

%%%% set wavelength and angle %%%%

polarization = 'TM'; % options are: 'TE', 'TM', 'S', 'P'
lambda = 670;


lambda_res = 1;

i_lambda = lambda;
f_lambda = lambda;

lambda = linspace(i_lambda, f_lambda, lambda_res);

angle=10*pi/180;

steps=20000;


nair=1*ones(1,length(lambda));

%%%% define structure %%%%

% [index,width] = ThueMores_structure(lambda,6);
peak = 670;
b_periods =8.5;  % # of bottom DBR periods
t_periods = 7.5;  % # of top DBR periods
a = 1;
b = 1;
a1 = 2/(1+b);
nAir =1;
nSiO2 = 1.45;
nSiNx = 1.77;
% nLiF = 1.4;
% nTeO2 = 2.44;
nSpacer = nSiO2;     %use SiO2 as the spacer
% nSpacer_2 = nLiF;
% nSpacer = nSiNx;   %use SiNx as the spacer

wSiNx = a*a1*peak/nSiNx/4;
wSiO2 = a*b*a1*peak/nSiO2/4;
% wLiF =  a*b*a1*peak/nLiF/4;
% wTeO2 = a*a1*peak/nTeO2/4;
% wCdSe = 28;
wMoS2_eff = 0.7;
% wZnO_eff = 185;
wSpacer = peak/4/nSpacer;
% wSpacer_2 = 20;
% wNTCDA_eff = 40;
% wAl = 20;

% % Using the ellipsometer data as the refractive index
% % datapts_1=importdata('nZnO.txt');           % spuncast ZnO nanoparticles
% datapts_1=importdata('ZnO_460c_T250.txt');
% % datapts_1=importdata('ZnO_130c_ALD.txt');           % ALD ZnO
% refr_1 = [datapts_1(:,1) datapts_1(:,2)];           %without the absorption
% % refr_1 = [datapts_1(:,1) datapts_1(:,2)+i.*datapts_1(:,3)]; %with the absorption
% nZnO_eff = interp1(refr_1(:,1),refr_1(:,2),lambda);

% datapts_2=importdata('nNTCDA.txt');
% refr_2 = [datapts_1(:,1) datapts_1(:,2)];           %without the absorption
% % refr_2 = [datapts_2(:,1) datapts_2(:,2)+i.*datapts_2(:,3)]; %with the absorption
% nNTCDA_eff = interp1(refr_2(:,1),refr_2(:,2),lambda);


% [Al_epsilon_Re Al_epsilon_Im nAl_eff] = LD(lambda, 'Al', 'LD');
% nAl_eff = real(nAl_eff);
% datapts_3=importdata('C:\Users\Xiaoze Liu\Desktop\ZnO mc fitting\spectrum profile fitting\nAl.txt');
% % refr = [datapts_1(:,1) datapts_1(:,2)];           %without the absorption
% refr_3 = [datapts_3(:,1) datapts_3(:,2)+i.*datapts_3(:,3)]; %with the absorption
% nAl_eff = interp1(refr_3(:,1),refr_3(:,2),lambda);

wpair = [wSiNx wSiO2];
wpair_flip = fliplr(wpair);

% wpair_t = [wTeO2 wLiF];
% wpair_flip_t = fliplr(wpair_t);

nSiNx = nSiNx*ones(1, lambda_res);
nSiO2 = nSiO2*ones(1, lambda_res);
% nLiF = nLiF*ones(1, lambda_res);
% nTeO2 = nTeO2*ones(1, lambda_res);
nAir = nAir*ones(1, lambda_res);
nSpacer = nSpacer*ones(1, lambda_res);
% nSpacer_2 = nSpacer_2*ones(1, lambda_res);
% nCdSe = 1.35+i*0.06;
% nCdSe = nCdSe*ones(1, lambda_res);
% nZnO_eff = 1.662+i*0.023;
% % nZnO_eff = 1.662;
% nNTCDA_eff = 1.642+i*0.173;
% % nNTCDA_eff = 1.642;
% % nZnO = 1.77;
% nZnO_eff = nZnO_eff*ones(1, lambda_res);
% nNTCDA_eff = nNTCDA_eff*ones(1, lambda_res);
nsubs = 3.45;
nSi = interp1(nSi(:,1),nSi(:,2), lambda); % index of Si

% E_0 = 1.87;
% B_osc =6;
% Gamma_br = 0.060;
% nMoS2_eff =Lorentzian_model(lambda,E_0,B_osc,Gamma_br); %using Lorentzian model to calculate MoS2 index
% nMoS2_eff_re = real(nMoS2_eff);

npair = [nSiNx; nSiO2];
npair_flip = flipud(npair);

% npair_t = [nTeO2; nLiF];
% npair_flip_t = flipud(npair_t);

nsubs = nsubs.*ones(1,lambda_res);
% n_green = getNK(lambda, 550, 50);
% nSi = interp1(nSi(:,1),nSi(:,2), lambda);
% nQDs = interp1(nQDs_red(:,1),nQDs_red(:,2), lambda);

[nbDBR, wbDBR] = make_DBR(npair_flip, wpair_flip, b_periods);
[ntDBR, wtDBR] = make_DBR(npair_flip, wpair_flip, t_periods);

% index = [ntDBR; nQDs; nbDBR];
% width = [wtDBR 200 wbDBR];

% index = [nSiO2; nQDs; nSiO2];
% width = [500 200 500];
% npassive_1 = nSiO2;
% npassive_2 = nSiNx;
% wpassive_1 = 130;
% wpassive_2 = 106;

% index = [ntDBR; nSpacer_1; npassive_2; nSpacer_1; nSpacer_1; npassive_2; nSpacer_1; nbDBR];
% width = [wtDBR wSpacer_1 wpassive_2 wSpacer_1 wSpacer_1 wpassive_2 wSpacer_1 wbDBR];

index = [ntDBR; nSpacer; nbDBR];
width = [wtDBR wSpacer*2 wbDBR];
index = [index; nSiO2];
n_in=1;

% index = [index; nsubs];
[pos, Efield, nval] = Efield_func(index,width,lambda,angle,steps,n_in,polarization);


% [X,Y]=meshgrid(lambda,pos);
% mesh(X,Y,Efield);

[Ax, H1, H2] = plotyy(pos, Efield, pos, nval);
% surfl(lambda,pos,Efield); shading interp; colormap(gray);
set(Ax(1),'XLim',[pos(1) pos(end)]);
xlabel('Position(nm)', 'fontsize', 20);
ylabel('Electric field(a. u.)', 'fontsize', 20);
set(Ax(1), 'XTick', pos(1):500:pos(end));
set(Ax(1), 'XTickLabel', pos(1):500:pos(end), 'Fontsize', 15);
set(Ax(1), 'YTick', 0:10:40);
set(Ax(1), 'YTickLabel', 0:10:40, 'Fontsize', 15);

set(Ax(2),'XLim',[pos(1) pos(end)]);
set(Ax(2),'YLim',[1.4 1.8]);
set(get(Ax(2), 'Ylabel'), 'String', 'Refractive index', 'fontsize', 20);
set(Ax(2), 'XTick', pos(1):500:pos(end));
set(Ax(2), 'XTickLabel', pos(1):500:pos(end), 'Fontsize', 15);
set(Ax(2), 'YTick', 1.4:.1:1.8);
set(Ax(2), 'YTickLabel', 1.4:.1:1.8, 'Fontsize', 15);
