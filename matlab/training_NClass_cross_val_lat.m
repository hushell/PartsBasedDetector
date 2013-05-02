clear
close all
addpath(genpath(pwd));
% --------------------
% specify model parameters
% number of mixtures for 12 parts
K = [1 1 1 1 1 1 1];

% Tree structure for 6 parts: pa(i) is the parent of part i
% This structure is implicity assumed during data preparation
% (PARSE_data.m) and evaluation (PARSE_eval_pcp)
% pname8 = {'I1','Nasal','u1','u2','u3','u4','u5','l1','l2','l3','l4','l5'};
pa = [0 1 2 3 4 5 6];

% need to be specified
name = 'NClass_lat';
dir = '/home/hushell/working/AVATOL/datasets/Lateral_View/Noctilio/';

% Spatial resolution of HOG cell, interms of pixel width and hieght
sbin = 8;

colorset = {'b','b','b','b','b','b','b'};

% --------------------
% Define training and testing data
globals;

show_data = 0;
if (show_data == 1)
    %[pos test] = getPositiveData([dir,'pos/'],'png','txt',1.0);
    %neg        = getNegativeData([dir,'pos/'],'png');
    %pos        = pointtobox(pos,pa,0.8,1.3);
    pos = load_bboxs(10,length(pa),[dir,'NoctilioLat.annotation']);

    % show data
    for i=1:length(pos)
        B = [pos(i).x1;pos(i).y1;pos(i).x2;pos(i).y2];
        B = reshape(B,[4*length(pa),1])';
        A = imread(pos(i).im);
        showboxes(A,B,colorset);
        pause;
    end
end

% --------------------
%% Training 
% manually set test data
demo_active = 0;
nInstances = 10;
nFolds = ceil(nInstances / 2);
%testID = [1:4; 5:8; 9:12; 13:16; 17:20];
neg        = getNegativeData([dir,'neg/'],'png');
posAll = load_bboxs(10,length(pa),[dir,'NoctilioLat.annotation']);

apk = cell(nFolds,1);
prec = cell(nFolds,1);
rec = cell(nFolds,1);

allBoxes = cell(nFolds,1);
allTests = cell(nFolds,1);
allModels = cell(nFolds,1);
allPscores = cell(nFolds,1);
allPdists = cell(nFolds,2);

current = 0;

% cross validation
for ci = 1:nFolds
    fprintf('-----------------------------%d-------------------------------\n', ci);
    
    lastTest = min(current+2,nInstances);
    testID = current+1:lastTest
    current = lastTest;
    
    %[pos test] = getPositiveDataNoRand([dir,'pos/'],'png','txt',testID);
    %pos        = pointtobox(pos,pa,1,1);
    test = posAll(testID);
    pos = posAll(setdiff(1:nInstances,testID));
    
    % --------------------
    % training
    model = train_model_diff_parts([name, '_iter_', num2str(ci)],pos,neg,K,pa,sbin);
    %save([name,'.mat'], 'model', 'pa', 'sbin', 'name');

    % --------------------
    % testing
    suffix = num2str(K')';
    model.thresh = min(model.thresh,-2);
    [boxes,pscores] = testmodel([name, '_iter_', num2str(ci)],model,test,suffix);
    allBoxes{ci} = boxes;
    allTests{ci} = test;
    allModels{ci} = model;
    allPscores{ci} = pscores;
    [allPdists{ci,1}, allPdists{ci,2}] = part_dist(boxes);

    % --------------------
    if (demo_active == 1)
        visualization
        figure(1);
        visualizemodel(model);
        figure(2);
        visualizeskeleton(model);

        % demo
        demoimid = 2;
        im = imread(test(demoimid).im);
        box = boxes{demoimid};
        % show all detections
        figure(3);
        subplot(1,2,1); 
        showboxes(im,box,colorset);
        subplot(1,2,2); 
        showskeletons(im,box,colorset,model.pa);

        % visual evaluation
        figure(4);
        testGT = pointtobox(test,pa,1,1);
        testB = [testGT(demoimid).x1;testGT(demoimid).y1;testGT(demoimid).x2;testGT(demoimid).y2];
        testB = reshape(testB,[4*length(pa),1])';
        showboxesGT(im,box,testB,colorset);
    end

    % precision-recall 
    [apk{ci},prec{ci},rec{ci}] = AVATOL_eval_apk(boxes,test);
    
end

save([name, '_eval', '.mat'], 'apk', 'prec', 'rec', 'allBoxes', 'allTests', 'allModels', 'allPscores', 'allPdists');