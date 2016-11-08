function [net, info] = train_regression_DANplus(varargin)
opt.model = 'vgg-face';
run('/opt/zhangcl/matconvnet/matlab/vl_setupnn.m');
net = load(['/opt/zhangcl/' opt.model '.mat']);
net = dagnn.DagNN.fromSimpleNN(net);
%net = net.net;
inputVar = 'data' ;

%[opts, varargin] = vl_argparse(opts, varargin) ;
opts.imdbPath = [];
opts.networkType = 'dagnn' ;
for name = {'fc8','prob','fc7','relu7','fc6','relu6'}
      net.removeLayer(name) ;
end
net.addLayer('l28_max',dagnn.Pooling('method','max','poolSize',[14 14],'stride',1,'pad',0),'x28','x28_max');
net.addLayer('l28_avg',dagnn.Pooling('method','avg','poolSize',[14 14],'stride',1,'pad',0),'x28','x28_avg');
net.addLayer('pool6_max',dagnn.Pooling('method','max','poolSize',[7 7],'stride',1,'pad',0),'x31','x32_max');
net.addLayer('pool6_avg',dagnn.Pooling('method','avg','poolSize',[7 7],'stride',1,'pad',0),'x31','x32_avg');
net.addLayer('norm6_max',L2NORM(),'x32_max','x32_max_norm');
net.addLayer('norm6_avg',L2NORM(),'x32_avg','x32_avg_norm');
net.addLayer('norm6_avg_l28',L2NORM(),'x28_avg','x28_avg_norm');
net.addLayer('norm6_max_l28',L2NORM(),'x28_max','x28_max_norm');
net.addLayer('concat',dagnn.Concat,{'x32_max_norm','x32_avg_norm','x28_avg_norm','x28_max_norm'},'x32_concat');
fc5 = dagnn.Conv('size',[1 1 2048 5],'pad',0,'stride',1,'hasBias',true);
net.addLayer('fc5',fc5,{'x32_concat'},{'fc5'},{'fc5_conv','fc5_bias'});
net.addLayer('prob',dagnn.Sigmoid(),{'fc5'},{'prob'});
net.addLayer('loss',dagnn.Loss('loss','pdist'),{'prob','label'},{'objective'});
net.params(27).value = single(0.05*randn(1,1,2048,5));
net.params(28).value = single(zeros(1,5)');
%[opts, varargin] = vl_argparse(opts, varargin) ;
opts.imdbPath = [];
opts.networkType = 'dagnn' ;
opts.train = struct() ;
opts.train.expDir = fullfile('data','exp_regression_avgmax_l28');
opts.train.gpus = [13];
opts.train.batchSize = 32;
opts.train.learningRate = logspace(-3,-6,30);
opts.train.numEpochs = 10;
opts = vl_argparse(opts, varargin) ;
if ~isfield(opts.train, 'gpus'), opts.train.gpus = []; end;

% -------------------------------------------------------------------------
%                                                    Prepare model and data
% -------------------------------------------------------------------------


%net.meta.classes.name = imdb.meta.classes(:)' ;

% -------------------------------------------------------------------------
%                                                                     Train
% -------------------------------------------------------------------------

switch opts.networkType
  case 'simplenn', trainfn = @cnn_train ;
  case 'dagnn', trainfn = @cnn_train_dag ;
end
imdb=load('imdb_train_v3.mat');
%imdb=imdb.imdb_now;
[net, info] = trainfn(net, imdb, getBatch(opts), ...
  opts.train) ;

% -------------------------------------------------------------------------
function fn = getBatch(opts)
% -------------------------------------------------------------------------
switch lower(opts.networkType)
  case 'simplenn'
    fn = @(x,y) getSimpleNNBatch(x,y) ;
  case 'dagnn'
    bopts = struct('numGpus', numel(opts.train.gpus)) ;
    fn = @(x,y) getDagNNBatch(bopts,x,y) ;
end

% -------------------------------------------------------------------------
function [images, labels] = getSimpleNNBatch(imdb, batch)
% -------------------------------------------------------------------------

%images = imdb.images.data(:,:,:,batch) ;
images = [];

for i=1:length(batch)
    im_ = imread(['train_jpg_2/' imdb.images.name{batch(i)}]);
    
    im_ = imresize(im_,[224 224]);
    im_ = single(im_);
    im_ = bsxfun(@minus,im_,imresize(imdb.averageImage,[224,224])) ;
    images = cat(4,images,im_);
end
labels(1,1,:,:) = imdb.images.class(batch,:)';
if rand > 0.5, images=fliplr(images) ; end

% -------------------------------------------------------------------------
function inputs = getDagNNBatch(opts, imdb, batch)
% -------------------------------------------------------------------------
images = [];
for i=1:length(batch)
    im_ = imread(['train_jpg_2/' imdb.images.name{batch(i)}]);
    
    im_ = imresize(im_,[224 224]);
    im_ = single(im_);
    im_ = bsxfun(@minus,im_,imresize(imdb.averageImage,[224,224])) ;
    images = cat(4,images,im_);
end
labels(1,1,:,:) = imdb.images.class(batch,:)';
if rand > 0.5, images=fliplr(images) ; end
if opts.numGpus > 0
  images = gpuArray(images) ;
end
inputs = {'x0', images, 'label', labels} ;
% -------------------------------------------------------------------------

