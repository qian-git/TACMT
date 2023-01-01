function [ node_struct,node_struct_mult,level5_out_clear,level5_output,level6_2_output,level6_3_output ] = level5_func( node_struct,input_data,node_struct_mult )

model_cnt_initial = 50;
[~,size_input] = size(input_data);
[~,level_number] = size(node_struct);
% level5_output = zeros(2,level_number);
% level5_output_cnt = 0;
% PX_flag = 0.75;PX_half = 0.5;PX_merge = 0.85;
PX_flag = 0.51;PX_half = 0.5;
for i = size_input:-1:1
    if(input_data(1,i) == 0 && input_data(2,i) == 0)
        input_data(:,i) = [];
    end
end
[~,size_input] = size(input_data);

for i = 1:1:level_number
    if(node_struct{i}.work_state == 1 && ~isempty(node_struct{i}.receive))
        [~,size_receive] = size(node_struct{i}.receive);
        for j = size_receive:-1:1
            if(node_struct{i}.receive{j}.need_clear == 1)
                node_struct{i}.receive(j) = [];
            end
        end
        if(isempty(node_struct{i}.receive))
            node_struct{i}.work_state = 0;
        end
    else
        node_struct{i}.work_state = 0;
        node_struct{i}.receive = {};
    end
end

for i = 1:1:size_input
    data_accept = 0;
    for j = 1:1:level_number
        if(node_struct{j}.work_state == 1 && ~isempty(node_struct{j}.receive))
            [~,size_receive] = size(node_struct{j}.receive);
            for k = 1:1:size_receive
                if(node_struct{j}.receive{k}.receive_id == input_data(3,i))
                    node_struct{j}.receive{k}.accept_data = 1;
                    [~,size_series] = size(node_struct{j}.receive{k}.series);
                    if(all(node_struct{j}.receive{k}.series(:,size_series) == [input_data(1,i);input_data(2,i)]))
                        node_struct{j}.receive{k}.valid_in = 0;
                    else
                        if(input_data(2,i) ~= 999 && input_data(1,i) ~= 999)
                            node_struct{j}.receive{k}.series(:,size_series+1) = [input_data(1,i);input_data(2,i)];
                        end
%                         if(node_struct{j}.receive{k}.series(1,size_series) == 999 || node_struct{j}.receive{k}.series(2,size_series) == 999)
%                             node_struct{j}.receive{k}.series(:,size_series) = [input_data(1,i);input_data(2,i)];
%                         else
%                             node_struct{j}.receive{k}.series(:,size_series+1) = [input_data(1,i);input_data(2,i)];
%                         end
                        node_struct{j}.receive{k}.valid_in = 1;
                    end
                    data_accept = 1;
                    break;
                end
            end
            if(data_accept == 1)
                break;
            end
        end
    end
    if(data_accept == 0 && (input_data(2,i) ~= 999 && input_data(1,i) ~= 999))
        node_choose = zeros(1,level_number);
        for j = 1:1:level_number
            if(~isempty(node_struct{j}.model{1}))
                [~,size_model] = size(node_struct{j}.model{1});
                for k = 1:1:size_model
                    if(all(node_struct{j}.model{1}(:,k) == [input_data(1,i);input_data(2,i)]))
                        node_choose(j) = node_struct{j}.model{2}(1,k);
                        break;
                    end
                end
            end
        end
        [max_PX,pointer_PX] = max(node_choose);
        if(max_PX ~= 0)
            if(~isempty(node_struct{pointer_PX}.receive))
                [~,size_pointer_receive] = size(node_struct{pointer_PX}.receive);
                node_struct{pointer_PX}.receive{size_pointer_receive + 1} = struct;
                node_struct{pointer_PX}.receive{size_pointer_receive + 1}.receive_id = input_data(3,i);
                node_struct{pointer_PX}.receive{size_pointer_receive + 1}.valid_in = 1;
                node_struct{pointer_PX}.receive{size_pointer_receive + 1}.input_direct = 0;
                node_struct{pointer_PX}.receive{size_pointer_receive + 1}.series_invalid = 0;
                node_struct{pointer_PX}.receive{size_pointer_receive + 1}.series = [input_data(1,i);input_data(2,i)];
                node_struct{pointer_PX}.receive{size_pointer_receive + 1}.output = 0;
                node_struct{pointer_PX}.receive{size_pointer_receive + 1}.history_output = 0;
                node_struct{pointer_PX}.receive{size_pointer_receive + 1}.accept_data = 1;
                node_struct{pointer_PX}.receive{size_pointer_receive + 1}.series_end = 0;
                node_struct{pointer_PX}.receive{size_pointer_receive + 1}.need_clear = 0;
            else
                node_struct{pointer_PX}.receive{1} = struct;
                node_struct{pointer_PX}.receive{1}.receive_id = input_data(3,i);
                node_struct{pointer_PX}.receive{1}.valid_in = 1;
                node_struct{pointer_PX}.receive{1}.input_direct = 0;
                node_struct{pointer_PX}.receive{1}.series_invalid = 0;
                node_struct{pointer_PX}.receive{1}.series = [input_data(1,i);input_data(2,i)];
                node_struct{pointer_PX}.receive{1}.output = 0;
                node_struct{pointer_PX}.receive{1}.history_output = 0;
                node_struct{pointer_PX}.receive{1}.accept_data = 1;
                node_struct{pointer_PX}.receive{1}.series_end = 0;
                node_struct{pointer_PX}.receive{1}.need_clear = 0;
            end
            node_struct{pointer_PX}.work_state = 1;
        else
            for j = 1:1:level_number
                if(~any(any(node_struct{j}.model{1})) && isempty(node_struct{j}.receive))
                    node_struct{j}.receive{1} = struct;
                    node_struct{j}.receive{1}.receive_id = input_data(3,i);
                    node_struct{j}.receive{1}.valid_in = 1;
                    node_struct{j}.receive{1}.input_direct = 0;
                    node_struct{j}.receive{1}.series_invalid = 0;
                    node_struct{j}.receive{1}.series = [input_data(1,i);input_data(2,i)];
                    node_struct{j}.receive{1}.output = 0;
                    node_struct{j}.receive{1}.history_output = 0;
                    node_struct{j}.receive{1}.accept_data = 1;
                    node_struct{j}.receive{1}.series_end = 0;
                    node_struct{j}.receive{1}.need_clear = 0;
                    node_struct{j}.work_state = 1;
                    break;
                end
            end
        end
    end
