fileID = fopen('predictions.csv','w')
A ={'VideoName','ValueExtraversion', 'ValueAgreeableness', 'ValueConscientiousness', 'ValueNeurotisicm','ValueOpenness'};
fprintf(fileID, '%s,', A{1,1:end-1});
fprintf(fileID, '%s\n', A{1,end});
for i=1:2000
    %fprintf(fileID,'%s,%.14f,%.14f,%.14f,%.14f,%.14f\n',VideoName{i},(ValueExtraversion(i)+ValueExtraversion1(i)+ValueExtraversion2(i))/3,(ValueAgreeableness(i)+ValueAgreeableness1(i)+ValueAgreeableness2(i))/3,(ValueConscientiousness(i)+ValueConscientiousness1(i)+ValueConscientiousness2(i))/3,(ValueNeurotisicm(i)+ValueNeurotisicm1(i)+ValueNeurotisicm2(i))/3,(ValueOpenness(i)+ValueOpenness1(i)+ValueOpenness2(i))/3);
    %fprintf(fileID,'%s,%.14f,%.14f,%.14f,%.14f,%.14f\n',VideoName{i},(ValueExtraversion(i)+ValueExtraversion1(i))/2,(ValueAgreeableness(i)+ValueAgreeableness1(i))/2,(ValueConscientiousness(i)+ValueConscientiousness1(i))/2,(ValueNeurotisicm(i)+ValueNeurotisicm1(i))/2,(ValueOpenness(i)+ValueOpenness1(i))/2);
    fprintf(fileID,'%s,%.14f,%.14f,%.14f,%.14f,%.14f\n',VideoName{i},(ValueExtraversion(i)+ValueExtraversion1(i)+ValueExtraversion2(i)+ValueExtraversion3(i))/4,(ValueAgreeableness(i)+ValueAgreeableness1(i)+ValueAgreeableness2(i)+ValueAgreeableness3(i))/4,(ValueConscientiousness(i)+ValueConscientiousness1(i)+ValueConscientiousness2(i)+ValueConscientiousness3(i))/4,(ValueNeurotisicm(i)+ValueNeurotisicm1(i)+ValueNeurotisicm2(i)+ValueNeurotisicm3(i))/4,(ValueOpenness(i)+ValueOpenness1(i)+ValueOpenness2(i)+ValueOpenness3(i))/4);
end
fclose(fileID);