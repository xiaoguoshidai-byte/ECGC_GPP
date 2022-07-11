clear;clc
cd F:\Matlab\GPP\arrangement\data
load all_chuli_IGBP_Mday_test.mat data_total data_lab
load site.mat site_R2_RMSE

Input_all = [data_total2(:,1:5) data_total2(:,7)];
Output_all = data_lab2(:,1:2);

for i = 1:max(data_total(:,7))
    disp(i)
    pos = find(Input_all(:,6)==i);
    for j = 1:length(pos)
        s1 = ['Input_',num2str(i),'(',num2str(j),',:) = Input_all(pos(j),:);'];
        eval(s1)
    end
end

for i = 1:max(data_lab(:,2))
    disp(i)
    pos = find(Output_all(:,2)==i);
    for j = 1:length(pos)
        s2 = ['Output_',num2str(i),'(',num2str(j),',:) = Output_all(pos(j),:);'];
        eval(s2)
    end
end

for RFOptimizationNum = 1:9
    RFLeaf=[5,10,20,50,100,200,500];
    col='rgbcmyk';
    figure('Name','RF Leaves and Trees');
    for i=1:length(RFLeaf)
        RFModel=TreeBagger(300,Input,Output,'Method','R','OOBPrediction','On','MinLeafSize',RFLeaf(i));
        plot(oobError(RFModel),col(i));
        hold on
    end
    xlabel('Number of Grown Trees');
    ylabel('Mean Squared Error') ;
    LeafTreelgd=legend({'5' '10' '20' '50' '100' '200' '500'},'Location','NorthEast');
    title(LeafTreelgd,'Number of Leaves');
    hold off
    disp(RFOptimizationNum);
end

for n = 1:9
    disp(n)
    s3 = ['Input = Input_',num2str(n),';'];
    eval(s3)
    s4 = ['Output = Output_',num2str(n),';'];
    eval(s4)
    RandomNumber = (randperm(length(Output),floor(length(Output)*0)))';
    TrainYield = Output;
    TestYield = zeros(length(RandomNumber),1);
    TrainVARI = Input;
    TestVARI = zeros(length(RandomNumber),size(TrainVARI,2));
    for i = 1:length(RandomNumber)
        m = RandomNumber(i,1);
        TestYield(i,1) = TrainYield(m,1);
        TestVARI(i,:) = TrainVARI(m,:);
        TrainYield(m,1) = 0;
        TrainVARI(m,:) = 0;
    end
    TrainYield(all(TrainYield==0,2),:)=[];
    TrainVARI(all(TrainVARI==0,2),:)=[];
    RFModel = TreeBagger(nTree,TrainVARI(:,1:5),TrainYield(:,1),...
    'Method','regression','OOBPredictorImportance','on', 'MinLeafSize',nLeaf);
    cd F:\Matlab\GPP\arrangement\model\classify\veg_Mday_test
    s5 = ['save RF_GPP_',num2str(n),'.mat',' RFModel'];
    eval(s5)
end
