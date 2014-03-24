function p = priorpredictive(hs, prior, data, num_ways)

ncolor = size(hs,2);
nhyp = size(hs,1);

%take counts of each possibility (color) in data
counts = histc(data', 1:ncolor);

p = 0;
for hind = 1:nhyp
  pr = prior(hind);
  p = p + pr*num_ways*prod(hs(hind,:).^counts) ;
end




