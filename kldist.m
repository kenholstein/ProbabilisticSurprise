function s = kldist(hs, prior, data)

post = findpost(hs, prior, data);

s = sum(prior.*log(prior./post));




