function  D_lambda_index=specfeature(I_GT,I_F,blocksizerow,blocksizecol,block_rownum,block_colnum)
 D_lambda_index=[];
   for j=1:block_rownum
        
            for k=1:block_colnum
                
               im=I_F(blocksizerow*(j-1)+1:blocksizecol*j,blocksizerow*(k-1)+1:blocksizecol*k,:);
               I_MS_HS=I_GT(blocksizerow*(j-1)+1:blocksizecol*j,blocksizerow*(k-1)+1:blocksizecol*k,:);
            
               D_lambda_index(block_rownum*(j-1)+k,:)= q_band(im,I_MS_HS,32,1); %%D_lambda
            
               
            end
   end
