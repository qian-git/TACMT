function [ node_struct ] = level4_func( node_struct,input_array,PX_flag,model_upper ) %input_array = [level2_node_id,position[4],direction] 6_bits
model_cnt_initial = 5;
[~,level_number] = size(node_struct);
% PX_flag = 0.85;
PX_half = 0.5;PX_flag_h = PX_flag + 0.1;
% PX_merge = 0.65;
%buffer_clear
for i = 1:1:level_number
%     if(node_struct{i}.work_state == 1)
    if(node_struct{i}.work_state == 1 && ~isempty(node_struct{i}.receive))
        [~,size_receive] = size(node_struct{i}.receive);
        for j = size_receive:-1:1
            if(node_struct{i}.receive{j}.need_clear == 1)
                if(node_struct{i}.receive{j}.pro_zero == 0)
                    node_struct{i}.receive{j}.pro_zero = 1;
                    node_struct{i}.receive{j}.output = [node_struct{i}.receive{j}.receive_id,0];
                else
                    node_struct{i}.receive(j) = [];
                end
                
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

%input_accpet
if(~isempty(input_array))
    [size_input,~] = size(input_array);
    for i = 1:1:size_input
        data_accept = 0;
        for j = 1:1:level_number
            if(node_struct{j}.work_state == 1 && ~isempty(node_struct{j}.receive))
                [~,size_receive] = size(node_struct{j}.receive);
                for k = 1:1:size_receive
                    if(node_struct{j}.receive{k}.receive_id == input_array(i,1))
                        node_struct{j}.receive{k}.input_direct = input_array(i,4);
                        if(input_array(i,4) == 0)
                            node_struct{j}.receive{k}.series_end = 1;
                        end
                        [~,axis_size] = size(node_struct{j}.receive{k}.series);
                        if(node_struct{j}.receive{k}.series(1,axis_size) ~= input_array(i,4))
                            node_struct{j}.receive{k}.valid_in = 1;
                            node_struct{j}.receive{k}.series(1,axis_size + 1) = input_array(i,4);
                            node_struct{j}.receive{k}.series_cnt(1,axis_size + 1) = 1;
                        else
                            node_struct{j}.receive{k}.series_cnt(1,axis_size) = node_struct{j}.receive{k}.series_cnt(1,axis_size) + 1;
                            node_struct{j}.receive{k}.valid_in = 0;
                        end
                        node_struct{j}.receive{k}.accept = 1;
                        node_struct{j}.receive{k}.no_response = 0;
                        node_struct{j}.receive{k}.need_clear = 0;
                        data_accept = 1;
                        break;
                    end
                end
            end
            if(data_accept == 1)
                break;
            end
        end
        if(data_accept == 0 && input_array(i,4) ~= 0)
            model_choose = zeros(1,level_number);
            for m = 1:1:level_number
                if(~isempty(node_struct{m}.model{1}))
                    [~,size_model] = size(node_struct{m}.model{1});
                    for n = 1:1:size_model
                        if(all(node_struct{m}.model{1}(1,n) == input_array(i,4)))
                            model_choose(m) = node_struct{m}.model{2}(1,n);
                            break;
                        end
                    end
                end
            end
            [max_PX,pointer_PX] = max(model_choose);
            if(max_PX ~= 0)
                if(~isempty(node_struct{pointer_PX}.receive))
                    [~,size_pointer_receive] = size(node_struct{pointer_PX}.receive);
                    node_struct{pointer_PX}.receive{size_pointer_receive + 1} = struct;
                    node_struct{pointer_PX}.receive{size_pointer_receive + 1}.receive_id = input_array(i,1);
                    node_struct{pointer_PX}.receive{size_pointer_receive + 1}.input_direct = input_array(i,4);
                    node_struct{pointer_PX}.receive{size_pointer_receive + 1}.series_end = 0;
                    node_struct{pointer_PX}.receive{size_pointer_receive + 1}.pro_zero = 0;
                    node_struct{pointer_PX}.receive{size_pointer_receive + 1}.valid_in = 1;
                    node_struct{pointer_PX}.receive{size_pointer_receive + 1}.series_invalid = 0;
                    node_struct{pointer_PX}.receive{size_pointer_receive + 1}.series = [];
                    node_struct{pointer_PX}.receive{size_pointer_receive + 1}.series_cnt = [];
                    node_struct{pointer_PX}.receive{size_pointer_receive + 1}.series(1) = input_array(i,4);
                    node_struct{pointer_PX}.receive{size_pointer_receive + 1}.series_cnt(1) = 1;
                    node_struct{pointer_PX}.receive{size_pointer_receive + 1}.output = [input_array(i,1),999];
                    node_struct{pointer_PX}.receive{size_pointer_receive + 1}.history_output = [input_array(i,1),999];
                    node_struct{pointer_PX}.receive{size_pointer_receive + 1}.accept = 1;
                    node_struct{pointer_PX}.receive{size_pointer_receive + 1}.no_response = 0;
                    node_struct{pointer_PX}.receive{size_pointer_receive + 1}.need_clear = 0;
                else
                    node_struct{pointer_PX}.receive{1} = struct;
                    node_struct{pointer_PX}.receive{1}.receive_id = input_array(i,1);
                    node_struct{pointer_PX}.receive{1}.input_direct = input_array(i,4);
                    node_struct{pointer_PX}.receive{1}.series_end = 0;
                    node_struct{pointer_PX}.receive{1}.pro_zero = 0;
                    node_struct{pointer_PX}.receive{1}.valid_in = 1;
                    node_struct{pointer_PX}.receive{1}.series_invalid = 0;
                    node_struct{pointer_PX}.receive{1}.series = [];
                    node_struct{pointer_PX}.receive{1}.series_cnt = [];
                    node_struct{pointer_PX}.receive{1}.series(1) = input_array(i,4);
                    node_struct{pointer_PX}.receive{1}.series_cnt(1) = 1;
                    node_struct{pointer_PX}.receive{1}.output = [input_array(i,1),999];
                    node_struct{pointer_PX}.receive{1}.history_output = [input_array(i,1),999];
                    node_struct{pointer_PX}.receive{1}.accept = 1;
                    node_struct{pointer_PX}.receive{1}.no_response = 0;
                    node_struct{pointer_PX}.receive{1}.need_clear = 0;
                end
                node_struct{pointer_PX}.work_state = 1;
            else
                for m = 1:1:level_number
                    if(~any(any(node_struct{m}.model{1})) && isempty(node_struct{m}.receive))
                        node_struct{m}.receive{1} = struct;
                        node_struct{m}.receive{1}.receive_id = input_array(i,1);
                        node_struct{m}.receive{1}.input_direct = input_array(i,4);
                        node_struct{m}.receive{1}.series_end = 0;
                        node_struct{m}.receive{1}.pro_zero = 0;
                        node_struct{m}.receive{1}.valid_in = 1;
                        node_struct{m}.receive{1}.series_invalid = 0;
                        node_struct{m}.receive{1}.series = [];
                        node_struct{m}.receive{1}.series_cnt = [];
                        node_struct{m}.receive{1}.series(1) = input_array(i,4);
                        node_struct{m}.receive{1}.series_cnt(1) = 1;
                        node_struct{m}.receive{1}.output = [input_array(i,1),999];
                        node_struct{m}.receive{1}.history_output = [input_array(i,1),999];
                        node_struct{m}.receive{1}.accept = 1;
                        node_struct{m}.receive{1}.no_response = 0;
                        node_struct{m}.receive{1}.need_clear = 0;
                        node_struct{m}.work_state = 1;
                        break;
                    end
                end
            end
        end
    end
