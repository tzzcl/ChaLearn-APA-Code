# NJU LAMDA Group
# Video classification contest
# Extract 4 kinds of features from wav files, and save them to disk.
#    MFCC
#    Filterbank Energies
#    * Log Filterbank Energies
#    Spectral Subband Centroids
# This file should be in 'data_wav/' folder
# Author: Hao Zhang
# Date: 2016.06.27
# File: wav2mfcc.py

import os
import scipy.io.wavfile as wav
import pylab
from features import logfbank

for f in os.listdir('./train_wav/'):
    frist_name = f[:-4]
    ext_name = f[-4:]
    if ext_name == '.wav':
        (rate,sig) = wav.read('./train_wav/' + f)
        logfbank_feat = logfbank(sig, rate)
        pylab.savetxt('../data_logfbank/train_logfbank/' + frist_name + '.csv', logfbank_feat, fmt='%.8f', delimiter=',')
        print f

for f in os.listdir('./test_wav/'):
    frist_name = f[:-4]
    ext_name = f[-4:]
    if ext_name == '.wav':
        (rate,sig) = wav.read('./test_wav/' + f)
        logfbank_feat = logfbank(sig, rate)
        pylab.savetxt('../data_logfbank/test_logfbank/' + frist_name + '.csv', logfbank_feat, fmt='%.8f', delimiter=',')
        print f
