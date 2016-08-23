classdef L2NORM < dagnn.ElementWise
  properties
    param = [5 1 0.0001/5 0.75]
  end

  methods
    function outputs = forward(obj, inputs, params)
      outputs{1} = vl_nnl2norm(inputs{1});
%       outputs{1} = vl_nnnormalize(inputs{1}, obj.param) ;
    end

    function [derInputs, derParams] = backward(obj, inputs, param, derOutputs)
      derInputs{1} = vl_nnl2norm(inputs{1}, derOutputs{1}) ;
%       derInputs{1} = vl_nnnormalize(inputs{1}, obj.param, derOutputs{1}) ;
      derParams = {} ;
    end

    function obj = L2NORM(varargin)
      obj.load(varargin) ;
    end
  end
end
