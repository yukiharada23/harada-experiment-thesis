%% breathROI_calc.m�Ōv�Z�������ϋP�x�l��Ǎ��݁C���g����͂���
% ���́Fint_list �o�́Fpks_fr_resp(�ċz�s�[�N���g��)

% ----------------------------------------------------------------
close all
clear all


%% 2�����̕��ϋP�x�l�f�[�^int_list(line:����, row:�t���[����)�ƌċz�g��ǂݍ��݁C�o���h�p�X�t�B���^���h�g

% ���ϋP�x�l�����
load('���ϋP�x�l�f�[�^\luminance_ROI_caf0za.mat')
Fs_brth = 100;
brth_l = 0.5;
brth_h = 5;

%--------�g�`�`��ɂ���-------------%
% ���n��f�[�^��`��
flag_t = 0;
 % ���g���f�[�^��`��
 flag_f = 1;

%int_list�̉�͂���s���w��i�҂����Ȃ̂�1�łn�j�j
part = 1;

%�I�����W�F�{�C�F�S���C�΁F�ċz�g
    orange = [1 102/255 0];
    blue = [0 102/255, 204/255];
    color = orange;
    green = [51/255, 153/255, 102/255];

%�o���h�p�X�t�B���^���h�g
lum_brth = BPF_but(int_list(part,1:fr_num-1),Fs_brth, brth_l, brth_h);

% �f�[�^����120�b�ԂɃJ�b�g
lum_brth(12001:end) = [];



%% ���ԋ��win[s]��lum_brth�𕪊�

% ������Ԓ��w��i�_���ł�5s�j
 win = 5; % [s]
win_fr = win*Fs_brth;

% ������
M = fix(fr_num/win_fr);

% lum_bpf�𕪊�
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
    

%% �e������ԂŐU���𐳋K���z�ɕW�����K��

 for i=1:M
    div_lum_brth(i,:) = zscore(div_lum_brth(i,:));
 end


if flag_t == 1
for i=1:M
    graphname = [num2str((i-1)*win_fr), '�`',num2str(i*win_fr),'�t���[���ɂ�����U���̕W���΍�'];
    figure('Name', graphname)  
    %�{or�S���`��
     plot(div_lum_brth(i,:), 'Color', color)
     xticklabels({})
     yticklabels({})
end

end

%% -------------------------------------------���g�����------------------------------------------------------------------
%% �e������Ԃ�PSD���CAR���f����p���Đ���
% AR���f���̌W������ɂ̓o�[�O�@�C��������ɂ�AIC���g�p

pAR = zeros(M,2); % �e��Ԃ�AR�������i�[�@1��ځF�ċz�@
dft= 512;   % dft�_����ݒ�(�����ɂ��邱�ƁI)�@

% PSD�l�Ɨ��U���g�����i�[
lum_psd = zeros(M, dft/2+1);
lum_F = zeros(M, dft/2+1);

for i=1:M
    % �K�؂�AR���f�������̐ݒ�
    for mo = 10:50
        ARmodel = ar(div_lum_brth(i,:), mo, 'yw');
        AIC(mo) = aic(ARmodel); % AIC�̌v�Z
    end
    [~, morder] = min(AIC);           % AIC���ŏ��ƂȂ鎟���𒊏o
    pAR(i, 1) = morder;
  
    
    % PSD����
    [Pb, Fb] = pburg(div_lum_brth(i,:)-mean(div_lum_brth(i,:)), 30, dft, Fs_brth);
 
    % ���ʂ��i�[
    lum_psd(i,:) = Pb;
    lum_F(i,:) = Fb;
     
end

lum_psd_dm = lum_psd;


%psd�̐��K��
    for i=1:M
        for j=1:length(Pb)
            lum_psd(i,j) = lum_psd_dm(i,j)/sum(lum_psd_dm(i,:));
        end
    end

 
% ���ʂ�`��
if flag_f == 1
for i=1:M
    graphname = [num2str((i-1)*win_fr), '�`',num2str(i*win_fr),'�t���[���ɂ�����PSD'];
    figure('Name', graphname)
        plot(lum_F(i, :), lum_psd(i, :), 'Color',color)

     
end

end

% �s�[�N���g���v�Z
pks_fr_resp = zeros(Mb, 1);

for i = 1:Mb
    [~, I1] = max(resp_psd(i, :));
    pks_fr_resp(i, 1) = resp_F(1, I1);
end 

pks_fr_resp = pks_fr_resp.';

%% �s�[�N���g���̎��ԕω���`��
figure();
plot(pks_fr_resp, '-b');
ylim([0 9]);
% pks_fr_resp(19*Fs:40*Fs) = NaN;
% pks_fr_resp(51*Fs:71*Fs) = NaN;

%% �ۑ�
if flag_save == 1
     savefile = append('�s�[�N���g��(�S������)\freq_', fishnum, '.mat');
    savevar1 = 'pks_fr_resp';
    save(savefile, savevar1);
 
end
