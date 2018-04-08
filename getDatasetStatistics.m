function stats = getDatasetStatistics(imdb)

train = find(imdb.images.set == 1 & imdb.images.segmentation) ;

% Class statistics
classCounts = zeros(2,1) ;
for i = 1:numel(train)
  fprintf('%s: computing segmentation stats for training image %d\n', mfilename, i) ;
  lb = imread(sprintf(imdb.paths.classSegmentation, imdb.images.name{train(i)})) ;
  ok = lb < 255 ;
  classCounts = classCounts + accumarray(lb(ok(:))+1, 1, [2 1]) ;
end
stats.classCounts = classCounts ;

% Image statistics
for t=1:numel(train)
  fprintf('%s: computing RGB stats for training image %d\n', mfilename, t) ;
%   if t < 403 ||(t > 657 && t < 1060) %1009ÎªmatÍ¼Æ¬ÊýÁ¿+1
%   if t < 268 || (t > 390 && t < 658) || (t > 780 && t < 1048) ||  (t > 1170 && t < 1438) || (t > 1560 && t < 2095)
%   if t < 268 || (t > 390 && t < 925) || (t > 1047)
%   if t < 523 || (t > 645 && t < 913) || (t > 1035 && t < 1558) ||  (t > 1680 && t < 1948) || t > 2070
%   if t < 757 || (t > 879 && t < 1147) || (t > 1269 && t < 2026) ||  (t > 2148 && t < 2416) || t > 2538
%   if t < 502 || (t > 624 && t < 892) || (t > 1014 && t < 1516) ||  (t > 1638 && t < 1906) || t > 2028
%    if t < 403 || (t > 525 && t < 793) || (t > 915 && t < 1318) ||  (t > 1440 && t < 1708) || (t > 1830 && t < 2365)
   if t < 403 || (t > 648 && t < 1051) || (t > 1296 && t < 1831 )
      rgb = load(sprintf(imdb.paths.image2, imdb.images.name{train(t)}));
      rgb = rgb.picture;
  else
      rgb = dicomread(sprintf(imdb.paths.image, imdb.images.name{train(t)})) ;
  end
  rgb = cat(3, rgb, rgb, rgb) ;
  rgb = single(rgb) ;
  z = reshape(permute(rgb,[3 1 2 4]),3,[]) ;
  n = size(z,2) ;
  rgbm1{t} = sum(z,2)/n ;
  rgbm2{t} = z*z'/n ;
end
rgbm1 = mean(cat(2,rgbm1{:}),2) ;
rgbm2 = mean(cat(3,rgbm2{:}),3) ;

stats.rgbMean = rgbm1 ;
stats.rgbCovariance = rgbm2 - rgbm1*rgbm1' ;
