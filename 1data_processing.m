clc;clear
cd F:\Matlab\GPP\arrangement\data\MM
fileFolder=fullfile('F:\Matlab\GPP\arrangement\data\MM');
dirOutput=dir(fullfile(fileFolder,'*.csv'));
name={dirOutput.name};

for i = 1:206
     disp(i)
     eval(['file_data_MM = csvread(''F:\Matlab\GPP\arrangement\data\MM\',name{i},''',1);']);
     mat_name = name{i};
     mat_name = ['F:\Matlab\GPP\arrangement\data\MM\' mat_name '.mat'];
     save(mat_name,'file_data_MM');
end

clc;clear
cd F:\Matlab\GPP\arrangement\data\MM
fileFolder=fullfile('F:\Matlab\GPP\arrangement\data\MM');
dirOutput=dir(fullfile(fileFolder,'*.csv'));
name={dirOutput.name};
met_MM = {};
data = [];

for i = 1:206
    eval(['[file_data,txt] = xlsread(''F:\Matlab\GPP\arrangement\data\MM\',name{i},''');']);
    TA_F = find(strcmp(txt(1,:),'TA_F'));
    SW_IN_F = find(strcmp(txt(1,:),'SW_IN_F'));
    VPD_F = find(strcmp(txt(1,:),'VPD_F'));
    P_F = find(strcmp(txt(1,:),'P_F'));
    TIMESTAMP = find(strcmp(txt(1,:),'TIMESTAMP'));
    data(:,1) = file_data(:,TA_F);%Temperature
    data(:,2) = file_data(:,SW_IN_F);%Shortwave Radiation
    data(:,3) = file_data(:,VPD_F);%VPD
    data(:,4) = file_data(:,P_F);%Precipitation
    a = num2str(file_data(:,TIMESTAMP));%Time
    data(:,5) = str2num(a(:,1:4));%Year
    data(:,6) = str2num(a(:,5:6));%Month
    met_MM{i} = data;
    disp(i);
    data = [];
end
for i = 1:206
    disp(i)
    data2 = met_MM{i};
    data_min = min(data2(:,5));
    if data_min<1999
        data2(1:(1999-data_min)*12,:) = [];
    end
    met_MM_new{i} = data2;
end

cd F:\Matlab\GPP\arrangement\data
save met_Mday.mat met_MM_new -append

clc;clear
cd F:\Matlab\GPP\arrangement\data\MM
fileFolder=fullfile('F:\Matlab\GPP\arrangement\data\MM');
dirOutput=dir(fullfile(fileFolder,'*.csv'));
name={dirOutput.name};
GPP_MM = {};
gpp = [];

for i = 1:206
    eval(['[file_data,txt] = xlsread(''F:\Matlab\GPP\arrangement\data\MM\',name{i},''');']);
    n = find(strcmp(txt(1,:),'GPP_NT_VUT_REF'));
    TIMESTAMP = find(strcmp(txt(1,:),'TIMESTAMP'));
    gpp(:,1) = file_data(:,n);%NT_GPP
    a = num2str(file_data(:,TIMESTAMP));%Time
    gpp(:,2) = str2num(a(:,1:4));%Year
    gpp(:,3) = str2num(a(:,5:6));%Month
    GPP_MM{i} = gpp;
    disp(i);
    gpp = [];
end
for i = 1:206
    disp(i)
    data2 = GPP_MM{i};
    data_min = min(data2(:,2));
    if data_min<1999
        data2(1:(1999-data_min)*12,:) = [];
    end
    GPP_MM_new{i} = data2;
end

cd F:\Matlab\GPP\arrangement\data
save GPP_Mday.mat GPP_MM_new -append

clc;clear
cd F:\Matlab\GPP\arrangement\data
[num,txt,raw] = xlsread('flux_station_267站点名单.xlsx');
name_raw = raw(:,1);
cd F:\Matlab\GPP\arrangement\data\MM
fileFolder=fullfile('F:\Matlab\GPP\arrangement\data\MM');
dirOutput=dir(fullfile(fileFolder,'*.csv'));
name={dirOutput.name};
name = name';
for i = 1:206
    a = name{i};
    name{i} = a(5:10);
end

for i = 1:206
    for j = 1:267
        if name{i} == name_raw{j}
           name{i,2} = raw{j,4};
           name{i,3} = raw{j,5};
        end
    end
end
site_latlon = cell2mat(name(:,2:3));

for i = 1:206
    for j = 1:267
        if name{i} == name_raw{j}
           name{i,2} = raw{j,4};
           name{i,3} = raw{j,5};
           switch(raw{j,7})
               case 'DBF'
                    name{i,4} = 1;
               case 'ENF'
                    name{i,4} = 2;
               case 'EBF'
                    name{i,4} = 3;
               case 'MF'
                    name{i,4} = 4;
               case 'GRA'
                    name{i,4} = 5;
               case 'CRO'
                    name{i,4} = 6;
               case 'SAV'
                    name{i,4} = 5;
               case 'WSA'
                    name{i,4} = 5;
               case 'CSH'
                    name{i,4} = 8;
               case 'OSH'
                    name{i,4} = 8;
               case 'WET'
                    name{i,4} = 9;
               case 'SNO'
                    name{i,4} = 10;
           end
        end
    end
end

site_IGBP = cell2mat(name(:,4));

cd F:\Matlab\GPP\arrangement\data
save site.mat site_latlon site_IGBP -append

clc;clear
cd F:\Matlab\GPP\arrangement\data
load site.mat site_latlon

lat1 = linspace(80,-60,15681);
lon1 = linspace(-180,180,40321);
site_latlon_pos_1km = zeros(206,2);
for k = 1:206
    for i = 1:15680
        if site_latlon(k,1)<=lat1(i)&&site_latlon(k,1)>lat1(i+1)
           site_latlon_pos_1km(k,1)=i;
        end
    end
end
for k = 1:206
    for i = 1:40320
        if site_latlon(k,2)>=lon1(i)&&site_latlon(k,2)<lon1(i+1)
           site_latlon_pos_1km(k,2)=i;
        end
    end
end

cd F:\Matlab\GPP\arrangement\data
save site.mat site_latlon_pos_1km -append

clc;clear
cd F:\Matlab\GPP\arrangement\data
load site.mat site_latlon_pos_1km

fileFolder=fullfile('D:\data\GEOV2\FAPAR\FAPAR_99_14');
dirOutput=dir(fullfile(fileFolder,'*.nc'));
name={dirOutput.name};
FAPAR_zhandian = [];
FAPAR_zhandian_zong = {};
fileFolder2=fullfile('D:\data\GEOV2\LAI\LAI_99_14');
dirOutput2=dir(fullfile(fileFolder2,'*.nc'));
name2={dirOutput2.name};
LAI_zhandian = [];
LAI_zhandian_zong = {};
for i = 1:576
    disp(i);
    s1 = ['file_data_FAPAR = ncread(''D:\data\GEOV2\FAPAR\FAPAR_99_14\',name{i},''',''FAPAR'');'];
    s2 = ['file_data_LAI = ncread(''D:\data\GEOV2\LAI\LAI_99_14\',name2{i},''',''LAI'');'];
    eval(s1);
    eval(s2);
    FAPAR = flip(rot90(file_data_FAPAR),1);
    LAI = flip(rot90(file_data_LAI),1);
    for j = 1:206
        FAPAR_zhandian(j) = FAPAR(site_latlon_pos_1km(j,1),site_latlon_pos_1km(j,2));
        LAI_zhandian(j) = LAI(site_latlon_pos_1km(j,1),site_latlon_pos_1km(j,2));
    end
    FAPAR_zhandian_zong{i} = FAPAR_zhandian;
    LAI_zhandian_zong{i} = LAI_zhandian;
end

cd F:\Matlab\GPP\arrangement\data
save LAI_FAPAR_zhandian_zong.mat LAI_zhandian_zong FAPAR_zhandian_zong -append

clc;clear
cd F:\Matlab\GPP\arrangement\data
load GPP_Mday.mat
load met_Mday.mat
load LAI_FAPAR_zhandian_zong.mat

FAPAR = {};
LAI = {};
fileFolder=fullfile('F:\Matlab\GPP\arrangement\data\MM');
dirOutput=dir(fullfile(fileFolder,'*.csv'));
name={dirOutput.name};
for i = 1:206
    disp(i)
    eval(['[file_data,txt] = xlsread(''F:\Matlab\GPP\arrangement\data\MM\',name{i},''');']);
    d = file_data(:,1);
    d = num2str(d);
    year = str2num(d(:,1:4));
    year = unique(year);
    gap = year - 1999;
    gap = gap(gap>-1&gap<16);
    down = min(gap);
    up = max(gap);
    down = down*36+1;up = (up+1)*36;
    a = FAPAR_zhandian_zong(down:up);
    for j = 1:length(a)
        b = a{j};
        c(j) = b(i);
    end
    f = length(c)/3;
    for k = 1:f
        e(k) = mean(c((k-1)*3+1:3*k));
    end
    FAPAR{i} = e;
    a = [];
    b = [];
    c = [];
    d = [];
    e = [];
    f = [];
end

for i = 1:206
    disp(i)
    eval(['[file_data,txt] = xlsread(''F:\Matlab\GPP\arrangement\data\MM\',name{i},''');']);
    d = file_data(:,1);
    d = num2str (d);
    year = str2num(d(:,1:4));
    year = unique(year);
    gap = year - 1999;
    gap = gap(gap>-1&gap<16);
    down = min(gap);
    up = max(gap);
    down = down*36+1;up = (up+1)*36;
    a = LAI_zhandian_zong(down:up);
    for j = 1:length(a)
        b = a{j};
        c(j) = b(i);
    end
    f = length(c)/3;
    for k = 1:f
        e(k) = mean(c((k-1)*3+1:3*k));
    end
    LAI{i} = e;
    a = [];
    b = [];
    c = [];
    d = [];
    e = [];
    f = [];
end

cd F:\Matlab\GPP\arrangement\data
save LAI_FAPAR.mat FAPAR LAI -append

clear;clc
cd F:\Matlab\GPP\arrangement\data
load site.mat site_IGBP

for i = 1:576
    IGBP_zhandian_zong{i} = site_IGBP';
end

IGBP = {};
fileFolder=fullfile('F:\Matlab\GPP\arrangement\data\MM');
dirOutput=dir(fullfile(fileFolder,'*.csv'));
name={dirOutput.name};
for i = 1:206
    disp(i)
    eval(['[file_data,txt] = xlsread(''F:\Matlab\GPP\arrangement\data\MM\',name{i},''');']);
    d = file_data(:,1);
    d = num2str (d);
    year = str2num(d(:,1:4));
    year = unique(year);
    gap = year - 1999;
    gap = gap(gap>-1&gap<16);
    down = min(gap);
    up = max(gap);
    down = down*36+1;up = (up+1)*36;
    a = IGBP_zhandian_zong(down:up);
    for j = 1:length(a)
        b = a{j};
        c(j) = b(i);
    end
    f = length(c)/3;
    for k = 1:f
        e(k) = mode(c((k-1)*3+1:3*k),'all');
    end
    IGBP{i} = e;
    a = [];
    b = [];
    c = [];
    d = [];
    e = [];
    f = [];
end

for i = 1:206
    name2{i} = name{i}(5:10);
end
IGBP(2,:) = name2;
site_C4 = {'BE-Lon','DE-Kli','FR-Gri','IT-BCi','US-ARM','US-Ne1','US-Ne2','US-Ne3'};
for i = 1:length(site_C4)
    C4_pos = find(strcmp(IGBP(2,:),site_C4{i}));
    disp(C4_pos)
    switch(site_C4{i})
        case 'BE-Lon'%1
            a = IGBP{1,C4_pos};
            a(97:108) = 7;%2012
            IGBP{1,C4_pos} = a;
            a = [];
        case 'DE-Kli'%2
            a = IGBP{1,C4_pos};
            a(37:48) = 7;%2007
            a(97:108) = 7;%2012
            IGBP{1,C4_pos} = a;
            a = [];
        case 'FR-Gri'%3
            a = IGBP{1,C4_pos};
            a(37:48) = 7;%2007
            a(97:108) = 7;%2012
            IGBP{1,C4_pos} = a;
            a = [];
        case 'IT-BCi'%4
            a = IGBP{1,C4_pos};
            a(1:96) = 7;%2004-2011
            IGBP{1,C4_pos} = a;
            a = [];
        case 'US-ARM'%5
            a = IGBP{1,C4_pos};
            a(25:36) = 7;%2005
            a(61:72) = 7;%2008
            IGBP{1,C4_pos} = a;
            a = [];
        case 'US-Ne1'%6
            a = IGBP{1,C4_pos};
            a(1:144) = 7;%2001-2012
            IGBP{1,C4_pos} = a;
            a = [];
        case 'US-Ne2'%7
            a = IGBP{1,C4_pos};
            a(1:12) = 7;%2001
            a(25:36) = 7;%2003
            a(49:60) = 7;%2005
            a(73:84) = 7;%2007
            a(97:108) = 7;%2009
            a(109:120) = 7;%2010
            a(121:132) = 7;%2011
            a(133:144) = 7;%2012
            IGBP{1,C4_pos} = a;
            a = [];
        case 'US-Ne3'%8
            a = IGBP{1,C4_pos};
            a(1:12) = 7;%2001
            a(25:36) = 7;%2003
            a(49:60) = 7;%2005
            a(73:84) = 7;%2007
            a(97:108) = 7;%2009
            a(121:132) = 7;%2011
            IGBP{1,C4_pos} = a;
            a = [];
    end
end

cd F:\Matlab\GPP\arrangement\data
save LAI_FAPAR_zhandian_zong.mat IGBP_zhandian_zong -append
save LAI_FAPAR.mat IGBP -append
