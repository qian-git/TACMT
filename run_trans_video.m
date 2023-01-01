clear;clc;
video_path_0 =  '.\videos';
obj_video = dir(video_path_0);
obj_video_size = size(obj_video);
write_excel = {};
temp_0 = 1;
for obj_num = 3:1:5%obj_video_size(1)
video_name = obj_video(obj_num).name;

video_name_number = obj_num;
video_path = strcat(video_path_0,'\',video_name);
video_path_out = '.\result_video';
pic_path = '.\pic\';
obj = VideoReader(video_path);
numframes = fix(obj.Duration * obj.FrameRate); 
fen_x = 2;fen_y = 2;
% row = obj.Height;col = obj.Width; 
% row = 1280;
% row = 400;
row = 580;
col = 520; 
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
for temp = begin_frame:1:(end_frame-10)
    frame = readFrame(obj);
    image_old = image_r;
%     image_r = frame(:,:,1);
    show = zeros(row,col,3,'uint8');
%     show = zeros(row,col,3,'uint8');
%     show(:,:,1) = frame(:,:,1);
%     show(:,:,1) = frame(351:930,101:620,1);
%     show(:,:,1) = frame(301:880,101:620,1);
    show(:,:,1) = frame(351:930,151:670,1);
%     show(:,:,1) = frame(451:830,151:570,1);
%     image_r = frame(451:830,151:570,1);
%     show(:,:,1) = frame(:,601:1080,1);
%     show(:,:,3) = frame(:,601:1080,2);
%     show(:,:,2) = frame(:,601:1080,3);
    
    
    for i = 1:1:row
        for j = 1:1:col
            if(show(i,j,1) < uint8(150))
                show(i,j,1) = uint8(0);
                image_r(i,j) = uint8(0);
            end
        end
    end
    %
%     older_layer = old_layer; old_layer = layer1;

%     level2_position = zeros(6,4);


%         show = zeros(row,col,3,'uint8');
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
    
    
    imwrite(show,strcat(pic_path,sprintf('%05d.jpg',temp)),'jpg');
%     direct_source(:,temp) = reshape(node_layer1_direct',[],1);
%     expansion_alg_source(:,temp) = reshape(expansion_alg',[],1);

end
%     direct_source(:,temp+1:end_frame) = [];
%     expansion_alg_source(:,temp+1:end_frame) = [];
% xlswrite('.\part1_excel\direct_source.xlsx',direct_source,num2str(video_name_number),'A1');
% xlswrite('.\part1_excel\expansion_alg_source.xlsx',expansion_alg_source,num2str(video_name_number),'A1');
true_name = erase(video_name,'.avi');
pic2video(pic_path,video_path_out,true_name);
delete(strcat(pic_path,'*.jpg'))
end