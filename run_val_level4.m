% clc;clear;
level_data = cell(1,7);
for i = 1:1:10
    [level_data{i},~,~] = xlsread('.\part1_excel\level2_data_val.xlsx',num2str(i));
end

level_data_val = cell(1,9);
up_line = 0;
down_line = 0;
old_cnt_num = 0;
for i = 1:1:10
    last_flag = 0;num_flag = 0;
    [size_level,~] = size(level_data{i});
    down_line = size_level;
    for j = size_level-1:-1:1
        if(level_data{i}(j,1) == 0 && level_data{i}(j+1,1) ~= 0)
%             up_line = j;
            level_data_val{level_data{i}(j+1,1)+old_cnt_num}(:,2:4) = level_data{i}(j:down_line,:);
            level_data_val{level_data{i}(j+1,1)+old_cnt_num}(:,1) = i*ones(down_line-j+1,1);
            if(down_line == size_level)
                last_flag = 1;
                num_flag = level_data{i}(j+1,1);
            end
            down_line = j;
        end
    end
    old_cnt_num = old_cnt_num + num_flag;
end


model_number = 15;
model_upper = 200;
out_data = zeros(10000,5);
out_cnt = 1;
% model_number = 15;
% model_upper = 200;
% level4_number = 40;
% level4_node = cell(1,level4_number);
% for i = 1:1:level4_number
%     level4_node{i} = struct;
%     level4_node{i}.node_id = i;
%     level4_node{i}.work_state = 0;
%     level4_node{i}.receive = {}; 
%     level4_node{i}.model = cell(1,2);
%     level4_node{i}.model{1} = [];
%     level4_node{i}.model{2} = [];
% end

[~,size_list] = size(level_data_val);

video_list = [195,38,34,142,46,131,186,106,26,178,9,61,118,5,104,105,179,92,74,180,116,185,128,50,11,170,164,47,59,183,53,115,146,171,71,156,103,28,73,21,133,55,27,85,130,90,10,57,145,12,60,23,91,176,43,4,159,143,51,31,127,80,136,109,155,36,150,123,138,152,107,172,82,8,144,40,65,148,161,13,141,134,108,76,15,77,41,39,45,49,95,122,184,182,167,17,126,101,119,14,120,3,177,88,99,97,64,188,62,87,191,129,169,35,75,52,6,197,86,111,69,19,96,66,94,98,67,78,81,29,160,124,24,33,22,181,68,63,139,135,25,117,190,140,72,1,100,48,137,54,125,173,132,154,110,58,163,151,42,79,112,7,32,44,175,157,153,192,147,174,84,162,83,30,187,121,165,196,89,16,193,168,149,37,56,189,113,93,18,70,158,20,2,114,194,166,102];

for video_cnt = 1:1:size_list
% for video_cnt = 1:1:197
%     video = video_cnt;
    video = video_list(video_cnt);
%     [endframe,~] = size(level_data{video});
    [endframe,~] = size(level_data_val{video});
    
    
    for temp = 1:1:endframe
        level2_out(1,:) = [level_data_val{video}(temp,2),0,0,level_data_val{video}(temp,4)];
%         level2_out(1,:) = [level_data{video}(temp,1),0,0,level_data{video}(temp,3)];
        
        %level3&level4:
%         [level3_node] = level3_func(level3_node,level2_out);
        [level4_node] = Copy_of_level4_func(level4_node,level2_out,0.75,0.85,model_upper);

        %level5_accept_data:
%         level5_accept_data = zeros(2,level2_number);
%         for i = 1:1:level3_number
%             if(level3_node{i}.work_state == 1)
%                 if(~isempty(level3_node{i}.receive))
%                     [~,size_1] = size(level3_node{i}.receive);
%                     for j = 1:1:size_1
%                         if(length(level3_node{i}.receive{size_1}.output) > 1)
%                             level5_accept_data(1,level3_node{i}.receive{size_1}.output(1,1)) = level3_node{i}.receive{size_1}.output(1,2);
%                         end
%                     end
%                 end
%             end
%             if(level4_node{i}.work_state == 1)
%                 if(~isempty(level4_node{i}.receive))
%                     [~,size_1] = size(level4_node{i}.receive);
%                     for j = 1:1:size_1
%                         if(length(level4_node{i}.receive{size_1}.output) > 1)
%                             level5_accept_data(2,level4_node{i}.receive{size_1}.output(1,1)) = level4_node{i}.receive{size_1}.output(1,2);
%                         end
%                     end
%                 end
%             end
%         end
        
%         if(~isempty(level2_out))
%             [size_input,~] = size(level2_out);
%             for b = 1:1:size_input
%                 fprintf(fid,'video_cnt: %d, temp: %d. node_id: %d, direct: %d\n',video,temp,level2_out(b,1),level2_out(b,4));
%             end
%         end

%         if(video == 5)
%             for i = 1:1:level3_number
%                 if(level3_node{i}.work_state == 1)
%                     [~,size_receive] = size(level3_node{i}.receive);
%                     for j = 1:1:size_receive
%                         fprintf(fid,'count: %d, video: %d, temp: %d, level2_node: %d belongto_position: %d\n',video_cnt,video,temp,level3_node{i}.receive{j}.output(1),level3_node{i}.receive{j}.output(2));
%                     end
%                 end
%             end
            for i = 1:1:level4_number
                if(level4_node{i}.work_state == 1)
                    [~,size_receive] = size(level4_node{i}.receive);
                    for j = 1:1:size_receive
                        out_data(out_cnt,:) = [level_data_val{video}(temp,1:3),level4_node{i}.receive{j}.output];
                        out_cnt = out_cnt + 1;
%                         fprintf(fid,'count: %d, video: %d, temp: %d, level2_node: %d belongto_direct: %d\n',video_cnt,video,temp,level4_node{i}.receive{j}.output(1),level4_node{i}.receive{j}.output(2));
                    end
                end
            end
%         end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% output_pic
%         set (gcf,'position',[0,0,row_fig,col_fig]);
%         axis normal;
%         print(strcat(pic_path,sprintf('%05d.jpg',temp_0)),'-djpeg');
%         temp_0 = temp_0 + 1;
%         close all

    end
% for i = 1:1:level3_number
%     level3_node{i}.model = model_sub(level3_node{i}.model,model_upper);
% end
%level4_model - 1
if(mod(video_cnt,100) == 0)
    for i = 1:1:level4_number
        level4_node{i}.model = model_sub(level4_node{i}.model,model_upper);
    end
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
% fclose(fid);
out_data(out_cnt:10000,:) = [];


% xlswrite('.\part1_excel\level2_out_data.xlsx',level2_data,num2str(obj_num),'A1');
