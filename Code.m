clc;
close all;
clear all;

% Step 1: Image Acquisition
img = imread('tiger.jpg'); % Load the image
figure;
imshow(img); % Display the original image
title('Original Image');

% Step 2: Preprocessing
grayImg = rgb2gray(img); % Convert the image to grayscale
figure;
imshow(grayImg);
title('Grayscale Image');

% Apply a median filter for noise reduction
filteredImg = medfilt2(grayImg, [3 3]);
figure;
imshow(filteredImg);
title('Filtered Image');

% Step 3: Edge Detection
edges = edge(filteredImg, 'Canny'); % Perform Canny edge detection
figure;
imshow(edges);
title('Edge Detection');

% Step 4: Convert to Binary Image
binaryImg = imbinarize(filteredImg); % Convert to binary image
figure;
imshow(binaryImg);
title('Binary Image');

% Step 5: Morphological Operations (Optional, for noise removal)
binaryImg = imfill(binaryImg, 'holes'); % Fill holes inside objects
binaryImg = bwareaopen(binaryImg, 50); % Remove small objects

% Step 6: Feature Extraction and Statistical Analysis
stats = regionprops(binaryImg, 'Area', 'Perimeter', 'Centroid', 'BoundingBox', 'Eccentricity');

% Display each detected object with its bounding box and area
figure;
imshow(binaryImg);
hold on;
title('Detected Objects with Bounding Boxes');
for i = 1:length(stats)
    rectangle('Position', stats(i).BoundingBox, 'EdgeColor', 'r', 'LineWidth', 2); % Draw bounding box
    text(stats(i).Centroid(1), stats(i).Centroid(2), sprintf('Area: %.2f', stats(i).Area), ...
         'Color', 'yellow', 'FontSize', 10); % Display area
end
hold off;

% Step 7: Statistical Analysis
areas = [stats.Area]; % Get areas of all detected objects
perimeters = [stats.Perimeter]; % Get perimeters of all detected objects

% Display basic statistics
fprintf('Number of Objects Detected: %d\n', length(stats));
fprintf('Average Object Area: %.2f pixels\n', mean(areas));
fprintf('Standard Deviation of Object Areas: %.2f pixels\n', std(areas));
fprintf('Average Object Perimeter: %.2f pixels\n', mean(perimeters));
fprintf('Standard Deviation of Object Perimeters: %.2f pixels\n', std(perimeters));

% Step 8: Plot Histogram of Object Areas
figure;
histogram(areas);
title('Histogram of Object Areas');
xlabel('Area (pixels)');
ylabel('Frequency');
