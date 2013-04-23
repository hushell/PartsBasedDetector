function presmodel = train_presence(partid, score, dist, pairs, bbox, gtbbox, overlap)
% traing presence classifiers via One-class SVM

addpath('/scratch/working/softwares/libsvm-3.17/matlab/');

I1 = find(pairs(:,1) == partid);
I2 = find(pairs(:,2) == partid);
I = I1 | I2;
dist = dist(:,I);
feat = [score, dist];

if size(gtbbox,2) == 1
    x1 = bbox(:,1:4:end);
    y1 = bbox(:,2:4:end);
    x2 = bbox(:,3:4:end);
    y2 = bbox(:,4:4:end);
    pointx = (x2+x1)/2;
    pointy = (y2+y1)/2;
    gdist = sqrt((pointx - gtbbox(:,1)).^2 + (pointy - gtbbox(:,2)).^2);
    
    label = gdist <= overlap;
elseif size(gtbbox,2) == 4
    
end

presmodel = svmtrain(label, feat, '-s 2 -t 2 -n 0.5');