end

for i = 1:1:level_number %check_receive
    if(node_struct{i}.work_state == 1 && ~isempty(node_struct{i}.receive))
        [~,size_receive] = size(node_struct{i}.receive);
        for j = 1:1:size_receive
            if(node_struct{i}.receive{j}.accept == 0)
                node_struct{i}.receive{j}.no_response = node_struct{i}.receive{j}.no_response + 1;
            end
            if(node_struct{i}.receive{j}.no_response >= 5)
                node_struct{i}.receive{j}.need_clear = 1;
            end
        end
    end
end


for i = 1:1:level_number
    if(~any(node_struct{i}.model{1}))%check model exist
        build_model = 1;
    else
        build_model = 0;
    end
    if(node_struct{i}.work_state == 1 && ~isempty(node_struct{i}.receive))
        [~,size_receive] = size(node_struct{i}.receive);
        for j = 1:1:size_receive
%             PX = 0;
            if(node_struct{i}.receive{j}.valid_in == 1) %½øÐÐÆ¥Åä
                [~,size_axis] = size(node_struct{i}.receive{j}.series);
                if(build_model == 0)
                    if(node_struct{i}.receive{j}.series_end == 1)
                        series_flip = flip(node_struct{i}.receive{j}.series);
                        series_flip_cnt = flip(node_struct{i}.receive{j}.series_cnt);
                        for k = size_axis:-1:2
                            if(k <= size_axis-2 && series_flip(k+2) == series_flip(k))
                                if(series_flip_cnt(k) > series_flip_cnt(k+2))
                                    series_flip(k+1:k+2) = [];
                                    series_flip_cnt(k+1:k+2) = [];
                                else
                                    series_flip(k:k+1) = [];
                                    series_flip_cnt(k:k+1) = [];
                                end
                                break;
                            end
                        end
                        series_flip = flip(series_flip);
                        series_flip_cnt = flip(series_flip_cnt);
                        model_flip = [flip(node_struct{i}.model{1});flip(node_struct{i}.model{2})];
                        [~,size_model1] = size(model_flip);
                        for k = size_model1:-1:2
                            if(k <= size_model1-2 && model_flip(1,k+2) == model_flip(1,k))
                                model_flip(:,k:k+1) = [];
                                break;
                            end
                        end
                        flip_model = {flip(model_flip(1,:)),flip(model_flip(2,:))};
                        
                        [LCS1] = match_direct(node_struct{i}.model{1},node_struct{i}.receive{j}.series);
                        [px_model,px_series] = cal_match(node_struct{i}.model,[node_struct{i}.receive{j}.series;node_struct{i}.receive{j}.series_cnt],LCS1,4);
