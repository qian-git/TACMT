function [lay1_node_result_D,lay1_node_result_dt] = perceive_pix(layer1,layer2,direct,power)
    % lay1_node_result_D: 8 directions, 
    % lay1_node_result_power: 3
%     direct_x = 0;direct_y = 0;
    layer1_cnt = 0;layer2_cnt = 0;
    layer1_mcnt = 0;layer2_mcnt = 0;
%     lay1_node_result_dt = 0;
    layer1_x = 0;layer1_y = 0;layer2_x = 0;layer2_y = 0;
    layer1_m = 0;layer1_n = 0;layer2_m = 0;layer2_n = 0;
%     flag_p = 0;flag_n = 0;
%     layer1_x_2 = 0;layer1_y_2 = 0;layer2_x_2 = 0;layer2_y_2 = 0;
    for i = 1:1:3
        for j = 1:1:3
            if(layer1(i,j) == 1)
                layer1_x = layer1_x + i;
                layer1_y = layer1_y + j;
                layer1_cnt = layer1_cnt + 1;
            elseif(layer1(i,j) == -1)
                layer1_m = layer1_m + i;
                layer1_n = layer1_n + j;
                layer1_mcnt = layer1_mcnt + 1;
            end
            if(layer2(i,j) == 1)
                layer2_x = layer2_x + i;
                layer2_y = layer2_y + j;
                layer2_cnt = layer2_cnt + 1;
            elseif(layer2(i,j) == -1)
                layer2_m = layer2_m + i;
                layer2_n = layer2_n + j;
                layer2_mcnt = layer2_mcnt + 1;
            end
        end
    end
    
%     if(layer1_cnt ~= 0)
%         layer1_x_2 = layer1_x/layer1_cnt; layer1_y_2 = layer1_y/layer1_cnt;
%     else
%         layer1_x_2 = 0; layer1_y_2 = 0;
%     end
%     if(layer2_cnt ~= 0)
%         layer2_x_2 = layer2_x/layer2_cnt; layer2_y_2 = layer2_y/layer2_cnt;
%     else
%         layer2_x_2 = 0;layer2_y_2 = 0;
%     end
%     if(layer2_x_2 ~= 0 && layer1_x_2 ~= 0)
%         
%     elseif(layer2_x_2 ~= 0 && layer1_x_2 == 0)
%         direct_1x = layer2_x_2 - layer1_x_2;
%     elseif(layer2_x_2 == 0 && layer1_x_2 ~= 0)
%         direct_1x = layer2_x_2 - layer1_x_2;
%     else
%         direct_1x = 0;
    if(layer1_cnt ~= 0 && layer2_cnt ~= 0)
        layer1_x_2 = layer1_x/layer1_cnt; layer1_y_2 = layer1_y/layer1_cnt;
        layer2_x_2 = layer2_x/layer2_cnt; layer2_y_2 = layer2_y/layer2_cnt;
        flag_p = 0;
    elseif(layer1_cnt ~= 0 && layer2_cnt == 0)
        flag_p = 1;
        layer1_x_2 = 0;layer1_y_2 = 0;layer2_x_2 = 0;layer2_y_2 = 0;
    elseif(layer1_cnt == 0 && layer2_cnt ~= 0)
        flag_p = 1;
        layer1_x_2 = 0;layer1_y_2 = 0;layer2_x_2 = 0;layer2_y_2 = 0;
    else
        layer1_x_2 = 0;layer1_y_2 = 0;layer2_x_2 = 0;layer2_y_2 = 0;
        flag_p = 2;
    end
    if(layer1_mcnt ~= 0 && layer2_mcnt ~= 0)
        layer1_m_2 = layer1_m/layer1_mcnt; layer1_n_2 = layer1_n/layer1_mcnt;
        layer2_m_2 = layer2_m/layer2_mcnt; layer2_n_2 = layer2_n/layer2_mcnt;
        flag_n = 0;
    elseif(layer1_mcnt ~= 0 && layer2_mcnt == 0)
        flag_n = 1;
        layer1_m_2 = 0;layer1_n_2 = 0;layer2_m_2 = 0;layer2_n_2 = 0;
    elseif(layer1_mcnt == 0 && layer2_mcnt ~= 0)
        flag_n = 1;
        layer1_m_2 = 0;layer1_n_2 = 0;layer2_m_2 = 0;layer2_n_2 = 0;
    else
        flag_n = 2;
        layer1_m_2 = 0;layer1_n_2 = 0;layer2_m_2 = 0;layer2_n_2 = 0;
    end
    direct_m = layer2_m_2 - layer1_m_2; direct_n = layer2_n_2 - layer1_n_2;
    direct_1x = layer2_x_2 - layer1_x_2;direct_1y = layer2_y_2 - layer1_y_2;
    direct_x = direct_m + direct_1x; direct_y = direct_n + direct_1y;
    
