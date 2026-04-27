function files=filefiter(files,inclusion,exclusion)

if ~isnan(inclusion)
  strs=strsplit(inclusion,';');
  for i=1:length(strs)  
    files=files(contains({files.name},strs{i},'IgnoreCase', true));
  end
end


if ~isnan(exclusion)
  strs=strsplit(exclusion,';');
  for i=1:length(strs)  
    files=files(~contains({files.name},strs{i},'IgnoreCase', true));
  end
end
