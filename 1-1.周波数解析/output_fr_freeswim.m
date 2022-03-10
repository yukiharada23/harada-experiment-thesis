%% 呼吸ピーク周波数をboxplotで出力（自由遊泳）
clear all
close all

% データ読込み
fishname = { 'caf0a', 'caf0b', 'caf0c', 'caf0d','caf0e',  'caf1a', 'caf1b', 'caf1c', 'caf1d', 'caf1e', 'caf50a', 'caf50b', 'caf50c', 'caf50d', 'caf50e', 'caf100a', 'caf100b', 'caf100c', 'caf100d', 'caf100f'};
num0 = 5;
num1 = 5;
num50 = 5;
num100 = 5;

pks_resp_caf0=[]; pks_resp_caf1=[];  pks_resp_caf50=[]; pks_resp_caf100=[]; 

filename = 'ピーク周波数(自由遊泳条件)\freq_2min_';

for fishnum = 1:num0
   % データロード
   filepass = append(filename, fishname(fishnum), '.mat'); 
   load(string(filepass));
   
   % 結合
   pks_resp_caf0 = vertcat(pks_resp_caf0, pks_fr_resp');

end

for fishnum = num0+1:num0+num1
    % データロード
    filepass = append(filename, fishname(fishnum), '.mat');
 load(string(filepass));
   
   % 結合
   pks_resp_caf1 = vertcat(pks_resp_caf1, pks_fr_resp');
   
end


for fishnum = num0+num1+1:num0+num1+num50
     % データロード
   filepass = append(filename, fishname(fishnum), '.mat'); 
  
  load(string(filepass));

   

   % 結合
   pks_resp_caf50 = vertcat(pks_resp_caf50, pks_fr_resp');
 
   
end

for fishnum = num0+num1+num50+1:num0+num1+num50+num100
    % データロード
   filepass = append(filename, fishname(fishnum), '.mat'); 
  
  load(string(filepass));
   

   % 結合
   pks_resp_caf100 = vertcat(pks_resp_caf100, pks_fr_resp');
   
end

% 大きさそろえる
    max_len_pks_resp = max([length(pks_resp_caf0) length(pks_resp_caf1) length(pks_resp_caf50) length(pks_resp_caf100)]);
    pks_resp_caf0(length(pks_resp_caf0):max_len_pks_resp) = NaN;
    pks_resp_caf1(length(pks_resp_caf1):max_len_pks_resp) = NaN;
    pks_resp_caf50(length(pks_resp_caf50):max_len_pks_resp) = NaN;
    pks_resp_caf100(length(pks_resp_caf100):max_len_pks_resp) = NaN;

% 結合
pks_resp_all = horzcat(pks_resp_caf0, pks_resp_caf1, pks_resp_caf50, pks_resp_caf100);

% caf0fdはおかしいので削除
pks_resp_all(24*3+1:24*4,2) = NaN;


%% boxplot描画
figure();
boxdata = [pks_resp_all];
boxchart(boxdata,'MarkerStyle','.', 'BoxWidth', 0.2);
title('各濃度の呼吸ピーク周波数');
pbaspect([3.17 1 1]);
ylim([1.5 6])

% violinplot
figure();
a = violinplot(pks_resp_all);
a(1,1).ScatterPlot.Marker = 'none';
a(1,2).ScatterPlot.Marker = 'none';
a(1,3).ScatterPlot.Marker = 'none';
a(1,4).ScatterPlot.Marker = 'none';
pbaspect([3.17 1 1])
ylim([1.5 6])