end

for i = 1:1:level_number
    if(node_struct{i}.work_state == 1 && ~isempty(node_struct{i}.receive))
        [~,size_receive] = size(node_struct{i}.receive);
        for j = 1:1:size_receive
            if(node_struct{i}.receive{j}.accept_data ~= 1)
                node_struct{i}.receive{j}.series_end = 1;
            end
        end
    end
end

% work_list = zeros(1,size_node); 
for i = 1:1:level_number
    if(~any(node_struct{i}.model{1}))
        build_model = 1;
    else
        build_model = 0;
    end
    if(node_struct{i}.work_state == 1 && ~isempty(node_struct{i}.receive))
        [~,size_receive] = size(node_struct{i}.receive);
%         need_new_model = zeros(1,size_receive);
%         need_eliminate = zeros(1,size_receive);
        for j = 1:1:size_receive
%             PX = 0;
            if(node_struct{i}.receive{j}.valid_in == 1 || node_struct{i}.receive{j}.series_end == 1)
                [~,size_series] = size(node_struct{i}.receive{j}.series);
                if(build_model == 0)
                    [LCS] = match_model(node_struct{i}.model{1},node_struct{i}.receive{j}.series);
                    [px_model,px_series] = cal_match(node_struct{i}.model,node_struct{i}.receive{j}.series,LCS,3);
%                     [~,size_LCS] = size(LCS);
%                     PX = size_LCS/size_series;
                    if(size_series > 2 || node_struct{i}.receive{j}.series_end == 1)
                        if(px_model == 1 && px_series >= PX_flag)
%                         if(PX >= PX_flag)
                            node_struct{i}.receive{j}.output = node_struct{i}.node_id;
                        else
                            node_struct{i}.receive{j}.output = 0;
                            node_struct{i}.receive{j}.series_invalid = 1;
                            node_struct{i}.receive{j}.need_clear = 1;
                        end
                        if(node_struct{i}.receive{j}.series_end == 1)
                            if(px_model == 1 && px_series >= PX_flag+0.1)
%                             if(PX >= PX_merge)
                                node_struct{i}.model = model_fusion_position(LCS,node_struct{i}.model,{node_struct{i}.receive{j}.series,model_cnt_initial*ones(1,size_series)});%model_cnt_
                            end
                            node_struct{i}.receive{j}.need_clear = 1;
                        end
                    else
                        if(px_model == 1 && px_series >= PX_half)
%                         if(PX>=PX_half)
                            node_struct{i}.receive{j}.output = node_struct{i}.node_id;
                        else
                            node_struct{i}.receive{j}.output = 0;
                            node_struct{i}.receive{j}.series_invalid = 1;
                            node_struct{i}.receive{j}.need_clear = 1;
                        end
                    end
                else
                    if(node_struct{i}.receive{j}.series_end == 1)
                        if(node_struct{i}.receive{j}.series(1,1) ~= 999 || node_struct{i}.receive{j}.series(2,1) ~= 999)
                            node_choose = zeros(1,level_number);
                            for m = 1:1:level_number
                                if(m ~= node_struct{i}.node_id && ~isempty(node_struct{m}.model{1}))
                                    [LCS_1] = match_model(node_struct{m}.model{1},node_struct{i}.receive{j}.series);
                                    [px_model,px_series] = cal_match(node_struct{m}.model,node_struct{i}.receive{j}.series,LCS_1,3);
                                    if(px_model == 1)
                                        node_choose(1,m) = px_series;
                                    else
                                        node_choose(1,m) = 0;
                                    end
%                                     [~,size_series] = size(node_struct{i}.receive{j}.series);
%                                     [~,size_LCS_1] = size(LCS_1);
%             %                         node_choose(1,m) = size_LCS_1/size_series;
%                                     if(size_LCS_1 == 0)
%                                         node_choose(m) = 0;
%                                     else
%                                         for k = 1:1:size_LCS_1
%                                             node_choose(m) = node_choose(m) + node_struct{m}.model{2}(LCS_1(3,k));
%                                         end
%                                         node_choose(m) = node_choose(m)/size_series;
%                                     end
                                end
                            end
                            [max_PX,pointer_PX] = max(node_choose);
                            if(max_PX >= PX_flag)
                                if(max_PX >= PX_flag+0.1) %merge_model
                                    [LCS_1] = match_model(node_struct{pointer_PX}.model{1},node_struct{i}.receive{j}.series);
                                    node_struct{i}.model = model_fusion_position(LCS_1,node_struct{pointer_PX}.model,{node_struct{i}.receive{j}.series,model_cnt_initial*ones(1,size_series)});%model_cnt_
                                end
                                node_struct{i}.receive{j}.output = pointer_PX;
                                build_model = 0;
                                node_struct{i}.receive{j}.need_clear = 1;
                            else
                                node_struct{i}.model{1} = node_struct{i}.receive{j}.series;
                                node_struct{i}.model{2} = model_cnt_initial*ones(1,size_series);%model_cnt_
                                node_struct{i}.receive{j}.output = node_struct{i}.node_id;
                                build_model = 0;
                                node_struct{i}.receive{j}.need_clear = 1;
                            end
                        else
                            node_struct{i}.receive{j}.need_clear = 1;
                            node_struct{i}.receive{j}.output = 0;
                        end
                    end
                end
            end
