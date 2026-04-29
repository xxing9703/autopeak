% double tracer, called by get_iso_data
function [isodata,pk]=get_eic_isodata2(M,pk,settings,atom,counts)  
   if strcmp(atom,'C13N15')
       mzshift1=1.00335;
       ab_A1=0.0107;
       im_A1=0.01;       
       mzshift2=0.997;
       ab_A2=0.00364;
       im_A2=0.01;
       lb{1}='C13';
       lb{2}='N15';
   elseif strcmp(atom,'C13D2')       
       mzshift1=1.00335;
       ab_A1=0.0107;
       im_A1=0.01;       
       mzshift2=1.0063;
       ab_A2=0.00;
       im_A2=0.01;
       lb{1}='C13';
       lb{2}='D2';
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

   ct=0;
   if counts(1)>0 || counts(2)>0
       for i=1:counts(1)+1
          for j=1:counts(2)+1
           pk_.mz= pk.mz+(i-1)*mzshift1+(j-1)*mzshift2; %update mz
           ct=ct+1;
            if sig0>2e4
               eic=M2EIC(M,pk_.mz,pk_.mz*settings.ppm);
               [sig,rt_dev,rt_fix,eic_sub,npts]=EIC2sig_v0(eic,pk_.rt,settings.rtm,settings.ave);
            else
                sig=0;
            end       
               isodata(ct).mz=pk_.mz;
               isodata(ct).rt=rt_fix;
               isodata(i+1).rt_dev=rt_dev;
               nn=size(eic_sub,1);
               eic_center=eic_sub(max(1,floor(nn*0.4)):floor(nn*0.6),:);
               isodata(ct).m2m=mean(eic_center(:,2))/mean(eic_sub(:,2)+1e-9);
               isodata(ct).npts=npts;
               isodata(ct).inten=sig;
               %   isodata(i+1).eic_full=eic;
               isodata(ct).eic=eic_sub;                

               if counts(1)==0
                   isodata(ct).isotopeLabel=[lb{2},'-label-',num2str(j-1)];
               elseif counts(2)==0
                   isodata(ct).isotopeLabel=[lb{1},'-label-',num2str(i-1)];
               else
                   isodata(ct).isotopeLabel=[atom,'-label-',num2str(i-1),'-',num2str(j-1)];
               end
               if i==1 && j==1
                   isodata(ct).isotopeLabel='C12 PARENT';
               end                             
           end
       end  

       threshold=2e3; score_cutoff=-1;
       isodata=isoclean(isodata, threshold, score_cutoff);

         
       inten = [isodata.inten];
       inten_norm = inten/(sum(inten)+1e-9);
       inten_corr=isocorr_AB(inten',counts(1),counts(2),ab_A1,ab_A2,im_A1,im_A2);
       inten_corr_norm=inten_corr/sum(inten_corr);
   else      
       inten = isodata(1).inten;
       inten_norm = inten/(sum(inten)+1e-9);
       inten_corr = isodata(1).inten;
       inten_corr_norm = 1;
   end

   for i=1:ct
       isodata(i).inten_norm=inten_norm(i);
       isodata(i).inten_corr=inten_corr(i);
       isodata(i).inten_corr_norm=inten_corr_norm(i);
   end
  
