% --------------------
% specify model parameters
% number of mixtures for 6 parts
K = [1 1 1 1 1 1 1 1 1 1 1 1 1];

% Tree structure for 6 parts: pa(i) is the parent of part i
% This structure is implicity assumed during data preparation
% (PARSE_data.m) and evaluation (PARSE_eval_pcp)
pa = [0 1 2 3 4 5 6 1 8 9 10 11 12];

% need to be specified
name = 'SClass';
dir = '/scratch/working/AVATOL/SClass/';

% Spatial resolution of HOG cell, interms of pixel width and hieght
sbin = 8;

% --------------------
% Define training and testing data
globals;

%[pos test] = getPositiveData('/path/to/positive/data','im_regex','label_regex',0.7);
%neg        = getNegativeData('/path/to/positive/data', 'im_regex');
[pos test] = getPositiveData([dir,'pos/'],'png','txt',0.95);
neg        = getNegativeData([dir,'neg/'],'png');
pos        = pointtobox(pos,pa,0.65,1);

% show data
colorset = {'g','r','r','r','r','r','r','b','b','b','b','b','b'};
for i=1:length(pos)
    B = [pos(i).x1;pos(i).y1;pos(i).x2;pos(i).y2];
    B = reshape(B,[4*length(pa),1])';
    A = imread(pos(i).im);
    showboxes(A,B,colorset);
    pause;
end

% --------------------
% training
model = trainmodel(name,pos,neg,K,pa,sbin);
save([name,'.mat'], 'model', 'pa', 'sbin', 'name');

suffix = num2str(K')';
model.thresh = min(model.thresh,0);
boxes = testmodel(name,model,test,suffix);

% --------------------
% visualization
figure(1);
visualizemodel(model);
figure(2);
visualizeskeleton(model);

% demo
demoimid = 1;
im = imread(test(demoimid).im);
box = boxes{demoimid};
% show all detections
figure(3);
subplot(1,2,1); showboxes(im,box,colorset);
subplot(1,2,2); showskeletons(im,box,colorset,model.pa);

% evaluation
figure(4);
testGT = pointtobox(test,pa,1,1);
testB = [testGT(demoimid).x1;testGT(demoimid).y1;testGT(demoimid).x2;testGT(demoimid).y2];
testB = reshape(testB,[4*length(pa),1])';
showboxesGT(im,box,testB,colorset);

% show best detection overlap with ground truth box
% box = boxes_gtbox{demoimid};
% figure(4);
% subplot(1,2,1); showboxes(im,box,colorset);
% subplot(1,2,2); showskeletons(im,box,colorset,model.pa);
