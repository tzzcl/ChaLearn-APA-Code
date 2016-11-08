%%prepare to read train file
train_dir = 'test';
listing = dir(train_dir);
video_names = [];
raw_names = [];
sample_num = 100;
%%read all training file names
for i=1:size(listing,1)
   if strcmp(listing(i).name,'.') || strcmp(listing(i).name,'..')
       continue
   end
   sub_listing = dir([train_dir '/' listing(i).name]);
   for j=1:size(sub_listing,1)
       if strcmp(sub_listing(j).name,'.') || strcmp(sub_listing(j).name,'..')
        continue
       end
       video_name = [train_dir '/' listing(i).name '/' sub_listing(j).name];
       video_names = [video_names;video_name];
       raw_names = [raw_names;sub_listing(j).name];
   end
end
mkdir('test_jpg')
datalens = []

for i=1:size(video_names,1)
   now_name = video_names(i,:); 
   v = VideoReader(now_name);
   location = fullfile('test_jpg',raw_names(i,:));
   mkdir(location)
   datas = []; 
   cnt = 0;
   while hasFrame(v)
       datas = cat(4,datas,imresize(readFrame(v),[224 224]));
       %readFrame(v);
       cnt = cnt + 1;
   end
   datalen = round((cnt - 1) / sample_num);
   samples = 1:datalen:cnt;
   datalens = [datalens size(samples,2)];
   fprintf('%d %d\n',i,size(samples,2))
   for j=1:size(samples,2)
       imwrite(datas(:,:,:,j),[location '/' num2str(j) '.jpg']);
   end
end

