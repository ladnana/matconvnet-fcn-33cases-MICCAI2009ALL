clear;
clc;
close all;

OutputDir = 'H:/nana/data/33cases_MICCAI2009/getImagesIcontour20/';
Outputpath = 'H:/nana/data/33cases_MICCAI2009';
InputDir =  'H:/nana/data/33cases_MICCAI2009/SegmentationClass/';

if ~exist(OutputDir) 
   mkdir(OutputDir); 
end
for j = 1 :33
    name = ['SCD00000' num2str(j,'%02d') '_20*.png'];
    img_path_list = dir([InputDir name]);%获取该文件夹中每个case的图像
    img_num = length(img_path_list);%获取每个case的图像数量

    for i = 1 : img_num
        filename = fullfile(InputDir,img_path_list(i).name);
        [I,map] = imread(filename);
        I0 = uint8(zeros(size(I)));
        I0(find(I == 1)) = 1;
        image(I0);
        imshow(I0,map);
        pathfile = fullfile(OutputDir,img_path_list(i).name);
        imwrite(I0,map,pathfile,'png');

    end
end


