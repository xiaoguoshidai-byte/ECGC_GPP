clear;clc
cd F:\Matlab\GPP\data\ERA5_Land_005
fileFolder=fullfile('F:\Matlab\GPP\data\ERA5_Land_005');
dirOutput=dir(fullfile(fileFolder,'*.mat'));
name_ERA={dirOutput.name};
cd F:\Matlab\GPP\data\LAI_005
fileFolder=fullfile('F:\Matlab\GPP\data\LAI_005');
dirOutput=dir(fullfile(fileFolder,'*.mat'));
name_LAI={dirOutput.name};
cd F:\Matlab\GPP\arrangement\data\MCD12C1_change_allC4
fileFolder=fullfile('F:\Matlab\GPP\arrangement\data\MCD12C1_change_allC4');
dirOutput=dir(fullfile(fileFolder,'*.mat'));
name_IGBP={dirOutput.name};


for i = 1:21
    disp(i)
    cd F:\Matlab\GPP\arrangement\data\MCD12C1_change_allC4
    s1 = ['load ',name_IGBP{i},';'];
    eval(s1)
    cd F:\Matlab\GPP\data\ERA5_Land_005
    s2 = ['load ',name_ERA{i},';'];
    eval(s2)
    for n = 1:12
        cd F:\Matlab\GPP\data\LAI_005
        s4 = ['load ',name_LAI{n+12*(i-1)},';'];
        eval(s4)
        a = LAI_005==0;
        b = isnan(LAI_005);
        c = a+b;
        e(:,:,n) = c==0;
    end
    e = e+0;
    e(e==0) = nan;
    mask_LAI_FAPAR(:,:,2) = nanmean(e,3);
    mask_LAI_FAPAR = nanmean(mask_LAI_FAPAR,3);
    mask_LAI_FAPAR(isnan(mask_LAI_FAPAR)) = 0;
    mask_LAI_FAPAR = logical(mask_LAI_FAPAR);
    for j = 1:12
        cd F:\Matlab\GPP\data\LAI_005
        s4 = ['load ',name_LAI{j+12*(i-1)},';'];
        eval(s4)
        LAI_005(~mask_LAI_FAPAR) = nan;
        LAI(:,:,j) = LAI_005;
    end
    clear LAI_005
    IGBP_005(~mask_LAI_FAPAR) = nan;
    IGBP_005 = reshape(IGBP_005,2800*7200,1);
    for m = 1:12
        disp(m)
        a = ERA_ssrd_005(:,:,m);
        a(~mask_LAI_FAPAR) = nan;
        ERA_ssrd_005_r = reshape(a,2800*7200,1);
        a = ERA_t2m_005(:,:,m);
        a(~mask_LAI_FAPAR) = nan;
        ERA_t2m_005_r = reshape(a,2800*7200,1);
        a = ERA_tp_005(:,:,m);
        a(~mask_LAI_FAPAR) = nan;
        ERA_tp_005_r = reshape(a,2800*7200,1);
        a = ERA_VPD_005(:,:,m);
        a(~mask_LAI_FAPAR) = nan;
        ERA_VPD_005_r = reshape(a,2800*7200,1);
        LAI_r = reshape(LAI(:,:,m),2800*7200,1);
        total = [ERA_t2m_005_r ERA_ssrd_005_r ERA_VPD_005_r ERA_tp_005_r LAI_r IGBP_005];%温度 辐射 VPD 降水 LAI IGBP
        mask_ERA = isnan(total(:,1));
        mask_ERA = mask_ERA==0;
        mask_LAI = isnan(total(:,5));
        mask_LAI = mask_LAI==0;
        mask_IGBP = isnan(total(:,6));
        mask_IGBP = mask_IGBP==0;
        mask_total = mask_ERA.*mask_LAI.*mask_IGBP;
        for n = 1:6
            a = total(:,n);
            a(~mask_total) = nan;
            total(:,n) = a;
        end
        for k = 1:9
            disp(k)
            mask_veg = total(:,6)==k;
            for k1 = 1:5
                total_k1 = total(:,k1);
                total_5(:,k1) = total_k1(mask_veg);
            end
            cd F:\Matlab\GPP\arrangement\model\classify\veg_Mday_test
            s5 = ['load RF_GPP_',num2str(k),'.mat'];
            eval(s5)
            [RFPredictGPP,RFPredictConfidenceInterval]=predict(RFModel,total_5);
            cd F:\Matlab\GPP\code
            RFPredictGPP_r = remask_file(RFPredictGPP,mask_veg);
            RFPredictGPP_r_world(:,:,k) = reshape(RFPredictGPP_r,2800,7200);
            total_5 = [];
        end
        RFPredictGPP_r_world_sum = nansum(RFPredictGPP_r_world,3);
        cd F:\Matlab\GPP\data\GPP_005\classify\veg\C4_Mday_test
        s6 = ['save GPP_005_',name_ERA{i}(1:4),'_',num2str(m,'%02d') '.mat RFPredictGPP_r_world_sum;'];
        eval(s6)
    end
    mask_LAI_FAPAR = [];
end
