clear;
clc;
close all;

OutputDir = 'H:/nana/data/fcn4s-500-33cases_MICCAI2009-1+1_2+2+08+132-Vmirror-i_1-control33case/filling_result/';
Outputpath = 'H:/nana/data/fcn4s-500-33cases_MICCAI2009-1+1_2+2+08+132-Vmirror-i_1-control33case';
file_path =  'H:/nana/data/fcn4s-500-33cases_MICCAI2009-1+1_2+2+08+132-Vmirror-i_1-control33case/processed_result/'
img_path_list = dir(strcat(file_path,'*.png'));%��ȡ���ļ���������png��ʽ��ͼ��  
img_num = length(img_path_list);%��ȡͼ��������   

floder = OutputDir(length(Outputpath) + 2:length(OutputDir));
if ~exist(fullfile(Outputpath, floder)) 
   mkdir(fullfile(Outputpath, floder)); 
end
    
 for j = 1:img_num %��һ��ȡͼ��  
     image_name = img_path_list(j).name;% ͼ����  
     [I,map] = imread(strcat(file_path,image_name)); 
     [m,n] = size(I);
%      I = I(1:2:m,1:2:n);
%      b = padarray(I, [64 64]); 
     a = padarray(I, [63 63]); %��A����Χ��չ63��0
     b = padarray(a,[2 2],'replicate','post');
     pathfile = fullfile(OutputDir,image_name); 
     imshow(b,map);
     imwrite(b,map,pathfile,'png');
 end
