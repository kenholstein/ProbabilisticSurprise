function cs = uniqueCombinations(n,color_set)
%NOTE: sampling without replacement/duplicates!
%from a vector cs, consisting of all ordered composite events
%(with length pre-specified within cs), and with ncolor
%primitive events:
%generates vector consisting only of unique count combinations

cs = color_set;
ncolor = length(color_set);

%code to generate possibilities from 
%samples of length = length(observed_data)
cs = nchoosek(color_set,n);

%code to generate possibilities from 
%samples of length <= length(observed_data)
%for i=1:(ncolor-1)
%    n_choose_i = nchoosek(color_set,i);
%    mat = zeros(size(n_choose_i,1),ncolor);
%    mat(1:size(n_choose_i,1),1:size(n_choose_i,2)) = n_choose_i;
%    cs = vertcat(cs,mat);
%end;

end

