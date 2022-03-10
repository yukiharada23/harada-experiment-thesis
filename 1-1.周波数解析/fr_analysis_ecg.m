%% 読み込んだ心電位にフィルタ処理を行い，Ｒ波を抽出して心拍数計算

% ----------------------------------------------------------------
close all
clear all


%% 心電位データ読込み
fishnum = 'caf0b';
fishfile = append('sig_', fishnum, '.txt.mat');
pass = '心電位\';
filepass = append(pass, fishfile);
load(filepass)

flag_save = 0;
flag_save_out = 0;

% サンプリング周波数
Fs = 1000;

% カットオフ周波数
ecg_l = 10;
ecg_h = 120;
ecg_l_high = 53;
ecg_h_high = 120;

%バンドパスフィルタで濾波
wave_ecg = BPF_but(data_sig(1:Fs*120,1),Fs, ecg_l, ecg_h);

% 生波形描画
figure();
plot(wave_ecg);
title('生波形');

% 60Hz成分除去
d = designfilt('bandstopiir','FilterOrder',2, ...
               'HalfPowerFrequency1',59,'HalfPowerFrequency2',61, ...
               'DesignMethod','butter','SampleRate',Fs);
filt_wave_ecg =  filtfilt(d, wave_ecg);
figure();
 plot([filt_wave_ecg])
title('60Hzカット後');
pbaspect([8 1 1])
xlim([1 2400000]);


% 低周波成分カット
filt_wave_ecg_high = BPF_but(filt_wave_ecg, Fs, ecg_l_high, ecg_h_high);
figure();
 plot([filt_wave_ecg_high])
title('低周波成分カット');


% 移動平均フィルタ
% windowSize = 251; 
% windowSize = 101;
% b = (1/windowSize)*ones(1,windowSize);
% a = 1;
% delay = (length(b)-1)/2;
% ave_wave_ecg_high = filter(b,a,abs(filt_wave_ecg_high));
% ave_wave_ecg_high_pre = ave_wave_ecg_high(delay:end);
% ave_wave_ecg_high_pre = zscore(ave_wave_ecg_high_pre);
% figure();
% plot([ave_wave_ecg_high_pre zscore(filt_wave_ecg_high(1:end-delay+1)) zscore(filt_wave_ecg(1:end-delay+1))]);
% title('移動平均フィルタ');
% 
% figure();
% plot(ave_wave_ecg_high_pre);
% title('移動平均のみ');
% 
% ave_wave_ecg_high = ave_wave_ecg_high_pre;
% 
% 最初はカット
% ave_wave_ecg_high = ave_wave_ecg_high(2001:end);
% フィルタ処理後にバンドパスフィルタを濾波
% ave_wave_ecg_high = BPF_but(ave_wave_ecg_high_pre, Fs, 1, 4);
% figure();
% plot([ave_wave_ecg_high]);
% title('フィルタ処理して低周波のみpass');

%% ピーク(R波)検出して心拍数計算
% ピーク抽出条件
mindistance = 300; % ピーク間の最低距離
pheight = 100;   % ピークの最低値
minpro = 0; 
% 手動でR波を検出するかどうか
click = 0;

% ピーク検出
% [~,locs,~,~] = findpeaks(ave_wave_ecg_high, 'MinPeakDistance', mindistance,  'MinPeakProminence', minpro, 'MinPeakHeight', pheight);
 [~,locs,~,~] = findpeaks(filt_wave_ecg, 'MinPeakDistance', mindistance,  'MinPeakProminence', minpro, 'MinPeakHeight', pheight);
figure();
% findpeaks(ave_wave_ecg_high, 'MinPeakDistance', mindistance,  'MinPeakProminence', minpro, 'MinPeakHeight', pheight)
  findpeaks(filt_wave_ecg, 'MinPeakDistance', mindistance,  'MinPeakProminence', minpro, 'MinPeakHeight', pheight)

 % ------------上の抽出結果に加えて，クリックでR波を検出したい場合----------------
if click == 1
    % クリック位置（R波位置）を格納
locs_cl = zeros(1500,1);
rrn = 1;

while 1   
     prompt = '"y"+"enter"押下でR波の指定終了, "enter"押下で継続\n';
    str = input(prompt,'s');
    if str =='y'
       break 
    end
    % 入力待ち状態にします。   
    waitforbuttonpress;
    % マウスの現在値の取得
    Cp = get(gca,'CurrentPoint');
    Xp = Cp(2,1);  % X座標
    Yp = Cp(2,2);  % Y座標
    Xp
   str1 = sprintf('\\leftarrow クリックした場所');
   ht(1) = text(Xp,Yp,str1,'Clipping','off');
   locs_cl(rrn, 1) = Xp;
   rrn = rrn+1;    
       
end

% 自動検出とクリック検出の結果を結合し，昇順にソート
locs = vertcat(locs, locs_cl);
locs = sort(locs);
end
% ------------------------------------------------------------------
if click == 1
    locs(1:1500-(rrn-1)) = [];
end
 
 
% 5秒ごとにピークをカウント
cnt_max = fix(length(ave_wave_ecg_high)/(5*Fs));
ecg_pkscnt = zeros(cnt_max, 1);
for cnt = 1:cnt_max
    pks_ind = locs((cnt-1)*5*Fs+1 < locs & cnt*5*Fs >= locs);
    ecg_pkscnt(cnt) = length(pks_ind);
end

% 5秒ごとの心拍数計算
pks_fr_ecg = ecg_pkscnt/5;

%% 保存
if flag_save == 1
    savefile = append(pass, '心拍数\heartrate_', fishnum, '.mat');
    savevar1 = 'ave_wave_ecg_high';
    savevar2 = 'pks_fr_ecg';
    savevar3 = 'locs';
    save(savefile, savevar1, savevar2, savevar3);
end

