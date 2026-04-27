function M=parse1(f1)
[pathname,filename,ext] = fileparts(f1);
f{1}=[filename,ext];
M = mzxml2struct(pathname,f);