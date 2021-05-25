 clc ;
 clear  ;
 
 blocksizerow    = 96;
 blocksizecol    = 96;

 fus_med={'1_PCA','2_IHS','3_BDSD','4_GS','5_ATWT_M2','6_MTF_GLP_CBD'};

 readpath_MS=('\Image\Buildings\MS.mat');
 readpath_PAN=('\Image\Buildings\PAN.mat');
 
 I_MS  =importdata(readpath_MS); 
 I_MS  =double(I_MS);
 I_MS_Interpolated = interp23tap(I_MS,4);  %upsampled
 
 I_PAN  =importdata(readpath_PAN); 
 I_PAN  =double(I_PAN);
 
 readpath_F=('\Image\Buildings\1_PCA.mat');
 
 Image_F  =importdata(readpath_F); 
 Image_F  =double(Image_F);

 Band   =size(Image_F,3);

 spatfeatnum     = 12;               % the number of spatial features
 specfeatnum     = Band*(Band-1)/2;  % the number of spectral features(C)
 
 tic
 %%%%%%%%%%%%%%%%%%%%%%%%  MVG model of fusion image  %%%%%%%%%%%%%%%%%%%%

 [im_f,block_rownum,block_colnum]=croppatch(Image_F,blocksizerow,blocksizecol); 
 image_f_gray=grayscale(im_f(:,:,[1,2,3])) ;%%RGB to gray
 I_F_Gray=mat2gray(image_f_gray).*255;

 fea_spat = blkproc(I_F_Gray,[blocksizerow blocksizerow],@spatfeature);
 feat_spat_all_f               = reshape(fea_spat',[spatfeatnum ....
                           size(fea_spat,1)*size(fea_spat,2)/spatfeatnum]);
 feat_spat_all_f               = feat_spat_all_f';
 
 feat_spec_all_f               = specfeature(I_MS_Interpolated(:,:,:),im_f(:,:,:),blocksizerow,blocksizecol,block_rownum,block_colnum);

 feat_all_f=[feat_spat_all_f,feat_spec_all_f];
 
 
  mu_distparam     = nanmean([feat_all_f(:,:)]);
  cov_distparam    = nancov([feat_all_f(:,:)]);
  
  
   %%%%%%%%%%%%%%%%%%%%%%%%  Benchmark  MVG model   %%%%%%%%%%%%%%%%%%%%
  [mu_prisparam,cov_prisparam]  =primodel(I_PAN,blocksizerow,blocksizecol,specfeatnum,spatfeatnum);
  
  
   %%%%%%%%%%%%%%%%%%%%%%%%  compute quality   %%%%%%%%%%%%%%%%%%%%%%%%%
  invcov_param     = pinv((cov_prisparam+cov_distparam)/2);
   quality = sqrt((mu_prisparam-mu_distparam)* ...
    invcov_param*(mu_prisparam-mu_distparam)')
  
toc