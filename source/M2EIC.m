% given mz with tolerance in Da, retrieve EIC. (time unit=mins)
function eic=M2EIC(M,mz,mz_tol)
peaks=M.data(:,2);
peaks_sig=M.data(:,3);
time=cell2mat(M.data(:,1));
for i=1:length(time)   
   ind=find(abs(peaks{i}-mz)<mz_tol);
   if ~isempty(ind)
      sig(i,1)=sum(peaks_sig{i}(ind)); 
   else
      sig(i,1)=0;
   end
end
eic=[time,sig];