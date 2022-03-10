clear all
close all

% データロード
fish_num = 'vel_all.mat';
savename = 'vel_all';
load(fish_num);

data = [vel_all(:,1) vel_all(:,2)];
% data = vel_all;

% プロット確認用
% violinplot(data);

% 1列にする
data = reshape(data, size(data,1)*size(data,2), 1);

% データ数 cv_resp:55 cv_ecg:55 pks_resp:120 pks_ecg:115 pks_resp(自由):120
% cv_resp（自由）:115
all_num = 69;
% 個体ごとのデータ数
div_num = all_num/3;
% 個体数
fnum = 6;
% 濃度
con_num = [0 1];
% 外れ値削除するか
flag_ex = 0;

% プロット確認用
% violinplot(cv_resp_all);

% 個体のグループ
ind = repmat([1:fnum], div_num, 1);
ind_int = reshape(ind, size(ind,1)*size(ind,2), 1);
ind = int2str(ind_int);

% 濃度のグループ
 con = repmat(log(con_num+1), all_num, 1);
% con = repmat(log([0, 1, 50, 100]+1), all_num, 1);
con = reshape(con, size(con,1)*size(con,2), 1);

%% 線形混合モデルで解析してみる
tbl = table(data, ind, con, 'VariableNames', {'Freqency', 'Individual', 'Concentration'});
lme{1,1} = fitlme(tbl,'Freqency~Concentration+(1|Concentration)+(1|Individual)');
lme{2,1} = fitlme(tbl,'Freqency~Concentration+(1|Concentration)');
lme{3,1} = fitlme(tbl,'Freqency~Concentration+(1|Individual)');
lme{4,1} = fitlme(tbl, 'Freqency~Concentration');
lme{5,1} = fitlme(tbl, 'Freqency~Concentration+(Individual-1|Concentration)');
lme{6,1} = fitlme(tbl, 'Freqency~Concentration+(Individual|Concentration)');
lme{7,1} = fitlme(tbl, 'Freqency~Concentration+(Concentration-1|Individual)');
lme{8,1} = fitlme(tbl, 'Freqency~Concentration+(Concentration|Individual)');
lme{9,1} = fitlme(tbl, 'Freqency~Concentration+(Individual-1|Concentration)+(Concentration-1|Individual)');
lme{10,1} = fitlme(tbl, 'Freqency~Concentration+(Individual|Concentration)+(Concentration-1|Individual)');
lme{11,1} = fitlme(tbl, 'Freqency~Concentration+(Individual-1|Concentration)+(Concentration|Individual)');
lme{12,1} = fitlme(tbl, 'Freqency~Concentration+(Individual|Concentration)+(Concentration|Individual)');

% 比較したp値を格納
p_mat = zeros(12);

for loop1 = 1:12
    for loop2 = 1:12
%         disp([int2str(loop1), ' vs ', int2str(loop2)]);
        result = compare(lme{loop1,1}, lme{loop2,1});
        p_const = result(2,8);
        p_mat(loop1, loop2) = p_const.pValue;
    end
end

% 対角成分（同じImeの比較結果）を1に変更
for i = 1:12
   p_mat(i, i) = 1; 
end

% p値が有意な組み合わせを抽出
[row, col] = find(p_mat < 0.05);

% col（勝った方）からrow（負けている方）を消していく
for i = 1:length(row)
   col(col == row(i)) = 0; 
end


% 勝ったモデルを抽出
gd_num = col(col ~= 0);
gdmodel = unique(gd_num);
gdmodel = [gdmodel zeros(length(gdmodel), 1) zeros(length(gdmodel), 1)];
%% 結果解析


% 候補モデルの決定係数とp値を計算
for i = 1:length(gdmodel(:,1))
    [r, p] = corr(data, fitted(lme{gdmodel(i, 1), 1}), 'Rows', 'complete');
    % モデル番号の右列に追加
    gdmodel(i,2) = lme{gdmodel(i, 1), 1}.Rsquared.Adjusted;
    gdmodel(i,3) = p;
end

% 決定係数が最も高かったモデル
[M, I] = max(gdmodel(:, 2));
lme{gdmodel(I, 1), 1}
%% 保存
% savepass = ('D:\harada\研究\matlab\呼吸波心電位解析\短時間計測実験データ\lme結果\');
% savepass = ('D:\harada\研究\matlab\呼吸波心電位解析\自由遊泳データ\lme結果\');
%   savefile = append(savepass, savename, '.mat');
%     savevar1 = 'gdmodel';
%     savevar2 = 'p_mat';
%     savevar3 = 'lme';
%     save(savefile, savevar1, savevar2, savevar3);