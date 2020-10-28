function  [mu_prisparam,cov_prisparam]  =primodel(I_PAN,blocksizerow,blocksizecol,specfeatnum,spatfeatnum)
   

    [I_pan,block_rownum,block_colnum]=croppatch(I_PAN,blocksizerow,blocksizecol); 
     i_pan=mat2gray(I_pan).*255;
     
     fea_spat = blkproc(i_pan,[blocksizerow blocksizerow],@spatfeature);
     feat_spat_all_p               = reshape(fea_spat',[spatfeatnum ....
                           size(fea_spat,1)*size(fea_spat,2)/spatfeatnum]);
     feat_spat_all_p               = feat_spat_all_p';
     feat_spec_all               = zeros(block_rownum*block_colnum,specfeatnum); %% pristine spectral feature can be understood as zero vector
     
     feat_all=[feat_spat_all_p,feat_spec_all];
 
     mu_prisparam     = nanmean(feat_all);
     cov_prisparam    = nancov(feat_all);
end