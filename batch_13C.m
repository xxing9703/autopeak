%  batch process all 13C tracing data --neg data

addpath('..\traceformerV2\');
addpath('C:\Users\xxing\Documents\MATLAB\myroutines');
T=table2struct(readtable("tracing_dir_index.xlsx"));
ct=[];

for i=1:length(T)
  files=dir(T(i).fileLocation); 
  tp=filefiter(files,T(i).inclusion,T(i).exclusion);
  ct(i,1)=length(tp);
end
%%
load settings
load pks_diet8279
settings.ppm=3e-6;
settings.rtm=0.3; %---------------------------
settings.ave=3;
settings.rt_tol=1; 


for i=1:length(T)
    files=dir(T(i).fileLocation); 
    files=filefiter(files,T(i).inclusion,T(i).exclusion);
    fn_out=['diet8279_0.3\',T(i).fid,'_',T(i).outputfile,'_neg_13C_diet8279','_0.3','.xlsx']; %----------
    autopeak13C_V2(pks,files,settings,fn_out);
end
