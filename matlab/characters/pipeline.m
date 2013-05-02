% main rules

%% training 

% train multi-class image classifiers


% train part detectors


% train presence classifiers
load AClass_eval.mat;
bboxes = cat(2,allBoxes{:});
score = zeros(numel(bboxes),1);
for i = 1:numel(bboxes)
    bboxes{i} = bboxes{i}(1,:);
    score(i) = bboxes{i}(1,end);
end

[pdists,pairs] = part_dist(bboxes);
gt = ones(numel(bboxes),1);
presmodel = train_presence_point(1, score, pdists, pairs, gt);

% train shape classifiers


%% apply rules for character scoring

% 1) predict class label

% 2) get part locations and scores

% 3) presence characters

% 4) shape characters

% 5) relation characters

% 6) measurement characters