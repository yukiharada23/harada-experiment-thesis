%% 呼吸変動係数をboxplotで出力（自由遊泳）
clear all
close all

% データ読込み
fishname = { 'caf0a', 'caf0b', 'caf0c', 'caf0d','caf0e',  'caf1a', 'caf1b', 'caf1c', 'caf1d', 'caf1e', 'caf50a', 'caf50b', 'caf50c', 'caf50d', 'caf50e', 'caf100a', 'caf100b', 'caf100c', 'caf100d', 'caf100f'};
num0 = 5;
num1 = 5;
num50 = 5;
num100 = 5;

cv_resp_caf0=[]; cv_resp_caf1=[]; cv_resp_caf50=[]; cv_resp_caf100=[];

filename = '変動係数(自由遊泳条件)\cv_2min_';

for fishnum = 1:num0
   % データロード
   filepass = append(filename, fishname(fishnum), '.mat'); 
   load(string(filepass));
   
   % 結合
   cv_resp_caf0 = vertcat(cv_resp_caf0, resp_cv);

end

for fishnum = num0+1:num0+num1
      % データロード
   filepass = append(filename, fishname(fishnum), '.mat'); 
   load(string(filepass));
   
   % 結合
   cv_resp_caf1 = vertcat(cv_resp_caf1, resp_cv);
   
end


for fishnum = num0+num1+1:num0+num1+num50
     % データロード
   filepass = append(filename, fishname(fishnum), '.mat'); 
   load(string(filepass));
   
   % 結合
   cv_resp_caf50 = vertcat(cv_resp_caf50, resp_cv);
   
end

for fishnum = num0+num1+num50+1:num0+num1+num50+num100
     % データロード
   filepass = append(filename, fishname(fishnum), '.mat'); 
   load(string(filepass));
   
   % 結合
   cv_resp_caf100 = vertcat(cv_resp_caf100, resp_cv);
   
end

% 大きさそろえる
    max_len_cv_resp = max([length(cv_resp_caf0) length(cv_resp_caf1) length(cv_resp_caf50) length(cv_resp_caf100)]);
    cv_resp_caf0(length(cv_resp_caf0):max_len_cv_resp) = NaN;
    cv_resp_caf1(length(cv_resp_caf1):max_len_cv_resp) = NaN;
%     cv_resp_caf10(length(cv_resp_caf10):max_len_cv_resp) = NaN;
    cv_resp_caf50(length(cv_resp_caf50):max_len_cv_resp) = NaN;
    cv_resp_caf100(length(cv_resp_caf100):max_len_cv_resp) = NaN;

% 結合
cv_resp_all = horzcat(cv_resp_caf0, cv_resp_caf1, cv_resp_caf50, cv_resp_caf100);

cv_resp_all = cv_resp_all/500;
% caf0fdはおかしいので削除
cv_resp_all(70:93,2) = NaN;


%% boxplot描画
figure();
cv_resp_all(cv_resp_all > 0.07) = NaN;
boxdata = [cv_resp_all];
boxchart(boxdata,'MarkerStyle','.', 'BoxWidth', 0.2);
title('各濃度の呼吸変動係数');
ylim([0 0.08]);
pbaspect([3.17 1 1]);

% violinplot
figure();
a = violinplot(cv_resp_all);
a(1,1).ScatterPlot.Marker = 'none';
a(1,2).ScatterPlot.Marker = 'none';
a(1,3).ScatterPlot.Marker = 'none';
a(1,4).ScatterPlot.Marker = 'none';

pbaspect([3.17 1 1])
ylim([0 0.08])
