% input pks
% input folder
% extract signals for each file in the folder for each peak
% export as excel file
function [header,intens,rt_fix] = autopeak1(pks, folder, inclusion,exclusion,settings)

files=dir(folder);
files=filefiter(files,inclusion,exclusion);
for i=1:length(files)
    fn{i}=fullfile(folder,files(i).name);
    header{i}=files(i).name(1:end-6);    
end
for i=1:length(fn)    
    M=parse1(fn{i});
    for j=1:length(pks)     
      eic=M2EIC(M,pks(j).mz,pks(j).mz*settings.ppm);
      [intens(j,i),~,rt_fix(j,i),~]=EIC2sig_v0(eic,pks(j).rt,settings.rtm,settings.ave);
    end       
end
