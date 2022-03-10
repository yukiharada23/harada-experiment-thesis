%% 自由遊泳条件で計測した呼吸波を周波数解析
% 呼吸波全電極データを読み込み，選択した電極で計測された呼吸波を2分間にカットし，ピーク周波数計算

% ----------------------------------------------------------------
close all
clear all

%% データ入力
fishnum = 'caf0fb_re';
loadname = append('解析前呼吸波(自由遊泳条件)\sig_free_', fishnum, '.mat');
load(loadname)

% フラグ
flag_save = 0;
flag_t = 0;
flag_freq = 0;

% サンプリング周波数
Fs = 500;

% カットオフ周波数
brth_l = 1;
brth_h = 8;

% 計測電極を指定
el_num = 64;

%バンドパスフィルタで濾波
wave_resp = BPF_but(data_sig(:,el_num),Fs, brth_l, brth_h);

% 最初の1500データをカット
wave_resp = wave_resp(1001:end);

% 呼吸をプロット
figure();
timeresp = (1:length(wave_resp))/Fs;
plot(timeresp, wave_resp);
title('呼吸');


%% データ長を2分間にカット
% クリックした点から2分間の呼吸波を抽出する
figure();
timeresp = (1:length(wave_resp))/Fs;
plot(timeresp, wave_resp);
title('呼吸');

while 1   
     prompt = '"y"+"enter"押下で指定終了, "enter"押下で継続\n';
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
   str2 = sprintf('\\leftarrow 終了時点');
   ht(1) = text(Xp,Yp,str1,'Clipping','off');
   ht(2) = text(Xp+120,Yp,str2,'Clipping','off');
end

time_st = Xp*Fs;
wave_resp = wave_resp(time_st:time_st+120*Fs);
figure();
plot(wave_resp);
title('2分間にカット');

  savefile = append('解析後呼吸波(自由遊泳条件)\sig_free_2min_', fishnum, '.mat');
    savevar = 'wave_resp';
    save(savefile, savevar);

    
% データ長
len = length(wave_resp);

%% 時間区間win[s]で分割

% 時間区間
 win = 5;
win_fr = win*Fs;

% 分割数
Mb = fix(len/win_fr);

% wave_brを分割
div_wave_resp = zeros(Mb, win_fr);

 cnt = 1;
    for i=1:Mb
          
        for j=1:win_fr
            div_wave_resp(i,j) = wave_resp(cnt);  
            if cnt >= len
                break;
            end
            cnt = cnt+1;
        end
    end

%% 各時間区間で振幅を正規分布に標準正規化

 for i=1:Mb
     div_wave_resp(i,:) = zscore(div_wave_resp(i,:));
end
 
 
% 結果を描画
if flag_t == 1
    for i=1:Mb
    graphname = [num2str((i-1)*win_fr), '～',num2str(i*win_fr),'フレームにおける振幅の標準偏差'];
    figure('Name', graphname) 
    % 呼吸波描画
     plot(div_wave_resp(i,:),'-b');
    
%      pbaspect([9 2 1]) 
%     pbaspect([8 1 1])

    hold on
    ylim([-3 3])
    
    
     xticklabels({})
     yticklabels({})
%     xlabel('フレーム数')
%     ylabel('振幅の標準偏差')
%     legend('1番目','2番目','3番目','4番目')
    end
end


%% 周波数解析
% ARモデルの係数決定にはユール・ウォーカー法，次数決定にはAICを使用

pAR = zeros(Mb,2); % 各区間のAR次数を格納　1列目：呼吸　2列目：心電図
dft= 2560;   % dft点数を設定(偶数にすること！)　

% PSD値と離散周波数を格納
resp_psd = zeros(Mb, dft/2+1);
resp_F = zeros(Mb, dft/2+1);

for i=1:Mb
    % 適切なARモデル次数の設定(呼吸)
    for mo = 10:30
        ARmodel = ar(div_wave_resp(i,:), mo, 'yw');
        AIC(mo) = aic(ARmodel); % AICの計算
    end
    [~, morder] = min(AIC);           % AICが最小となる次数を抽出
    pAR(i, 1) = morder;

    % PSD推定
    [Pr, Fr] = pburg(div_wave_resp(i,:)-mean(div_wave_resp(i,:)), pAR(i,1), dft, Fs);
   
    % 結果を格納
    resp_psd(i,:) = Pr;
    resp_F(i,:) = Fr;

     
end

resp_psd_dm = resp_psd;

%psdの正規化
    for i=1:Mb
        for j=1:length(Pr)
            resp_psd(i,j) = resp_psd_dm(i,j)/sum(resp_psd_dm(i,:));
        end
    end


% 結果を描画
if flag_freq == 1
    for i=1:Mb
    graphname = [num2str((i-1)*win_fr), '～',num2str(i*win_fr),'フレームにおけるPSD'];
    figure('Name', graphname)
        plot(resp_F(i, :), resp_psd(i, :), '-b')
        xlim([0 10])
        ylim([0 0.6])
        pbaspect([3 1 1])
%          xticklabels({})
          yticklabels({})
        
    end

end

% ピーク周波数計算
pks_fr_resp = zeros(Mb, 1);
for i = 1:Mb
    [~, I1] = max(resp_psd(i, :));
    pks_fr_resp(i, 1) = resp_F(1, I1);end 

pks_fr_resp = pks_fr_resp.';

%% ピーク周波数の時間変化を描画
figure();
plot(pks_fr_resp, '-b');
ylim([0 9]);

%% 保存
if flag_save == 1
    savefile2 = append('ピーク周波数(自由遊泳条件)\freq_2min_', fishnum, '.mat');
    savevar3 = 'pks_fr_resp';
    save(savefile2, savevar3);
 
end
