function ker = expker(tau)
   ker = exp(-(0:tau:3))./sum(exp(-(0:tau:3)));
end