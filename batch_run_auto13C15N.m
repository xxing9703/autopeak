%  batch process all 13C tracing data
function batch_run_auto13C15N(job,settings)
% create a output folder for the job, using the job name
addpath('source');
if nargin<1
    [fname,path]=uigetfile('*.xlsx; .csv');
    if fname==0
        return;
    end
    job=fullfile(path,fname);
    fout=path;
    O=load('source\settings13C15.mat'); %default settings
    settings=O.settings;
else
fout='jobs13C15N';
end
[~,fd,~]=fileparts(job);  %
job_outdir = fullfile(fout, fd);
if ~exist(job_outdir, 'dir')
   mkdir(job_outdir);
end
sheetNames = sheetnames(job);

for n=1:length(sheetNames) %--------------loop over each sheet
  nm=sheetNames{n};
  subfd = fullfile(job_outdir, nm);
  if ~exist(subfd, 'dir')
        mkdir(subfd);
  end
% load one sheet of the job 
  T=table2struct(readtable(job,'Sheet',sheetNames{n}));  

  for i=1:length(T) %----------- loop over each row in the sheet
     fprintf([nm,' -- ',num2str(i),'--',num2str(length(T)),'  \n']); 
     pks=table2struct(readtable(['pklist\', T(i).pklist,'.xlsx']));
     fn_out=fullfile(subfd,[T(i).output_fname,'.xlsx']);
      % -------- Resume logic: skip completed --------
        if exist(fn_out, 'file')
            fprintf('Skipping existing: %s\n', fn_out);
            continue;
        end    
     try
      files=dir(T(i).folder); 
      files=filefiter(files,T(i).inclusion,T(i).exclusion);
      autopeak13C15N(pks,files,settings,fn_out);
     catch ME
         %writematrix([1,1;0,0],fn_out);  %-----error message
         disp(ME.message)
         fprintf('FAILED: %s\n', fn_out)         
      end
   end
end


