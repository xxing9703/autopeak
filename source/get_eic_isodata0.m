% use the new EIC function, added intensity cleanup
% input M, pk, atom, C_num, get the isotopologues and eics
% dependence: M2EIC; EIC2sig_v0
function isodata=get_eic_isodata0(M,pk,settings,atom,counts)
   if strcmp(atom,'C13')||strcmp(atom,'13C')
       atom='C13';
       type=1;
       mzshift=1.00335;
       ab_A=0.0107;
       im_A=0.01;
   elseif strcmp(atom,'N15')||strcmp(atom,'15N')
       atom='N15';
       type=2;
       mzshift=0.997;
       ab_A=0.00364;
       im_A=0.01;
   elseif strcmp(atom,'D2')||strcmp(atom,'2D')
       atom='D2';
       type=3;
       mzshift=1.0063;
       ab_A=0.00015;
       im_A=0.01;
   elseif strcmp(atom,'O18')||strcmp(atom,'18O')
       atom='O18';
       type=4;
       mzshift=2.00424;
       ab_A=0.042099;
       im_A=0.01;   
   end

pk_=pk; % make a copy of pk

%get full EIC for M0
eic=M2EIC(M,pk.mz,pk.mz*settings.ppm);

%get EIC slice (using rt_tol) and find the revised rt.
[~,~,rt_fix,~]=EIC2sig_v0(eic,pk.rt,settings.rt_tol,settings.ave);

% re-center rt, run it again
pk_.rt=rt_fix;  %rt fix
[sig0,rt_dev,rt_fix,eic_sub,npts]=EIC2sig_v0(eic,pk_.rt,settings.rtm,settings.ave);
isodata(1).mz=pk.mz;
isodata(1).rt=rt_fix;
isodata(1).rt_dev=rt_dev;
nn=size(eic_sub,1);
eic_center=eic_sub(max(1,floor(nn*0.4)):floor(nn*0.6),:);
isodata(1).m2m=mean(eic_center(:,2))/mean(eic_sub(:,2)+1e-9);
isodata(1).npts=npts; %--------insert number of continuous pts
isodata(1).inten=sig0;
%isodata(1).eic_full=eic;
isodata(1).eic=eic_sub;
isodata(1).isotopeLabel='C12 PARENT';

if counts>0
       for i=1:counts
           pk_.mz= pk.mz+i*mzshift; %update mz
           if sig0>5e4
             eic=M2EIC(M,pk_.mz,pk_.mz*settings.ppm);
             [sig,rt_dev,rt_fix,eic_sub,npts]=EIC2sig_v0(eic,pk_.rt,settings.rtm,settings.ave);
           else
             sig=0;
           end
           isodata(i+1).mz=pk_.mz;
           isodata(i+1).rt=rt_fix;
           isodata(i+1).rt_dev=rt_dev;
           nn=size(eic_sub,1);
           eic_center=eic_sub(max(1,floor(nn*0.4)):floor(nn*0.6),:);
           isodata(i+1).m2m=mean(eic_center(:,2))/mean(eic_sub(:,2)+1e-9);
           isodata(i+1).npts=npts; %--------insert number of continuous pts
           isodata(i+1).inten=sig; 
        %   isodata(i+1).eic_full=eic;
           isodata(i+1).eic=eic_sub;
           isodata(i+1).isotopeLabel=[atom,'-label-',num2str(i)];
       end
       % clean up based on eic pearson correlation.  %%%%%%%%turn off
       threshold=2e3; score_cutoff=-1;
       isodata=isoclean(isodata, threshold, score_cutoff);

         
        inten = [isodata.inten];
        inten_norm = inten/(sum(inten)+1e-9);
        inten_corr = isocorr_A(inten,counts,ab_A,im_A);
        inten_corr_norm = inten_corr/(sum(inten_corr)+1e-9);
      
else
       inten = isodata(1).inten;
       inten_norm = inten/(sum(inten)+1e-9);
       inten_corr = isodata(1).inten;
       inten_corr_norm = 1;
end

for i=1:counts+1
       isodata(i).inten_norm=inten_norm(i);
       isodata(i).inten_corr=inten_corr(i);
       isodata(i).inten_corr_norm=inten_corr_norm(i);
end