%             if(PX >= PX_merge && node_struct{i}.receive{j}.series_end == 1)
%                 node_struct{i}.model = model_fusion_position(LCS,node_struct{i}.model,{node_struct{i}.receive{j}.series,model_cnt_initial*ones(1,size_series)});%model_cnt_
% %                 need_eliminate(j) = 1;
%             end
            node_struct{i}.receive{j}.valid_in = 0;
            node_struct{i}.receive{j}.accept_data = 0;
            node_struct{i}.receive{j}.input_direct = 0;
        end
        for j = size_receive:-1:1 %trans info
            if(node_struct{i}.receive{j}.series_invalid == 1)
                node_choose = zeros(1,level_number);
                for m = 1:1:level_number
                    if(m ~= node_struct{i}.node_id && ~isempty(node_struct{m}.model{1}))
                        [LCS_1] = match_model(node_struct{m}.model{1},node_struct{i}.receive{j}.series);
                        [px_model,px_series] = cal_match(node_struct{m}.model,node_struct{i}.receive{j}.series,LCS_1,3);
                        if(px_model == 1)
                            node_choose(1,m) = px_series;
                        else
                            node_choose(1,m) = 0;
                        end
%                         [~,size_LCS_1] = size(LCS_1);
%                         [~,size_series] = size(node_struct{i}.receive{j}.series);
%                         node_choose(1,m) = size_LCS_1/size_series;
%                         if(size_LCS_1 == 0)
%                             node_choose(m) = 0;
%                         else
%                             for k = 1:1:size_LCS_1
%                                 node_choose(m) = node_choose(m) + node_struct{m}.model{2}(LCS_1(3,k));
%                             end
%                             node_choose(m) = node_choose(m)/size_series;
%                         end
                    end
                end
                [max_PX,pointer_PX] = max(node_choose);
                if(max_PX >= PX_half)
                    if(~isempty(node_struct{pointer_PX}.receive))
                        [~,size_pointer_receive] = size(node_struct{pointer_PX}.receive);
                        node_struct{pointer_PX}.receive{size_pointer_receive + 1} = struct;
                        node_struct{pointer_PX}.receive{size_pointer_receive + 1}.receive_id = node_struct{i}.receive{j}.receive_id;
                        node_struct{pointer_PX}.receive{size_pointer_receive + 1}.valid_in = 0;
                        node_struct{pointer_PX}.receive{size_pointer_receive + 1}.input_direct = 0;
                        node_struct{pointer_PX}.receive{size_pointer_receive + 1}.series = node_struct{i}.receive{j}.series;
                        node_struct{pointer_PX}.receive{size_pointer_receive + 1}.output = pointer_PX;
                        node_struct{pointer_PX}.receive{size_pointer_receive + 1}.accept_data = 0;
                        node_struct{pointer_PX}.receive{size_pointer_receive + 1}.series_end = node_struct{i}.receive{j}.series_end;
                        node_struct{pointer_PX}.receive{size_pointer_receive + 1}.need_clear = 0;
                        node_struct{pointer_PX}.receive{size_pointer_receive + 1}.series_invalid = 0;
                    else
                        node_struct{pointer_PX}.receive{1} = struct;
                        node_struct{pointer_PX}.receive{1}.receive_id = node_struct{i}.receive{j}.receive_id;
                        node_struct{pointer_PX}.receive{1}.valid_in = 0;
                        node_struct{pointer_PX}.receive{1}.input_direct = 0;
                        node_struct{pointer_PX}.receive{1}.series = node_struct{i}.receive{j}.series;
                        node_struct{pointer_PX}.receive{1}.output = pointer_PX;
                        node_struct{pointer_PX}.receive{1}.accept_data = 0;
                        node_struct{pointer_PX}.receive{1}.series_end = node_struct{i}.receive{j}.series_end;
                        node_struct{pointer_PX}.receive{1}.need_clear = 0;
                        node_struct{pointer_PX}.receive{1}.series_invalid = 0;
                    end
                    node_struct{pointer_PX}.work_state = 1;
                else%转移到新节点
                    for m = 1:1:level_number
                        if(~any(any(node_struct{m}.model{1})) && m ~= i && isempty(node_struct{m}.receive))
                            node_struct{m}.receive{1} = struct;
                            node_struct{m}.receive{1}.receive_id = node_struct{i}.receive{j}.receive_id;
                            node_struct{m}.receive{1}.valid_in = 0;
                            node_struct{m}.receive{1}.input_direct = 0;
                            node_struct{m}.receive{1}.series = node_struct{i}.receive{j}.series;
                            node_struct{m}.receive{1}.output = 0;
                            node_struct{m}.receive{1}.accept_data = 0;
                            node_struct{m}.receive{1}.series_end = node_struct{i}.receive{j}.series_end;
                            node_struct{m}.receive{1}.need_clear = 0;
                            node_struct{m}.receive{1}.series_invalid = 0;
                            node_struct{m}.work_state = 1;
                            break;
                        end
                    end
                end
                node_struct{i}.receive(j) = [];
            end
        end
        if(isempty(node_struct{i}.receive))
            node_struct{i}.work_state = 0;
        end
    else
        node_struct{i}.work_state = 0;
        node_struct{i}.receive = {};
    end
end
level5_output = zeros(2,level_number);
level5_output_cnt = 0;
for i = 1:1:level_number
    if(node_struct{i}.work_state == 1 && ~isempty(node_struct{i}.receive))
        [~,size_receive] = size(node_struct{i}.receive);
        for j = 1:1:size_receive
            if(node_struct{i}.receive{j}.output ~= 0)
                level5_output(1,level5_output_cnt+1) = node_struct{i}.receive{j}.receive_id;
                level5_output(2,level5_output_cnt+1) = node_struct{i}.receive{j}.output;
                level5_output_cnt = level5_output_cnt + 1;
            end
        end
    end
end

for i = level_number:-1:1
    if(level5_output(1,i) == 0 && level5_output(2,i) == 0)
        level5_output(:,i) = [];
    end
end
% [~,size_level5_out] = size(level5_output);
% [~,size_level6] = size(node_struct_mult);
size_level5_out = 0;
size_level6 = 0;
for i = 1:1:size_level6
    if(node_struct_mult{i}.series_end == 1)
        node_struct_mult{i}.work_state = 0;
        node_struct_mult{i}.valid_in = 0;
        node_struct_mult{i}.receive_id = 0;
        node_struct_mult{i}.receive_data = 0;
        node_struct_mult{i}.receive_flag = 0;
        node_struct_mult{i}.series = 0;
        node_struct_mult{i}.output = 0;
        node_struct_mult{i}.series_end = 0;
    end