%                         [LCS1] = match_direct(node_struct{i}.model{1},series_flip);
%                         [px_model1,px_series1] = cal_match(node_struct{i}.model,[series_flip;series_flip_cnt],LCS1,4);
%                         [LCS2] = match_direct(flip_model{1},series_flip);
%                         [px_model2,px_series2] = cal_match(flip_model,[series_flip;series_flip_cnt],LCS2,4);
%                         if(px_model1 >= PX_flag)
%                             if(px_model1 >= PX_flag_h)
%                                 px_model1 = PX_flag_h;
%                             else
%                                 px_model1 = PX_flag;
%                             end
%                         end
%                         if(px_series1 >= PX_flag)
%                             if(px_series1 >= PX_flag_h)
%                                 px_series1 = PX_flag_h;
%                             else
%                                 px_series1 = PX_flag;
%                             end
%                         end
                        if(px_model >= PX_flag && px_series >= PX_flag)
                            PX = (px_model + px_series)/2;
                        else
                            PX = 0;
                        end
%                         PX1 = (px_model1 + px_series1)/2;
%                         if(px_model2 >= PX_flag)
%                             if(px_model2 >= PX_flag_h)
%                                 px_model2 = PX_flag_h;
%                             else
%                                 px_model2 = PX_flag;
%                             end
%                         end
%                         if(px_series2 >= PX_flag)
%                             if(px_series2 >= PX_flag_h)
%                                 px_series2 = PX_flag_h;
%                             else
%                                 px_series2 = PX_flag;
%                             end
%                         end
%                         PX2 = (px_model2 + px_series2)/2;
%                         if(PX1 >= PX2)
%                             PX = PX1;
%                         else
%                             PX = PX2;
%                         end
%                         if(series_flip_true == 1)
%                             if(PX1 >= PX2)
%                                 PX = PX1;
%                             else
%                                 PX = PX2;
%                             end
%                         else
%                             PX = PX1;
%                         end
                    else
    %                     LCS = zeros(3,size_axis);
                        [LCS] = match_direct(node_struct{i}.model{1},node_struct{i}.receive{j}.series);
                        [px_model,px_series] = cal_match(node_struct{i}.model,[node_struct{i}.receive{j}.series;node_struct{i}.receive{j}.series_cnt],LCS,4);
