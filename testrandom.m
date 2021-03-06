clear all;

cases = {'prior_wsurp_rank + prior_pval_rank - priorsurp_rank', 'prior_wsurp_rank - prior_pval_rank - priorsurp_rank', '-prior_wsurp_rank + prior_pval_rank - priorsurp_rank'};
case_names = {'HHL','HLL','LHL'};

%simulation parameters
nsample = 1000; % # 'cases' to generate & plot
ncolor = 3; % # discrete possibilities (colors|'urn' case)
nhyp = 2;   % # hypotheses
maxsample = 3;
%report settings
include_n_best = 10; %how many cases to include in reports
case_filter = 3; %set which case to look for and include in reports (indices correspond to case_names above)
%visualization/report options
plotvis = 'ON'; %print plots?
visFigure = 'off'; %display figure during run?
printReports = 'ON'; %print text reports?


% %create special-case collection files
str_nhyp=num2str(nhyp);
out_fnames = {strcat(str_nhyp,'HHL.txt'),strcat(str_nhyp,'HLL.txt'),strcat(str_nhyp,'LHL.txt')};
%
% if nhyp>1
%     out_fnames = {strcat(str_nhyp,'priorweaver_priorsurp.txt'), strcat(str_nhyp,'postweaver_postsurp.txt'), strcat(str_nhyp,'priorweaver_priorpval.txt'), strcat(str_nhyp,'postweaver_postpval.txt'), strcat(str_nhyp,'priorsurp_priorpval.txt'), strcat(str_nhyp,'postsurp_postpval.txt'), strcat(str_nhyp,'priorpval_postpval.txt'), strcat(str_nhyp,'priorsurp_postsurp.txt'), strcat(str_nhyp,'priorweaver_postweaver.txt') };
% else
%     out_fnames = {strcat(str_nhyp,'weaver_surp.txt'), strcat(str_nhyp,'weaver_pval.txt'), strcat(str_nhyp,'surp_pval.txt')};
% end;
for i=1:length(out_fnames)
    fid = fopen(out_fnames{i},'w');
    fclose(fid);
end;

rand('state', 0);

