function err = class_err(X,w,y_ref)
y_hyp = sign(X*w);
err = 1-sum(y_ref == y_hyp)/size(y_ref,1);
end