%                         if(px_model >= PX_flag)
%                             if(px_model >= PX_flag_h)
%                                 px_model = PX_flag_h;
%                             else
%                                 px_model = PX_flag;
%                             end
%                         end
%                         if(px_series >= PX_flag)
%                             if(px_series >= PX_flag_h)
%                                 px_series = PX_flag_h;
%                             else
%                                 px_series = PX_flag;
%                             end
%                         end
%                         PX = (px_model + px_series)/2;
                        if(px_model >= PX_flag && px_series >= PX_flag)
                            PX = (px_model + px_series)/2;
                        else
                            PX = 0;
                        end
                    end

%                     [~,size_LCS] = size(LCS);
%                     PX = size_LCS/size_axis;
                    if(size_axis > 2 || node_struct{i}.receive{j}.series_end == 1) %output
%                         if(px_model == 1 && px_series >= PX_flag)
                        if(PX>= PX_flag)
                            node_struct{i}.receive{j}.output = [node_struct{i}.receive{j}.receive_id,node_struct{i}.node_id];
                            node_struct{i}.receive{j}.history_output = [node_struct{i}.receive{j}.receive_id,node_struct{i}.node_id];
                        else
                            node_struct{i}.receive{j}.series_invalid = 1;
                            node_struct{i}.receive{j}.output = [node_struct{i}.receive{j}.receive_id,999];
                            node_struct{i}.receive{j}.history_output = [node_struct{i}.receive{j}.receive_id,999];
                            node_struct{i}.receive{j}.need_clear = 1;
                        end
                        if(node_struct{i}.receive{j}.series_end == 1)
                            if(PX>= PX_flag)
%                             if(px_model == 1 && px_series >= PX_flag+0.1)
                                [LCS] = match_direct(node_struct{i}.model{1},node_struct{i}.receive{j}.series);
                                node_struct{i}.model = model_fusion_direct(LCS,node_struct{i}.model,{node_struct{i}.receive{j}.series,model_cnt_initial*node_struct{i}.receive{j}.series_cnt},model_upper);
%                                 node_struct{i}.model = model_fusion_direct(LCS,node_struct{i}.model,{node_struct{i}.receive{j}.series,model_cnt_initial*ones(1,size_axis)});
                            end
                            node_struct{i}.receive{j}.need_clear = 1;
                        end
                    else
%                         if(px_model == 1 && px_series >= PX_flag)
                        if( PX>= PX_flag)
                            node_struct{i}.receive{j}.output = [node_struct{i}.receive{j}.receive_id,node_struct{i}.node_id];
                            node_struct{i}.receive{j}.history_output = [node_struct{i}.receive{j}.receive_id,node_struct{i}.node_id];
                        else
                            node_struct{i}.receive{j}.series_invalid = 1;
                            node_struct{i}.receive{j}.output = [node_struct{i}.receive{j}.receive_id,999];
                            node_struct{i}.receive{j}.history_output = [node_struct{i}.receive{j}.receive_id,999];
                            node_struct{i}.receive{j}.need_clear = 1;
                        end
                    end
                else
                    if(node_struct{i}.receive{j}.series_end == 1)
                        node_choose = zeros(1,level_number);
                        series_flip = flip(node_struct{i}.receive{j}.series);
                        series_flip_cnt = flip(node_struct{i}.receive{j}.series_cnt);
                        for k = size_axis:-1:2
                            if(k <= size_axis-2 && series_flip(k+2) == series_flip(k))
                                if(series_flip_cnt(k) > series_flip_cnt(k+2))
                                    series_flip(k+1:k+2) = [];
                                    series_flip_cnt(k+1:k+2) = [];
                                else
                                    series_flip(k:k+1) = [];
                                    series_flip_cnt(k:k+1) = [];
                                end
                                break;
                            end
                        end
                        series_flip = flip(series_flip);
                        series_flip_cnt = flip(series_flip_cnt);
                        for m = 1:1:level_number
                            if(m ~= node_struct{i}.node_id && ~isempty(node_struct{m}.model{1}))
                                
                                
                                model_flip = [flip(node_struct{m}.model{1});flip(node_struct{m}.model{2})];
                                [~,size_model1] = size(model_flip);
                                for k = size_model1:-1:2
                                    if(k <= size_model1-2 && model_flip(1,k+2) == model_flip(1,k))
                                        model_flip(:,k:k+1) = [];
                                        break;
                                    end
                                end
                                flip_model = {flip(model_flip(1,:)),flip(model_flip(2,:))};
                                [LCS1] = match_direct(node_struct{m}.model{1},node_struct{i}.receive{j}.series);
                                [px_model,px_series] = cal_match(node_struct{m}.model,[node_struct{i}.receive{j}.series;node_struct{i}.receive{j}.series_cnt],LCS1,4);
