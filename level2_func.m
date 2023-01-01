function [ level2_struct,expansion_alg_source_frame ] = level2_func( level2_struct,direct_source_frame,expansion_alg_source_frame,row,col )
    if(any(level2_struct.position ~= zeros(1,4)))
        line_x1 = level2_struct.position(1,1);
        line_x2 = level2_struct.position(1,2);
        line_y1 = level2_struct.position(1,3);
        line_y2 = level2_struct.position(1,4);
        clear_area = 0;
        while(clear_area ~= 4)
            clear_area = 0;
            if(~any(expansion_alg_source_frame(line_x1,line_y1:line_y2)))
                if(line_x1 < line_x2 - 1 && ~any(expansion_alg_source_frame((line_x1 + 1),line_y1:line_y2)))
                    line_x1 = line_x1 + 1;
                else
                    clear_area = clear_area + 1;
                end
            else
                if(line_x1 > 1)
                    line_x1 = line_x1 - 1;
                else
                    clear_area = clear_area + 1;
                end
            end
            if(~any(expansion_alg_source_frame(line_x2,line_y1:line_y2)))
                if(line_x1 < line_x2 - 1 && ~any(expansion_alg_source_frame((line_x2 - 1),line_y1:line_y2)))
                    line_x2 = line_x2 - 1;
                else
                    clear_area = clear_area + 1;
                end
            else
                if(line_x2 < row - 1)
                    line_x2 = line_x2 + 1;
                else
                    clear_area = clear_area + 1;
                end
            end
            if(~any(expansion_alg_source_frame(line_x1:line_x2,line_y1)))
                if(line_y1 < line_y2 - 1 && ~any(expansion_alg_source_frame(line_x1:line_x2,(line_y1 + 1))))
                  line_y1 = line_y1 + 1;
                else
                    clear_area = clear_area + 1;
                end
            else
              if(line_y1 > 1)
                  line_y1 = line_y1 - 1;
              else
                  clear_area = clear_area + 1;
              end
            end
            if(~any(expansion_alg_source_frame(line_x1:line_x2,line_y2)))
                if(line_y1 < line_y2 - 1 && ~any(expansion_alg_source_frame(line_x1:line_x2,(line_y2 - 1))))
                    line_y2 = line_y2 - 1;
                else
                    clear_area = clear_area + 1;
                end
            else
                if(line_y2 < col - 1)
                    line_y2 = line_y2 + 1;
                else
                    clear_area = clear_area + 1;
                end
            end
        end
        if(line_y2 - line_y1 <= 1 || line_x2 - line_x1 <= 1)
            if(level2_struct.stay_data == 0)
                level2_struct.position = zeros(1,4);
%                 level2_struct.end_flag = 1;
%                 level2_struct.work_state = 0;
                level2_struct.time_direct = zeros(1,10);
            else
                level2_struct.stay_data = level2_struct.stay_data - 1;
            end
            sample = 0;
        else
            level2_struct.position = [line_x1,line_x2,line_y1,line_y2];
%             sample = zeros((line_x2-line_x1),(line_y2-line_y1));
            sample = direct_source_frame(line_x1:line_x2,line_y1:line_y2);
            level2_struct.stay_data = 4;
            for x = line_x1:1:line_x2
                for y = line_y1:1:line_y2
                    expansion_alg_source_frame(x,y) = 0;
                end
            end
        end
        [level2_struct.sample_direct,level2_struct.time_direct] = sample_analysis(sample,level2_struct.time_direct);
    else

        level2_struct.time_direct = zeros(1,10);
        level2_struct.end_flag = 0;
        level2_struct.work_state = 0;
        level2_struct.sample_direct = 0;
    end
    
end

