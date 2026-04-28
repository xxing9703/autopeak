%cleanup isodata based on pearson correlation
function isodt=isoclean(isodt, threshold, score_cutoff)
for i=1:length(isodt)  
    tp=corrcoef(isodt(i).eic,isodt(1).eic);
    isodt(i).coeff=tp(1,2); 
    if isodt(i).coeff<=score_cutoff || isodt(i).inten<threshold
       isodt(i).inten_origin = isodt(i).inten;
       isodt(i).inten=0;
    else
       isodt(i).inten_origin = isodt(i).inten;      
    end
    isodt(i).mim0=isodt(i).inten/isodt(1).inten;
end