%                                 [LCS1] = match_direct(node_struct{m}.model{1},series_flip);
%                                 [px_model1,px_series1] = cal_match(node_struct{m}.model,[series_flip;series_flip_cnt],LCS1,4);
%                                 [LCS2] = match_direct(flip_model{1},series_flip);
%                                 [px_model2,px_series2] = cal_match(flip_model,[series_flip;series_flip_cnt],LCS2,4);
%                                 if(px_model1 >= PX_flag)
%                                     if(px_model1 >= PX_flag_h)
%                                         px_model1 = PX_flag_h;
%                                     else
%                                         px_model1 = PX_flag;
%                                     end
%                                 end
%                                 if(px_series1 >= PX_flag)
%                                     if(px_series1 >= PX_flag_h)
%                                         px_series1 = PX_flag_h;
%                                     else
%                                         px_series1 = PX_flag;
%                                     end
%                                 end
                                if(px_model >= PX_flag && px_series >= PX_flag)
                                    node_choose(1,m) = (px_model + px_series)/2;
                                else
                                    node_choose(1,m) = 0;
                                end
%                                 node_choose(1,m) = (px_model1 + px_series1)/2;
%                                 PX1 = (px_model1 + px_series1)/2;
%                                 if(px_model2 >= PX_flag)
%                                     if(px_model2 >= PX_flag_h)
%                                         px_model2 = PX_flag_h;
%                                     else
%                                         px_model2 = PX_flag;
%                                     end
%                                 end
%                                 if(px_series2 >= PX_flag)
%                                     if(px_series2 >= PX_flag_h)
%                                         px_series2 = PX_flag_h;
%                                     else
%                                         px_series2 = PX_flag;
%                                     end
%                                 end
%                                 PX2 = (px_model2 + px_series2)/2;
% %                                 if(series_flip_true == 1)
% %                                     if(PX1 >= PX2)
% %                                         node_choose(1,m) = PX1;
% %                                     else
% %                                         node_choose(1,m) = PX2;
% %                                     end
% %                                 else
% %                                     node_choose(1,m) = PX1;
% %                                 end
%                                 if(PX1 >= PX2)
%                                     node_choose(1,m) = PX1;
%                                 else
%                                     node_choose(1,m) = PX2;
%                                 end

                            end
                        end
                        [max_PX,pointer_PX] = max(node_choose);
                        if(max_PX >= PX_flag)
                            if(max_PX >= PX_flag)
%                             if(max_PX >= PX_merge) %merge_model
                                [LCS_1] = match_direct(node_struct{pointer_PX}.model{1},node_struct{i}.receive{j}.series);
                                node_struct{pointer_PX}.model = model_fusion_direct(LCS_1,node_struct{pointer_PX}.model,{node_struct{i}.receive{j}.series,model_cnt_initial*node_struct{i}.receive{j}.series_cnt},model_upper);
%                                 node_struct{pointer_PX}.model = model_fusion_direct(LCS_1,node_struct{pointer_PX}.model,{node_struct{i}.receive{j}.series,model_cnt_initial*ones(1,size_axis)});
                            end
                            node_struct{i}.receive{j}.output = [node_struct{i}.receive{j}.receive_id,pointer_PX];
                            node_struct{i}.receive{j}.history_output = [node_struct{i}.receive{j}.receive_id,pointer_PX];
                            build_model = 0;
                            node_struct{i}.receive{j}.need_clear = 1;
                        else %build new model
                            node_struct{i}.model{1} = node_struct{i}.receive{j}.series;
                            node_struct{i}.model{2} = model_cnt_initial*node_struct{i}.receive{j}.series_cnt;
