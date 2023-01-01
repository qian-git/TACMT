clear;clc;
video_path_0 =  '.\videos';
obj_video = dir(video_path_0);
obj_video_size = size(obj_video);
write_excel = {};
temp_0 = 1;

level2_number = 20;
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


for obj_num = 3:1:9%obj_video_size(1)
video_name = obj_video(obj_num).name;

video_name_number = obj_num;
video_path = strcat(video_path_0,'\',video_name);
video_path_out = '.\result_video';
pic_path = '.\pic\';
obj = VideoReader(video_path);
numframes = fix(obj.Duration * obj.FrameRate);
fen_x = 2;fen_y = 2;
row = obj.Height;col = obj.Width;
image_r = zeros(row,col,'uint8');
row2 = row/fen_x;col2 = col/fen_y;


if_change_layer = zeros(row2,col2); old_if_change_layer = zeros(row2,col2); older_if_change_layer = zeros(row2,col2);
actlayer1 = zeros(row2,col2); actlayer2 = zeros(row2,col2); 
dr_func_layer1 = zeros(3,3);dr_func_layer2 = zeros(3,3);func_layer3 = 0;func_layer4 = 0;
node_layer1_power = zeros(row2,col2,5);
note_change_old = 0;note_change_oneframe = 0;
%
object_pic = zeros(row,col);

% track_pic = zeros(row,col,'uint8');
begin_frame = 1; end_frame = fix(numframes);%574;%1311;1500
data_old_pre = zeros(row,col);data_old_ref = zeros(row,col);

ref_image = zeros(row,col,'uint8');
level2_data = zeros(end_frame-5,3);
for temp = begin_frame:1:(end_frame-5)
    frame = readFrame(obj);
    image_old = image_r;
    image_r = frame(:,:,1);

%     older_layer = old_layer; old_layer = layer1;
    older_if_change_layer = old_if_change_layer; old_if_change_layer = if_change_layer;
    
    expansion_alg = zeros(row2,col2);
    node_layer1_direct = zeros(row2,col2);
%     level2_position = zeros(6,4);


    if(temp==1)
        ref_image = image_r;
%         show = zeros(row,col,3);
    end
    if(temp > begin_frame)
        for i=1:row
            for j=1:col
                data_old_pre(i,j) = abs(image_r(i,j) - image_old(i,j));
                data_old_ref(i,j) = abs(image_r(i,j) - ref_image(i,j));
                
            end
        end
        
        for i=1:row
            for j=1:col
                if(data_old_ref(i,j) >= 20  )
                    if(data_old_pre(i,j) >= 25)
                        if(object_pic(i,j) == 0)
                            object_pic(i,j) = 1;
                        else 
                            object_pic(i,j) = 0;
                        end
%                     else
%                         object_pic(i,j) = object_pic(i,j);
                    end
                else
                    object_pic(i,j) = 0;
                end
            end
        end

        
        for i = 1:1:row2
           for j = 1:1:col2
               at_layer1_cnt = 0;
               for m = 1:fen_x
                  for n = 1:fen_y
                     if(object_pic((fen_x*i-fen_x+m),(fen_y*j-fen_y+n)) ~= 0)
                         at_layer1_cnt = at_layer1_cnt + 1;
                     end
                  end
               end
               if(at_layer1_cnt<2)
                   if_change_layer(i,j) = 0;
               else
                   if_change_layer(i,j) = 1;
               end
           end
        end
        for i = 1:1:row2
           for j = 1:1:col2
               actlayer1(i,j) = old_if_change_layer(i,j) - older_if_change_layer(i,j);
               actlayer2(i,j) = if_change_layer(i,j) - old_if_change_layer(i,j);
           end
        end

        for i = 2:1:row2-1
            for j = 2:1:col2-1
%                 power_p = zeros(1,5);
                dr_func_layer1 = actlayer1(i-1:i+1,j-1:j+1);
                dr_func_layer2 = actlayer2(i-1:i+1,j-1:j+1);
                func_layer3 = node_layer1_direct(i,j);
                func_layer4 = [node_layer1_power(i,j,1),node_layer1_power(i,j,2),node_layer1_power(i,j,3),node_layer1_power(i,j,4),node_layer1_power(i,j,5)];
                [node_layer1_direct(i,j),node_layer1_power(i,j,1)] = perceive_pix(dr_func_layer1,dr_func_layer2,func_layer3,func_layer4);
                node_layer1_power(i,j,5) = node_layer1_power(i,j,4);
                node_layer1_power(i,j,4) = node_layer1_power(i,j,3);
                node_layer1_power(i,j,3) = node_layer1_power(i,j,2);
                node_layer1_power(i,j,2) = node_layer1_power(i,j,1);
%                 node_layer1_power(i,j,1) = power_p;
            end
        end

        for i = 1:1:row2
            for j = 1:1:col2
                if(node_layer1_direct(i,j) ~= 0)
                    expansion_alg(i,j) = expansion_alg(i,j) + 1;
                    for m = -8:8
                       for n =  -8:8
                           if((m+i>0 && m+i<row2)&&(n+j>0 && n+j<col2) && (m~=0 || n~=0))
                               expansion_alg(i+m,j+n) =  expansion_alg(i+m,j+n) + 0.5;
                           end
                       end
                    end
                end
            end
        end
        for i = 1:1:row2
            for j = 1:1:col2
                if(expansion_alg(i,j) <= 4)
                    expansion_alg(i,j) = 0;
                end
            end
        end
    end

    

    %level2
    for i = 1:1:level2_number
        if(level2_node{i}.work_state == 1)
            [level2_node{i},expansion_alg] = level2_func(level2_node{i},node_layer1_direct,expansion_alg,row2,col2);
        end
    end
    %level2_info
    [level2_node] = left_data_level2input(level2_node,node_layer1_direct,expansion_alg,row2,col2,level2_number);

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
                level2_data(temp,:) = [obj_num,temp,level2_out(b,4)];
%                 fprintf(fid,'video_cnt: %d, temp: %d. node_id: %d, direct: %d\n',video_cnt,temp,level2_out(b,1),level2_out(b,4));
            end
        
    end
    


end

xlswrite('.\part1_excel\level2_data.xlsx',level2_data,num2str(obj_num),'A1');
end




    





