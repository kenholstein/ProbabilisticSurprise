%prints details about interesting cases

for q = 1:include_n_best
    %open file
    fid = fopen(out_fnames{case_filter},'a');
    
    %content
    fprintf(fid, '%s %s \n\n' ,'Image #: ', num2str(q) );
    fprintf(fid, '%s %s \n\n' ,'Filter Score: ', num2str(filter_scores(q)) );
    
    if nhyp >= 2
        fprintf(fid, '%s %s\n', 'prior', num2str(prior_array{q}));
    end;
    hyps = hypothesis_array{q};
    for g = 1:nhyp
        fprintf(fid, '%s%s %s\n' , 'hyp', num2str(g), num2str(hyps(g,:)));
    end;
    fprintf(fid, '%s %s \n' ,'data', num2str(histc(data_array{q},1:ncolor)) );
    if nhyp >= 2
        fprintf(fid, '%s %s\n\n' ,'posterior', num2str(posterior_array{q}));
    end;
    
    fprintf(fid, '%s %s\n' ,'prior_weaver:', num2str(prior_wsurp(q)));
    fprintf(fid, '%s %s\n' ,'prior_pval:', num2str(prior_pval(q)));
    fprintf(fid, '%s %s\n' ,'prior_pred:', num2str(priorsurp(q)));
    if nhyp >=2
        fprintf(fid, '%s %s\n' ,'posterior_weaver:', num2str(post_wsurp(q)));
        fprintf(fid, '%s %s\n' ,'posterior_pvalue:', num2str(post_pval(q)));
        fprintf(fid, '%s %s' ,'posterior_pred:', num2str(postsurp(q)));
    end;
    fprintf(fid, '\n\n\n');
    fclose(fid);
    
    %print distribution as image
    figure('visible','off');
    if nhyp > 1
        a = sort(prior_p_outcomes_array{q},1,'descend');
        hb = bar(a);
        v = plus_minus_boolean(a, prior_p_observed_array{q});
        set(get(hb,'children'),'cdata', v );
        colormap([0 0 1; 1 0 0]);
        filename = strcat(int2str(q),'prior_dist','.png');
        print ('-dpng', '-r100', filename);
        
        a = sort(post_p_outcomes_array{q},1,'descend');
        hb = bar(a);
        v = plus_minus_boolean(a, post_p_observed_array{q});
        set(get(hb,'children'),'cdata', v );
        colormap([0 0 1; 1 0 0]);
        filename = strcat(int2str(q),'post_dist','.png');
        print ('-dpng', '-r100', filename);
    else
        a = sort(prior_p_outcomes_array{q},1,'descend');
        hb = bar(a);
        v = plus_minus_boolean(a, prior_p_observed_array{q});
        set(get(hb,'children'),'cdata', v );
        colormap([0 0 1; 1 0 0]);
        filename = strcat(int2str(q),'dist','.png');
        print ('-dpng', '-r100', filename);
    end;
    
end;