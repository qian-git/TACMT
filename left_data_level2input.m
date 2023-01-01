function [ level2_node ] = left_data_level2input( level2_node,direct_source_frame,expansion_alg_source_frame,row,col,level2_number )

for i = 1:1:row
    for j = 1:1:col
        if(expansion_alg_source_frame(i,j)~=0)
            line_up = i;
            line_down = 0;line_left = 0;line_right = 0;
            down_num = 1;left_num = 1;right_num = 1;
            while(line_down==0 && line_left==0 && line_right==0)
                if(j == 1 || (j-left_num)<=1)
                    left_num_plus = 0;
                else
                    if(~any(expansion_alg_source_frame(line_up:(line_up+down_num-1),j-left_num)))
                       left_num_plus = 0;
                   else
                       left_num_plus = 1;
                   end
                end
                if(j == col || (j+right_num)>=col-1)
                    right_num_plus = 0;
                else
                    if(~any(expansion_alg_source_frame(line_up:(line_up+down_num-1),j+right_num)))
                       right_num_plus = 0;
                   else
                       right_num_plus = 1;
                   end
                end
                left_num = left_num + left_num_plus;right_num = right_num + right_num_plus;
                if(j-left_num <1)
                    m_left = 1;
                else
                    m_left = j-left_num;
                end
                if(j+right_num >col)
                    m_right = col;
                else
                    m_right = j+right_num;
                end
                if(i== row || (i+down_num)>=row-1)
                    down_num_plus = 0;
                else
                    if(~any(expansion_alg_source_frame(i+down_num,m_left:m_right)))
                        down_num_plus = 0;
                    else
                        down_num_plus = 1;
                    end
                end
                down_num = down_num + down_num_plus;
                if(left_num_plus==0 && right_num_plus==0 && down_num_plus==0)
                    line_down = line_up + down_num-1;
                    line_left = j - left_num+1;
                    line_right = j + right_num-1;
                end
            end
%-----------------------------------------------------------------------------------------------
            if(down_num<18 || (right_num + left_num)<18)
               for m = line_up:1:line_down
                  for n = line_left:1:line_right
                     expansion_alg_source_frame(m,n) = 0;
                  end
               end
            else
                for m = 1:1:level2_number
                   if(level2_node{m}.work_state == 0)
                       level2_node{m}.position = [line_up,line_down,line_left,line_right];
%                        sample = zeros((line_down-line_up),(line_right-line_left));
                       sample = direct_source_frame(line_up:line_down,line_left:line_right);
                       [level2_node{m}.sample_direct,level2_node{m}.time_direct] = sample_analysis(sample,level2_node{m}.time_direct);
                       level2_node{m}.stay_data = 4;
                        for x = line_up:1:line_down
                            for y = line_left:1:line_right
                                expansion_alg_source_frame(x,y) = 0;
                            end
                        end
                        level2_node{m}.work_state = 1;
                        break;
                   end
                end
            end
        end  
    end
end
end