%                             for k = 1:1:size_axis
%                                 node_struct{i}.model{2}(k) = model_cnt_initial*node_struct{i}.receive{j}.series_cnt(k);
%                             end
%                             node_struct{i}.model{2} = model_cnt_initial*ones(1,size_axis);%model_cnt_
                            node_struct{i}.receive{j}.output = [node_struct{i}.receive{j}.receive_id,node_struct{i}.node_id];
                            node_struct{i}.receive{j}.history_output = [node_struct{i}.receive{j}.receive_id,node_struct{i}.node_id];
                            build_model = 0;
                            node_struct{i}.receive{j}.need_clear = 1;
                        end
                    end
                end
%             else 
%                 node_struct{i}.receive{j}.output = node_struct{i}.receive{j}.history_output;
            end

            node_struct{i}.receive{j}.valid_in = 0;
            node_struct{i}.receive{j}.accept = 0;
            node_struct{i}.receive{j}.input_direct = 0;
        end
        
        for j = size_receive:-1:1 %trans info
            if(node_struct{i}.receive{j}.series_invalid == 1)
                node_choose = zeros(1,level_number);
                [~,size_axis] = size(node_struct{i}.receive{j}.series);
                series_flip = flip(node_struct{i}.receive{j}.series);
                series_flip_cnt = flip(node_struct{i}.receive{j}.series_cnt);
                for k = size_axis:-1:2
                    if(k <= size_axis-2 && series_flip(k+2) == series_flip(k))
                        if(series_flip_cnt(k) > series_flip_cnt(k+2))
                            series_flip(k+1:k+2) = [];
                            series_flip_cnt(k+1:k+2) = [];
                        else
                            series_flip(k:k+1) = [];
                            series_flip_cnt(k:k+1) = [];
                        end
                        break;
                    end
                end
                series_flip = flip(series_flip);
                series_flip_cnt = flip(series_flip_cnt);
                for m = 1:1:level_number
                    if(m ~= node_struct{i}.node_id && ~isempty(node_struct{m}.model{1}))
                        if(node_struct{i}.receive{j}.series_end == 1)

                            
                            model_flip = [flip(node_struct{m}.model{1});flip(node_struct{m}.model{2})];
                            [~,size_model1] = size(model_flip);
                            for k = size_model1:-1:2
                                if(k <= size_model1-2 && model_flip(1,k+2) == model_flip(1,k))
                                    model_flip(:,k:k+1) = [];
                                    break;
                                end
                            end
                            flip_model = {flip(model_flip(1,:)),flip(model_flip(2,:))};
                            [LCS1] = match_direct(node_struct{m}.model{1},node_struct{i}.receive{j}.series);
                            [px_model,px_series] = cal_match(node_struct{m}.model,[node_struct{i}.receive{j}.series;node_struct{i}.receive{j}.series_cnt],LCS1,4);
%                             [LCS1] = match_direct(node_struct{m}.model{1},series_flip);
%                             [px_model1,px_series1] = cal_match(node_struct{m}.model,[series_flip;series_flip_cnt],LCS1,4);
%                             [LCS2] = match_direct(flip_model{1},series_flip);
%                             [px_model2,px_series2] = cal_match(flip_model,[series_flip;series_flip_cnt],LCS2,4);
                            if(px_model >= PX_flag && px_series >= PX_flag)
                                node_choose(1,m) = (px_model + px_series)/2;
                            else
                                node_choose(1,m) = 0;
                            end
