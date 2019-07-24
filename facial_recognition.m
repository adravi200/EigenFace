function [i,rand_idx] = facial_recognition(N)
    %%Math 214 Final Project - Face Recognition 
    % Aditya Ravi, Jag Wani, & Aditya Chitta

    %%Create Database of Images to Compare against Later
    % Loading the database into variable im_data
    im_data = load_database();


    % Essentially, from our database of 100 images, we are training this model
    % with 99 images and testing against a randomly selected one

    rand_idx = round(100*rand());     
    if (rand_idx == 0) 
        rand_idx = 1;
    end
    
    test_im = im_data(:,rand_idx);   %Set test_im as the rand_idx column of im_data

    train_im = im_data(:,[1:rand_idx-1 rand_idx+1:end]);  %train_im contains 
                                                      %the rest of the data

    %%To normalize the images we have, we have to subtract the "average" face
    %%from all of the images. The reason why this is necessary is because we 
    %%want to create a system that is able to represent any face. If we extract 
    %%this average from the pictures, the features that distinguish each picture 
    %%from the rest of the set are visible.

    mean_face = uint8(mean(train_im,2));  %Calculate mean face of each image

    train_num_cols = size(train_im,2);  

    x = uint8(ones(1,train_num_cols)); %Initialize a 1 x (# of cols of images) matrix
                                   % with 1s

    normalized_train = train_im - uint8(single(mean_face)*single(x)); %Subtract mean face

    %%Through PCA, we need to find the eigenvectors and then choose the
    % the N eigenvectors that have largest eigenvalues       
    L = single(normalized_train)'*single(normalized_train);
    [e_base,e_val_diag]=eig(L);   %e_val_diag is a diagonal matrix with 
                              %eigenvalues in increasing order and e_base
                              %is matrix comprised of the corresponding
                              %eigenvectors

    e_base=single(normalized_train)*e_base;

    e_base=e_base(:,end:-1:end-(N-1)); %Select N largest eigenfaces


    signatures=zeros(size(train_im,2),N);
    for i=1:size(train_im,2)
    signatures(i,:)=single(normalized_train(:,i))'*e_base;    % Each row is the signature for one image.
    end

     subplot(121); 
     imshow(reshape(test_im,112,92));
     title('Testing Image ...','FontWeight','bold','Fontsize',16,'color','red');
 
    subplot(122);
    normalized_test = test_im - mean_face;

    s = single(normalized_test)'*e_base;

    dist_calc=[];
    for i=1:size(train_im,2)
    dist_calc = [dist_calc,norm(signatures(i,:)-s,2)];
     if(rem(i,3)==0),imshow(reshape(train_im(:,i),112,92)),end;
     drawnow;
    end

    [a,i]=min(dist_calc);
    subplot(122);
    imshow(reshape(train_im(:,i),112,92));
    title('Found!','FontWeight','bold','Fontsize',16,'color','red');
end


