
clear all
close all

%% データ読込み
fishnames = {'caf0g', 'caf0b', 'caf0c','caf0d', 'caf0e', 'caf1a', 'caf1b', 'caf1c', 'caf1d', 'caf1e', 'caf50a','caf50b',  'caf50c', 'caf50d', 'caf50e',  'caf100a', 'caf100b','caf100c', 'caf100d' ,'caf100e'};

num0 = 5;
num1 = 5;
num50 = 5;
num100 = 5;
vel_caf0=[]; vel_caf1=[]; vel_caf50=[]; vel_caf100=[];
out_flag = 1;
filename = '平均遊泳速度計算結果(20s間隔)\';

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
vel_all = horzcat(vel_caf0, vel_caf1, vel_caf50, vel_caf100);

% 平均
ave_caf0 = mean(vel_caf0);
ave_caf1 = mean(vel_caf1);
ave_caf50 = mean(vel_caf50);
ave_caf100 = mean(vel_caf100);
ave_mat = horzcat(ave_caf0, ave_caf1, ave_caf50, ave_caf100);
%% boxplot描画
figure();
bar(ave_mat);
% 
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




