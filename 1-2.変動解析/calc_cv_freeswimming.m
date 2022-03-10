%% q秒ごとの変動係数を計算する

clear all
close all

%% データ読込
fishnum = 'caf100g';
loadname1 = append('間隔波形(自由遊泳条件)\pks_', fishnum, '.mat');
load(loadname1)

% サンプリング周波数
Fs = 20;

% ms→sに変換
% これいらんかも？
PP = PP(:,2)/1000;


flag_save = 0;

%% 変動係数計算
% 窓幅
q = 10*Fs;
% 分割数
Mr= fix(length(PP)/q);
% CV計算結果
resp_cv = zeros(Mr,1);
% 平均値
resp_av = mean(PP);

for i = 1:Mr
    resp_cv(i) = var(PP((i-1)*q+1:i*q))/resp_av;
end

%% 結果を保存
if flag_save == 1
     savefile = append('変動係数(自由遊泳条件)\cv_', fishnum, '.mat');
    savevar1 = 'resp_cv';
    save(savefile, savevar1); 
end
