y = [40 10 10 20 10 10; 45 0 0 20 20 15];
h = bar([1,2], y,'stacked');
ylabel('Percentage of total score', 'fontsize',16)
yPadded = [0 0;y']';
cumsumyPadded = cumsum(yPadded,2);
ECTS = {'F','E','D','C','B','A'};
for i = 1:6
    text(1,cumsumyPadded(1,i)+0.5*yPadded(1,i+1),ECTS{i}, 'color', 'w', 'fontsize', 16, 'fontweight','bold')
end
ENGINEER = {'U','','','3','4','5'};
for i = 1:6
    text(2,cumsumyPadded(2,i)+0.5*yPadded(2,i+1),ENGINEER{i}, 'color', 'w', 'fontsize', 16, 'fontweight','bold')
end
box off
set(gca,'XTickLabel',{'ECTS','LiTH'})
print Grades -dpng