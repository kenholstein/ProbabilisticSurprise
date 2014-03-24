function [cs,cprob,num_ways] = pOutcomes(hs,prior,data)
%given hypothesis distributions hs over individual discrete outcomes
%and a prior over these hypotheses,
%pOutcomes returns two column vectors with corresponding indices, 
%[cs,cprob]: cs contains all possible 'outcome' n-vectors; cprob contains 
%associated probabilities of these n-vectors

n = length(data);
ncolor = size(hs,2);
color_set=1:ncolor;

%generate all possible 'outcome' n-vectors (i.e. all orders)
cs = allconcepts(n, 'base', ncolor)+1;

%reduce cs to set of all n-vectors consisting only of 
%unique combinations
cs = unique(sort(cs,2,'descend'),'rows');

    
%initialize probability vector
cprob = zeros(size(cs,1),1);
for hind = 1:size(hs,1)
  probs = hs(hind,:);
  pr = prior(hind);
  for j = 1:size(cs,1)
    count = histc(cs(j,:), color_set);
    num_ways(j) = size((unique(perms(cs(j,:)),'rows')),1);
    cprob(j) = cprob(j)+num_ways(j)*pr*prod(probs.^count) ;
  end
end

end

