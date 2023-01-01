function [ node_struct ] = level3_func( node_struct,input_array )
model_cnt_initial = 50;
[~,level_number] = size(node_struct);
% PX_flag = 0.8;PX_half = 0.55;PX_merge = 0.9;% PX_merge = 0.65;
PX_flag = 0.65;PX_half = 0.5;
%buffer_clear
for i = 1:1:level_number
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
                        node_struct{j}.receive{k}.input_position = input_array(i,2:3);
                        if(any(input_array(i,2:3) == zeros(1,2)))
                            node_struct{j}.receive{k}.series_end = 1;
                        end
                        [~,axis_size] = size(node_struct{j}.receive{k}.axis_1);
                        if((abs(node_struct{j}.receive{k}.axis_1(1,axis_size) - input_array(i,2)) > 5 && abs(node_struct{j}.receive{k}.axis_2(1,axis_size) - input_array(i,3)) > 5) || ~any(input_array(i,2:3) ~= zeros(1,2)))
                            node_struct{j}.receive{k}.valid_in = 1;
                            node_struct{j}.receive{k}.axis_1(1,axis_size + 1) = input_array(i,2);
                            node_struct{j}.receive{k}.axis_2(1,axis_size + 1) = input_array(i,3);
                        else
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
        if(data_accept == 0 && any(input_array(i,2:3) ~= zeros(1,2)))
            axis_1 = input_array(i,2);
            axis_2 = input_array(i,3);
            model_choose = zeros(1,level_number);
            for m = 1:1:level_number
                if(~isempty(node_struct{m}.model{1}))
                    [~,size_model] = size(node_struct{m}.model{1});
                    for n = 1:1:size_model
                        if(abs(node_struct{m}.model{1}(1,n) - axis_1) <= 5 && abs(node_struct{m}.model{1}(2,n) - axis_2) <= 5)
%                         if(all(node_struct{m}.model{1}(:,n) == [axis_1;axis_2]))% problem
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
                    node_struct{pointer_PX}.receive{size_pointer_receive + 1}.input_position = input_array(i,2:3);
                    node_struct{pointer_PX}.receive{size_pointer_receive + 1}.series_end = 0;
                    node_struct{pointer_PX}.receive{size_pointer_receive + 1}.pro_zero = 0;
                    node_struct{pointer_PX}.receive{size_pointer_receive + 1}.valid_in = 1;
                    node_struct{pointer_PX}.receive{size_pointer_receive + 1}.series_invalid = 0;
                    node_struct{pointer_PX}.receive{size_pointer_receive + 1}.axis_1 = [];
                    node_struct{pointer_PX}.receive{size_pointer_receive + 1}.axis_2 = [];
                    node_struct{pointer_PX}.receive{size_pointer_receive + 1}.axis_1(1) = axis_1;
                    node_struct{pointer_PX}.receive{size_pointer_receive + 1}.axis_2(1) = axis_2;
                    node_struct{pointer_PX}.receive{size_pointer_receive + 1}.output = [input_array(i,1),999];
                    node_struct{pointer_PX}.receive{size_pointer_receive + 1}.history_output = [input_array(i,1),999];
                    node_struct{pointer_PX}.receive{size_pointer_receive + 1}.accept = 1;
                    node_struct{pointer_PX}.receive{size_pointer_receive + 1}.no_response = 0;
                    node_struct{pointer_PX}.receive{size_pointer_receive + 1}.need_clear = 0;
                else
                    node_struct{pointer_PX}.receive{1} = struct;
                    node_struct{pointer_PX}.receive{1}.receive_id = input_array(i,1);
                    node_struct{pointer_PX}.receive{1}.input_position = input_array(i,2:3);
                    node_struct{pointer_PX}.receive{1}.series_end = 0;
                    node_struct{pointer_PX}.receive{1}.pro_zero = 0;
                    node_struct{pointer_PX}.receive{1}.valid_in = 1;
                    node_struct{pointer_PX}.receive{1}.series_invalid = 0;
                    node_struct{pointer_PX}.receive{1}.axis_1 = [];
                    node_struct{pointer_PX}.receive{1}.axis_2 = [];
                    node_struct{pointer_PX}.receive{1}.axis_1(1) = axis_1;
                    node_struct{pointer_PX}.receive{1}.axis_2(1) = axis_2;
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
                        node_struct{m}.receive{1}.input_position = input_array(i,2:3);
                        node_struct{m}.receive{1}.series_end = 0;
                        node_struct{m}.receive{1}.pro_zero = 0;
                        node_struct{m}.receive{1}.valid_in = 1;
                        node_struct{m}.receive{1}.series_invalid = 0;
                        node_struct{m}.receive{1}.axis_1 = [];
                        node_struct{m}.receive{1}.axis_2 = [];
                        node_struct{m}.receive{1}.axis_1(1) = axis_1;
                        node_struct{m}.receive{1}.axis_2(1) = axis_2;
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
    if(~any(node_struct{i}.model{1}))
        build_model = 1;
    else
        build_model = 0;
    end
    if(node_struct{i}.work_state == 1 && ~isempty(node_struct{i}.receive))
        [~,size_receive] = size(node_struct{i}.receive);
        for j = 1:1:size_receive
