function BPF_v=BPF_but(data,fs, low, high)
% �o�^���[�X2*n���t�B���^
% �z��data�̒l��passband�̗̈�Ńo���h�p�X

n = 3;                     % n:BPF(BandPassFilter)�̎���
passband=[low high]/(fs/2);    %[low high] pass filter


[ButB,ButA] = butter(n,passband,'bandpass');
assignin('base', 'ButB', ButB);
assignin('base', 'ButA', ButA);
BPF_v=filtfilt(ButB,ButA,data); 