im_data = load_database();
results = zeros(100,2);
for ii = 99:99
    count = 0;
    for jj = 1:1000
        [i,rand_idx] = facial_recognition(im_data,ii);
        if (i >= rand_idx) 
            i = i + 1;
        end
        if (floor(i / 10) == floor(rand_idx / 10))
            count = count + 1;
        end
    end
    results(ii,:) = [ii,count / 1000];
end
    