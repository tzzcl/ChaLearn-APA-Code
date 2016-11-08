# NJU LAMDA Group
# Video classification contest
# Extract wav files from mp4 files in the current directory.
# Author: Hao Zhang
# Date: 2016.06.05
# File: mp42wav.sh

#for file in *.mp4;
for file in $(ls | grep .mp4);
do 
#    echo $file
    name1=$(ls "$file" | cut -d. -f1)
    name2=$(ls "$file" | cut -d. -f2)
    name=$name1.$name2
#    echo "$name"

    # -vn: remove the video and take audio out uncompressed (output.wav)
    # -ar: sample rate of 44100 Hz (-ar 44100) 
    # -ac: 2 channels (stereo) (-ac 2)
    ffmpeg -i "${file}" -ab 320k -ac 2 -ar 44100 -vn ${name}.wav;
done


