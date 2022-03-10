%% 呼吸と心拍変動係数をboxplotで出力（拘束条件）
clear all
close all

%% データ読込み
fishname = {'caf0a', 'caf0b', 'caf0c', 'caf0d', 'caf0e', 'caf1a', 'caf1b', 'caf1c', 'caf1d', 'caf1e', 'caf50b', 'caf50c', 'caf50d', 'caf50e', 'caf100a', 'caf100b', 'caf100c', 'caf100d', 'caf100e'};
num0 = 5;
num1 = 5;
num50 = 4;
num100 = 5;
fish_cnt = max([num0  num1 num50 num100])*4;
% 各データを格納
cv_resp_caf0=[]; cv_resp_caf1=[]; cv_resp_caf50=[]; cv_resp_caf100=[]; 
cv_ecg_caf0=[]; cv_ecg_caf1=[]; cv_ecg_caf50=[]; cv_ecg_caf100=[]; 
% 呼吸変動係数
filename = '変動係数(拘束条件)\cv_';


for fishnum = 1:num0
   % データロード
   filepass = append(filename, fishname(fishnum), '.mat'); 
   load(string(filepass));
   
   % 結合
    cv_resp_caf0 = vertcat(cv_resp_caf0, resp_cv);
    cv_ecg_caf0 = vertcat(cv_ecg_caf0, ecg_cv);
    
end

for fishnum = num0+1:num1+num0
     % データロード
   filepass = append(filename, fishname(fishnum), '.mat'); 
   load(string(filepass));
   
   % 結合
    cv_resp_caf1 = vertcat(cv_resp_caf1, resp_cv);
    cv_ecg_caf1 = vertcat(cv_ecg_caf1, ecg_cv);
end

for fishnum = num1+num0+1:num50+num1+num0
     % データロード
   filepass = append(filename, fishname(fishnum), '.mat'); 
   load(string(filepass));
   
   % 結合
    cv_resp_caf50 = vertcat(cv_resp_caf50, resp_cv);
    cv_ecg_caf50 = vertcat(cv_ecg_caf50, ecg_cv);
end

for fishnum = num50+num1+num0+1:num100+num50+num1+num0
      % データロード
   filepass = append(filename, fishname(fishnum), '.mat'); 
   load(string(filepass));
   
   % 結合
    cv_resp_caf100 = vertcat(cv_resp_caf100, resp_cv);
    cv_ecg_caf100 = vertcat(cv_ecg_caf100, ecg_cv);
end

% 大きさそろえる
    % 呼吸変動係数
     max_len_cv_resp = max([length(cv_resp_caf0) length(cv_resp_caf1) length(cv_resp_caf50) length(cv_resp_caf100)]);
    if length(cv_resp_caf0) < max_len_cv_resp
        cv_resp_caf0(length(cv_resp_caf0)+1:max_len_cv_resp) = NaN;
    end
    
    if length(cv_resp_caf1) < max_len_cv_resp
        cv_resp_caf1(length(cv_resp_caf1)+1:max_len_cv_resp) = NaN;
    end
    
    if length(cv_resp_caf50) < max_len_cv_resp
        cv_resp_caf50(length(cv_resp_caf50)+1:max_len_cv_resp) = NaN;
    end
    
    if length(cv_resp_caf100) < max_len_cv_resp
        cv_resp_caf100(length(cv_resp_caf100)+1:max_len_cv_resp) = NaN;
    end
    
     % 心拍変動係数
     max_len_cv_ecg = max([length(cv_ecg_caf0) length(cv_ecg_caf1) length(cv_ecg_caf50) length(cv_ecg_caf100)]);
    if length(cv_ecg_caf0) < max_len_cv_ecg
        cv_ecg_caf0(length(cv_ecg_caf0)+1:max_len_cv_ecg) = NaN;
    end
    
    if length(cv_ecg_caf1) < max_len_cv_ecg
        cv_ecg_caf1(length(cv_ecg_caf1)+1:max_len_cv_ecg) = NaN;
    end
    
    if length(cv_ecg_caf50) < max_len_cv_ecg
        cv_ecg_caf50(length(cv_ecg_caf50)+1:max_len_cv_ecg) = NaN;
    end
    
    if length(cv_ecg_caf100) < max_len_cv_ecg
        cv_ecg_caf100(length(cv_ecg_caf100)+1:max_len_cv_ecg) = NaN;
    end

% 結合
cv_resp_all = horzcat(cv_resp_caf0, cv_resp_caf1, cv_resp_caf50, cv_resp_caf100);
cv_ecg_all = horzcat(cv_ecg_caf0, cv_ecg_caf1, cv_ecg_caf50, cv_ecg_caf100);

% 単位を[ms]から[s]に変換
cv_resp_all = cv_resp_all/100;
cv_ecg_all = cv_ecg_all/1000;

% caf50eの呼吸のみサンプリング周波数が1000Hz
cv_resp_all(115-23+1:115, 3) = cv_resp_all(115-23+1:115, 3)/10;
%% boxplot描画
figure();
boxchart(cv_resp_all,'MarkerStyle','.');
title('各濃度の呼吸変動係数');
ylim([0 0.1]);
pbaspect([2 1 1]);
%  ylim([0 0.04]);


% cv_ecg_all(5,2) = NaN;
figure();
boxchart(cv_ecg_all,'MarkerStyle','.');
title('各濃度の心拍変動係数');
 ylim([0 0.1]);
pbaspect([2 1 1]);
