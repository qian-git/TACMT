clc;clear;
level_data = cell(1,7);
for i = 3:1:48
    [level_data{i},~,~] = xlsread('.\part1_excel\level2_data.xlsx',num2str(i));
end

row0 = 380;col0 = 420; 
row = row0/2;col = col0/2;
% pic_path = '.\pic\';video_path_out = '.\result_video';




%  txt_path = '.\part1_excel\work.txt';
%  fid = fopen(txt_path,'a');
temp_0 = 1;
model_number = 15;
model_upper = 100;
% level2_number = 20;level3_number = 40;level5_number = 20;
% level3_node = cell(1,level3_number);
% for i = 1:1:level3_number
%     level3_node{i} = struct;
%     level3_node{i}.node_id = i;
%     level3_node{i}.work_state = 0;
%     level3_node{i}.receive = {}; 
%     level3_node{i}.model = cell(1,2);
%     level3_node{i}.model{1} = [];
%     level3_node{i}.model{2} = [];
% end
level4_number = 40;
level4_node = cell(1,level4_number);
for i = 1:1:level4_number
    level4_node{i} = struct;
    level4_node{i}.node_id = i;
    level4_node{i}.work_state = 0;
    level4_node{i}.receive = {}; 
    level4_node{i}.model = cell(1,2);
    level4_node{i}.model{1} = [];
    level4_node{i}.model{2} = [];
end


% video_list = [6,6,3,6,5,3,4,5,6,6,3,6,6,4,6,3,4,6,6,6,5,3,6,6,5,6,5,4,5,3,5,3,4,3,3,6,5,4,6,3];
% video_list = [3,4,5,6,7,8,9,10,11,12,13,14,15];
video_list = [3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48];
[~,size_list] = size(video_list);
for video_cnt = 1:1:size_list
    video = video_list(video_cnt);
    [endframe,~] = size(level_data{video});

    
    
    for temp = 1:1:endframe

        level2_out(1,:) = [level_data{video}(temp,1),0,0,level_data{video}(temp,3)];
        
        %level3&level4:
%         [level3_node] = level3_func(level3_node,level2_out);
        [level4_node] = level4_func(level4_node,level2_out,0.85,model_upper);

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
% for i = 1:1:level3_number
%     level3_node{i}.model = model_sub(level3_node{i}.model,model_upper);
% end
% %level4_model - 1
% for i = 1:1:level3_number
%     level4_node{i}.model = model_sub(level4_node{i}.model,model_upper);
% end


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

% pic2video(pic_path,video_path_out,1010);
% delete(strcat(pic_path,'*.jpg'))


