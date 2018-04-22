clc;clear;

imdbPath = 'H:/nana/data/fcn4s-500-33cases_MICCAI2009-123+132-i_20-1_2lr_2scaleLoss/imdb.mat';
OutputimagesPath = 'H:/nana/data/33cases_MICCAI2009/2009-dcm-0mean1';

if ~exist(OutputimagesPath) 
   mkdir(OutputimagesPath); 
end

imdb = load(imdbPath) ;
train = find(imdb.images.set == 1 & imdb.images.segmentation ) ;
for i = 1 : numel(train)
        imagePath = sprintf(imdb.paths.image, imdb.images.name{train(i)}) ;
        I = dicomread(imagePath);
        subplot(121);imshow(I,[]);
        title([imdb.images.name{train(i)} '未处理过的原图']);
        
        I = double(I);
        tsubI = (I - mean(I(:)))/std(I(:),0,1);
        tsubI( find(tsubI>3)) = 3;
        tsubI( find(tsubI<-3)) = -3;
        tsubI = (tsubI+3)/6;
        tsubI = imadjust( tsubI, [min(tsubI(:)) max(tsubI(:))], [0 1]);
        subplot(122);imshow(tsubI,[]);
        title('零均值归一');
        
        disp([num2str(train(i)) ' ' imdb.images.name{train(i)} '.dcm']);
        dicomwrite(tsubI,fullfile(OutputimagesPath,[imdb.images.name{train(i)} '.dcm']));
%         pause;

end

val = find(imdb.images.set == 2 & imdb.images.segmentation ) ;
for i = 1:numel(val)
    imagePath = sprintf(imdb.paths.image, imdb.images.name{val(i)}) ;
    I = dicomread(imagePath);
    subplot(121);imshow(I,[]);
    title([imdb.images.name{val(i)} '未处理过的原图']);
    
    I = double(I);
    tsubI = (I - mean(I(:)))/std(I(:),0,1);
    tsubI( find(tsubI>3)) = 3;
    tsubI( find(tsubI<-3)) = -3;
    tsubI = (tsubI+3)/6;
    tsubI = imadjust( tsubI, [min(tsubI(:)) max(tsubI(:))], [0 1]);
    subplot(122);imshow(tsubI,[]);
    title('零均值归一');
    
    image_name = imdb.images.name{val(i)};
    idx = strfind(image_name,'_');
    num = image_name(idx-4:idx-1);
    if str2num(num) == 4201 || str2num(num) == 3401 || str2num(num) == 1901 || str2num(num) == 4001
        tsubI = rot90(tsubI,3);
    end
    disp([num2str(val(i)) ' ' imdb.images.name{val(i)} '.dcm']);
    dicomwrite(tsubI,fullfile(OutputimagesPath,[imdb.images.name{val(i)} '.dcm']));
%     pause;
end

