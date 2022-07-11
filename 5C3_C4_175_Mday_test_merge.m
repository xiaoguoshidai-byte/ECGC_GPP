clear;clc
cd F:\Matlab\GPP\arrangement\data\C3_C4
load C3_C4.mat C4_total_005_ratio
cd F:\Matlab\GPP\data\GPP_005\classify\veg\C3_Mday_test
fileFolder_C3=fullfile('F:\Matlab\GPP\data\GPP_005\classify\veg\C3_Mday_test');
dirOutput_C3=dir(fullfile(fileFolder_C3,'*.mat'));
cd F:\Matlab\GPP\code
name_C3=sort_nat({dirOutput_C3.name});
cd F:\Matlab\GPP\data\GPP_005\classify\veg\C4_Mday_test
fileFolder_C4=fullfile('F:\Matlab\GPP\data\GPP_005\classify\veg\C4_Mday_test');
dirOutput_C4=dir(fullfile(fileFolder_C4,'*.mat'));
cd F:\Matlab\GPP\code
name_C4=sort_nat({dirOutput_C4.name});

mask_ratio = logical(C4_total_005_ratio);
for i = 19:21
    disp(i)
    year = i+1998;
    for j = 1:12
        disp(j)
        cd F:\Matlab\GPP\data\GPP_005\classify\veg\C3_Mday_test
        s1 = ['load GPP_005_',num2str(year),'_',num2str(j,'%02d'),' RFPredictGPP_r_world_sum'];
        eval(s1)
        a(:,:,1) = RFPredictGPP_r_world_sum;
        cd F:\Matlab\GPP\data\GPP_005\classify\veg\C4_Mday_test
        s2 = ['load GPP_005_',num2str(year),'_',num2str(j,'%02d'),' RFPredictGPP_r_world_sum'];
        eval(s2)
        a(:,:,2) = RFPredictGPP_r_world_sum;
        in_a(:,:,1) = a(:,:,1).*mask_ratio;%C3
        in_a(:,:,2) = a(:,:,2).*mask_ratio;%C4
        in_a(:,:,3) = in_a(:,:,1).*(1-C4_total_005_ratio) + in_a(:,:,2).*C4_total_005_ratio;
        out_a(:,:,1) = a(:,:,1).*~mask_ratio;
        out_a(:,:,2) = a(:,:,2).*~mask_ratio;
        out_a(:,:,3) = (out_a(:,:,1)+out_a(:,:,2))/2;
        RFPredictGPP = out_a(:,:,3) + in_a(:,:,3);
        cd F:\Matlab\GPP\data\GPP_005\classify\veg\C3_C4_Mday_175_test
        s3 = ['save ',name_C4{(i-1)*12+j},' RFPredictGPP'];
        eval(s3)
        a = [];in_a = [];out_a = [];RFPredictGPP = [];
    end
end
