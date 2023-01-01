clc;clear;
a_direct_source = cell(1,57);
a_expansion_alg_source = cell(1,57);
for i = 37:1:48
    [a_direct_source{i},~,~] = xlsread('.\part1_excel\direct_source.xlsx',num2str(i));
    [a_expansion_alg_source{i},~,~] = xlsread('.\part1_excel\expansion_alg_source.xlsx',num2str(i));
end

row0 = 580;col0 = 520; 
row = row0/2;col = col0/2;
% pic_path = '.\pic\';video_path_out = '.\result_video';

video_path_0 =  '.\videos';
obj_video = dir(video_path_0);
video_path_out = '.\result_video';
pic_path = '.\pic\';

 txt_path = '.\part1_excel\work.txt';
 fid = fopen(txt_path,'a');
temp_0 = 1;
model_number = 15;
model_upper = 100;
level2_number = 20;level3_number = 20;level5_number = 20;
level2_node = cell(1,level2_number);
for i = 1:1:level2_number
    level2_node{i} = struct;
    level2_node{i}.node_id = i;
    level2_node{i}.work_state = 0;
    level2_node{i}.position = zeros(1,4);
    level2_node{i}.sample_direct = 0;   
    level2_node{i}.time_direct = zeros(1,10);
    level2_node{i}.stay_data = 0;
    level2_node{i}.end_flag = 0;
end

level5_all_data = zeros(10,5);
leve5_cnt = 1;
% video_list = [6,6,3,6,5,3,4,5,6,6,3,6,6,4,6,3,4,6,6,6,5,3,6,6,5,6,5,4,5,3,5,3,4,3,3,6,5,4,6,3];
% video_list = [3,4,5,6,7,8,9,10,11,12,13,14,15];
% video_list = [16,17,18,19,20,21,22,23,24,25,26,27,28];
% video_list = [29,30,31,32,33,34,35,36];
video_list = [37,38,39,40,41,42,43,44,45,46,47,48];
[~,size_list] = size(video_list);
for video_cnt = 1:1:size_list
    video = video_list(video_cnt);
    [~,endframe] = size(a_direct_source{video});
    video_name = obj_video(video).name;
    video_path = strcat(video_path_0,'\',video_name);
    obj = VideoReader(video_path);
    row_fig = obj.Height;col_fig = obj.Width;
    
    level2_data = zeros(endframe,3);
    
    for temp = 1:1:endframe

        
        direct_source_frame_1 = reshape(a_direct_source{video}(:,temp),col,row);
        direct_source_frame = direct_source_frame_1';
        expansion_alg_source_frame_1 = reshape(a_expansion_alg_source{video}(:,temp),col,row);
        expansion_alg_source_frame = expansion_alg_source_frame_1';
        %level2
        for i = 1:1:level2_number
            if(level2_node{i}.work_state == 1)
                [level2_node{i},expansion_alg_source_frame] = level2_func(level2_node{i},direct_source_frame,expansion_alg_source_frame,row,col);
            end
        end
        %level2_info
        [level2_node] = left_data_level2input(level2_node,direct_source_frame,expansion_alg_source_frame,row,col,level2_number);

        %output_level2
        level2_out = zeros(level2_number,4);%input_array = [level2_node_id,position[2],direction] 4_bits
        for i = 1:1:level2_number
            if(level2_node{i}.work_state == 1)
                level2_out(i,:) = [level2_node{i}.node_id,abs((level2_node{i}.position(2)-level2_node{i}.position(1))),abs((level2_node{i}.position(4)-level2_node{i}.position(3))),level2_node{i}.sample_direct];
            end
        end
        for i = level2_number:-1:1
            if(all(level2_out(i,:) == zeros(1,4)))
                level2_out(i,:) = [];
            end
        end

        
        if(~isempty(level2_out))
            [size_input,~] = size(level2_out);
            for b = 1:1:size_input
                fprintf(fid,'video_cnt: %d, temp: %d. node_id: %d, direct: %d\n',video_cnt,temp,level2_out(b,1),level2_out(b,4));
            end
            level2_data(temp,:) = [video,temp,level2_out(b,4)];
        end


    end
    xlswrite('.\part1_excel\level2_data.xlsx',level2_data,num2str(video),'A1');

end
fclose(fid);

% pic2video(pic_path,video_path_out,1010);
% delete(strcat(pic_path,'*.jpg'))


