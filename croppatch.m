function [im,block_rownum,block_colnum]=croppatch(image,blocksizerow,blocksizecol)
[row,col,~]=size(image);
 
 block_rownum     = floor(row/blocksizerow);
 block_colnum     = floor(col/blocksizecol);
 im               = image(1:block_rownum*blocksizerow,1:block_colnum*blocksizecol,:);   