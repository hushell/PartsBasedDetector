function [pdists,pairs] = part_dist(bboxs)
%
    numimgs = numel(bboxs);
    numpart = floor(size(bboxs{1},2)/4);
    if numpart == 1
        pdists = [];
        return
    end
    
    [p,q] = meshgrid(1:numpart,1:numpart);
    p = triu(p); p = p-diag(diag(p)); p = p(p~=0);
    q = triu(q); q = q-diag(diag(q)); q = q(q~=0);
    pairs = [p q];
    
    pdists = zeros(numimgs, numpart*(numpart-1)/2);
    for i = 1:numimgs    
        bbox = bboxs{i}(:,1:4*numpart);
        x1 = bbox(:,1:4:end);
        y1 = bbox(:,2:4:end);
        x2 = bbox(:,3:4:end);
        y2 = bbox(:,4:4:end);
        pointx = (x2+x1)/2;
        pointy = (y2+y1)/2;
        pdists(i,:) = sqrt((pointx(p) - pointx(q)).^2 + (pointy(p) - pointy(q)).^2);
        pdists(i,:) = pdists(i,:) ./ pdists(i,1); % normalize by dist(part1,part2)
    end
end