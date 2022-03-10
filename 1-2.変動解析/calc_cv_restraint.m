%% q秒ごとの変動係数を計算する

clear all
close all

%% データ読込
fishnum = 'caf100g';
loadname1 = append('間隔波形(拘束条件)\pks_', fishnum, '.mat');
load(loadname1)

% サンプリング周波数
Fs = 20;

% ms→sに変換
PP = PP(:,2)/1000;
RR = RR(:,2)/1000;


flag_save = 0;

%% 変動係数計算
% 窓幅
q = 10*Fs;
% 分割数
Mh= fix(length(RR)/q);
Mr= fix(length(PP)/q);
% CV計算結果
resp_cv = zeros(Mr,1);
ecg_cv = zeros(Mh,1);
% 平均値
resp_av = mean(PP);
ecg_av = mean(RR);

for i = 1:Mh
    ecg_cv(i) = var(RR((i-1)*q+1:i*q))/ecg_av;
end

for i = 1:Mr
    resp_cv(i) = var(PP((i-1)*q+1:i*q))/resp_av;
end

%% 結果を保存
if flag_save == 1
     savefile = append('変動係数(拘束条件)\cv_', fishnum, '.mat');
    savevar1 = 'resp_cv';
    savevar2 = 'ecg_cv';
    save(savefile, savevar1, savevar2); 
end
