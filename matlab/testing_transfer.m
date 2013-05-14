clear
close all
addpath(genpath(pwd));

gclass_dir = '/scratch/working/AVATOL/datasets/Ventral_View/Glossophaga/';
aclass_dir = '/scratch/working/AVATOL/datasets/Ventral_View/Artibeus/';
dclass_dir = '/scratch/working/AVATOL/datasets/Ventral_View/Desmodus/';
m1class_dir = '/scratch/working/AVATOL/datasets/Ventral_View/Molossus/';
m2class_dir = '/scratch/working/AVATOL/datasets/Ventral_View/Mormoops/';
nclass_dir = '/scratch/working/AVATOL/datasets/Ventral_View/Noctilio/';
sclass_dir = '/scratch/working/AVATOL/datasets/Ventral_View/Saccopteryx/';
tclass_dir = '/scratch/working/AVATOL/datasets/Ventral_View/Trachops/';

Acolorset = {'g','g','r','r','r','r','r','b','b','b','b','b'}; % AClass
Tcolorset = {'g','g','r','r','r','r','r','r','b','b','b','b','b','b'};
Dcolorset = {'g','g','r','r','b','b'};
M1colorset = {'g','g','r','r','r','r','r','b','b','b','b','b'};

Tpa = [0 1 1 3 4 5 6 7 1 9 10 11 12 13];
M1pa = [0 1 1 3 4 5 6 1 8 9 10 11];

allModels = load('./TClass_eval.mat', 'allModels');
model = allModels(1).allModels{1};

[~,test] = getPositiveDataNoRand([m1class_dir,'pos/'],'png','txt',[1 2]);
test = pointtobox(test,Tpa,1,1);
boxes = cell(1,length(test));
for i = 1:length(test)
    %fprintf(['Glossophaga' ': testing: %d/%d\n'],i,length(test));
    im = imread(test(i).im);
    box = detect_fast(im,model,model.thresh);
    box = nms(box,0.3);
    %showboxes(im,box,Tcolorset);
    testB = [test(i).x1;test(i).y1;test(i).x2;test(i).y2];
    testB = reshape(testB,[4*length(M1pa),1])';
    showboxesGT(im,box,testB,Tcolorset,M1colorset);
    pause;
    
    %boxes{i} = nms(box,0.3);
    boxes{i} = box;
end