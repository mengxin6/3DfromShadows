% script for saving important frames down
% v = VideoReader('vid.mov');
% currAxes = axes;
% step = 4;
% 
% num = 1;
% while hasFrame(v)
%     for i = 1:step-1
%         readFrame(v);
%     end
%     vidFrame = readFrame(v);
%     image(vidFrame, 'Parent', currAxes);
%     currAxes.Visible = 'off';
%     a = input('');
%     if a == 0
%         imwrite(vidFrame, [num2str(num) '.jpg']);
%         num = num + 1;
%     else if a == 1
%             
%     end
% end

implay('vid.mov');
camcalib = [1,114,194,352,435,535,609,660,];
lightcalib = [854,943,1030,1103,1248,1337,1386,1496];
duck1 = 2120:2340; % back and forth
% duck2 = 3250:3335;
% duck3 = 3370:3470;
% duck4 = 3640:3705;
% duck5 = 3710:3765;
% duck6 = 3910:3990;
% duck7 = 3990:4050;
% dog1 = 6130:6270;
% dog2 = 6495:6610;
% dog3 = 6645:6670;

% Script for saving the frames
% v = VideoReader('vid.mov');
% num = 1;
% all = dog3;%%
% for i = all
%     vidFrame = read(v, i);
%     imwrite(vidFrame, ['dog3/' num2str(num) '.jpg']); %%
%     num = num + 1;
% end