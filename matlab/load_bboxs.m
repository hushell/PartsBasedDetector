function [pos] = load_bboxs(Npos,partnum,filename)  
% read bbox annotations by Inria's imgAnnotation tool

pos = struct();

fid = fopen(filename);
tline = fgets(fid);
i = 0;
pid = 1;
cumid = 0;
while i <= Npos && ischar(tline)
    %disp(tline)
    
    if strfind(tline, 'file:') == 1
        currentImagePath = strtrim(strrep(tline, 'file: ', ''));
        pos(i).im = currentImagePath;
        pos(i).x1 = zeros(partnum,1);
        pos(i).y1 = zeros(partnum,1);
        pos(i).x2 = zeros(partnum,1);
        pos(i).y2 = zeros(partnum,1);
        pos(i).point = zeros(partnum,2);
        
    elseif strfind(tline, 'bbox:') == 1
        % parse line for bbox
        bbox = strtrim(strrep(tline, 'bbox: ', ''));
        bbox = textscan(bbox,'%s','delimiter',',');
        
        % convert bounding box coordinates to MATLAB
        x = str2double(bbox{1}(1));
        y = str2double(bbox{1}(2));
        width = str2double(bbox{1}(3));
        height = str2double(bbox{1}(4));
        %featureImage = currentImage(y:y+height,x:x+width,:);

        pos(i).x1(pid) = x;
        pos(i).y1(pid) = y;
        pos(i).x2(pid) = x + width;
        pos(i).y2(pid) = y + height;
        pos(i).point(pid,1) = x + width/2;
        pos(i).point(pid,2) = y + height/2;
        
        pid = pid + 1;
        cumid = cumid + 1;
        
        %imwrite(featureImage, sprintf('%spos_%d.png', DEBUG_OUTPUT_PATH, i), 'png');
    elseif strfind(tline, '########## NEW FILE ##########') == 1
        if mod(cumid,partnum) ~= 0
            fclose(fid);
            error('reading annotation: part num error!');
        end
        pid = 1; 
        i = i+1;
    end

    tline = fgets(fid);
end

fclose(fid);