%                             if(px_model1 >= PX_flag)
%                                 if(px_model1 >= PX_flag_h)
%                                     px_model1 = PX_flag_h;
%                                 else
%                                     px_model1 = PX_flag;
%                                 end
%                             end
%                             if(px_series1 >= PX_flag)
%                                 if(px_series1 >= PX_flag_h)
%                                     px_series1 = PX_flag_h;
%                                 else
%                                     px_series1 = PX_flag;
%                                 end
%                             end
%                             node_choose(1,m) = (px_model1 + px_series1)/2;
%                             PX1 = (px_model1 + px_series1)/2;
%                             if(px_model2 >= PX_flag)
%                                 if(px_model2 >= PX_flag_h)
%                                     px_model2 = PX_flag_h;
%                                 else
%                                     px_model2 = PX_flag;
%                                 end
%                             end
%                             if(px_series2 >= PX_flag)
%                                 if(px_series2 >= PX_flag_h)
%                                     px_series2 = PX_flag_h;
%                                 else
%                                     px_series2 = PX_flag;
%                                 end
%                             end
%                             PX2 = (px_model2 + px_series2)/2;
% %                             if(series_flip_true == 1)
% %                                 if(PX1 >= PX2)
% %                                     node_choose(1,m) = PX1;
% %                                 else
% %                                     node_choose(1,m) = PX2;
% %                                 end
% %                             else
% %                                 node_choose(1,m) = PX1;
% %                             end
%                             if(PX1 >= PX2)
%                                 node_choose(1,m) = PX1;
%                             else
%                                 node_choose(1,m) = PX2;
%                             end
                            
                            
%                             [LCS_1] = match_direct(node_struct{m}.model{1},series_flip);
%                             [px_model,px_series] = cal_match(node_struct{m}.model,series_flip,LCS_1,4);
                        else
                            [LCS_1] = match_direct(node_struct{m}.model{1},node_struct{i}.receive{j}.series);
                            [px_model,px_series] = cal_match(node_struct{m}.model,[node_struct{i}.receive{j}.series;node_struct{i}.receive{j}.series_cnt],LCS_1,4);
                            if(px_model >= PX_flag && px_series >= PX_flag)
                                node_choose(1,m) = (px_model + px_series)/2;
                            else
                                node_choose(1,m) = 0;
                            end
%                             if(px_model >= PX_flag)
%                                 if(px_model >= PX_flag_h)
%                                     px_model = PX_flag_h;
%                                 else
%                                     px_model = PX_flag;
%                                 end
% 
%                             end
%                             if(px_series >= PX_flag)
%                                 if(px_series >= PX_flag_h)
%                                     px_series = PX_flag_h;
%                                 else
%                                     px_series = PX_flag;
%                                 end
%                             end
%                             node_choose(1,m) = (px_model + px_series)/2;
                        end

%                         if(px_model == 1)
%                             node_choose(1,m) = px_series;
%                         else
%                             node_choose(1,m) = 0;
%                         end
%                         [~,size_LCS_1] = size(LCS_1);
%                         node_choose(1,m) = size_LCS_1/size_axis;
                    end
                end
                [max_PX,pointer_PX] = max(node_choose);
                if(max_PX >= PX_flag)
                    if(~isempty(node_struct{pointer_PX}.receive))
                        [~,size_pointer_receive] = size(node_struct{pointer_PX}.receive);
                        node_struct{pointer_PX}.receive{size_pointer_receive + 1} = struct;
                        node_struct{pointer_PX}.receive{size_pointer_receive + 1}.receive_id = node_struct{i}.receive{j}.receive_id;
                        node_struct{pointer_PX}.receive{size_pointer_receive + 1}.input_direct = 0;
                        node_struct{pointer_PX}.receive{size_pointer_receive + 1}.series_end = node_struct{i}.receive{j}.series_end;
                        node_struct{pointer_PX}.receive{size_pointer_receive + 1}.pro_zero = 0;
                        node_struct{pointer_PX}.receive{size_pointer_receive + 1}.valid_in = 0;
                        node_struct{pointer_PX}.receive{size_pointer_receive + 1}.series_invalid = 0;
                        node_struct{pointer_PX}.receive{size_pointer_receive + 1}.series = node_struct{i}.receive{j}.series;
                        node_struct{pointer_PX}.receive{size_pointer_receive + 1}.series_cnt = node_struct{i}.receive{j}.series_cnt;
                        node_struct{pointer_PX}.receive{size_pointer_receive + 1}.output = [node_struct{i}.receive{j}.receive_id,pointer_PX];
                        node_struct{pointer_PX}.receive{size_pointer_receive + 1}.history_output = [node_struct{i}.receive{j}.receive_id,pointer_PX];
                        node_struct{pointer_PX}.receive{size_pointer_receive + 1}.accept = 0;
                        node_struct{pointer_PX}.receive{size_pointer_receive + 1}.no_response = node_struct{i}.receive{j}.no_response;
                        node_struct{pointer_PX}.receive{size_pointer_receive + 1}.need_clear = node_struct{i}.receive{j}.series_end;
                    else
                        node_struct{pointer_PX}.receive{1} = struct;
                        node_struct{pointer_PX}.receive{1}.receive_id = node_struct{i}.receive{j}.receive_id;
                        node_struct{pointer_PX}.receive{1}.input_direct = 0;
                        node_struct{pointer_PX}.receive{1}.series_end = node_struct{i}.receive{j}.series_end;
                        node_struct{pointer_PX}.receive{1}.pro_zero = 0;
                        node_struct{pointer_PX}.receive{1}.valid_in = 0;
                        node_struct{pointer_PX}.receive{1}.series_invalid = 0;
                        node_struct{pointer_PX}.receive{1}.series = node_struct{i}.receive{j}.series;
                        node_struct{pointer_PX}.receive{1}.series_cnt = node_struct{i}.receive{j}.series_cnt;
                        node_struct{pointer_PX}.receive{1}.output = [node_struct{i}.receive{j}.receive_id,pointer_PX];
                        node_struct{pointer_PX}.receive{1}.history_output = [node_struct{i}.receive{j}.receive_id,pointer_PX];
                        node_struct{pointer_PX}.receive{1}.accept = 0;
                        node_struct{pointer_PX}.receive{1}.no_response = node_struct{i}.receive{j}.no_response;
                        node_struct{pointer_PX}.receive{1}.need_clear = node_struct{i}.receive{j}.series_end;
                    end
                    node_struct{pointer_PX}.work_state = 1;
                    if(node_struct{i}.receive{j}.series_end == 1 && max_PX >= PX_flag+0.1)
                        [~,size_axis] = size(node_struct{i}.receive{j}.series);
