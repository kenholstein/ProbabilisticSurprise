function si_prob = weaver(p_observed, p_all_outcomes)

% reciprocal of Weaver's index
si_inv = p_observed/sum(p_all_outcomes.^2);

%'probability form' of si_inv
si_prob = si_inv/(si_inv + 1);