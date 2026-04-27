% peak detection from eic,  using max top 
function [sig,rt_dev,rt_fix,eic_sub,npts]=EIC2sig_v0(eic,rt,rt_tol,avg)
ind=find(abs(eic(:,1)-rt)<rt_tol);npts=0;
if ~isempty(ind) % rt not in range
 eic_sub=eic(ind,:); % a subset of eic within RT window
 eic_sub(:,3)=smooth(eic_sub(:,2),avg); %moving average
 [~,loc]=max(eic_sub(:,3));

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

 rt_fix=eic_sub(loc,1);
 sig=eic_sub(loc,3);   %max intensity
 rt_dev=(rt_fix-rt)/rt_tol;
else
 sig=0;
 rt_dev=0;
 rt_fix=0;
 eic_sub=eic;
 npts=0;
end








 