end
for i = 1:1:size_level6
    if(node_struct_mult{i}.work_state == 1 && node_struct_mult{i}.work_mode == 2 && all(node_struct_mult{i}.receive_id ~= 0))
        for j = 1:1:size_level5_out
            if(node_struct_mult{i}.receive_id(1) == level5_output(1,j) || node_struct_mult{i}.receive_id(2) == level5_output(1,j))
                [~,size_series] = size(node_struct_mult{i}.series);
                if(node_struct_mult{i}.receive_id(1) == level5_output(1,j))
                    if(node_struct_mult{i}.receive_data(1) ~= level5_output(2,j))
                        node_struct_mult{i}.series(:,size_series+1) = level5_output(:,j);
                        node_struct_mult{i}.receive_data(1) = level5_output(2,j);
                        node_struct_mult{i}.valid_in = 1;
                    end
                    node_struct_mult{i}.receive_flag(1) = 1;
                elseif(node_struct_mult{i}.receive_id(2) == level5_output(1,j))
                    if(node_struct_mult{i}.receive_data(2) ~= level5_output(2,j))
                        node_struct_mult{i}.series(:,size_series+1) = level5_output(:,j);
                        node_struct_mult{i}.receive_data(2) = level5_output(2,j);
                        node_struct_mult{i}.valid_in = 1;
                    end
                    node_struct_mult{i}.receive_flag(2) = 1;
                end
            end
        end
        if(node_struct_mult{i}.receive_flag(1) == 0 && node_struct_mult{i}.receive_flag(2) == 0)
            node_struct_mult{i}.series_end = 1;
        end
        [~,size_series] = size(node_struct_mult{i}.series);
        if(node_struct_mult{i}.receive_flag(1) == 0 && node_struct_mult{i}.receive_data(1) ~= 0)
            node_struct_mult{i}.receive_data(1) = 0;
            node_struct_mult{i}.series(:,size_series+1) = [node_struct_mult{i}.receive_id(1),0];
            node_struct_mult{i}.valid_in = 1;
        end
        [~,size_series] = size(node_struct_mult{i}.series);
        if(node_struct_mult{i}.receive_flag(2) == 0 && node_struct_mult{i}.receive_data(2) ~= 0)
            node_struct_mult{i}.receive_data(2) = 0;
            node_struct_mult{i}.series(:,size_series+1) = [node_struct_mult{i}.receive_id(2),0];
            node_struct_mult{i}.valid_in = 1;
        end
        [~,size_series] = size(node_struct_mult{i}.series);
        if(~isempty(node_struct_mult{i}.model{1}))
            if(node_struct_mult{i}.valid_in == 1)
                [LCS] = match_model(node_struct_mult{i}.model{1},node_struct_mult{i}.series);
                [~,size_LCS] = size(LCS);
                PX = size_LCS/size_series;
                if(PX>=PX_flag)
                    node_struct_mult{i}.output = 1;
                    if(node_struct_mult{i}.series_end == 1 && PX >= PX_merge)
                        node_struct_mult{i}.model = model_fusion_position(LCS,node_struct_mult{i}.model,{node_struct_mult{i}.series,model_cnt_initial * ones(1,size_series)});%model_cnt_
                    end
                else
                    find_model = 0;
                    node_choose = zeros(1,size_level6);
                    for j = 1:1:size_level6
                        if(node_struct_mult{j}.work_state == 0 && node_struct_mult{j}.work_mode == 2)
                            [LCS] = match_model(node_struct_mult{j}.model{1},node_struct_mult{i}.series);
                            [~,size_LCS] = size(LCS);
                            if(size_LCS == 0)
                                node_choose(j) = 0;
                            else
                                for k = 1:1:size_LCS
                                    node_choose(j) = node_choose(j) + node_struct_mult{j}.model{2}(LCS(3,k));
                                end
                                node_choose(j) = node_choose(j)/size_series;
                            end
                        end
                    end
                    [max_PX,pointer_PX] = max(node_choose);
                    if(max_PX >= PX_half)
                        find_model = 1;
                        node_struct_mult{pointer_PX}.work_state = 1;
                        node_struct_mult{pointer_PX}.valid_in = 0;
                        node_struct_mult{pointer_PX}.receive_id = node_struct_mult{i}.receive_id;
                        node_struct_mult{pointer_PX}.receive_data = node_struct_mult{i}.receive_data;
                        node_struct_mult{pointer_PX}.receive_flag = node_struct_mult{i}.receive_flag;
                        node_struct_mult{pointer_PX}.series = node_struct_mult{i}.series;
                        node_struct_mult{pointer_PX}.output = 1;
                        node_struct_mult{pointer_PX}.series_end = 0;
                    end
                    if(find_model == 0)
                        for j = 1:1:size_level6
                            if(node_struct_mult{j}.work_state == 0 && node_struct_mult{j}.work_mode == 0)
                                node_struct_mult{j}.work_state = 1;
                                node_struct_mult{j}.valid_in = 0;
                                node_struct_mult{j}.receive_id = node_struct_mult{i}.receive_id;
                                node_struct_mult{j}.receive_data = node_struct_mult{i}.receive_data;
                                node_struct_mult{j}.receive_flag = node_struct_mult{i}.receive_flag;
                                node_struct_mult{j}.series = node_struct_mult{i}.series;
                                node_struct_mult{j}.output = 0;
                                node_struct_mult{j}.series_end = 0;
                                node_struct_mult{j}.work_mode = 2;
                                break;
                            end
                        end
                    end
                 
                    node_struct_mult{i}.work_state = 0;
                    node_struct_mult{i}.valid_in = 0;
                    node_struct_mult{i}.receive_id = 0;
                    node_struct_mult{i}.receive_data = 0;
                    node_struct_mult{i}.receive_flag = 0;
                    node_struct_mult{i}.series = 0;
                    node_struct_mult{i}.output = 0;
                    node_struct_mult{i}.series_end = 0;
                end
            end
        else
            if(node_struct_mult{i}.series_end == 1)
                node_struct_mult{i}.model{1} = node_struct_mult{i}.series;
                node_struct_mult{i}.model{2} = model_cnt_initial * ones(1,size_series);%model_cnt_
                node_struct_mult{i}.output = 1;
            else
                node_struct_mult{i}.output = 999;
            end
        end
    elseif(node_struct_mult{i}.work_state == 1 && node_struct_mult{i}.work_mode == 3 && all(node_struct_mult{i}.receive_id ~= 0))
        for j = 1:1:size_level5_out
            if(node_struct_mult{i}.receive_id(1) == level5_output(1,j) || node_struct_mult{i}.receive_id(2) == level5_output(1,j) || node_struct_mult{i}.receive_id(3) == level5_output(1,j))
                [~,size_series] = size(node_struct_mult{i}.receive.series);
                if(node_struct_mult{i}.receive_id(1) == level5_output(1,j))
                    if(node_struct_mult{i}.receive_data(1) ~= level5_output(2,j))
                        node_struct_mult{i}.series(:,size_series+1) = level5_output(:,j);
                        node_struct_mult{i}.receive_data(1) = level5_output(2,j);
                        node_struct_mult{i}.valid_in = 1;
                    end
                    node_struct_mult{i}.receive_flag(1) = 1;
                elseif(node_struct_mult{i}.receive_id(2) == level5_output(1,j))
                    if(node_struct_mult{i}.receive_data(2) ~= level5_output(2,j))
                        node_struct_mult{i}.series(:,size_series+1) = level5_output(:,j);
                        node_struct_mult{i}.receive_data(2) = level5_output(2,j);
                        node_struct_mult{i}.valid_in = 1;
                    end
                    node_struct_mult{i}.receive_flag(2) = 1;
                elseif(node_struct_mult{i}.receive_id(3) == level5_output(1,j))
                    if(node_struct_mult{i}.receive_data(3) ~= level5_output(2,j))
                        node_struct_mult{i}.series(:,size_series+1) = level5_output(:,j);
                        node_struct_mult{i}.receive_data(3) = level5_output(2,j);
                        node_struct_mult{i}.valid_in = 1;
                    end
                    node_struct_mult{i}.receive_flag(3) = 1;
                end
            end
        end
        if(node_struct_mult{i}.receive_flag(1) == 0 && node_struct_mult{i}.receive_flag(2) == 0 && node_struct_mult{i}.receive_flag(3) == 0)
            node_struct_mult{i}.series_end = 1;
        end
        [~,size_series] = size(node_struct_mult{i}.series);
        if(node_struct_mult{i}.receive_flag(1) == 0 && node_struct_mult{i}.receive_data(1) ~= 0)
            node_struct_mult{i}.receive_data(1) = 0;
            node_struct_mult{i}.series(:,size_series+1) = [node_struct_mult{i}.receive_id(1),0];
            node_struct_mult{i}.valid_in = 1;
        end
        [~,size_series] = size(node_struct_mult{i}.series);
        if(node_struct_mult{i}.receive_flag(2) == 0 && node_struct_mult{i}.receive_data(2) ~= 0)
            node_struct_mult{i}.receive_data(2) = 0;
            node_struct_mult{i}.series(:,size_series+1) = [node_struct_mult{i}.receive_id(2),0];
            node_struct_mult{i}.valid_in = 1;
        end
        [~,size_series] = size(node_struct_mult{i}.series);
        if(node_struct_mult{i}.receive_flag(3) == 0 && node_struct_mult{i}.receive_data(3) ~= 0)
            node_struct_mult{i}.receive_data(3) = 0;
            node_struct_mult{i}.series(:,size_series+1) = [node_struct_mult{i}.receive_id(3),0];
            node_struct_mult{i}.valid_in = 1;
        end
        [~,size_series] = size(node_struct_mult{i}.series);
        if(~isempty(node_struct_mult{i}.model{1}))
            if(node_struct_mult{i}.valid_in == 1)
                [LCS] = match_model(node_struct_mult{i}.model{1},node_struct_mult{i}.series);
                [~,size_LCS] = size(LCS);
                PX = size_LCS/size_series;
                if(PX>=PX_flag)
                    node_struct_mult{i}.output = 1;
                    if(node_struct_mult{i}.series_end == 1 && PX >= PX_merge)
                        node_struct_mult{i}.model = model_fusion_position(LCS,node_struct_mult{i}.model,{node_struct_mult{i}.series,model_cnt_initial * ones(1,size_series)}); %model_cnt_
                    end
                else
                    find_model = 0;
                    node_choose = zeros(1,size_level6);
                    for j = 1:1:size_level6
                        if(node_struct_mult{j}.work_state == 0 && node_struct_mult{j}.work_mode == 3)
                            [LCS] = match_model(node_struct_mult{j}.model{1},node_struct_mult{i}.series);
                            [~,size_LCS] = size(LCS);
                            if(size_LCS == 0)
                                node_choose(j) = 0;
                            else
                                for k = 1:1:size_LCS
                                    node_choose(j) = node_choose(j) + node_struct_mult{j}.model{2}(LCS(3,k));
                                end
                                node_choose(j) = node_choose(j)/size_series;
                            end
                        end
                    end
                    [max_PX,pointer_PX] = max(node_choose);
                    if(max_PX >= PX_half)
                        find_model = 1;
                        node_struct_mult{pointer_PX}.work_state = 1;
                        node_struct_mult{pointer_PX}.valid_in = 0;
                        node_struct_mult{pointer_PX}.receive_id = node_struct_mult{i}.receive_id;
                        node_struct_mult{pointer_PX}.receive_data = node_struct_mult{i}.receive_data;
                        node_struct_mult{pointer_PX}.receive_flag = node_struct_mult{i}.receive_flag;
                        node_struct_mult{pointer_PX}.series = node_struct_mult{i}.series;
                        node_struct_mult{pointer_PX}.output = 1;
                        node_struct_mult{pointer_PX}.series_end = 0;
                    end
                    if(find_model == 0)
                        for j = 1:1:size_level6
                            if(node_struct_mult{j}.work_state == 0 && node_struct_mult{j}.work_mode == 0)
                                node_struct_mult{j}.work_state = 1;
                                node_struct_mult{j}.valid_in = 0;
                                node_struct_mult{j}.receive_id = node_struct_mult{i}.receive_id;
                                node_struct_mult{j}.receive_data = node_struct_mult{i}.receive_data;
                                node_struct_mult{j}.receive_flag = node_struct_mult{i}.receive_flag;
                                node_struct_mult{j}.series = node_struct_mult{i}.series;
                                node_struct_mult{j}.output = 0;
                                node_struct_mult{j}.series_end = 0;
                                node_struct_mult{j}.work_mode = 3;
                                break;
                            end
                        end
                    end
           
                    node_struct_mult{i}.work_state = 0;
                    node_struct_mult{i}.valid_in = 0;
                    node_struct_mult{i}.receive_id = 0;
                    node_struct_mult{i}.receive_data = 0;
                    node_struct_mult{i}.receive_flag = 0;
                    node_struct_mult{i}.series = 0;
                    node_struct_mult{i}.output = 0;
                    node_struct_mult{i}.series_end = 0;
                end
            end
        else
            if(node_struct_mult{i}.series_end == 1)
                node_struct_mult{i}.model{1} = node_struct_mult{i}.series;
                node_struct_mult{i}.model{2} = model_cnt_initial * ones(1,size_series);%model_cnt_
                node_struct_mult{i}.output = 1;
            else
                node_struct_mult{i}.output = 999;
            end
        end
    end
