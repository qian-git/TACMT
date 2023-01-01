% clc;clear;
% [data_out,~,~] = xlsread('.\part1_excel\inD_output.xlsx','Sheet3');
% 
% [size_da,~] = size(data_out);
% pic_obj = zeros(size_da,319);
% for i = 3:1:size_obj
%     track_id = str2double(erase(obj_video(i).name,'.png'));
%     pic_obj(i-2) = track_id;
%     new_data{track_id} = zeros(1867,6);
%     new_cnt = 1;
%     for j = 1:1:size_da
%         if(track_id == data_out(j,2))
%             new_data{track_id}(new_cnt,:) = data_out(j,:);
%             new_cnt = new_cnt + 1;
%         end
%     end
%     new_data{track_id}(new_cnt:1867,:) = [];
% end

%%%%%%%%%%%%%%%%%%%%%%% 输出最终选择,查看序列使用

data_out = out_data;
[size_data,~] = size(data_out);
new_data1 = zeros(1000,4);
count = 1;
old_id = 0;
for i = 1:1:size_data
    if(i ~= 1)
        if(data_out(i,2) == 0 && old_id ~= 0)
            new_data1(count,:) = [data_out(i-1,1:3),data_out(i-1,5)];
            count = count + 1;
        end
        if(data_out(i,2) ~= 0 && data_out(i-1,2) == 0)
            old_id = data_out(i,2);
        end
    else
        old_id = data_out(i,2);
    end
end
new_data1(count:1000,:) = [];

%%%%%%%%%%%%%%%%%%%%%%% 计算正确率
[size_new,~] = size(new_data1);
pp = zeros(3,11);
for i = 1:1:size_new
    if(new_data1(i,2) ~= 0)
        if(new_data1(i,1) == 10)
            if(new_data1(i,4) == 1)
                pp(1,10) = pp(1,10) + 1;
            end
            pp(2,10) = pp(2,10) + 1;
        else
            col = new_data1(i,1);
            if(new_data1(i,4) == col + 1)
                pp(1,col) = pp(1,col) + 1;
            end
            pp(2,col) = pp(2,col) + 1;
        end
    end
end
for i = 1:1:10
    pp(3,i) = pp(1,i)/pp(2,i);
    pp(1,11) = pp(1,11) + pp(1,i);
    pp(2,11) = pp(2,11) + pp(2,i);
end
pp(3,11) = pp(1,11)/pp(2,11);
