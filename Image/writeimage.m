%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description: 
%           Visualization [3-2-1] of images with 3 bands by exploiting linear stretching and fixing the saturation. 
% 
% Interface:
%           ImageToWrite = viewimage(ImageToWrite,tol)
%
% Inputs:
%           ImageToWrite:    Image to write;   
%                           e.g.  writeimage(I_MS,1);  ֱ�ӱ���
%                           writeimage(I_MS(:,:,[1,3,5]),1) %���治ͬͨ��
%                           ����·�����Ը���
%           tol:            Saturation; Default values: [0.01 0.99] equal for all the three bands.
%           save_path:      �洢·��
%           name_num:       д����ļ����
% Outputs:
%           ImageToWrite:    Image to write.

% data:2018.11.1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Write
function ImageToWrite = writeimage(ImageToWrite,save_path,name_num)
iptsetpref('ImshowBorder', 'tight')
ImageToWrite = double(ImageToWrite);
L=size(ImageToWrite,3); %�ж�ͨ����
if (L<3)
    ImageToWrite=ImageToWrite(:,:,[1 1 1]);  %ת��Ϊ3ͨ��
end

% �ж� �����ؾ�Ϊ0������ʾ0
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

if (number>num/2) % �ж� �����ؾ�Ϊ0������ʾ0
  imwrite(ImageToWrite1,strcat(save_path,name_num,'.tif')); %����Ϊ��ɫͼ��
    
else

    if nargin == 3  % nargin�������ж������������
    tol1 = [0.01 0.99];
    tol = [tol1;tol1;tol1];
    ImageToWrite = linstretch(ImageToWrite,tol);  % linstretch ���������涨��  % Linear Stretching ��������
%     figure,imshow(ImageToWrite(:,:,3:-1:1),[])   %ȫɫͼ�񼰶����ͼ����ʾ

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

    iptsetpref('ImshowBorder', 'loose')  %��ȡͼ���������������


%%%%�Լ���ӵ�  % �������������ͼ��
% imwrite(ImageToView(:,:,3:-1:1),'PanView.tif');   %����ȫɫͼ��
% imwrite(ImageToView(:,:,3:-1:1),'MsView.tif');    %��������ͼ��
% imwrite(seg{i},strcat('m',int2str(i),'.bmp'));   %�ѵ�i֡��ͼƬдΪ'mi.bmp'����
% save_path='./Fusion_results/';   %·��
write_values=ImageToWrite(:,:,3:-1:1); %д���ֵ
imwrite(write_values,strcat(save_path,name_num,'.tif')); %д��
% imwrite(write_values,strcat(path,'ms',num2str(name_num),'.tif')); %д��
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

[N,M,~] = size(ImageToWrite);  %ͼ��ĳߴ�
NM = N*M;
for i=1:3
    b = reshape(double(uint16(ImageToWrite(:,:,i))),NM,1); %ImageToView(:,:,i) ĳһͨ��ͼ �� % reshape ���µ��������������������ά��
    [hb,levelb] = hist(b,max(b)-min(b));  %��ʹ�� hist ����
    chb = cumsum(hb);
    t(1)=ceil(levelb(find(chb>NM*tol(i,1), 1 ))); %ceil �����������ȡ��
    t(2)=ceil(levelb(find(chb<NM*tol(i,2), 1, 'last' )));
    b(b<t(1))=t(1);
    b(b>t(2))=t(2);
    b = (b-t(1))/(t(2)-t(1));
    ImageToWrite(:,:,i) = reshape(b,N,M);
end

end