end
for i = 1:1:size_level6
    if(node_struct_mult{i}.work_state == 1)
        node_struct_mult{i}.valid_in = 0;
        if(node_struct_mult{i}.work_mode == 2)
            node_struct_mult{i}.receive_flag = [0,0];
        elseif(node_struct_mult{i}.work_mode == 3)
            node_struct_mult{i}.receive_flag = [0,0,0];
        end
    end
end
if(size_level5_out == 2)
    comb_exit = 0; %[A,B]
    for i = 1:1:size_level6
        if(node_struct_mult{i}.work_state == 1 && node_struct_mult{i}.work_mode == 2)
            [~,size_comb] = size(intersect(node_struct_mult{i}.receive_id,level5_output(1,:)));
            if(size_comb == 2)
                comb_exit = 1;
                break;
            end
        end
    end
    if(comb_exit == 0)
        data_accept = 0;
        node_choose = zeros(1,size_level6);
        for i = 1:1:size_level6
            if(node_struct_mult{i}.work_mode == 2 && ~isempty(node_struct_mult{i}.model{1}))
                [LCS] = match_model(node_struct_mult{i}.model{1},level5_output);
                [~,size_LCS] = size(LCS);
                if(size_LCS == 0)
                    node_choose(i) = 0;
                else
                    for j = 1:1:size_LCS
                        node_choose(i) = node_choose(i) + node_struct_mult{i}.model{2}(LCS(3,j));
                    end
                    node_choose(i) = node_choose(i)/2;
                end
            end
        end
        [max_PX,pointer_PX] = max(node_choose);
        if(max_PX >= PX_half)
            data_accept = 1;
            node_struct_mult{pointer_PX}.work_state = 1;
            node_struct_mult{pointer_PX}.valid_in = 0;
            node_struct_mult{pointer_PX}.receive_id = level5_output(1,:);
            node_struct_mult{pointer_PX}.receive_data = level5_output(2,:);
            node_struct_mult{pointer_PX}.receive_flag = [0,0];
            node_struct_mult{pointer_PX}.series = level5_output;
            node_struct_mult{pointer_PX}.output = 1;
            node_struct_mult{pointer_PX}.series_end = 0;
        end
        if(data_accept == 0)
            for j = 1:1:size_level6
                if(node_struct_mult{j}.work_state == 0 && node_struct_mult{j}.work_mode == 0)
                    node_struct_mult{j}.work_state = 1;
                    node_struct_mult{j}.valid_in = 0;
                    node_struct_mult{j}.receive_id = level5_output(1,:);
                    node_struct_mult{j}.receive_data = level5_output(2,:);
                    node_struct_mult{j}.receive_flag = [0,0];
                    node_struct_mult{j}.series = level5_output;
                    node_struct_mult{j}.output = 0;
                    node_struct_mult{j}.series_end = 0;
                    node_struct_mult{j}.work_mode = 2;
                    break;
                end
            end
        end
    end
