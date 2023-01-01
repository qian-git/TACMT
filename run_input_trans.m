clear;clc;
video_path_0 =  '.\videos';
obj_video = dir(video_path_0);
obj_video_size = size(obj_video);
write_excel = {};
temp_0 = 1;
for obj_num = 3:1:6%obj_video_size(1)
video_name = obj_video(obj_num).name;
video_name_number = obj_num;
video_path = strcat(video_path_0,'\',video_name);
video_path_out = '.\result_video';
pic_path = '.\pic\';
obj = VideoReader(video_path);
numframes = obj.Duration * obj.FrameRate;
fen_x = 2;fen_y = 2;
% row = obj.Height;col = obj.Width; 
row = 720;col = 480; 
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

all_col = row2 * col2;
all_col_4 = all_col/4;
direct_source = zeros(all_col,end_frame);
expansion_alg_source = zeros(all_col,end_frame);
for temp = begin_frame:1:end_frame
    frame = readFrame(obj);
    image_old = image_r;
    image_r = frame(:,:,1);
%     show(:,:,1) = frame(:,601:1080,1);
%     show(:,:,3) = frame(:,601:1080,2);
%     show(:,:,2) = frame(:,601:1080,3);
    show = zeros(row,col,3,'uint8');
%     show = frame;
    %
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

%         for i = 1:1:row
%            for j = 1:1:col
%                actlayer1(i,j) = old_layer(i,j) - older_layer(i,j);
%                actlayer2(i,j) = layer1(i,j) - old_layer(i,j);
%            end
%         end
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
        
%         if(any(any(node_layer1_power)))
%            expan_0 = 0;
%         else
%             node_layer1_direct = node_old_direct;
%             expan_0 = 1;
%         end
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
%         show = zeros(row,col,3);
%         for i = 1:1:row2
%             for j = 1:1:col2
%                 if(expansion_alg(i,j) ~= 0)
%                     if(node_layer1_direct(i,j) ~= 0)
%                         if(node_layer1_direct(i,j) == 1)
%                             show(2*i-1:2*i,2*j-1:2*j,1) = 255;
%                             show(2*i-1:2*i,2*j-1:2*j,2) = 0;
%                             show(2*i-1:2*i,2*j-1:2*j,3) = 255;
%                         elseif(node_layer1_direct(i,j) == 2)
%                             show(2*i-1:2*i,2*j-1:2*j,1) = 255;
%                             show(2*i-1:2*i,2*j-1:2*j,2) = 0;
%                             show(2*i-1:2*i,2*j-1:2*j,3) = 102;
%                         elseif(node_layer1_direct(i,j) == 3)
%                             show(2*i-1:2*i,2*j-1:2*j,1) = 255;
%                             show(2*i-1:2*i,2*j-1:2*j,2) = 153;
%                             show(2*i-1:2*i,2*j-1:2*j,3) = 51;
%                         elseif(node_layer1_direct(i,j) == 4)
%                             show(2*i-1:2*i,2*j-1:2*j,1) = 204;
%                             show(2*i-1:2*i,2*j-1:2*j,2) = 255;
%                             show(2*i-1:2*i,2*j-1:2*j,3) = 51;
%                         elseif(node_layer1_direct(i,j) == 5)
%                             show(2*i-1:2*i,2*j-1:2*j,1) = 51;
%                             show(2*i-1:2*i,2*j-1:2*j,2) = 204;
%                             show(2*i-1:2*i,2*j-1:2*j,3) = 51;
%                         elseif(node_layer1_direct(i,j) == 6)
%                             show(2*i-1:2*i,2*j-1:2*j,1) = 0;
%                             show(2*i-1:2*i,2*j-1:2*j,2) = 255;
%                             show(2*i-1:2*i,2*j-1:2*j,3) = 204;
%                         elseif(node_layer1_direct(i,j) == 7)
%                             show(2*i-1:2*i,2*j-1:2*j,1) = 0;
%                             show(2*i-1:2*i,2*j-1:2*j,2) = 153;
%                             show(2*i-1:2*i,2*j-1:2*j,3) = 255;
%                         elseif(node_layer1_direct(i,j) == 8)
%                             show(2*i-1:2*i,2*j-1:2*j,1) = 102;
%                             show(2*i-1:2*i,2*j-1:2*j,2) = 102;
%                             show(2*i-1:2*i,2*j-1:2*j,3) = 255;
%                         end
%                     end
% %                     show(2*i-1:2*i,2*j-1:2*j,1) = 255;
% %                     show(2*i-1:2*i,2*j-1:2*j,2) = 255;
% %                     show(2*i-1:2*i,2*j-1:2*j,3) = 255;
%                 end
%             end
%         end
    end
    imwrite(show,strcat(pic_path,sprintf('%05d.jpg',temp)),'jpg');
    direct_source(:,temp) = reshape(node_layer1_direct',[],1);
    expansion_alg_source(:,temp) = reshape(expansion_alg',[],1);
end

xlswrite('.\part1_excel\direct_source.xlsx',direct_source,num2str(video_name_number),'A1');
xlswrite('.\part1_excel\expansion_alg_source.xlsx',expansion_alg_source,num2str(video_name_number),'A1');
% pic2video(pic_path,video_path_out,video_name_number);
% delete(strcat(pic_path,'*.jpg'))
end