%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description: 
%           Visualization [3-2-1] of images with 3 bands by exploiting linear stretching and fixing the saturation. 
% 
% Interface:
%           ImageToWrite = viewimage(ImageToWrite,tol)
%
% Inputs:
%           ImageToWrite:    Image to write;   
%                           e.g.  writeimage(I_MS,1);  直接保存
%                           writeimage(I_MS(:,:,[1,3,5]),1) %保存不同通道
%                           保存路径可以更改
%           tol:            Saturation; Default values: [0.01 0.99] equal for all the three bands.
%           save_path:      存储路径
%           name_num:       写入的文件编号
% Outputs:
%           ImageToWrite:    Image to write.

% data:2018.11.1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Write
function ImageToWrite = writeimage(ImageToWrite,save_path,name_num)
iptsetpref('ImshowBorder', 'tight')
ImageToWrite = double(ImageToWrite);
L=size(ImageToWrite,3); %判断通道数
if (L<3)
    ImageToWrite=ImageToWrite(:,:,[1 1 1]);  %转化为3通道
end

% 判断 若像素均为0，则显示0
ImageToWrite1=ImageToWrite(:,:,[1]);
[hang,lie]=size(ImageToWrite1);
num=hang*lie;
number=0;
for h=1:hang
    for l=1:lie
       if  (ImageToWrite1(h,l)==0)
           number=number+1;
       end
    end
end

if (number>num/2) % 判断 若像素均为0，则显示0
  imwrite(ImageToWrite1,strcat(save_path,name_num,'.tif')); %保存为黑色图像
    
else

    if nargin == 3  % nargin是用来判断输入变量个数
    tol1 = [0.01 0.99];
    tol = [tol1;tol1;tol1];
    ImageToWrite = linstretch(ImageToWrite,tol);  % linstretch 函数在下面定义  % Linear Stretching 线性拉伸
%     figure,imshow(ImageToWrite(:,:,3:-1:1),[])   %全色图像及多光谱图像显示

elseif nargin == 4
    if sum(tol1(2)+tol2(2)+tol3(2)) <= 3
        tol = [tol1;tol2;tol3];
        ImageToWrite = linstretch(ImageToWrite,tol);
%         figure,imshow(ImageToWrite(:,:,3:-1:1),[])
    else
        tol = [tol1;tol2;tol3];
        [N,M,~] = size(ImageToWrite);
        NM = N*M;
        for i=1:3
            b = reshape(double(uint16(ImageToWrite(:,:,i))),NM,1);
            b(b<tol(i,1))=tol(i,1);
            b(b>tol(i,2))=tol(i,2);
            b = (b-tol(i,1))/(tol(i,2)-tol(i,1));
            ImageToWrite(:,:,i) = reshape(b,N,M);
        end
%         figure,imshow(ImageToWrite(:,:,3:-1:1),[])
    end
    end

    iptsetpref('ImshowBorder', 'loose')  %获取图像处理工具箱参数设置


%%%%自己添加的  % 保存线性拉伸的图像
% imwrite(ImageToView(:,:,3:-1:1),'PanView.tif');   %保存全色图像
% imwrite(ImageToView(:,:,3:-1:1),'MsView.tif');    %保存多光谱图像
% imwrite(seg{i},strcat('m',int2str(i),'.bmp'));   %把第i帧的图片写为'mi.bmp'保存
% save_path='./Fusion_results/';   %路径
write_values=ImageToWrite(:,:,3:-1:1); %写入的值
imwrite(write_values,strcat(save_path,name_num,'.tif')); %写入
% imwrite(write_values,strcat(path,'ms',num2str(name_num),'.tif')); %写入
end

end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description: 
%           Linear Stretching. 
% 
% Interface:
%           ImageToView = linstretch(ImageToView,tol)
%
% Inputs:
%           ImageToView:    Image to stretch;
%           tol:            ;
%
% Outputs:
%           ImageToView:    Stretched image.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ImageToWrite = linstretch(ImageToWrite,tol)

[N,M,~] = size(ImageToWrite);  %图像的尺寸
NM = N*M;
for i=1:3
    b = reshape(double(uint16(ImageToWrite(:,:,i))),NM,1); %ImageToView(:,:,i) 某一通道图 ； % reshape 重新调整矩阵的行数、列数、维数
    [hb,levelb] = hist(b,max(b)-min(b));  %仅使用 hist 计算
    chb = cumsum(hb);
    t(1)=ceil(levelb(find(chb>NM*tol(i,1), 1 ))); %ceil 朝正无穷大方向取整
    t(2)=ceil(levelb(find(chb<NM*tol(i,2), 1, 'last' )));
    b(b<t(1))=t(1);
    b(b>t(2))=t(2);
    b = (b-t(1))/(t(2)-t(1));
    ImageToWrite(:,:,i) = reshape(b,N,M);
end

end