function out=load_database();
% We load the database the first time we run the program.

persistent loaded;
persistent w;
if(isempty(loaded))
    v=zeros(10304,30);
    for i = 1:10 %DELETE THIS
       cd(strcat('p',num2str(i)));
        for j=1:10
            if (i == 2) 
                a = imrotate(imresize(imread(strcat(num2str(j),'.pgm')),[92,112]),90);
            elseif (i == 4)
                a = imresize(imread(strcat(num2str(j),'.pgm')),[112,92]);
            else    
                a=imrotate(imresize(imread(strcat(num2str(j),'.pgm')),[92,112]),270);
            end
            v(:,(i-1)*10+j)=reshape(a,size(a,1)*size(a,2),1);
            %imshow(a)
        end
        cd ..
    end
    w=uint8(v); % Convert to unsigned 8 bit numbers to save memory. 
end
loaded=1;  % Set 'loaded' to aviod loading the database again. 
out=w;