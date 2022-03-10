%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 呼吸波データと心電位データを読み込み，それぞれの間隔波形を描画する(拘束条件)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 入力：心電位，呼吸波データ　出力：間隔波形データRR(心拍)，PP(呼吸波)

clear all
close all


%% データ読込，フィルタ処理
fishnum = 'caf100g';
% 心電位データを読み込み(既にピークを抽出しているので，変数locsだけが必要)
loadname1 = append('..\1-1.周波数解析\心拍数\heartrate_', fishnum, '.mat');
% 呼吸波データを読み込み
loadname2 = append('..\0.動画像(鰓運動)解析\平均輝度値データ\luminance_ROI_', fishnum, '.mat');
load(loadname1)
load(loadname2)

% 心電位のピークが現れる時間locs
locs_ecg = locs;

% 出力ファイル名
name_fish = append('間隔波形(拘束条件)\pks_', fishnum, '.mat');

% サンプリング周波数
Fs_heart = 1000;
Fs_resp = 100;

% カットオフ周波数
resp_fl = 1;
resp_fh = 6;

wave_resp = BPF_but(int_list(1,1:120*Fs_resp),Fs_resp, resp_fl, resp_fh);

%% ピーク抽出(呼吸)
% ピーク抽出条件
mindistance = 100; % ピーク間の最低距離
pheight = 0;   % ピークの最低値
minpro = 0; 
click_resp = 0;

% ピーク抽出
[~,locs_resp,~,~] = findpeaks(wave_resp(1500:end), 'MinPeakDistance', mindistance,  'MinPeakProminence', minpro, 'MinPeakHeight', pheight);
findpeaks(wave_resp(1500:end), 'MinPeakDistance', mindistance,  'MinPeakProminence', minpro, 'MinPeakHeight', pheight)

%%  PP（呼吸）間隔計算
RawPP = [locs_resp(2:end)/Fs_resp, diff(locs_resp)]; % 1列目：時刻(「秒」に変換)，2列目：RR間隔
figure();
plot(RawPP(:,1), RawPP(:,2)); % RRデータの描画
xlabel('Time[s]'); ylabel('PP interval[ms]');
title('PP interval');
% ylim([0 200])

%%  RR(心拍)間隔計算
RawRR = [locs_ecg(2:end)/Fs_heart, diff(locs_ecg)]; % 1列目：時刻(「秒」に変換)，2列目：RR間隔
figure();
plot(RawRR(:,1), RawRR(:,2)); % RRデータの描画
xlabel('Time[s]'); ylabel('RR interval[ms]');
title('RR interval');
ylim([0 200])
%% PP間隔データをリサンプリング
newFs = 20; % リサンプリングの時間間隔
newtind = RawPP(1, 1):1/newFs:RawPP(end,1); % 等間隔の時刻データを定義 1/newFs刻みにしている
PP = [newtind; interp1(RawPP(:, 1), RawPP(:, 2), newtind)]';   % リサンプリング後データ　列に転置している
figure();
plot(RawPP(:,1), RawPP(:, 2));  % リサンプリング前のRR間隔
hold on;
plot(PP(:,1), PP(:,2), 'r');    % リサンプリング後のRR間隔
xlabel('Time [s]');ylabel('PP interval [ms]');
title('PP interval');

figure();
plot(PP(:,2))

%% RR間隔データをリサンプリング
newFs = 20; % リサンプリングの時間間隔
newtind = RawRR(1, 1):1/newFs:RawRR(end,1); % 等間隔の時刻データを定義 1/newFs刻みにしている
RR = [newtind; interp1(RawRR(:, 1), RawRR(:, 2), newtind)]';   % リサンプリング後データ　列に転置している
figure();
plot(RawRR(:,1), RawRR(:, 2));  % リサンプリング前のRR間隔
hold on;
plot(RR(:,1), RR(:,2), 'r');    % リサンプリング後のRR間隔
xlabel('Time [s]');ylabel('RR interval [ms]');
title('RR interval');

% 120sに揃えるため，それ以降を削除
idx = knnsearch(RR(:,1), 120);
RR(idx:end, :) = [];

figure();
plot(RR(:,2))


%% 呼吸・心拍間隔波形を保存
    savevar1 = 'PP';
    savevar2 = 'RR';
    save(name_fish, savevar1, savevar2); 