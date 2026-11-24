
clc;
clear;
close all;

%% 1. STUDENT DATASET

studentNames = {'Student 1'; 'Student 2'; 'Student 3';
                'Student 4'; 'Student 5'; 'Student 6';
                'Student 7'; 'Student 8'; 'Student 9';
                'Student 10'; 'Student 11'; 'Student 12'};

% Marks in three subjects
% Columns: Mathematics, Computer Science, Statistics

marks = [78 85 80;
         65 70 68;
         90 92 88;
         55 60 58;
         78 80 82;
         88 84 90;
         72 75 70;
         60 65 62;
         95 90 94;
         68 72 70;
         82 85 80;
         75 78 76];

% Attendance percentage of students

attendance = [95; 80; 98; 65; 88; 92;
              78; 70; 99; 75; 90; 85];

% Calculate average marks of each student

averageMarks = mean(marks, 2);

% Display dataset

disp('===== STUDENT DATASET =====');

studentData = table(studentNames, attendance, ...
    marks(:,1), marks(:,2), marks(:,3), averageMarks, ...
    'VariableNames', {'Name','Attendance','Maths', ...
    'ComputerScience','Statistics','AverageMarks'});

disp(studentData);


%% 2. STATISTICAL CALCULATIONS

allMarks = marks(:);

MeanValue = mean(allMarks);
MedianValue = median(allMarks);
ModeValue = mode(allMarks);
RangeValue = max(allMarks) - min(allMarks);
VarianceValue = var(allMarks);
SDValue = std(allMarks);

disp('===== STATISTICAL RESULTS =====');

fprintf('Mean = %.2f\n', MeanValue);
fprintf('Median = %.2f\n', MedianValue);
fprintf('Mode = %.2f\n', ModeValue);
fprintf('Range = %.2f\n', RangeValue);
fprintf('Variance = %.2f\n', VarianceValue);
fprintf('Standard Deviation = %.2f\n', SDValue);


%% 3. CORRELATION BETWEEN ATTENDANCE AND MARKS

R = corrcoef(attendance, averageMarks);

correlation = R(1,2);

disp('===== CORRELATION ANALYSIS =====');

fprintf('Correlation Coefficient = %.4f\n', correlation);

if correlation > 0
    disp('Positive relationship between attendance and marks.');
elseif correlation < 0
    disp('Negative relationship between attendance and marks.');
else
    disp('No linear correlation.');
end


%% 4. LINEAR REGRESSION AND MARKS PREDICTION

% Calculate regression coefficients

coefficients = polyfit(attendance, averageMarks, 1);

slope = coefficients(1);
intercept = coefficients(2);

% Predicted marks for all students

predictedMarks = polyval(coefficients, attendance);

disp('===== REGRESSION RESULTS =====');

fprintf('Slope = %.4f\n', slope);
fprintf('Intercept = %.4f\n', intercept);

% Predict marks for a student with 85 percent attendance

newAttendance = 85;

predictedNewMarks = polyval(coefficients, newAttendance);

fprintf('Predicted marks at 85%% attendance = %.2f\n', ...
    predictedNewMarks);


%% 5. INDEPENDENT SAMPLES T-TEST

% Divide students into two groups

GroupA = averageMarks(1:6);
GroupB = averageMarks(7:12);

% Perform independent samples t-test

[h, p, ci, stats] = ttest2(GroupA, GroupB);

disp('===== T-TEST RESULTS =====');

fprintf('Group A Mean = %.2f\n', mean(GroupA));
fprintf('Group B Mean = %.2f\n', mean(GroupB));
fprintf('T-statistic = %.4f\n', stats.tstat);
fprintf('P-value = %.4f\n', p);

if h == 1
    disp('Reject the Null Hypothesis.');
    disp('There is a significant difference between the groups.');
else
    disp('Fail to Reject the Null Hypothesis.');
    disp('No statistically significant difference was found.');
end


%% 6. PERFORMANCE GRADING

performance = cell(length(averageMarks), 1);

for i = 1:length(averageMarks)

    if averageMarks(i) >= 85
        performance{i} = 'Excellent';

    elseif averageMarks(i) >= 70
        performance{i} = 'Good';

    elseif averageMarks(i) >= 50
        performance{i} = 'Average';

    else
        performance{i} = 'Needs Improvement';

    end

end


%% 7. GRAPH GENERATION

figure('Name','Student Performance Analysis', ...
       'NumberTitle','off');

% Graph 1: Average marks of students

subplot(2,2,1);

bar(averageMarks);

title('Average Marks of Students');
xlabel('Student Number');
ylabel('Average Marks');
ylim([0 100]);
grid on;


% Graph 2: Attendance vs Marks

subplot(2,2,2);

scatter(attendance, averageMarks, 60, 'filled');

hold on;

xLine = linspace(min(attendance), max(attendance), 100);

yLine = polyval(coefficients, xLine);

plot(xLine, yLine, 'r', 'LineWidth', 2);

title('Attendance vs Average Marks');
xlabel('Attendance (%)');
ylabel('Average Marks');

legend('Students','Regression Line', ...
       'Location','best');

grid on;
hold off;


% Graph 3: Subject-wise average marks

subplot(2,2,3);

subjectMeans = mean(marks, 1);

bar(subjectMeans);

set(gca, 'XTickLabel', ...
    {'Mathematics','Computer Science','Statistics'});

title('Subject-wise Performance');
ylabel('Average Marks');
ylim([0 100]);
grid on;


% Graph 4: Group comparison

subplot(2,2,4);

groupMeans = [mean(GroupA), mean(GroupB)];

bar(groupMeans);

set(gca, 'XTickLabel', {'Group A','Group B'});

title('Group Performance Comparison');
ylabel('Average Marks');
ylim([0 100]);
grid on;


%% 8. GENERATE PERFORMANCE REPORT

report = table(studentNames, attendance, averageMarks, ...
    predictedMarks, performance, ...
    'VariableNames', {'Student','Attendance', ...
    'ActualMarks','PredictedMarks','Performance'});

disp('===== FINAL PERFORMANCE REPORT =====');

disp(report);

% Save report as CSV file

writetable(report, 'Student_Performance_Report.csv');

disp('Performance report saved successfully!');

% Save graphs as image

saveas(gcf, 'Student_Performance_Graphs.png');

disp('Graphs saved successfully!');

disp('===== PROJECT COMPLETED SUCCESSFULLY =====');
