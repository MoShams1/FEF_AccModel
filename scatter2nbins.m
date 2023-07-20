% 
% June 2023
% Mohammad Shams
% MoShamsCBR@gmail.com
%
% Converts a scatter plot into 'nbins' bins of almost equal number of elements.
%
% scatter2nbins(m,nbins)
%       m: items x coordinates
%       nbins: number of bins

function scatter2nbins(m,nbins)
bins = linspace(1,size(m,1),nbins+1);
bins = round(bins);
bin_cntr = 1;
for i = 1:length(bins)-1
    a_avg(1,bin_cntr) = mean(m(bins(i):bins(i+1),1),1);
    b_avg(1,bin_cntr) = mean(m(bins(i):bins(i+1),2),1);
    b_err(1,bin_cntr) = std(m(bins(i):bins(i+1),2),1) / sqrt(bins(i+1)-bins(i));
    bin_cntr = bin_cntr+1;
end
errorbar(a_avg,b_avg,b_err,'-ok','linewidth',1, ...
    'MarkerFaceColor','k','markeredgecolor','none')
end