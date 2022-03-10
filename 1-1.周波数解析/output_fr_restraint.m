%% 呼吸ピーク周波数と心拍数をboxplotで出力

clear all
close all

%% データ読込み
fishname = {'caf0a', 'caf0b', 'caf0c', 'caf0d', 'caf0e', 'caf1a', 'caf1b', 'caf1c', 'caf1d', 'caf1e', 'caf50a', 'caf50b', 'caf50c', 'caf50d', 'caf50e', 'caf100a', 'caf100b', 'caf100c', 'caf100d', 'caf100e'};
num0 = 5;
num1 = 5;
num50 = 5;
num100 = 5;
fish_cnt = max([num0  num1 num50 num100])*4;
% 各データを格納
pks_resp_caf0=[]; pks_resp_caf1=[]; pks_resp_caf50=[]; pks_resp_caf100=[]; 
pks_ecg_caf0=[]; pks_ecg_caf1=[]; pks_ecg_caf50=[]; pks_ecg_caf100=[]; 

% 呼吸ピーク周波数
filename_resp = '..\0.動画像(鰓運動)解析\ピーク周波数\freq_';
% 心拍数
filename_ht = '心拍数\freq_';

for fishnum = 1:num0
   % データロード
   filepass_resp = append(filename_resp, fishname(fishnum), '.mat'); 
   filepass_ht = append(filename_ht, fishname(fishnum), '.mat'); 
   load(string(filepass_resp));
    load(string(filepass_ht));
   
   % 各個体データを結合
   pks_resp_caf0 = vertcat(pks_resp_caf0, pks_fr_resp');
   pks_ecg_caf0 = vertcat(pks_ecg_caf0, pks_fr_ecg);
 
    
end

for fishnum = num0+1:num1+num0
   % データロード
   filepass_resp = append(filename_resp, fishname(fishnum), '.mat'); 
   filepass_ht = append(filename_ht, fishname(fishnum), '.mat'); 
   load(string(filepass_resp));
    load(string(filepass_ht));
   
   % 各個体データを結合
   pks_resp_caf1 = vertcat(pks_resp_caf1, pks_fr_resp');
   pks_ecg_caf1 = vertcat(pks_ecg_caf1, pks_fr_ecg);
end

for fishnum = num1+num0+1:num50+num1+num0
    % データロード
   filepass_resp = append(filename_resp, fishname(fishnum), '.mat'); 
   filepass_ht = append(filename_ht, fishname(fishnum), '.mat'); 
   load(string(filepass_resp));
    load(string(filepass_ht));
   
   % 各個体データを結合
   pks_resp_caf50 = vertcat(pks_resp_caf50, pks_fr_resp');
   pks_ecg_caf50 = vertcat(pks_ecg_caf50, pks_fr_ecg);
end

for fishnum = num50+num1+num0+1:num100+num50+num1+num0
   % データロード
   filepass_resp = append(filename_resp, fishname(fishnum), '.mat'); 
   filepass_ht = append(filename_ht, fishname(fishnum), '.mat'); 
   load(string(filepass_resp));
    load(string(filepass_ht));
   
   % 各個体データを結合
   pks_resp_caf100 = vertcat(pks_resp_caf100, pks_fr_resp');
   pks_ecg_caf100 = vertcat(pks_ecg_caf100, pks_fr_ecg);
end

% 大きさそろえる
    % 呼吸ピーク周波数
    max_len_pks_resp = max([length(pks_resp_caf0) length(pks_resp_caf1) length(pks_resp_caf50) length(pks_resp_caf100)]);
    if length(pks_resp_caf0) < max_len_pks_resp
        pks_resp_caf0(length(pks_resp_caf0)+1:max_len_pks_resp) = NaN;
    end
    
    if length(pks_resp_caf1) < max_len_pks_resp
        pks_resp_caf1(length(pks_resp_caf1)+1:max_len_pks_resp) = NaN;
    end
    
    if length(pks_resp_caf50) < max_len_pks_resp
        pks_resp_caf50(length(pks_resp_caf50)+1:max_len_pks_resp) = NaN;
    end
    
    if length(pks_resp_caf100) < max_len_pks_resp
        pks_resp_caf100(length(pks_resp_caf100)+1:max_len_pks_resp) = NaN;
    end
    
    % 心拍ピーク周波数
    max_len_pks_ecg = max([length(pks_ecg_caf0) length(pks_ecg_caf1) length(pks_ecg_caf50) length(pks_ecg_caf100)]);
    if length(pks_ecg_caf0) < max_len_pks_ecg
        pks_ecg_caf0(length(pks_ecg_caf0)+1:max_len_pks_ecg) = NaN;
    end
    
    if length(pks_ecg_caf1) < max_len_pks_ecg
        pks_ecg_caf1(length(pks_ecg_caf1)+1:max_len_pks_ecg) = NaN;
    end
    
    if length(pks_ecg_caf50) < max_len_pks_ecg
        pks_ecg_caf50(length(pks_ecg_caf50)+1:max_len_pks_ecg) = NaN;
    end
    
    if length(pks_ecg_caf100) < max_len_pks_ecg
        pks_ecg_caf100(length(pks_ecg_caf100)+1:max_len_pks_ecg) = NaN;
    end
    
% 怪しいデータ削除
pks_resp_caf0(49:72,1) = NaN;
pks_resp_caf1(49:72,1) = NaN;
pks_resp_caf50(73:96,1) = NaN;
pks_resp_caf100(97:end,1) = NaN;

% 結合
pks_resp_all = horzcat(pks_resp_caf0, pks_resp_caf1, pks_resp_caf50, pks_resp_caf100);
pks_ecg_all = horzcat(pks_ecg_caf0, pks_ecg_caf1, pks_ecg_caf50, pks_ecg_caf100);


%% boxplot描画
figure();
boxchart(pks_resp_all,'MarkerStyle','.', 'BoxWidth', 0.2);
title('各濃度の呼吸ピーク周波数');
% pbaspect([1.1 1 1]);
% pbaspect([1.4 1 1]);
pbaspect([3.17 1 1]);
ylim([0 8]);
% ylim([2 10])

% violinplot
figure();
a = violinplot(pks_resp_all);
a(1,1).ScatterPlot.Marker = 'none';
a(1,2).ScatterPlot.Marker = 'none';
a(1,3).ScatterPlot.Marker = 'none';
a(1,4).ScatterPlot.Marker = 'none';
pbaspect([3.17 1 1]);
ylim([0 8])

figure();
boxchart(pks_ecg_all, 'BoxWidth', 0.2);
title('各濃度の心拍ピーク周波数');
% pbaspect([1.1 1 1]);
% pbaspect([1.4 1 1]);
pbaspect([3.17 1 1]);
ylim([0 4])
% ylim([2 10])

% violinplot
figure();
a = violinplot(pks_ecg_all);
a(1,1).ScatterPlot.Marker = 'none';
a(1,2).ScatterPlot.Marker = 'none';
a(1,3).ScatterPlot.Marker = 'none';
a(1,4).ScatterPlot.Marker = 'none';

pbaspect([3.17 1 1]);
ylim([0 4])


 