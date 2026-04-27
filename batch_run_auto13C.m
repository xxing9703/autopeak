%  batch process all 13C tracing data
function batch_run_auto13C(job,settings)
% create a output folder for the job, using the job name
addpath('source');
if nargin<1
    [fname,path]=uigetfile('*.xlsx');
    if fname==0
        return;
    end
    job=fullfile(path,fname);
    fout=path;
    O=load('source\settings.mat');
    settings=O.settings;
else
fout='jobs13C\';
end
[~,fd,~]=fileparts(job);  %
mkdir([fout,fd]);
sheetNames = sheetnames(job);

for n=1:length(sheetNames) %--------------loop over each sheet
  nm=sheetNames{n};
  subfd=[fout,fd,'\',nm];
  mkdir(subfd);
  % load one sheet of the job 
  T=table2struct(readtable(job,'Sheet',sheetNames{n}));  

  for i=1:length(T) %----------- loop over each row in the sheet
     fprintf([nm,' -- ',num2str(i),'--',num2str(length(T)),'  \n']); 
     pks=table2struct(readtable(['pklist\', T(i).pklist,'.xlsx']));
     fn_out=[fullfile(subfd,T(i).output_fname),'.xlsx'];
    
     try
      files=dir(T(i).fileLocation); 
      files=filefiter(files,T(i).inclusion,T(i).exclusion);
      autopeak13C_V2(pks,files,settings,fn_out);
     catch ME
         writematrix([1,1;0,0],fn_out);  %-----error message
         disp(ME.message)
      end
   end
end