%             PX = 0;
            if(node_struct{i}.receive{j}.valid_in == 1)
                [~,size_axis] = size(node_struct{i}.receive{j}.axis_1);
                if(build_model == 0)
%                     LCS = zeros(4,size_axis);
                    [LCS] = match_position(node_struct{i}.model{1},[node_struct{i}.receive{j}.axis_1;node_struct{i}.receive{j}.axis_2]);
                    [px_model,px_series] = cal_match(node_struct{i}.model,[node_struct{i}.receive{j}.axis_1;node_struct{i}.receive{j}.axis_2],LCS,3);
%                     [~,size_LCS] = size(LCS);
%                     PX = size_LCS/size_axis;
                    PX = (px_model + px_series)/2;
                    if(size_axis > 2  || node_struct{i}.receive{j}.series_end == 1)
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
                        if(node_struct{i}.receive{j}.series_end == 1)
%                             if(px_model == 1 && px_series >= PX_flag+0.1)
                            if(PX >= PX_flag+0.1) % merge_model
                                node_struct{i}.model = model_fusion_position(LCS,node_struct{i}.model,{[node_struct{i}.receive{j}.axis_1;node_struct{i}.receive{j}.axis_2],model_cnt_initial*ones(1,size_axis)});%model_cnt_
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
                        for m = 1:1:level_number
                            if(m ~= node_struct{i}.node_id && ~isempty(node_struct{m}.model{1}))
                                [LCS_1] = match_position(node_struct{m}.model{1},[node_struct{i}.receive{j}.axis_1;node_struct{i}.receive{j}.axis_2]);
                                [px_model,px_series] = cal_match(node_struct{m}.model,[node_struct{i}.receive{j}.axis_1;node_struct{i}.receive{j}.axis_2],LCS_1,3);
                                node_choose(1,m) = (px_model + px_series)/2;
%                                 if(px_model == 1)
%                                     node_choose(1,m) = px_series;
%                                 else
%                                     node_choose(1,m) = 0;
%                                 end
%                                 [~,size_LCS_1] = size(LCS_1);
%                                 node_choose(1,m) = size_LCS_1/size_axis;
                            end
                        end
                        [max_PX,pointer_PX] = max(node_choose);
                        if(max_PX >= PX_flag)
                            if(max_PX >= PX_flag+0.1) %merge_model
                                [LCS_1] = match_position(node_struct{pointer_PX}.model{1},[node_struct{i}.receive{j}.axis_1;node_struct{i}.receive{j}.axis_2]);
                                node_struct{pointer_PX}.model = model_fusion_position(LCS_1,node_struct{pointer_PX}.model,{[node_struct{i}.receive{j}.axis_1;node_struct{i}.receive{j}.axis_2],model_cnt_initial*ones(1,size_axis)});%model_cnt_
                            end
                            node_struct{i}.receive{j}.output = [node_struct{i}.receive{j}.receive_id,pointer_PX];
                            node_struct{i}.receive{j}.history_output = [node_struct{i}.receive{j}.receive_id,pointer_PX];
                            build_model = 0;
                            node_struct{i}.receive{j}.need_clear = 1;
                        else %build new model
                            node_struct{i}.model{1} = [node_struct{i}.receive{j}.axis_1;node_struct{i}.receive{j}.axis_2];
                            node_struct{i}.model{2} = model_cnt_initial*ones(1,size_axis);%model_cnt_
                            node_struct{i}.receive{j}.output = [node_struct{i}.receive{j}.receive_id,node_struct{i}.node_id];
                            node_struct{i}.receive{j}.history_output = [node_struct{i}.receive{j}.receive_id,node_struct{i}.node_id];
                            build_model = 0;
                            node_struct{i}.receive{j}.need_clear = 1;
                        end
