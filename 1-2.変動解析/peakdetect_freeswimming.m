%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 呼吸波データを読み込み，間隔波形を描画する(自由遊泳条件)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 入力：呼吸波データ　出力：間隔波形データPP(呼吸波)

clear all
close all


%% データ読込，フィルタ処理
fishnum = 'caf100g';
% 呼吸波データを読み込み
loadname2 = append('..\1-1.周波数解析\解析後呼吸波(自由遊泳条件)\sig_free_2min_', fishnum, '.mat');
load(loadname2)

% 出力ファイル名
name_fish = append('間隔波形(自由遊泳条件)\pks_', fishnum, '.mat');

% サンプリング周波数
Fs_resp = 500;

% カットオフ周波数
resp_fl = 1;
resp_fh = 6;

%% ピーク抽出
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

%% matファイルに出力
save(name_fish)