%     for m = 1:1:3
%         for n = 1:1:3
%             if(layer1(m,n) ~= 0)
%                 for i = 1:1:3
%                     for j = 1:1:3
%                         if(layer1(m,n) == layer2(i,j) && m~=i && n~=j)
%                             direct_x = direct_x + (i-m);
%                             direct_y = direct_y + (j-n);
%                         end
%                     end
%                 end
%             end
%         end
%     end
    if(flag_p ==2 && flag_n == 2)
        lay1_node_result_dt = 0;
    elseif(flag_p ~=0 && flag_n ~= 0)
        lay1_node_result_dt = direct;
    else
        if(direct_x == 0)
            if(direct_y == 0)
                lay1_node_result_dt = 0;
            elseif(direct_y >0)
                lay1_node_result_dt = 1;
            else
                lay1_node_result_dt = 5;
            end
        elseif(direct_x > 0)
            if(direct_y == 0)
                lay1_node_result_dt = 3;
            elseif(direct_y >0)
                lay1_node_result_dt = 2;
            else
                lay1_node_result_dt = 4;
            end
        else
            if(direct_y == 0)
                lay1_node_result_dt = 7;
            elseif(direct_y >0)
                lay1_node_result_dt = 8;
            else
                lay1_node_result_dt = 6;
            end
        end
    end
    time_direct1 = [lay1_node_result_dt,power(1:4)];
    direct_x_1 = 0;direct_y_1 = 0;
    for i = 1:5
      
      if(time_direct1(i) == 1)
          direct_x_1 = direct_x_1 + 1;
      elseif(time_direct1(i) == 2)
          direct_x_1 = direct_x_1 + 1;
          direct_y_1 = direct_y_1 + 1;
      elseif(time_direct1(i) == 3)
          direct_y_1 = direct_y_1 + 1;
      elseif(time_direct1(i) == 4)
          direct_x_1 = direct_x_1 - 1;
          direct_y_1 = direct_y_1 + 1;
      elseif(time_direct1(i) == 5)
          direct_x_1 = direct_x_1 - 1;
      elseif(time_direct1(i) == 6)
          direct_x_1 = direct_x_1 - 1;
          direct_y_1 = direct_y_1 - 1;
      elseif(time_direct1(i) == 7)
          direct_y_1 = direct_y_1 - 1;
      elseif(time_direct1(i) == 8)
          direct_x_1 = direct_x_1 + 1;
          direct_y_1 = direct_y_1 - 1;
      end
    end
    if(direct_x_1>=0)
        if(direct_y_1>=0)
            if(direct_x_1 == 0 && direct_y_1 == 0)
                time_direct2 = 0;
            else
                if(abs(direct_x_1) >= abs(direct_y_1)*4)
                    time_direct2 = 1;
                elseif(abs(direct_x_1)*4 <= abs(direct_y_1))
                    time_direct2 = 3;
                else
                    time_direct2 = 2;
                end
            end
        else
            if(abs(direct_x_1) >= abs(direct_y_1)*4)
                time_direct2 = 1;
            elseif(abs(direct_x_1)*4 <= abs(direct_y_1))
                time_direct2 = 7;
            else
                time_direct2 = 8;
            end
        end
    else
        if(direct_y_1>=0)
            if(abs(direct_x_1) >= direct_y_1*4)
                time_direct2 = 5;
            elseif(abs(direct_x_1)*4 <= direct_y_1)
                time_direct2 = 3;
            else
                time_direct2 = 4;
            end
        else
            if(abs(direct_x_1) >= abs(direct_y_1)*4)
                time_direct2 = 5;
            elseif(abs(direct_x_1)*4 <= abs(direct_y_1))
                time_direct2 = 7;
            else
                time_direct2 = 6;
            end
        end
    end
    
    lay1_node_result_D = time_direct2;
    
end