elseif(size_level5_out == 3)
    comb_exit = 0; %[A,B]
    for i = 1:1:size_level6
        if(node_struct_mult{i}.work_state == 1 && node_struct_mult{i}.work_mode == 2)
            [~,size_comb] = size(intersect(node_struct_mult{i}.receive_id,[level5_output(1,1),level5_output(1,2)]));
            if(size_comb == 2)
                comb_exit = 1;
                break;
            end
        end
    end
    if(comb_exit == 0)
        data_accept = 0;
        node_choose = zeros(1,size_level6);
        for i = 1:1:size_level6
            if(node_struct_mult{i}.work_mode == 2 && ~isempty(node_struct_mult{i}.model{1}))
                [LCS] = match_model(node_struct_mult{i}.model{1},level5_output(:,1:2));
                [~,size_LCS] = size(LCS);
                if(size_LCS == 0)
                    node_choose(i) = 0;
                else
                    for j = 1:1:size_LCS
                        node_choose(i) = node_choose(i) + node_struct_mult{i}.model{2}(LCS(3,j));
                    end
                    node_choose(i) = node_choose(i)/2;
                end
            end
        end
        [max_PX,pointer_PX] = max(node_choose);
        if(max_PX >= PX_half)
            data_accept = 1;
            node_struct_mult{pointer_PX}.work_state = 1;
            node_struct_mult{pointer_PX}.valid_in = 0;
            node_struct_mult{pointer_PX}.receive_id = [level5_output(1,1),level5_output(1,2)];
            node_struct_mult{pointer_PX}.receive_data = [level5_output(2,1),level5_output(2,2)];
            node_struct_mult{pointer_PX}.receive_flag = [0,0];
            node_struct_mult{pointer_PX}.series = level5_output(:,1:2);
            node_struct_mult{pointer_PX}.output = 1;
            node_struct_mult{pointer_PX}.series_end = 0;
        end
        if(data_accept == 0)
            for j = 1:1:size_level6
                if(node_struct_mult{j}.work_state == 0 && node_struct_mult{j}.work_mode == 0)
                    node_struct_mult{j}.work_state = 1;
                    node_struct_mult{j}.valid_in = 0;
                    node_struct_mult{j}.receive_id = [level5_output(1,1),level5_output(1,2)];
                    node_struct_mult{j}.receive_data = [level5_output(2,1),level5_output(2,2)];
                    node_struct_mult{j}.receive_flag = [0,0];
                    node_struct_mult{j}.series = level5_output(:,1:2);
                    node_struct_mult{j}.output = 0;
                    node_struct_mult{j}.series_end = 0;
                    node_struct_mult{j}.work_mode = 2;
                    break;
                end
            end
        end
    end
    
    comb_exit = 0;%[A,C]
    for i = 1:1:size_level6
        if(node_struct_mult{i}.work_state == 1 && node_struct_mult{i}.work_mode == 2)
            [~,size_comb] = size(intersect(node_struct_mult{i}.receive_id,[level5_output(1,1),level5_output(1,3)]));
            if(size_comb == 2)
                comb_exit = 1;
                break;
            end
        end
    end
    if(comb_exit == 0)
        data_accept = 0;
        node_choose = zeros(1,size_level6);
        for i = 1:1:size_level6
            if(node_struct_mult{i}.work_mode == 2 && ~isempty(node_struct_mult{i}.model{1}))
                [LCS] = match_model(node_struct_mult{i}.model{1},[level5_output(:,1),level5_output(:,3)]);
                [~,size_LCS] = size(LCS);
                if(size_LCS == 0)
                    node_choose(i) = 0;
                else
                    for j = 1:1:size_LCS
                        node_choose(i) = node_choose(i) + node_struct_mult{i}.model{2}(LCS(3,j));
                    end
                    node_choose(i) = node_choose(i)/2;
                end
            end
        end
        [max_PX,pointer_PX] = max(node_choose);
        if(max_PX >= PX_half)
            data_accept = 1;
            node_struct_mult{pointer_PX}.work_state = 1;
            node_struct_mult{pointer_PX}.valid_in = 0;
            node_struct_mult{pointer_PX}.receive_id = [level5_output(1,1),level5_output(1,3)];
            node_struct_mult{pointer_PX}.receive_data = [level5_output(2,1),level5_output(2,3)];
            node_struct_mult{pointer_PX}.receive_flag = [0,0];
            node_struct_mult{pointer_PX}.series = [level5_output(:,1),level5_output(:,3)];
            node_struct_mult{pointer_PX}.output = 1;
            node_struct_mult{pointer_PX}.series_end = 0;
        end
        if(data_accept == 0)
            for j = 1:1:size_level6
                if(node_struct_mult{j}.work_state == 0 && node_struct_mult{j}.work_mode == 0)
                    node_struct_mult{j}.work_state = 1;
                    node_struct_mult{j}.valid_in = 0;
                    node_struct_mult{j}.receive_id = [level5_output(1,1),level5_output(1,3)];
                    node_struct_mult{j}.receive_data = [level5_output(2,1),level5_output(2,3)];
                    node_struct_mult{j}.receive_flag = [0,0];
                    node_struct_mult{j}.series = [level5_output(:,1),level5_output(:,3)];
                    node_struct_mult{j}.output = 0;
                    node_struct_mult{j}.series_end = 0;
                    node_struct_mult{j}.work_mode = 2;
                    break;
                end
            end
        end
    end
    
    comb_exit = 0; %[B,C]
    for i = 1:1:size_level6
        if(node_struct_mult{i}.work_state == 1 && node_struct_mult{i}.work_mode == 2)
            [~,size_comb] = size(intersect(node_struct_mult{i}.receive_id,[level5_output(1,2),level5_output(1,3)]));
            if(size_comb == 2)
                comb_exit = 1;
                break;
            end
        end
    end
    if(comb_exit == 0)
        data_accept = 0;
        node_choose = zeros(1,size_level6);
        for i = 1:1:size_level6
            if(node_struct_mult{i}.work_mode == 2 && ~isempty(node_struct_mult{i}.model{1}))
                [LCS] = match_model(node_struct_mult{i}.model{1},level5_output(:,2:3));
                [~,size_LCS] = size(LCS);
                if(size_LCS == 0)
                    node_choose(i) = 0;
                else
                    for j = 1:1:size_LCS
                        node_choose(i) = node_choose(i) + node_struct_mult{i}.model{2}(LCS(3,j));
                    end
                    node_choose(i) = node_choose(i)/2;
                end
            end
        end
        [max_PX,pointer_PX] = max(node_choose);
        if(max_PX >= PX_half)
            data_accept = 1;
            node_struct_mult{pointer_PX}.work_state = 1;
            node_struct_mult{pointer_PX}.valid_in = 0;
            node_struct_mult{pointer_PX}.receive_id = [level5_output(1,2),level5_output(1,3)];
            node_struct_mult{pointer_PX}.receive_data = [level5_output(2,2),level5_output(2,3)];
            node_struct_mult{pointer_PX}.receive_flag = [0,0];
            node_struct_mult{pointer_PX}.series = level5_output(:,2:3);
            node_struct_mult{pointer_PX}.output = 1;
            node_struct_mult{pointer_PX}.series_end = 0;
        end
        if(data_accept == 0)
            for j = 1:1:size_level6
                if(node_struct_mult{j}.work_state == 0 && node_struct_mult{j}.work_mode == 0)
                    node_struct_mult{j}.work_state = 1;
                    node_struct_mult{j}.valid_in = 0;
                    node_struct_mult{j}.receive_id = [level5_output(1,2),level5_output(1,3)];
                    node_struct_mult{j}.receive_data = [level5_output(2,2),level5_output(2,3)];
                    node_struct_mult{j}.receive_flag = [0,0];
                    node_struct_mult{j}.series = level5_output(:,2:3);
                    node_struct_mult{j}.output = 0;
                    node_struct_mult{j}.series_end = 0;
                    node_struct_mult{j}.work_mode = 2;
                    break;
                end
            end
        end
    end
    
    comb_exit = 0; %[A,B,C]
    for i = 1:1:size_level6
        if(node_struct_mult{i}.work_state == 1 && node_struct_mult{i}.work_mode == 3)
            [~,size_comb] = size(intersect(node_struct_mult{i}.receive_id,level5_output(1,:)));
            if(size_comb == 3)
                comb_exit = 1;
                break;
            end
        end
    end
    if(comb_exit == 0)
        data_accept = 0;
        node_choose = zeros(1,size_level6);
        for i = 1:1:size_level6
            if(node_struct_mult{i}.work_mode == 3 && ~isempty(node_struct_mult{i}.model{1}))
                [LCS] = match_model(node_struct_mult{i}.model{1},level5_output);
                [~,size_LCS] = size(LCS);
                if(size_LCS == 0)
                    node_choose(i) = 0;
                else
                    for j = 1:1:size_LCS
                        node_choose(i) = node_choose(i) + node_struct_mult{i}.model{2}(LCS(3,j));
                    end
                    node_choose(i) = node_choose(i)/3;
                end
            end
        end
        [max_PX,pointer_PX] = max(node_choose);
        if(max_PX >= PX_half)
            data_accept = 1;
            node_struct_mult{pointer_PX}.work_state = 1;
            node_struct_mult{pointer_PX}.valid_in = 0;
            node_struct_mult{pointer_PX}.receive_id = level5_output(1,:);
            node_struct_mult{pointer_PX}.receive_data = level5_output(2,:);
            node_struct_mult{pointer_PX}.receive_flag = [0,0,0];
            node_struct_mult{pointer_PX}.series = level5_output;
            node_struct_mult{pointer_PX}.output = 1;
            node_struct_mult{pointer_PX}.series_end = 0;
        end
        if(data_accept == 0)
            for j = 1:1:size_level6
                if(node_struct_mult{j}.work_state == 0 && node_struct_mult{j}.work_mode == 0)
                    node_struct_mult{j}.work_state = 1;
                    node_struct_mult{j}.valid_in = 0;
                    node_struct_mult{j}.receive_id = level5_output(1,:);
                    node_struct_mult{j}.receive_data = level5_output(2,:);
                    node_struct_mult{j}.receive_flag = [0,0,0];
                    node_struct_mult{j}.series = level5_output;
                    node_struct_mult{j}.output = 0;
                    node_struct_mult{j}.series_end = 0;
                    node_struct_mult{j}.work_mode = 3;
                    break;
                end
            end
        end
    end
