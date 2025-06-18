% Set up folder of images
imageDir = 'G:\MATLAB Code'; % Path to folder containing images
imageFiles = dir(fullfile(imageDir, '*.jpg')); % Assuming jpg images

% Ensure the required first image is present
firstImageName = 'Displacement_0.jpg';
firstImagePath = fullfile(imageDir, firstImageName);
if ~isfile(firstImagePath)
    error('The first image named "Displacement_0.jpg" is not found in the specified directory.');
end

% Load the first image
firstImage = imread(firstImagePath);

% Display the first image and let the user select the point to track
figure;
imshow(firstImage);
title('Zoom in/out to select the point to track (click to select)');
zoom on;
uiwait(msgbox('Adjust zoom and close this message box when ready to select the point.')); % Wait for user to adjust zoom
zoom off;

% Wait for user to select the point
point = round(ginput(1)); % Select the point manually

% Display the first image again for reference length selection
figure;
imshow(firstImage);
title('Zoom in/out to select two points for known distance (click to select)');
zoom on;
uiwait(msgbox('Adjust zoom and close this message box when ready to select the reference points.')); % Wait for user to adjust zoom
zoom off;

% Wait for user to select two points for known distance
points = round(ginput(2));

% Calculate pixel distance between the two selected points
pixelDistance = sqrt((points(2,1) - points(1,1))^2 + (points(2,2) - points(1,2))^2);

% Prompt user to enter the known distance in mm
knownDistanceMm = input('Enter the known distance between the selected points in mm: ');
while isempty(knownDistanceMm) || ~isnumeric(knownDistanceMm) || knownDistanceMm <= 0
    disp('Invalid input. Please enter a positive number for the distance in mm.');
    knownDistanceMm = input('Enter the known distance between the selected points in mm: ');
end

% Calculate scale factor (mm per pixel)
scaleFactor = knownDistanceMm / pixelDistance;

% Initialize point tracker
tracker = vision.PointTracker('MaxBidirectionalError', 2);
initialize(tracker, point, firstImage);

% Create a matrix to store the point's positions in all images
nImages = length(imageFiles);
trackedPoints = zeros(nImages, 2);
trackedPoints(1, :) = point;

% Loop through the rest of the images and track the point
for i = 2:nImages
    currentImageName = sprintf('Displacement_%d.jpg', i - 1);
    currentImagePath = fullfile(imageDir, currentImageName);

    if ~isfile(currentImagePath)
        warning('Image %s not found. Skipping.', currentImageName);
        continue;
    end

    % Read the next image
    currentImage = imread(currentImagePath);

    % Track the point
    [newPoint, validity] = step(tracker, currentImage);

    if validity
        trackedPoints(i, :) = newPoint;
    else
        warning('Tracking failed at image %d', i);
        break;
    end

    % Optionally, display the tracked point
    imshow(currentImage); hold on;
    plot(newPoint(1), newPoint(2), 'ro', 'MarkerSize', 10, 'LineWidth', 2);
    title(sprintf('Tracking on Image %d', i));
    pause(0.5); % Pause for visualization
end

% Convert tracked points from pixels to mm
trackedPointsMm = trackedPoints * scaleFactor;

% Calculate displacement in mm relative to the first image
displacementX = trackedPointsMm(:, 1) - trackedPointsMm(1, 1); % X-direction displacement
displacementY = trackedPointsMm(:, 2) - trackedPointsMm(1, 2); % Y-direction displacement
displacementTotal = sqrt(displacementX.^2 + displacementY.^2); % Total displacement

% Display displacement
disp('Displacement in X direction (mm):');
disp(displacementX);
disp('Displacement in Y direction (mm):');
disp(displacementY);
disp('Total displacement in mm for each frame relative to the first image:');
disp(displacementTotal);

% Save tracked points and displacements to CSV files
writematrix(trackedPointsMm, fullfile(imageDir, 'trackedPointsMm.csv'));
writematrix([displacementX, displacementY], fullfile(imageDir, 'displacementXY.csv'));
writematrix(displacementTotal, fullfile(imageDir, 'displacementTotal.csv'));

% Plot the movement in mm
figure;
plot(trackedPointsMm(:,1), trackedPointsMm(:,2), '-o', 'MarkerSize', 5);
hold on;
plot(trackedPointsMm(1,1), trackedPointsMm(1,2), 'go', 'MarkerSize', 10, 'DisplayName', 'Start (Displacement_0)');
plot(trackedPointsMm(end,1), trackedPointsMm(end,2), 'ro', 'MarkerSize', 10, 'DisplayName', 'End');
title('Movement of the Point Across Images (in mm)');
xlabel('X Coordinate (mm)');
ylabel('Y Coordinate (mm)');
legend('Tracked Path', 'Start (Displacement_0)', 'End');
grid on;

% Plot X and Y displacements over frames
figure;
plot(1:nImages, displacementX, '-o', 'DisplayName', 'X Displacement');
hold on;
plot(1:nImages, displacementY, '-o', 'DisplayName', 'Y Displacement');
title('Displacement in X and Y Directions Across Frames');
xlabel('Frame Number');
ylabel('Displacement (mm)');
legend;
grid on;
