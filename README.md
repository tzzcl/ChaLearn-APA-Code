#Source codes of _NJU-LAMDA_ for the ChaLearn LAP 2016 challenge (The Code Follows MIT license.)

##This package was developed by Mr. Chen-Lin Zhang (zhangcl@lamda.nju.edu.cn). For any problem concerning the code, please feel free to contact Mr. Zhang. This packages are free for academic usage. You can run them at your own risk. For other purposes, please contact Prof. Jianxin Wu (wujx2001@gmail.com).


##Operating System:
####  Ubuntu Linux
##Requirements:
####  Matlab R2014b
####  GPU With CUDA Support
####  CUDNN
####  MatConvNet v1.0.20
####  LuaJIT
####  Torch7 (with cunn, cutorch support)
####  iTorch
####  python2.7
####  anaconda2
####  python_speech_features: https://github.com/jameslyons/python_speech_features
####  libxgboost
####  ipython
####  libffmpeg

##Setup:

####1. Extracting Images From Videos

####   First, please put the Test Video files into /test folder like training. For example, /test/testing80_01/a.mp4

####   Then, please use MATLAB and execute readdata_test.m. It will extract images from videos, and save as /test_jpg/a.mp4/1.jpg, etc.

####2. Extract Audio Feature From Video
####   Suppose you have download all the data needed in the current folder, these will be many *.zip files.

####Extract wav files from the mp4 video files
```bash
     shell extract.sh                # Unzip all the *.zip files.
     shell mp42wav.sh                # Extract wav files from mp4 files in the current directory.
```
####   Save these file into ./train_wav/ ./test_wav/ folders seperately

####Extract audio features from wav, each into a csv file.
```python
     python wav2logfbank.py
```
####   Concat those csv files into torch Tensors and save them to disk.
```bash
     cd ../data_logfbank/  
     th train2torch.lua              # Merge train csv files and save into disk.
```	 
####3. Predicting Model From Images

####   First, in eval_val_reg_resnet.m,eval_val_reg_avg_max.m and eval_val_reg_avg_max_l28.m line 2, please change MatConvNet location to your own MatConvNet location.

####   Then, please execute the aforementioned three MATLAB files. You will get predictions_reg_avg_max_l28.csv, predictions_reg_avg_max.csv and predictions_reg_res.csv.
   
####   Besides, You can change the model number from epoch-1 to epoch-2, you will get different results.
####4. Predict Model From Audio
####   jupyter notebook  # Open itorch notebook
   
####   Open and run logreg.ipynb file   # This is the main file to train the audio model.
####                                    # The trained model will be saved to disk to make prediction
									
####   Make predictions
```torch
    th predict.lua                  # Make predictions on the test data. 
                                    # Note the y_test.csv file must be provided.
                                    # The final predictions file is predictions.csv.
```									
####5. csv Order Transforming
####   In this Step, we change the generated “.csv” files in Step 3 and 4 into the correct order.

####   In MATLAB, please firstly use the “uiimport” command to import the generated “.csv” files.

####   Then, import correct examples like training_gt.csv or provided predictions_val.csv (only uiimport name column and rename it to VideoName_test).

####   Then, change the transform.m Line 1 to change the generated file name for the csv.

####   It will output the csv file in the correct order.

####6. Score Fusion and Output 
####   First, please use “uiimport” to import all the csv files into MATLAB (including redictions_reg_avg_max_l28.csv, predictions_reg_avg_max.csv, predictions_reg_res.csv and y_test.csv).

####   Then, please run the fusion.m. You will get the final output.
