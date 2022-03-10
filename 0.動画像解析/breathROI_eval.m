%% breathROI_calc.mで計算した平均輝度値を読込み，周波数解析する
% 入力：int_list 出力：pks_fr_resp(呼吸ピーク周波数)

% ----------------------------------------------------------------
close all
clear all


%% 2次元の平均輝度値データint_list(line:部位, row:フレーム数)と呼吸波を読み込み，バンドパスフィルタで濾波

% 平均輝度値を入力
load('平均輝度値データ\luminance_ROI_caf0za.mat')
Fs_brth = 100;
brth_l = 0.5;
brth_h = 5;

%--------波形描画について-------------%
% 時系列データを描画
flag_t = 0;
 % 周波数データを描画
 flag_f = 1;

%int_listの解析する行を指定（鰓だけなので1でＯＫ）
part = 1;

%オレンジ：顎，青：心臓，緑：呼吸波
    orange = [1 102/255 0];
    blue = [0 102/255, 204/255];
    color = orange;
    green = [51/255, 153/255, 102/255];

%バンドパスフィルタで濾波
lum_brth = BPF_but(int_list(part,1:fr_num-1),Fs_brth, brth_l, brth_h);

% データ長を120秒間にカット
lum_brth(12001:end) = [];



%% 時間区間win[s]でlum_brthを分割

% 分割区間長指定（論文では5s）
 win = 5; % [s]
win_fr = win*Fs_brth;

% 分割数
M = fix(fr_num/win_fr);

% lum_bpfを分割
div_lum_brth = zeros(M, win_fr);

 cnt = 1;
    for i=1:M
        for j=1:win_fr
            div_lum_brth(i,j) = lum_brth(cnt);
            if cnt >= fr_num
                break;
            end
            cnt = cnt+1;
        end
    end
    

%% 各分割区間で振幅を正規分布に標準正規化

 for i=1:M
    div_lum_brth(i,:) = zscore(div_lum_brth(i,:));
 end


if flag_t == 1
for i=1:M
    graphname = [num2str((i-1)*win_fr), '～',num2str(i*win_fr),'フレームにおける振幅の標準偏差'];
    figure('Name', graphname)  
    %顎or心臓描画
     plot(div_lum_brth(i,:), 'Color', color)
     xticklabels({})
     yticklabels({})
end

end

%% -------------------------------------------周波数解析------------------------------------------------------------------
%% 各分割区間のPSDを，ARモデルを用いて推定
% ARモデルの係数決定にはバーグ法，次数決定にはAICを使用

pAR = zeros(M,2); % 各区間のAR次数を格納　1列目：呼吸　
dft= 512;   % dft点数を設定(偶数にすること！)　

% PSD値と離散周波数を格納
lum_psd = zeros(M, dft/2+1);
lum_F = zeros(M, dft/2+1);

for i=1:M
    % 適切なARモデル次数の設定
    for mo = 10:50
        ARmodel = ar(div_lum_brth(i,:), mo, 'yw');
        AIC(mo) = aic(ARmodel); % AICの計算
    end
    [~, morder] = min(AIC);           % AICが最小となる次数を抽出
    pAR(i, 1) = morder;
  
    
    % PSD推定
    [Pb, Fb] = pburg(div_lum_brth(i,:)-mean(div_lum_brth(i,:)), 30, dft, Fs_brth);
 
    % 結果を格納
    lum_psd(i,:) = Pb;
    lum_F(i,:) = Fb;
     
end

lum_psd_dm = lum_psd;


%psdの正規化
    for i=1:M
        for j=1:length(Pb)
            lum_psd(i,j) = lum_psd_dm(i,j)/sum(lum_psd_dm(i,:));
        end
    end

 
% 結果を描画
if flag_f == 1
for i=1:M
    graphname = [num2str((i-1)*win_fr), '～',num2str(i*win_fr),'フレームにおけるPSD'];
    figure('Name', graphname)
        plot(lum_F(i, :), lum_psd(i, :), 'Color',color)

     
end

end

% ピーク周波数計算
pks_fr_resp = zeros(Mb, 1);

for i = 1:Mb
    [~, I1] = max(resp_psd(i, :));
    pks_fr_resp(i, 1) = resp_F(1, I1);
end 

pks_fr_resp = pks_fr_resp.';

%% ピーク周波数の時間変化を描画
figure();
plot(pks_fr_resp, '-b');
ylim([0 9]);
% pks_fr_resp(19*Fs:40*Fs) = NaN;
% pks_fr_resp(51*Fs:71*Fs) = NaN;

%% 保存
if flag_save == 1
     savefile = append('ピーク周波数(拘束条件)\freq_', fishnum, '.mat');
    savevar1 = 'pks_fr_resp';
    save(savefile, savevar1);
 
end
