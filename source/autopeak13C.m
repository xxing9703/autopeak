% this version inputs predefined files, processing multiple folders all at
% once
function [ISO,T]=autopeak13C(pks,files,settings,fn_out)
if settings.mode == -1
    mode='neg';
else
    mode='pos';
end
fn=[];
for i=1:length(files)
    fn{i,1}=fullfile(files(i).folder,files(i).name);       
end
  
T=[];
for i=1:length(files)
    T(i).fid=i;
    T(i).flag='G';
    T(i).drive='\\gen-iota-cifs.princeton.edu\msdata';
    T(i).path=files(i).folder(23:end);  %remove the first 3 char Y:"
    T(i).filename=files(i).name(1:end-6);
    T(i).mode=mode;
    T(i).grp=1;
    T(i).tissue='';
    T(i).tissue_str='';
    T(i).tracer='';
    T(i).tracer_str='';
    T(i).tracer_atom='13C'; %---------------------------------------------
    T(i).ctrl='';
end

ISO=cell(length(pks),length(fn));

parfor i=1:length(fn)      
    if strcmp(mode,'neg')
    M=parse1(fn{i}); % single M structure
    else
    M=parse1_pos(fn{i});    
    end

    iso=cell(length(pks),1);
    for j=1:length(pks)
        fprintf([num2str(i),'-',num2str(j),'\n'])
       try
          [~,~,ct]=formula2mass(pks(j).formula);
          Cnum=max(ct(1),1);
          Cnum=min(Cnum,30);
       catch
          Cnum=min(round(pks(j).mz/25),30);  %Cnum estimate, upper bound is 30 
       end       
       tp=get_eic_isodata0(M,pks(j), settings, '13C', Cnum); 
       tp=rmfield(tp,'eic'); 
       iso{j}=tp;
    end 
    ISO(:,i)=iso;
end
  if ~isempty(T)
    save_isodata(fn_out, ISO, T, pks, settings);
  end

  
