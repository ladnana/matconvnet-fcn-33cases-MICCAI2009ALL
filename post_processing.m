clear;
clc;
close all;

OutputDir = 'H:/nana/data/fcn4s-500-33cases_MICCAI2009_128_doublehalf/processed_result/';
Outputpath = 'H:/nana/data/fcn4s-500-33cases_MICCAI2009_128_doublehalf';
file_path =  'H:/nana/data/fcn4s-500-33cases_MICCAI2009_128_doublehalf/segamentation_result/';% 图像文件夹路径
img_path_list = dir(strcat(file_path,'*.png'));%获取该文件夹中所有png格式的图像
img_num = length(img_path_list);%获取图像总数量

if ~exist(fullfile(Outputpath, 'processed_result'))
    mkdir(fullfile(Outputpath, 'processed_result'));
end

% A = imread(strcat(file_path,'SCD0000401_0040.png'));
% imshow(A);
for j = 1:img_num %逐一读取图像
    image_name = img_path_list(j).name;% 图像名
    [I,map] = imread(strcat(file_path,image_name));
    imshow(I,map);
    %     [I,map] = imread('SCD0003401_0100.png');
    I_i = uint8(zeros(size(I)));
    I_o = uint8(zeros(size(I)));
    I_i ( find (I==1) ) = 1;
    I_o ( find (I==2) ) = 2;
    
    for i = [1 2]
        % delete small regions
        if i ==1
            I = I_i;
        else
            I = I_o;
        end
        [L,num]  = bwlabel ( I, 8);
        if num>1
            %find the biggest area
            areas = zeros(1,num);
            for k=1:num
                areas(k) = sum(sum(L==k));
            end
            [~,ind]=max(areas);
            %set redundant area value 0
            index = find ( L == ind );
        else
            index = find( I );
        end
        
        I2 = uint8(zeros(size(I)));
        I2(index) = I(index) ;
        
        if i == 1
            endocardium = uint8(zeros(size(I)));
            endocardium ( find (I2==1) ) = 1;
            %%%%%%%%%%%%%%%%%%%%%
            if length(find(I2==1)) < 500
                areaTh = 0;
                se2 = strel('disk',1);
            else
                areaTh = 50;
                se2 = strel( 'disk',10);
            end
            
            %%%%%%%%%%%%%%%%%%%%%%processing endocardium%%%%%%%%%%%%%%%%%%%%%%
            %delete small parts
            endocardium = bwareaopen (endocardium, areaTh);
            %fill holes
            endocardium = imfill (endocardium,'hole');
            %cut small corners
            endocardium = imopen (endocardium, se2 );
            
        else
            epicardium = uint8(zeros(size(I)));
            epicardium ( find (I2==2) ) = 2;
        end
    end
    
    
    %         %%%%%write auto segmentation results%%%%%%%%%%%
    %         B = bwboundaries (endocardium);
    %         if ~isempty (B)
    %             endoB = fliplr(B{1});
    %             autoIContoursFilename = [OutputDir1 'fcn4s_Eval-100-MCCAI2009-15\' caseName '\contours-auto\Auto2\IM-0001-' t(12:15) '-icontour-auto.txt'];
    %             dlmwrite (autoIContoursFilename, endoB, ' ');
    %         end
    %         B = bwboundaries (epicardium);
    %         if ~isempty (B)
    %             epiB = fliplr(B{1});
    %             autoOContoursFilename = [OutputDir1 'fcn4s_Eval-100-MCCAI2009-15\' caseName '\contours-auto\Auto2\IM-0001-' t(12:15) '-ocontour-auto.txt'];
    %             dlmwrite (autoOContoursFilename, epiB, ' ');
    %         end
    
    pathfile = fullfile(OutputDir,image_name);
    A = double(endocardium);
    B = double(epicardium);
    imsize = size(A);
    C = zeros(imsize);
    for j = 1 : imsize(1)
        for k = 1 : imsize(2)
            if sum(A(j, k, :)) == 0
                C(j, k, :) = B(j, k, :);
            else
                C(j, k, :) = A(j, k, :);
            end
        end
    end
    C = uint8(C);
    image(C)
    imwrite(C,map,pathfile,'png');
end