function [sample_direct_time,time_direct1] = sample_analysis( sample_array,time_direct )
    [sample_row,sample_col] = size(sample_array);

    direct_x = 0;direct_y = 0;
    for i = 1:sample_row
       for j = 1:sample_col
          if(sample_array(i,j) == 1)
              direct_x = direct_x + 2;
          elseif(sample_array(i,j) == 2)
              direct_x = direct_x + 1;
              direct_y = direct_y + 1;
          elseif(sample_array(i,j) == 3)
              direct_y = direct_y + 2;
          elseif(sample_array(i,j) == 4)
              direct_x = direct_x - 1;
              direct_y = direct_y + 1;
          elseif(sample_array(i,j) == 5)
              direct_x = direct_x - 2;
          elseif(sample_array(i,j) == 6)
              direct_x = direct_x - 1;
              direct_y = direct_y - 1;
          elseif(sample_array(i,j) == 7)
              direct_y = direct_y - 2;
          elseif(sample_array(i,j) == 8)
              direct_x = direct_x + 1;
              direct_y = direct_y - 1;
          end
       end
    end
    if(direct_x>=0)
        if(direct_y>=0)
            if(direct_x == 0 && direct_y == 0)
                sample_direct = 0;
            else
                if(abs(direct_x) >= abs(direct_y)*4)
                    sample_direct = 1;
                elseif(abs(direct_x)*4 <= abs(direct_y))
                    sample_direct = 3;
                else
                    sample_direct = 2;
                end
            end
        else
            if(abs(direct_x) >= abs(direct_y)*4)
                sample_direct = 1;
            elseif(abs(direct_x)*4 <= abs(direct_y))
                sample_direct = 7;
            else
                sample_direct = 8;
            end
        end
    else
        if(direct_y>=0)
            if(abs(direct_x) >= direct_y*4)
                sample_direct = 5;
            elseif(abs(direct_x)*4 <= direct_y)
                sample_direct = 3;
            else
                sample_direct = 4;
            end
        else
            if(abs(direct_x) >= abs(direct_y)*4)
                sample_direct = 5;
            elseif(abs(direct_x)*4 <= abs(direct_y))
                sample_direct = 7;
            else
                sample_direct = 6;
            end
        end
    end
    initi_flag = 0;
    if(all(time_direct(5:10) == zeros(1,6)))
        initi_flag = 1;
    end
    time_direct1 = [sample_direct,time_direct(1:9)];
    direct_x_1 = 0;direct_y_1 = 0;
    
    for i = 1:10
      if(time_direct1(i) == 1)
          direct_x_1 = direct_x_1 + 2;
      elseif(time_direct1(i) == 2)
          direct_x_1 = direct_x_1 + 1;
          direct_y_1 = direct_y_1 + 1;
      elseif(time_direct1(i) == 3)
          direct_y_1 = direct_y_1 + 2;
      elseif(time_direct1(i) == 4)
          direct_x_1 = direct_x_1 - 1;
          direct_y_1 = direct_y_1 + 1;
      elseif(time_direct1(i) == 5)
          direct_x_1 = direct_x_1 - 2;
      elseif(time_direct1(i) == 6)
          direct_x_1 = direct_x_1 - 1;
          direct_y_1 = direct_y_1 - 1;
      elseif(time_direct1(i) == 7)
          direct_y_1 = direct_y_1 - 2;
      elseif(time_direct1(i) == 8)
          direct_x_1 = direct_x_1 + 1;
          direct_y_1 = direct_y_1 - 1;
      end
%       if(i == 1)
%           direct_x_1 = direct_x_1 * 2;
%           direct_y_1 = direct_y_1 * 2;
%       end
    end
    
    if(initi_flag == 0)
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
    else
        if(direct_x_1>=0)
            if(direct_y_1>=0)
                if(direct_x_1 == 0 && direct_y_1 == 0)
                    time_direct2 = 0;
                else
                    if(abs(direct_x_1) >= abs(direct_y_1)*2)
                        time_direct2 = 1;
                    elseif(abs(direct_x_1)*2 <= abs(direct_y_1))
                        time_direct2 = 3;
                    else
                        time_direct2 = 2;
                    end
                end
            else
                if(abs(direct_x_1) >= abs(direct_y_1)*2)
                    time_direct2 = 1;
                elseif(abs(direct_x_1)*2 <= abs(direct_y_1))
                    time_direct2 = 7;
                else
                    time_direct2 = 8;
                end
            end
        else
            if(direct_y_1>=0)
                if(abs(direct_x_1) >= direct_y_1*2)
                    time_direct2 = 5;
                elseif(abs(direct_x_1)*2 <= direct_y_1)
                    time_direct2 = 3;
                else
                    time_direct2 = 4;
                end
            else
                if(abs(direct_x_1) >= abs(direct_y_1)*2)
                    time_direct2 = 5;
                elseif(abs(direct_x_1)*2 <= abs(direct_y_1))
                    time_direct2 = 7;
                else
                    time_direct2 = 6;
                end
            end
        end
    end
    


    sample_direct_time = time_direct2;
%     time_direct1(1) = time_direct2;

end

