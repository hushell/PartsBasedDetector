globals;
K = [1 1 1 1 1 1];
pa = [0 1 1 3 1 5];

part_names = ['I1', 'Nasal', 'C', 'P5', 'C', 'P5'];

% need to be specified
name = 'DClass';
%dir = '/scratch/working/AVATOL/datasets/DClass/';
dir = '/Users/zooey/working/AVATOL/data_avatol/DClass/';

sbin = 8;
colorset = {'g','g','r','r','b','b'};

% Evaluation from loaded data
clear;
load DClass_eval.mat;

BB1 = cat(1,allBoxes{:});
BB1 = BB1(:);
BB1 = BB1';

TT1 = cat(1,allTests{:});
TT1 = TT1(:);
TT1 = TT1';

[apk1,prec1,rec1,dist1] = AVATOL_eval_apk(BB1,TT1, 0.15);
distMat1 = [dist1{:}];
distMat1 = sort(distMat1);
boxplot(distMat1(1:20,:));

% show data
testGT = pointtobox(TT1,pa,1,1);
for i=1:length(TT1)
    dummy = splitstring(TT1(i).im, '/');
    imPath = [dir,dummy{end}];
    im = imread(imPath);
    testB = [testGT(i).x1;testGT(i).y1;testGT(i).x2;testGT(i).y2];
    testB = reshape(testB,[4*length(pa),1])';
    showboxesGT(im,BB1{i}(1,:),testB,colorset);
    %legend('Some quick information','location','EastOutside')
    
    %[h,w,~] = size(im);
    %text(w - 100,h - 50,'sth annotation');
    %showboxes(A,BB1{i},colorset);
    pause;
end

% -------------------------------------------------------
clear;
load SClass_eval.mat;

BB2 = cat(1,allBoxes{:});
BB2 = BB2(:);
BB2 = BB2';

TT2 = cat(1,allTests{:});
TT2 = TT2(:);
TT2 = TT2';

[apk2,prec2,rec2,dist2] = AVATOL_eval_apk(BB2,TT2, 0.15);
distMat2 = [dist2{:}];
distMat2 = sort(distMat2);
boxplot(distMat2(1:20,:));

