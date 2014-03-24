function p_val = p_value(p_observed, p_all_outcomes)

%computes p_value of observed outcome as 
%p_value(outcome(j)) = 
%sum_over_i( p(outcome(i)) | p(outcome(i))<=p(outcome(j)) )
p_val = p_all_outcomes'*(p_all_outcomes <= p_observed);

