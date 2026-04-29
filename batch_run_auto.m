%  batch process all 13C tracing data 
function batch_run_auto(job,settings)
% create a output folder for the job, using the job name
addpath('source');
if nargin<1
    [fname,path]=uigetfile('*.xlsx; .csv');
    if fname==0
        return;
    end
    job=fullfile(path,fname);
    fout=path;
    O=load('source\settings.mat'); %default settings
    settings=O.settings;
else
fout='jobs';
end
[~,fd,~]=fileparts(job);  %
job_outdir = fullfile(fout, fd);
if ~exist(job_outdir, 'dir')
    mkdir(job_outdir);
end
sheetNames = sheetnames(job);

for n=1:length(sheetNames) %--------------loop over each sheet
  % create output subfolders for each sheet 
  nm=sheetNames{n};
  subfd = fullfile(job_outdir, nm);
  if ~exist(subfd, 'dir')
        mkdir(subfd);
  end
  % load one sheet of the job 
  T=table2struct(readtable(job,'Sheet',sheetNames{n}));  

  parfor i=1:length(T) %----------- loop over each row in the sheet
     fprintf([nm,' -- ',num2str(i),'--',num2str(length(T)),'  \n']); 
     pks=table2struct(readtable(['pklist\', T(i).pklist,'.xlsx']));
     fn_out=fullfile(subfd,[T(i).output_fname,'.xlsx']);
      % -------- Resume logic: skip completed --------
        if exist(fn_out, 'file')
            fprintf('Skipping existing: %s\n', fn_out);
            continue;
        end 
     try
        [header,intens, rt_fix] = autopeak1(pks, T(i).folder, T(i).inclusion,T(i).exclusion, settings);
     
        T0=struct2table(pks);
        T1=array2table(intens,'VariableNames',header);
        T2=array2table(rt_fix,'VariableNames',header);
            
        writetable([T0,T1],fn_out,'Sheet','intens');
        writetable([T0,T2],fn_out,'Sheet','rt');
         para=[];
         para(1).name='ppm';para(1).value=settings.ppm*1e6;
         para(2).name='rt tolerance (min)';para(4).value=settings.rtm;
         para(3).name='EIC moving average';para(3).value=settings.ave;
         
        writetable(struct2table(para),fn_out,'Sheet','_info','UseExcel', true);

     catch ME
         %writematrix([1,1;0,0],fn_out);  %-----error message
         disp(ME.message)
         fprintf('FAILED: %s\n', fn_out)  
      end
   end
 end







