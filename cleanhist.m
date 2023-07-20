% cleanhist
% Mohammad Shams
% m.shamsahmar@gmail.com

function cleanhist(h)
for ih = 1:length(h)
    h(ih).EdgeColor = 'none';
end
cleanplot