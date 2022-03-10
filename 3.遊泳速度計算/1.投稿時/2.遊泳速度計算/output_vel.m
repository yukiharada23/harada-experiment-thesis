
clear all
close all

%% データ読込み
fishnames = {'caf0a', 'caf0b','caf0e', 'caf1b', 'caf1d', 'caf1a', 'caf50a','caf50b',  'caf50c',  'caf100a', 'caf100e'};

num0 = 3;
num1 = 3;
num50 = 3;
num100 = 2;
fish_cnt = max([num0  num1 num50 num100])*4;
vel_caf0=[]; vel_caf1=[]; vel_caf50=[]; vel_caf100=[];
out_flag = 1;
filename = '平均遊泳速度計算結果(5s間隔)\';

for fishnumber = 1:num0
   % データロード
   filepass = append(filename, fishnames(fishnumber), '_vel.mat'); 
   load(string(filepass));
   
   % 結合
   vel_caf0 = vertcat(vel_caf0, vel); 
end

for fishnumber = num0+1:num1+num0 
   % データロード
   filepass = append(filename, fishnames(fishnumber), '_vel.mat'); 
   load(string(filepass));
     

   % 結合
   vel_caf1 = vertcat(vel_caf1, vel);
end

for fishnumber = num1+num0+1:num50+num1+num0
    % データロード
   filepass = append(filename, fishnames(fishnumber), '_vel.mat'); 
   load(string(filepass));

   
   % 結合
   vel_caf50 = vertcat(vel_caf50, vel);
end

for fishnumber = num50+num1+num0+1:num100+num50+num1+num0
     % データロード
   filepass = append(filename, fishnames(fishnumber), '_vel.mat'); 
   load(string(filepass));
     
 
   % 結合
   vel_caf100 = vertcat(vel_caf100, vel);
end

% 外れ値除去
if out_flag == 1
    [~, TF] = rmoutliers(vel_caf0, 'quartiles');
    vel_caf0(TF) = NaN;
    [~, TF] = rmoutliers(vel_caf1, 'quartiles');
    vel_caf1(TF) = NaN;
    [~, TF] = rmoutliers(vel_caf50, 'quartiles');
    vel_caf50(TF) = NaN;
    [~, TF] = rmoutliers(vel_caf100, 'quartiles');
    vel_caf100(TF) = NaN;
end

% 100mg/Lだけ1匹少ない
vel_caf100(length(vel_caf100)+1:length(vel_caf0)) = NaN;

% pixelからcmに変換
vel_all = horzcat(vel_caf0/6.08, vel_caf1/4.2, vel_caf50/8, vel_caf100/4.5);


%% boxplot描画
figure();
boxdata = [vel_all];
boxchart(boxdata,'MarkerStyle','.', 'BoxWidth', 0.2);
pbaspect([1 1 1]);
ylim([0 15]);

% violinplot
figure();
a = violinplot(vel_all);
a(1,1).ScatterPlot.Marker = 'none';
a(1,2).ScatterPlot.Marker = 'none';
a(1,3).ScatterPlot.Marker = 'none';
a(1,4).ScatterPlot.Marker = 'none';
pbaspect([1 1 1])
ylim([0 15]);