%                         node_struct{i}.model{1} = [node_struct{i}.receive{j}.axis_1;node_struct{i}.receive{j}.axis_2];
%                         node_struct{i}.model{2} = model_cnt_initial*ones(1,size_axis);%model_cnt_
%                         build_model = 1;
%                         node_struct{i}.receive{j}.need_clear = 1;
                    end
                end
%             else 
%                 node_struct{i}.receive{j}.output = node_struct{i}.receive{j}.history_output;
            end
%             if(node_struct{i}.receive{j}.series_end == 1)
%                 if(PX >= PX_merge) % merge_model
%                     node_struct{i}.model = model_fusion_position(LCS,node_struct{i}.model,{[node_struct{i}.receive{j}.axis_1;node_struct{i}.receive{j}.axis_2],model_cnt_initial*ones(1,size_axis)});%model_cnt_
% %                 else
% %                     
%                 end
%                 node_struct{i}.receive{j}.need_clear = 1;
%             end
            node_struct{i}.receive{j}.valid_in = 0;
            node_struct{i}.receive{j}.accept = 0;
            node_struct{i}.receive{j}.input_position = zeros(1,2);
        end
        
        for j = size_receive:-1:1
            if(node_struct{i}.receive{j}.series_invalid == 1)
                node_choose = zeros(1,level_number);
                for m = 1:1:level_number
                    if(m ~= node_struct{i}.node_id && ~isempty(node_struct{m}.model{1}))
                        [LCS_1] = match_position(node_struct{m}.model{1},[node_struct{i}.receive{j}.axis_1;node_struct{i}.receive{j}.axis_2]);
                        [px_model,px_series] = cal_match(node_struct{m}.model,[node_struct{i}.receive{j}.axis_1;node_struct{i}.receive{j}.axis_2],LCS_1,3);
                        node_choose(1,m) = (px_model + px_series)/2;
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
                if(max_PX >= PX_half)
                    if(~isempty(node_struct{pointer_PX}.receive))
                        [~,size_pointer_receive] = size(node_struct{pointer_PX}.receive);
                        node_struct{pointer_PX}.receive{size_pointer_receive + 1} = struct;
                        node_struct{pointer_PX}.receive{size_pointer_receive + 1}.receive_id = node_struct{i}.receive{j}.receive_id;
                        node_struct{pointer_PX}.receive{size_pointer_receive + 1}.input_position = zeros(1,2);
                        node_struct{pointer_PX}.receive{size_pointer_receive + 1}.series_end = node_struct{i}.receive{j}.series_end;
                        node_struct{pointer_PX}.receive{size_pointer_receive + 1}.pro_zero = 0;
                        node_struct{pointer_PX}.receive{size_pointer_receive + 1}.valid_in = 0;
                        node_struct{pointer_PX}.receive{size_pointer_receive + 1}.series_invalid = 0;
                        node_struct{pointer_PX}.receive{size_pointer_receive + 1}.axis_1 = node_struct{i}.receive{j}.axis_1;
                        node_struct{pointer_PX}.receive{size_pointer_receive + 1}.axis_2 = node_struct{i}.receive{j}.axis_2;
                        node_struct{pointer_PX}.receive{size_pointer_receive + 1}.output = [node_struct{i}.receive{j}.receive_id,pointer_PX];
                        node_struct{pointer_PX}.receive{size_pointer_receive + 1}.history_output = [node_struct{i}.receive{j}.receive_id,pointer_PX];
                        node_struct{pointer_PX}.receive{size_pointer_receive + 1}.accept = 0;
                        node_struct{pointer_PX}.receive{size_pointer_receive + 1}.no_response = node_struct{i}.receive{j}.no_response;
                        node_struct{pointer_PX}.receive{size_pointer_receive + 1}.need_clear = node_struct{i}.receive{j}.need_clear;
                    else
                        node_struct{pointer_PX}.receive{1} = struct;
                        node_struct{pointer_PX}.receive{1}.receive_id = node_struct{i}.receive{j}.receive_id;
                        node_struct{pointer_PX}.receive{1}.input_position = zeros(1,2);
                        node_struct{pointer_PX}.receive{1}.series_end = node_struct{i}.receive{j}.series_end;
                        node_struct{pointer_PX}.receive{1}.pro_zero = 0;
                        node_struct{pointer_PX}.receive{1}.valid_in = 0;
                        node_struct{pointer_PX}.receive{1}.series_invalid = 0;
                        node_struct{pointer_PX}.receive{1}.axis_1 = node_struct{i}.receive{j}.axis_1;
                        node_struct{pointer_PX}.receive{1}.axis_2 = node_struct{i}.receive{j}.axis_2;
                        node_struct{pointer_PX}.receive{1}.output = [node_struct{i}.receive{j}.receive_id,pointer_PX];
                        node_struct{pointer_PX}.receive{1}.history_output = [node_struct{i}.receive{j}.receive_id,pointer_PX];
                        node_struct{pointer_PX}.receive{1}.accept = 0;
                        node_struct{pointer_PX}.receive{1}.no_response = node_struct{i}.receive{j}.no_response;
                        node_struct{pointer_PX}.receive{1}.need_clear = node_struct{i}.receive{j}.need_clear;
                    end
                    node_struct{pointer_PX}.work_state = 1;
                    if(node_struct{i}.receive{j}.series_end == 1 && max_PX >= PX_flag+0.1)
                        [~,size_axis] = size(node_struct{i}.receive{j}.series);
                        [LCS_1] = match_position(node_struct{pointer_PX}.model{1},[node_struct{i}.receive{j}.axis_1;node_struct{i}.receive{j}.axis_2]);
                        node_struct{pointer_PX}.model = model_fusion_position(LCS_1,node_struct{pointer_PX}.model,{[node_struct{i}.receive{j}.axis_1;node_struct{i}.receive{j}.axis_2],model_cnt_initial*ones(1,size_axis)});
                    end
                else
                    for m = 1:1:level_number
                        if(~any(any(node_struct{m}.model{1})) && m ~= i && isempty(node_struct{m}.receive))
                            node_struct{m}.receive{1} = struct;
                            node_struct{m}.receive{1}.receive_id = node_struct{i}.receive{j}.receive_id;
                            node_struct{m}.receive{1}.input_position = zeros(1,2);
                            node_struct{m}.receive{1}.series_end = node_struct{i}.receive{j}.series_end;
                            node_struct{m}.receive{1}.pro_zero = 0;
                            node_struct{m}.receive{1}.valid_in = 0;
                            node_struct{m}.receive{1}.series_invalid = 0;
                            node_struct{m}.receive{1}.axis_1 = node_struct{i}.receive{j}.axis_1;
                            node_struct{m}.receive{1}.axis_2 = node_struct{i}.receive{j}.axis_2;
                            node_struct{m}.receive{1}.output = node_struct{i}.receive{j}.output;
                            node_struct{m}.receive{1}.history_output = node_struct{i}.receive{j}.output;
                            node_struct{m}.receive{1}.accept = 0;
                            node_struct{m}.receive{1}.no_response = node_struct{i}.receive{j}.no_response;
                            node_struct{m}.receive{1}.need_clear = node_struct{i}.receive{j}.need_clear;
                            node_struct{m}.work_state = 1;
                            if(node_struct{i}.receive{j}.series_end == 1)
                                [~,size_axis] = size(node_struct{i}.receive{j}.series);
                                node_struct{m}.model{1} = node_struct{i}.receive{j}.series;
                                node_struct{m}.model{2} = model_cnt_initial*ones(1,size_axis);%model_cnt_
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
