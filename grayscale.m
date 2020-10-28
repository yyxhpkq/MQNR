function Gray=grayscale(image)
[row,column,channel]=size(image);
Gray=zeros(row,column);
for k=1:1
for i=1:row
    for j=1:column
       % sum=0;
%         for k=1:3
         Gray(i,j,k)=0.299*image(i,j,1)+0.587*image(i,j,2)+0.11400*image(i,j,3);
%         end
        %Gray(i,j)=sum/channel;
    end
end
end
%  [z,y]=max(Gray(:));
%  Gray=Gray./z ;


