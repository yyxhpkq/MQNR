
%% 裁剪图像像素
function imgs = modcrop(imgs, modulo)
if size(imgs,3)==1  %图像为单波段
    sz = size(imgs);
    sz = sz - mod(sz, modulo); %sz-sz/modulo的余数
    imgs = imgs(1:sz(1), 1:sz(2));
else   %图像为多波段
    tmpsz = size(imgs);
    sz = tmpsz(1:2);
    sz = sz - mod(sz, modulo);
    imgs = imgs(1:sz(1), 1:sz(2),:);
end
