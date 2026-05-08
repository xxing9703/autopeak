% This is a different version of peak detection from eic,  using peak
% finder instead of pick the highest signal
function [sig,rt_dev,rt_fix,eic_sub,npts]=EIC2sig_v1(eic,rt,rt_tol,avg)
npts=0;sig=0;rt_fix=rt;rt_dev=0;eic_sub=eic;
ind=find(abs(eic(:,1)-rt)<rt_tol); % find the index range for the subset of eic
if length(ind)>5 % eic_sub must contain at least 5 data points
 eic_sub=eic(ind,:); % a subset of eic within RT window
 eic_sub(:,3)=smooth(eic_sub(:,2),avg); %moving average
 [peak_sig,peak_loc]=findpeaks(eic_sub(:,3),sort(eic_sub(:,1)+rand(size(eic_sub,1),1)/1e7),...%avoid identical x
     'MinPeakProminence',1000,...  %threshold
     'MinPeakWidth',0.1);    %peakwidth
 if isempty(peak_sig)
    sig=0;
    rt_fix=nan;
    rt_dev=nan;
    npts=0;
 else
    try
   [~,ind2]=max(peak_sig); %find the index of "max" peak in peak_sig array
    catch
        ind2
    end
  
   rt_fix=peak_loc(ind2);  %rt location at max 
   sig=peak_sig(ind2); 
   rt_dev=(rt_fix-rt)/rt_tol;
   [~,loc]=min(abs(eic_sub(:,1)-rt_fix));

    %-----------------insert npts 3/16/2026  number of continous points
     y = eic_sub(:,3);
     n = length(y);
    % --- search left ---
    left_idx = loc;
    while left_idx > 1 && y(left_idx-1) > 0
        left_idx = left_idx - 1;
    end
    % --- search right ---
    right_idx = loc;
    while right_idx < n && y(right_idx+1) > 0
        right_idx = right_idx + 1;
    end
    % number of continuous non-zero points around peak
    npts = right_idx - left_idx + 1;
    
    %----------------------end insert

 end


end