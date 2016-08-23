val_dir = 'test_jpg';
run('/opt/zhangcl/matconvnet/matlab/vl_setupnn.m');
listing = dir(val_dir);
video_names = [];
sample_num = 100;
gpuDevice(15);

fileID = fopen('predictions_reg_avg_max_l28.csv','w');
A ={'VideoName','ValueExtraversion', 'ValueAgreeableness', 'ValueConscientiousness', 'ValueNeurotisicm','ValueOpenness'};
fprintf(fileID, '%s,', A{1,1:end-1});
fprintf(fileID, '%s\n', A{1,end});
net = load('data/exp_regression_avgmax_l28/net-epoch-1.mat');
net = net.net;
net = dagnn.DagNN.loadobj(net);
net.mode = 'test' ;
net.removeLayer('loss');
net.move('gpu') ;
imdb = load('imdb_train_v3.mat');
inputVar = 'x0';
for i=1:size(listing,1)
   if strcmp(listing(i).name,'.') || strcmp(listing(i).name,'..')
       continue
   end
   sub_listing = dir([val_dir '/' listing(i).name]);
   %%eval process
   labels = [];
   img1 = zeros(224,224,3,size(sub_listing,1));
   img1 = single(img1);
   for j=1:size(sub_listing,1)
       if strcmp(sub_listing(j).name,'.') || strcmp(sub_listing(j).name,'..')
        continue
       end
       im_ = imread([val_dir '/' listing(i).name '/' sub_listing(j).name]);
       im_ = imresize(im_,[224,224]);
       im_ = single(im_);
       
       im_ = bsxfun(@minus,im_,imresize(imdb.averageImage,[224,224])) ;
       %im_ = gpuArray(im_);
       class = [];
       img1(:,:,:,j) = im_;
       %res = vl_simplenn(net,im_);
   end
    img1 = img1(:,:,:,3:end);
       net.eval({inputVar,gpuArray(img1)});
       scores = squeeze(gather(net.vars(end).value)) ;
       labels = [labels;scores'];
   
   ans_label = mean(labels,1);
   disp(ans_label);
   disp(i);
   disp(listing(i).name);
   fprintf(fileID, '%s,', listing(i).name);
   for k=1:4
      fprintf(fileID,'%.6f,',ans_label(k)); 
   end
   fprintf(fileID,'%.6f\n',ans_label(5));
end
fclose(fileID);
