% clc;clear;
% a_direct_source = cell(1,15);
% a_expansion_alg_source = cell(1,15);
% for i = 3:1:15
%     [a_direct_source{i},~,~] = xlsread('.\part1_excel\direct_source.xlsx',num2str(i));
%     [a_expansion_alg_source{i},~,~] = xlsread('.\part1_excel\expansion_alg_source.xlsx',num2str(i));
% end

level2_data = {};

row0 = 380;col0 = 420; 
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
level3_node = cell(1,level3_number);
for i = 1:1:level3_number
    level3_node{i} = struct;
    level3_node{i}.node_id = i;
    level3_node{i}.work_state = 0;
    level3_node{i}.receive = {}; 
    level3_node{i}.model = cell(1,2);
    level3_node{i}.model{1} = [];
    level3_node{i}.model{2} = [];
end
level4_number = level3_number;
level4_node = cell(1,level3_number);
for i = 1:1:level3_number
    level4_node{i} = struct;
    level4_node{i}.node_id = i;
    level4_node{i}.work_state = 0;
    level4_node{i}.receive = {};
    level4_node{i}.model = cell(1,2);
    level4_node{i}.model{1} = [];
    level4_node{i}.model{2} = [];
end
% level5_node = cell(1,level5_number);
% for i = 1:1:level5_number
%     level5_node{i} = struct;
%     level5_node{i}.node_id = i;
%     level5_node{i}.work_state = 0;
%     level5_node{i}.receive = {}; 
%     level5_node{i}.model = cell(1,2);
%     level5_node{i}.model{1} = [];
%     level5_node{i}.model{2} = [];
% end
% level5_input_data = [];
% level6_number = level5_number;
% level6_node = cell(1,level6_number);
% for i = 1:1:level6_number
%     level6_node{i} = struct;
%     level6_node{i}.node_id = i;
%     level6_node{i}.work_state = 0;
%     level6_node{i}.valid_in = 0;
%     level6_node{i}.receive_id = 0;
%     level6_node{i}.receive_data = 0;
%     level6_node{i}.receive_flag = 0;
%     level6_node{i}.series = 0;
%     level6_node{i}.output = 0;
%     level6_node{i}.series_end = 0;
%     level6_node{i}.work_mode = 0;
%     level6_node{i}.model = cell(1,2);
%     level6_node{i}.model{1} = [];
%     level6_node{i}.model{2} = [];
%     level6_node{i}.model_cnt = 0;
% end


level5_all_data = zeros(10,5);
leve5_cnt = 1;
% video_list = [6,6,3,6,5,3,4,5,6,6,3,6,6,4,6,3,4,6,6,6,5,3,6,6,5,6,5,4,5,3,5,3,4,3,3,6,5,4,6,3];
video_list = [3,4,5,6,7,8,9,10,11,12,13,14,15];
[~,size_list] = size(video_list);
for video_cnt = 1:1:size_list
    video = video_list(video_cnt);
    [~,endframe] = size(a_direct_source{video});
    video_name = obj_video(video).name;
    video_path = strcat(video_path_0,'\',video_name);
    obj = VideoReader(video_path);
    row_fig = obj.Height;col_fig = obj.Width;
    
    
    for temp = 1:1:endframe
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% output_pic
%         show = readFrame(obj);
%         set(figure(1),'visible','off');
%         imshow(show,'border','tight','initialmagnification','fit');
        
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
        
        %level3&level4:
%         [level3_node] = level3_func(level3_node,level2_out);
        [level4_node] = level4_func(level4_node,level2_out);

        %level5_accept_data:
        level5_accept_data = zeros(2,level2_number);
        for i = 1:1:level3_number
            if(level3_node{i}.work_state == 1)
                if(~isempty(level3_node{i}.receive))
                    [~,size_1] = size(level3_node{i}.receive);
                    for j = 1:1:size_1
                        if(length(level3_node{i}.receive{size_1}.output) > 1)
                            level5_accept_data(1,level3_node{i}.receive{size_1}.output(1,1)) = level3_node{i}.receive{size_1}.output(1,2);
                        end
                    end
                end
            end
            if(level4_node{i}.work_state == 1)
                if(~isempty(level4_node{i}.receive))
                    [~,size_1] = size(level4_node{i}.receive);
                    for j = 1:1:size_1
                        if(length(level4_node{i}.receive{size_1}.output) > 1)
                            level5_accept_data(2,level4_node{i}.receive{size_1}.output(1,1)) = level4_node{i}.receive{size_1}.output(1,2);
                        end
                    end
                end
            end
        end
        
        if(~isempty(level2_out))
            [size_input,~] = size(level2_out);
            for b = 1:1:size_input
                fprintf(fid,'video_cnt: %d, temp: %d. node_id: %d, direct: %d\n',video_cnt,temp,level2_out(b,1),level2_out(b,4));
            end
        end

%         if(video == 5)
%             for i = 1:1:level3_number
%                 if(level3_node{i}.work_state == 1)
%                     [~,size_receive] = size(level3_node{i}.receive);
%                     for j = 1:1:size_receive
%                         fprintf(fid,'count: %d, video: %d, temp: %d, level2_node: %d belongto_position: %d\n',video_cnt,video,temp,level3_node{i}.receive{j}.output(1),level3_node{i}.receive{j}.output(2));
%                     end
%                 end
%             end
%             for i = 1:1:level3_number
%                 if(level4_node{i}.work_state == 1)
%                     [~,size_receive] = size(level4_node{i}.receive);
%                     for j = 1:1:size_receive
%                         fprintf(fid,'count: %d, video: %d, temp: %d, level2_node: %d belongto_direct: %d\n',video_cnt,video,temp,level4_node{i}.receive{j}.output(1),level4_node{i}.receive{j}.output(2));
%                     end
%                 end
%             end
%         end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% output_pic
%         set (gcf,'position',[0,0,row_fig,col_fig]);
%         axis normal;
%         print(strcat(pic_path,sprintf('%05d.jpg',temp_0)),'-djpeg');
%         temp_0 = temp_0 + 1;
%         close all

    end
    %level3_model - 1
for i = 1:1:level3_number
    level3_node{i}.model = model_sub(level3_node{i}.model,model_upper);
end
%level4_model - 1
for i = 1:1:level3_number
    level4_node{i}.model = model_sub(level4_node{i}.model,model_upper);
end
%level5_model - 1
% for i = 1:1:level5_number
%     level5_node{i}.model = model_sub(level5_node{i}.model,model_upper);
% end
% %level6_model - 1
% for i = 1:1:level6_number
%     level6_node{i}.model = model_sub(level6_node{i}.model,model_upper);
%     if(~any(level6_node{i}.model{1}))
%         level6_node{i}.work_mode = 0;
%     end
% end    

end
fclose(fid);

% pic2video(pic_path,video_path_out,1010);
% delete(strcat(pic_path,'*.jpg'))


