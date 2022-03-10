%% 読み込んだ動画の関心領域を指定し，平均輝度値を計算する．
% 入力：鰓運動の動画　出力：int_list(平均輝度値)
% ----------------------------------------------------------------

%% 第一フレームの読み取り
close all;clear;clc

% 解析動画を指定
Videoname = '計測動画\caf100a.avi';
% ROI画像を保存
ROIpngname = 'ROI画像\ROI_caf0za.png';
% 平均輝度値を出力
luminance_ROIname = '平均輝度値データ\luminance_ROI_caf0za.mat';

stTime = 0; % 動画の読み取りを開始する時間[s]

Video = VideoReader(Videoname);
% 実行時動画を再生するか
videoplay = 0;
img = readFrame(Video); % 動画1フレーム目の画像を格納
figure;imshow(img)

% 動画の再生
if videoplay == 1
    implay(Videoname)
end
%% 関心領域を指定（左クリックで対象の多角形を作成＝＞右クリック＝＞マスクの作成）

ROI = roipoly;  %関心領域をマウスで指定
index_ROI = zeros(10000, 10000);
index_ROI(1:length(find(ROI>=1)),1) =find(ROI>=1); %指定した関心領域を取り出す(座標情報)
page = 1;

% ①動画の1フレーム目画像を出力
% ②"enter"押下でROIの指定開始
% ③指定後，"y"+"enter"押下で終了
% (一応複数個指定できるようになっている)
while 1
    prompt = '"y"+"enter"押下でROIの指定終了, "enter"押下で継続\n';
    str = input(prompt,'s');
    if str =='y'
       break 
    end
    page = page + 1;
    ROI(:, :, page)=roipoly;
    index_ROI(1:length(find(ROI(:,:,page)>=1)), page) = find(ROI(:,:,page)>=1);
end

%% ROIを枠線にする処理

flag = 0;
sz = size(ROI(:,:,1));

% ROIの塗りつぶしを無しにする処理
for i = 1:page
    for ln = 1:sz(1,1)
        for rw = 1:sz(1,2)
            if flag == 1 && ROI(ln, rw+1,i) ~= 0
                ROI(ln, rw, i) = 0;
    
            elseif flag == 1 && ROI(ln, rw+1,i) == 0
                flag = 0;
                
            elseif ROI(ln, rw, i) >= 1
                flag = 1;
            end
        end
    end
end

% ROIの値を反転
for i = 1:page
    for ln = 1:sz(1,1)
        for rw = 1:sz(1,2)
            if(ROI(ln,rw,i) > 0)
                ROI(ln,rw,i) = 0;
            else
                ROI(ln,rw,i) = 1;
            end
        end
    end
end

% 全ROI(ROI_all)を重ね描く
ROI_all = ROI(:,:,1);

for i = 1:page-1
    for In = 1:sz(1,1)
        for rw = 1:sz(1,2)
            if ROI(In,rw,i+1) == 0
                ROI_all(In,rw) = 0;
            end
        end
    end
end


imshow(imfuse(ROI_all, img))
imwrite(ROI_all,ROIpngname)
%% 各フレームを読み取り=>そのフレームの輝度を計算

fr_num=1;
Video.CurrentTime=stTime; % 1フレーム目から読み取り
fr_cnt = round(Video.Duration)*round(Video.FrameRate);
int_list=zeros(2,fr_cnt);    % 計算した平均輝度値を格納
int_in_ROI = zeros(10000,10000);    % あるフレームにおけるROI内の輝度値を格納


while hasFrame(Video)
   img = readFrame(Video);
   int=mean(img,3);     % RGB平均
   
   for i=1:page
       %i番目のROIの座標情報を格納
       index_ROI_i=index_ROI(:,i);
       
        % index_ROI(:,i)のゼロ成分を削除
       for j = 1:length(index_ROI_i)
           if index_ROI_i(j)==0
               break
           end
       end
       
       index_ROI_i(j:end,:)=[];
       
       int_in_ROI(1:length(int(index_ROI_i)), i)=int(index_ROI_i);
       
       % フレームfr_numにおける輝度値の平均を計算
       int_list(i, fr_num)=mean(int_in_ROI(:,i)); 
   end
   
   fr_num=fr_num+1;
   if fr_num > fr_cnt
      break 
   end
   
end


%% matファイルに出力
 save(luminance_ROIname)
 