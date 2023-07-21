% Sample data for plotting
x1 = 0:0.1:10;
y1 = sin(x1);

x2 = 0:0.05:4;
y2 = cos(x2);

% Create the figure
figure;

% Set the position of the first subplot
subplot(1, 2, 1);
plot(x1, y1);
title('Plot 1');

% Set the position of the second subplot
subplot(1, 2, 2);
plot(x2, y2);
title('Plot 2');

% Manually adjust the position of the subplots to match the desired lengths
pos1 = get(gca, 'Position');  % Get the current position of the first subplot
pos2 = pos1;                  % Start with the same position for the second subplot
pos2(3) = pos2(3) / 10;       % Adjust the width of the second subplot to match the desired length
pos2(1) = pos2(1) + pos1(3);  % Shift the second subplot to the right of the first subplot
set(gca, 'Position', pos1);   % Set the new position for the first subplot
subplot(1, 2, 2);
set(gca, 'Position', pos2);   % Set the new position for the second subplot