end
level6_2_output = [];
level6_3_output = [];
for i = 1:1:size_level6
    if(node_struct_mult{i}.work_state == 1 && node_struct_mult{i}.output == 1)
        if(node_struct_mult{i}.work_mode == 2)
            [size_2,~] = size(level6_2_output);
            level6_2_output(size_2 + 1,:) = [node_struct_mult{i}.node_id,0,node_struct_mult{i}.receive_id];
        elseif(node_struct_mult{i}.work_mode == 3)
            [size_3,~] = size(level6_3_output);
            level6_3_output(size_3 + 1,:) = [node_struct_mult{i}.node_id,node_struct_mult{i}.receive_id];
        end
    end
end
[size_3,~] = size(level6_3_output);
[size_2,~] = size(level6_2_output);
level5_out_clear = zeros(1,size_level5_out);
level5_out_clear_cnt = 0;
if(size_3 ~= 0)
    if(size_2 ~= 0)
        for i = 1:1:size_3
            for j = 1:1:size_2
                [~,size_comb] = size(intersect(level6_3_output(i,2:4),level6_2_output(j,3:4)));
                if(size_comb == 2)
                    level6_2_output(j,2) = 1;
                end
            end
        end
    end
    for i = 1:1:size_3
        for j = 1:1:level_number
            if(node_struct{j}.work_state == 1 && ~isempty(node_struct{j}.receive))
                [~,size_receive] = size(node_struct{j}.receive);
                for k = 1:1:size_receive
                    if(node_struct{j}.receive{k}.output ~= 0)
                        if(ismember(node_struct{j}.receive{k}.receive_id,level6_3_output(i,2:4)))
                            level5_out_clear(level5_out_clear_cnt + 1) = node_struct{j}.receive{k}.receive_id;
                            level5_out_clear_cnt = level5_out_clear_cnt + 1;
                        end
                    end
                end
            end
        end
    end
