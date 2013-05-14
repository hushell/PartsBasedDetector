clear
close all
addpath(genpath(pwd));

%% All to Tranchops
% load models
allModels = load('./AClass_eval.mat', 'allModels'); % 16
Amodel = allModels(1).allModels{1};
allModels = load('./DClass_eval.mat', 'allModels'); % 8
Dmodel = allModels(1).allModels{1};
allModels = load('./GClass_eval.mat', 'allModels'); % 16
Gmodel = allModels(1).allModels{1};
allModels = load('./M1Class_eval.mat', 'allModels'); % 12
M1model = allModels(1).allModels{1};
allModels = load('./M2Class_eval.mat', 'allModels'); % 16
M2model = allModels(1).allModels{1};
allModels = load('./NClass_eval.mat', 'allModels'); % 14
Nmodel = allModels(1).allModels{1};
allModels = load('./SClass_eval.mat', 'allModels'); % 16
Smodel = allModels(1).allModels{1};

n_sources = 6;
sModels = cell(n_sources,1);
sModels{1} = Amodel;
sModels{2} = Gmodel;
sModels{3} = M1model;
sModels{4} = M2model;
sModels{5} = Nmodel;
sModels{6} = Smodel;

% basic params
sbin = 8;
dir = '/scratch/working/AVATOL/datasets/Ventral_View/Trachops/';
pa = [0 1 1 3 4 5 6 7 1 9 10 11 12 13];
color_sources = {{'g'},{'b'},{'r'},{'y'},{'m'},{'w'},};

% testing
[~,test] = getPositiveDataNoRand([dir,'pos/'],'png','txt',[1 2]);
test = pointtobox(test,pa,1,1);
im = imread(test(1).im);

% presence table
% I1,Nasal,I2,C,P4,P5,M1,M2,M3 
presence = [1,1,1,1,1,1,1,1,1,1;   % A
            1,1,1,1,1,1,1,1,1,1;   % G
            1,1,0,1,0,1,1,1,1,1;   % M1
            1,1,1,1,1,1,1,1,1,1;   % M2
            1,1,1,1,0,1,1,1,1,1;   % N
            0,1,1,1,1,1,1,1,1,1;]; % S


BBX = cell(9,1);
for p = 1:9
    boxes = cell(n_sources,1);
    figure(p);
    imagesc(im); axis image; axis off;
    for i = 1:n_sources
        if (presence(i,p) == 0)
            continue;
        end
        
        tsize = size(sModels{i}.filters(p).w);
        model = makemodel(sbin,tsize);
        model.filters(1) = sModels{i}.filters(p);
        %visualizemodel(model);
        model.thresh = -1;

        box = detect_fast(im,model,model.thresh);
        box = nms(box,0.3);
        box = box(1:2,:);
        boxes{i} = box;

        %fprintf('[***DEBUG***] color = %s\n', color_sources{i}{1});
        showboxesTransfer(im,box,color_sources{i});
    end
    drawnow
    BBX{p} = cat(1,boxes{:});
    %pause;
end

