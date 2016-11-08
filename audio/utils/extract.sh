# NJU LAMDA Group
# Video classification contest
# Goal: Extract zip files in the current directory.
# Author: Hao Zhang
# Date: 2016.06.05
# File: extract.sh

for file in *.zip;
do unzip "${file}";
done