end
if(size_2 ~= 0)
    for i = 1:1:size_2
        if(level6_2_output(i,2) == 0)
            for j = 1:1:level_number
                if(node_struct{j}.work_state == 1 && ~isempty(node_struct{j}.receive))
                    [~,size_receive] = size(node_struct{j}.receive);
                    for k = 1:1:size_receive
                        if(node_struct{j}.receive{k}.output ~= 0)
                            if(ismember(node_struct{j}.receive{k}.receive_id,level6_2_output(i,3:4)))
                                level5_out_clear(level5_out_clear_cnt + 1) = node_struct{j}.receive{k}.receive_id;
                                level5_out_clear_cnt = level5_out_clear_cnt + 1;
                            end
                        end
                    end
                end
            end
        end
    end
end

end

% node_struct{pointer_PX}.receive{1} = struct;
% node_struct{pointer_PX}.receive{1}.receive_id = input_data(3,i);
% node_struct{pointer_PX}.receive{1}.valid_in = 0;
% node_struct{pointer_PX}.receive{1}.input_direct = 0;
% node_struct{pointer_PX}.receive{1}.series_end = 0;
% node_struct{pointer_PX}.receive{1}.series = [input_data(1,i);input_data(2,i)];
% node_struct{pointer_PX}.receive{1}.output = 0;
% node_struct{pointer_PX}.receive{1}.history_output = 0;
% node_struct{pointer_PX}.receive{1}.accept_data = 1;
% node_struct{pointer_PX}.receive{1}.end_flag = 0;
