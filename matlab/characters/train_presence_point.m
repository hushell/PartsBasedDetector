function [presmodel,newscores] = train_presence_point(partid, score, dist, pairs, gt)
% traing presence classifiers via One-class SVM

addpath('/home/hushell/working/softwares/libsvm-3.17/matlab');

I1 = find(pairs(:,1) == partid);
I2 = find(pairs(:,2) == partid);
I = union(I1,I2);
dist = dist(:,I);
feat = [score, dist];

presmodel = svmtrain(gt, feat, '-s 2 -t 2 -n 0.5');
[~, ~, newscores] = svmpredict(gt,feat,presmodel);