%                         for k = 1:1:size_axis
%                             node_struct{m}.model{2}(k) = model_cnt_initial*node_struct{i}.receive{j}.series_cnt(k);
%                         end
                        [LCS_1] = match_direct(node_struct{pointer_PX}.model{1},node_struct{i}.receive{j}.series);
                        node_struct{pointer_PX}.model = model_fusion_direct(LCS_1,node_struct{pointer_PX}.model,{node_struct{i}.receive{j}.series,model_cnt_initial*node_struct{i}.receive{j}.series_cnt},model_upper);
%                         node_struct{pointer_PX}.model = model_fusion_direct(LCS_1,node_struct{pointer_PX}.model,{node_struct{i}.receive{j}.series,model_cnt_initial*ones(1,size_axis)});
                    end
                else
                    for m = 1:1:level_number
                        if(~any(any(node_struct{m}.model{1})) && m ~= i && isempty(node_struct{m}.receive))
                            node_struct{m}.receive{1} = struct;
                            node_struct{m}.receive{1}.receive_id = node_struct{i}.receive{j}.receive_id;
                            node_struct{m}.receive{1}.input_direct = 0;
                            node_struct{m}.receive{1}.series_end = node_struct{i}.receive{j}.series_end;
                            node_struct{m}.receive{1}.pro_zero = 0;
                            node_struct{m}.receive{1}.valid_in = 0;
                            node_struct{m}.receive{1}.series_invalid = 0;
                            node_struct{m}.receive{1}.series = node_struct{i}.receive{j}.series;
                            node_struct{m}.receive{1}.series_cnt = node_struct{i}.receive{j}.series_cnt;
                            node_struct{m}.receive{1}.output = node_struct{i}.receive{j}.output;
                            node_struct{m}.receive{1}.history_output = node_struct{i}.receive{j}.history_output;
                            node_struct{m}.receive{1}.accept = 0;
                            node_struct{m}.receive{1}.no_response = node_struct{i}.receive{j}.no_response;
                            node_struct{m}.receive{1}.need_clear = node_struct{i}.receive{j}.series_end;
                            node_struct{m}.work_state = 1;
                            if(node_struct{i}.receive{j}.series_end == 1)
                                [~,size_axis] = size(node_struct{i}.receive{j}.series);
                                node_struct{m}.model{1} = node_struct{i}.receive{j}.series;
                                node_struct{m}.model{2} = model_cnt_initial*node_struct{i}.receive{j}.series_cnt;
%                                 for k = 1:1:size_axis
%                                     node_struct{m}.model{2}(k) = model_cnt_initial*node_struct{i}.receive{j}.series_cnt(k);
%                                 end
%                                 node_struct{m}.model{2} = model_cnt_initial*ones(1,size_axis);%model_cnt_
                                node_struct{m}.receive{1}.output = [node_struct{i}.receive{j}.receive_id,node_struct{m}.node_id];
                            end
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

end