for i = 1:nsample
  for j = 1:nhyp
    hs(j,:) = dirichlet_sample(ones(1,ncolor));
  end
  %generate data
  nsamp = sample_discrete(ones(1, maxsample)/maxsample); % 
  data = multinomial(ones(1, ncolor)/ncolor, nsamp); %
  data = sort(data,1,'descend');  %sort data
  
  prior = dirichlet_sample(ones(1, nhyp)); %sample a prior over hypotheses
  [outcomes,prior_p_outcomes,num_ways] = pOutcomes(hs,prior,data);
  num_ways_observed = num_ways(findrow(outcomes, data'));
  posterior = findpost(hs, prior, data, num_ways_observed); %compute posterior over hypotheses
  
  [outcomes,post_p_outcomes] = pOutcomes(hs,posterior,data);
  prior_p_observed = prior_p_outcomes(findrow(outcomes, data'));
  post_p_observed = post_p_outcomes(findrow(outcomes, data'));
  
  %add to cell arrays
  data_array{i} = data';
  hypothesis_array{i} = hs;
  prior_array{i} = prior;
  posterior_array{i} = posterior;
  prior_p_observed_array{i} = prior_p_observed; 
  prior_p_outcomes_array{i} = prior_p_outcomes; 
  post_p_observed_array{i} = post_p_observed;
  post_p_outcomes_array{i} = post_p_outcomes;
  

  %Surprise Measures
 
  priorsurp(i) = priorpredictive(hs, prior, data, num_ways_observed);
  postsurp(i) = priorpredictive(hs,posterior,data,num_ways_observed);

  prior_wsurp(i) = weaver(prior_p_observed, prior_p_outcomes);
  post_wsurp(i) = weaver(post_p_observed, post_p_outcomes);
  prior_pval(i) = p_value(prior_p_observed, prior_p_outcomes);
  post_pval(i) = p_value(post_p_observed, post_p_outcomes);
  
  %klsurp(i) = kldist(hs, prior, data);
  
end


%rank and sort cases
priorsurp_rank = tiedrank(priorsurp);
postsurp_rank= tiedrank(postsurp);
prior_wsurp_rank = tiedrank(prior_wsurp);
post_wsurp_rank = tiedrank(post_wsurp);
prior_pval_rank = tiedrank(prior_pval);
post_pval_rank = tiedrank(post_pval);
%vector of filter scores for each case
filter_scores = eval(cases{case_filter});
%sort all cases according to the scores assigned by the given case_filter
[filter_scores,ind]=sort(filter_scores,'descend');
priorsurp = priorsurp(ind);
postsurp = postsurp(ind);
prior_wsurp = prior_wsurp(ind);
post_wsurp = post_wsurp(ind);
prior_pval = prior_pval(ind);
post_pval = post_pval(ind);
data_array = data_array(ind);
hypothesis_array = hypothesis_array(ind);
prior_array = prior_array(ind);
posterior_array = posterior_array(ind);
prior_p_observed_array = prior_p_observed_array(ind); 
prior_p_outcomes_array = prior_p_outcomes_array(ind); 
post_p_observed_array = post_p_observed_array(ind);
post_p_outcomes_array = post_p_outcomes_array(ind);
  


%printing
if strcmp(printReports, 'ON')
  print_special;
end;


%visualizations => print to pdfs

if strcmp(plotvis, 'ON')
    
    set(gcf, 'renderer', 'painters');
    figure('visible',visFigure);
    
    if nhyp>1

        %output
        subplot(1,2,1)
        scatter(priorsurp, prior_wsurp);
        title('prior_wsurp vs priorsurp ');
        axis square
        %subplot(2,2,2)
        %scatter(postsurp, prior_wsurp);
        %title('prior_wsurp vs postsurp');
        %axis square
        %subplot(2,2,3)
        %scatter(priorsurp, post_wsurp);
        %title('post_wsurp vs priorsurp');
        %axis square
        subplot(1,2,2)
        scatter(postsurp, post_wsurp);
        title('post_wsurp vs postsurp');
        axis square
        %
        filename = strcat('weaver_predsurp_nhyp',int2str(nhyp),'.pdf');
        print ('-dpdf', '-r100', filename);

        %output
        subplot(1,2,1)
        scatter(prior_pval, prior_wsurp);
        title('prior_wsurp vs prior_pvalue ');
        axis square
%         subplot(2,2,2)
%         scatter(post_pval, prior_wsurp);
%         title('prior_wsurp vs post_pvalue ');
%         axis square
%         subplot(2,2,3)
%         scatter(prior_pval, post_wsurp);
%         title('post_wsurp vs prior_pvalue');
%         axis square
        subplot(1,2,2)
        scatter(post_pval, post_wsurp);
        title('post_wsurp vs post_pvalue');
        axis square
        %
        filename = strcat('weaver_pvalue_nhyp',int2str(nhyp),'.pdf');
        print ('-dpdf', '-r100', filename);

        %output
        subplot(1,2,1)
        scatter(priorsurp, prior_pval);
        title('prior_pvalue vs priorsurp ');
        axis square
%         subplot(2,2,2)
%         scatter(postsurp, prior_pval);
%         title('prior_pvalue vs postsurp ');
%         axis square
%         subplot(2,2,3)
%         scatter(priorsurp, post_pval);
%         title('post_pvalue vs priorsurp ');
%         axis square
        subplot(1,2,2)
        scatter(postsurp, post_pval);
        title('post_pvalue vs postsurp ');
        axis square
        %
        filename = strcat('pval_predsurp_nhyp',int2str(nhyp),'.pdf');
        print ('-dpdf', '-r100', filename);

        %output
        subplot(1,3,1)
        scatter(prior_pval, post_pval);
        title('post_pvalue vs prior_pvalue');
        axis square
        subplot(1,3,2)
        scatter(priorsurp, postsurp);
        title('postsurp vs priorsurp');
        axis square
        subplot(1,3,3)
        scatter(post_wsurp, prior_wsurp);
        title('prior_wsurp vs post_wsurp');
        axis square
        %
        filename = strcat('prior_post_nhyp',int2str(nhyp),'.pdf');
        print ('-dpdf', '-r100', filename);
    else
        %output
        subplot(1,3,1)
        scatter(prior_pval, prior_wsurp);
        title('wsurp vs pvalue');
        axis square
        subplot(1,3,2)
        scatter(priorsurp,prior_wsurp);
        title('wsurp vs surp');
        axis square
        subplot(1,3,3)
        scatter(priorsurp,prior_pval);
        title('pvalue vs surp');
        axis square
        %
        filename = strcat('nhyp',int2str(nhyp),'.pdf');
        print ('-dpdf', '-r100', filename);
    end;
end;

%subplot(*,*,*)
%scatter(postsurp, -klsurp);
%title('klsurp vs postsurp');
%axis square
