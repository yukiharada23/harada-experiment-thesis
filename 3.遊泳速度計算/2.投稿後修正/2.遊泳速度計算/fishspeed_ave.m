clear all
close all

%% csvデータ（xy座標）読込
fishnum = 'caf100e';
filepass = '..\1.元データ\2.位置推定結果(Deeplabcut)\';
loadpass = append(filepass, 'sci_', fishnum, '.csv');

% csvファイル読込
data = readtable(loadpass);

% 座標データ読込
x = table2array(data(:,2));
y = table2array(data(:,3));

% 精度読込
% ac = table2array(data(:,4));

% 動画最初の白飛びを削除
x = x(51:end);
y = y(51:end);
% ac = ac(51:end);

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
% 総移動距離(pixel)
dst = zeros(len-1,1);
for i = 2:len
    x_dst = (x(i) - x(i-1)).^2;
    y_dst = (y(i) - y(i-1)).^2;
    dst(i) = sqrt(x_dst+y_dst);
end

% 総移動距離を[cm]に変換（動画ごとに比率が異なる）
% caf0a,b,c : 802 pixel
% caf0d,e : 1340 pixel
% caf0f : 1313 pixel
% caf0g : 1337 pixel
% caf1a,b,c,d,e : 860 pixel
% caf50a,b,c,d : 797 pixel
% caf50e : 1355 pixel
% caf100a : 802 pixel
% caf100b,c,d,e : 863 pixel

horztank_cm = 21; % 水槽横[cm]
horztank_px = 0;  % 水槽横[px] 

switch fishnum
    case {'caf0a', 'caf0b', 'caf0c'}
        horztank_px = 802;
    case {'caf0d', 'caf0e'}
        horztank_px = 1340;
    case 'caf0f'
        horztank_px = 1313;
    case 'caf0g'
        horztank_px = 1337;
    case {'caf1a', 'caf1b', 'caf1c', 'caf1d', 'caf1e'}
        horztank_px = 860;
    case {'caf50a', 'caf50b', 'caf50c', 'caf50d'}
        horztank_px = 797;
    case 'caf50e'
        horztank_px = 1355;
    case 'caf100a'
        horztank_px = 802;
    case {'caf100b','caf100c','caf100d','caf100e'}
        horztank_px = 863;
end
    
% 総移動距離[cm]
dst_cm = dst*horztank_cm/horztank_px;

% winごとに分割
% win_s = 5;          % second
win_s = 5;
win = win_s*Fs;     % frame
div = fix(len/win);
% 速度
vel = zeros(div,1);

% 速度計算
for i = 1:div
    % 分割区間の総移動距離
    sum_dst = sum(dst_cm((i-1)*win+1:i*win));
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





