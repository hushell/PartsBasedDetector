clear
close all
addpath(genpath(pwd));

name = 'Diatoms';
dir = '/scratch/working/AVATOL/datasets/Diatoms/Diatom_compvision_pics/subset/';

sbin = 8;

globals;

neg        = getNegativeData([dir,'neg/'],'png');
num_pos = 8;
posAll = load_bboxs(num_pos,1,[dir,'test.annotation']);

models = cell(num_pos,1);
boxesAll = cell(num_pos,1);
for i = 1:num_pos
    pos = posAll(i);
    tsize = init_part_size(pos,sbin);
    model = initmodel(pos,sbin,tsize);
    model = train(name,model,pos,neg,1,1);
    models{i} = model;

    visualizemodel(model);
    model.thresh = -1;
    boxes = testmodel([name,'_test'],model,pos);
    boxesAll{i} = boxes;
    pause;
end

% model.thresh = -1;
% boxes = testmodel([name,'_test'],model,pos);

BBX = cat(1,boxesAll{:});
for i = 1:num_pos
    BBX{i} = BBX{i}(1:2,:);
end
BBX = cat(1,BBX{:});
BBX = nms(BBX,0.3);

demoimid = 1;
% box = boxes{demoimid};
im = imread(pos(demoimid).im);
showboxes(im,BBX(:,:),{'g'});
colormap(gray)

% bboxes centers
points = zeros(num_pos,2);
points(:,1) = (BBX(:,3) - BBX(:,1)) + BBX(:,1);
points(:,2) = (BBX(:,4) - BBX(:,2)) + BBX(:,2);
