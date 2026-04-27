%required field of pks: mz, rt, formula, compound
function save_isodata(fn_out,ISO,S_M,pks,settings)
  if isfield(S_M,'data')
   S_M=rmfield(S_M,'data'); 
  end
  for j=1:size(ISO,2)    % index for tissue         
         ct=0;
    fieldname=matlab.lang.makeValidName(num2str(S_M(j).filename)); 
    for i=1:length(pks)  % index for peak         
         pk=pks(i); 
         isodata=ISO{i,j};         
         for k=1:length(isodata) 
           ct=ct+1; 
           tb(ct).groupId=i;
           tb(ct).medMz=isodata(k).mz;
           tb(ct).medRt=pk.rt;
           tb(ct).compound=pk.compound;
           tb(ct).formula=pk.formula;
           tb(ct).parent=pk.mz;
           tb(ct).isotopeLabel=isodata(k).isotopeLabel;
           %tb(ct).cont=isodata(k).cont;
           tb_original(ct).(fieldname)=isodata(k).inten_origin; 
           tb_clean(ct).(fieldname)=isodata(k).inten; 
           tb_coef(ct).(fieldname)=isodata(k).coeff;
           tb_npts(ct).(fieldname)=isodata(k).npts;
           tb_corrected(ct).(fieldname)=isodata(k).inten_corr; 
           tb_normalized(ct).(fieldname)=isodata(k).inten_corr_norm; 
           
        end
     end
 end
 
     [path,fname,~] = fileparts(fn_out); 
     fn_out_xlsx=fullfile(path,[fname,'.xlsx']);
     %fn_out_mat=fullfile(path,[fname,'.mat']);
tic
     writetable(struct2table(tb),fn_out_xlsx,'Sheet','original','UseExcel', true)
     writetable(struct2table(tb_original),fn_out_xlsx,'Sheet','original','Range','H1','UseExcel', true);
     writetable(struct2table(tb),fn_out_xlsx,'Sheet','clean','UseExcel', true)
     writetable(struct2table(tb_clean),fn_out_xlsx,'Sheet','clean','Range','H1','UseExcel', true);

     writetable(struct2table(tb),fn_out_xlsx,'Sheet','coef','UseExcel', true)
     writetable(struct2table(tb_coef),fn_out_xlsx,'Sheet','coef','Range','H1','UseExcel', true);
     writetable(struct2table(tb),fn_out_xlsx,'Sheet','npts','UseExcel', true)                       %----insert
     writetable(struct2table(tb_npts),fn_out_xlsx,'Sheet','npts','Range','H1','UseExcel', true);    %----insert
     writetable(struct2table(tb),fn_out_xlsx,'Sheet','cor_abs','UseExcel', true)
     writetable(struct2table(tb_corrected),fn_out_xlsx,'Sheet','cor_abs','Range','H1','UseExcel', true);
     writetable(struct2table(tb),fn_out_xlsx,'Sheet','cor_pct','UseExcel', true)
     writetable(struct2table(tb_normalized),fn_out_xlsx,'Sheet','cor_pct','Range','H1','UseExcel', true);

     writetable(struct2table(S_M),fn_out_xlsx,'Sheet','_meta','UseExcel', true);
     writetable(struct2table(pks),fn_out_xlsx,'Sheet','_pks','UseExcel', true);

         para(1).name='ppm';para(1).value=settings.ppm*1e6;
         para(2).name='rt search window(min)';para(2).value=settings.rt_tol;
         para(3).name='EIC moving average';para(3).value=settings.ave;
         para(4).name='rt tolerance (min)';para(4).value=settings.rtm;
     writetable(struct2table(para),fn_out_xlsx,'Sheet','_info','UseExcel', true);
 toc

            