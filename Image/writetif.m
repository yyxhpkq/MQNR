
clc
clear
fus_med={'1_PCA','2_IHS','3_BDSD','4_GS','5_ATWT_M2','6_MTF_GLP_CBD'};


readpath=('E:\work3\MQNR\Image\Mixed\1_PCA.mat');

savePath_tif=('E:\work3\MQNR\Image\Mixed\1_PCA');
image=importdata(readpath);

writeimage(image(:,:,[1,2,3]),savePath_tif,'');