function [env_cohere, tfs_cohere, freq_cohere, peak_tfs_harm, freq_peak, env_cohere_mean, s, phi, input_env, input_tfs] = getCoherence(bankedSig, input_fs, psth_pos, psth_neg, psth_fs, NFFT, CF);
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    input_dur = length(bankedSig)/input_fs;
    psth_pos = psth_pos(:,1:ceil(input_dur*psth_fs));
    psth_neg = psth_neg(:,1:ceil(input_dur*psth_fs));

    input_env = abs(hilbert(bankedSig'));
    input_tfs = cos(angle(hilbert(bankedSig')));
    
    input_env = resample(input_env,psth_fs,input_fs);
    input_tfs = resample(input_tfs,psth_fs,input_fs);

    s = (psth_pos+psth_neg)./2;
    s = s';
    
    d = (psth_pos-psth_neg)./2;
    d = d';
    
    %questionable
    for i = 1:length(CF)
        [B,A] = butter(6,CF(i)/(psth_fs/2),'low');
        s(:,i) = filter(B,A,s(:,i));
    end
    
    phi = sqrt(2).*rms(d).*(d./abs(hilbert(d)));
    
%     %applying slepian tapers:
%     w = dpss(length(input_env),1,1);
%     w = w./sum(w,2);
%     
%     for j = 1:size(input_env,2)
%     
%             input_env(:,j) = sum(w.*input_env(:,j),2)';
%             s(:,j) = sum(w.*s(:,j),2);
%     
%             input_tfs(:,j) = sum(w.*input_tfs(:,j),2)';
%             phi(:,j) = sum(w.*phi(:,j),2);
%     
%     end
    
    [env_cohere, freq_cohere] = mscohere(input_env,s,[],[],NFFT,psth_fs);
    [tfs_cohere, ~] = mscohere(input_tfs,phi,[],[],NFFT,psth_fs);
    
    env_cohere = env_cohere.*~(freq_cohere>CF);
    env_cohere_lf = env_cohere.*(freq_cohere<(CF(1)));
    env_cohere_nz = [];
    
    %Identifying Peaks
    band = 1;
    %too many for loops...clean up later. can optimize this    
    for k = 1:length(CF)
        r = tfs_cohere(:,k).*((freq_cohere>(CF(k)-band)).*(freq_cohere<(CF(k)+band)));
        [peak_tfs_harm(k),ind] = max(r);
        freq_peak(k) = freq_cohere(ind);
        
        env_cohere_nz = horzcat(env_cohere_nz,nonzeros(env_cohere_lf(:,k)));
        
    end
    
    env_cohere_mean = mean(env_cohere_nz);
    
end

