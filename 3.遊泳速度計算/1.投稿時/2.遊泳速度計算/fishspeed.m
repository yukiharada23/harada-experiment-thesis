clear all
close all

%% csvデータ（xy座標）読込
fishnum = 'caf100a';
filenum = 'DLC_resnet50_HaradaJan15shuffle1_50000.csv';
filepass = '..\1.元データ\2.位置推定結果(Deeplabcut)\';
loadpass = append(filepass, fishnum, filenum);

% csvファイル読込
data = readtable(loadpass);

% 座標データ読込
x = table2array(data(:,2));
y = table2array(data(:,3));

% 精度読込
ac = table2array(data(:,4));

% 動画最初の白飛びを削除
x = x(51:end);
y = y(51:end);
ac = ac(51:end);

% 精度が低い座標を削除
% lac = find(ac < 0.5);
% x(lac) = [];
% y(lac) = [];


% フレームレート
Fs = 30;
% 総フレーム数
len = length(x);

% 速度保存するか
flag_save = 1;

%% 速度計算
% 総移動距離
dst = zeros(len-1,1);
for i = 2:len
    x_dst = (x(i) - x(i-1)).^2;
    y_dst = (y(i) - y(i-1)).^2;
    dst(i) = sqrt(x_dst+y_dst);
end

% 各フレームの遊泳速度
vel_fr = dst/(1/Fs);

% winごとに分割
win_s = 5;          % second
% win_s = 20;
win = win_s*Fs;     % frame
div = fix(len/win);
% 速度
vel = zeros(div,1);

% winごとの平均遊泳速度計算
for i = 1:div
    % 分割区間の総移動距離
    sum_dst = sum(dst((i-1)*win+1:i*win));
    vel(i) = sum_dst/win_s;
end

%% 結果保存
savepass = '平均遊泳速度計算結果(5s間隔)\';

if flag_save == 1
    savename = append(savepass, fishnum, '_vel.mat');
    savevar1 = 'vel';
    savevar2 = 'fishnum';
    save(savename, savevar1, savevar2);
 
end





