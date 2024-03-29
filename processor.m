% Size (bytes) threshold to switch to multi scale align
MULTI_SCALE_THRESHOLD = 500000;

% Iterate over raw images
image_files = dir('raw/*.jpg');
for i = 1:numel(image_files)
    fprintf("Processing %s\n", image_files(i).name);

    fullim = imread(strcat('raw/', image_files(i).name));

    % Convert to double matrix (might want to do this later on to same memory)
    fullim = im2double(fullim);

    % Compute the height of each part (just 1/3 of total)
    height = floor(size(fullim,1)/3);

    % Separate color channels
    B = fullim(1:height,:);
    G = fullim(height+1:height*2,:);
    R = fullim(height*2+1:height*3,:);

    % Find best displacements
    % If smaller than 500KB, can use single scale align
    if image_files(i).bytes < MULTI_SCALE_THRESHOLD
        [B, G, R] = single_scale_align(B, G, R);
    else
        [B, G, R] = multi_scale_align(B, G, R);
    end

    % Get new composite image
    BG = cat(3, B, G);
    BGR = cat(3, BG, R);

    % Save processed image
    imwrite(BGR,['processed/' image_files(i).name]);
end