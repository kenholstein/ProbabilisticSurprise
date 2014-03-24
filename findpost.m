function pos = findpost(hs, prior, data,num_ways)

ncolor = size(hs,2);
counts = histc(data', 1:ncolor); 

pDph = zeros(1, size(hs,1));
for hind = 1:size(hs,1)
  pDph(hind) =  num_ways*prod(hs(hind,:).^counts)* prior(hind) ;
end

pos = pDph;
pos = pos/sum(pos);