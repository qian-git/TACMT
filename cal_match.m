function [ px_model,px_series ] = cal_match( model,series,LCS,mode )
[~,size_LCS] = size(LCS);
[~,size_model] = size(model{1});
[~,size_series] = size(series);

px_model = 0;px_series = 0;
if(size_LCS ~= 0)
    if(mode == 3)
        if(series(1,size_series) == 0)
            series_end = 1;
        else
            series_end = 0;
        end
        PX_model_1 = 0;PX_model_2 = 0;
%         for m = 1:1:size_LCS
%             PX_model_1 = PX_model_1 + model{2}(LCS(3,m));
%         end
%         for m = 1:1:LCS(3,size_LCS)
%             PX_model_2 = PX_model_2 + model{2}(m);
%         end
        if(series_end == 1) %ingnore the last_zero
            for m = 1:1:(size_LCS-1)
                PX_model_1 = PX_model_1 + model{2}(LCS(3,m));
            end
            for m = 1:1:(LCS(3,size_LCS)-1)
                PX_model_2 = PX_model_2 + model{2}(m);
            end
            px_model_3 = PX_model_1;
            model_flag = PX_model_2;
        else
            for m = 1:1:size_LCS
                PX_model_1 = PX_model_1 + model{2}(LCS(3,m));
            end
            for m = 1:1:LCS(3,size_LCS)
                PX_model_2 = PX_model_2 + model{2}(m);
            end
            px_model_3 = PX_model_1;
            model_flag = PX_model_2;
%             for m = 1:1:size_model-1
%                 PX_model_2 = PX_model_2 + model{2}(m);
%             end
        end
        px_model = px_model_3/model_flag;
%         if(px_model_3/model_flag > 0.5)
%             px_model = 1;
%         else
%             px_model = 0;
%         end
        PX_series_1 = 0;PX_series_2 = 0;n = 1;
        avr_model = 25;
        for m = 1:1:size_model-1
            avr_model = avr_model + model{2}(m);
        end
        avr_model = avr_model/(size_model-1);
        if(series_end == 1)
            for m = 1:1:size_LCS-1
                PX_series_1 = PX_series_1 + model{2}(LCS(3,m));
            end
            for m = 1:1:size_series-1
                if(n <= size_LCS-1 && m == LCS(4,n))
                    PX_series_2 = PX_series_2 + model{2}(LCS(3,n));
                    n = n + 1;
                else
                    PX_series_2 = PX_series_2 + avr_model;
                end
            end
        else
            for m = 1:1:size_LCS
                PX_series_1 = PX_series_1 + model{2}(LCS(3,m));
            end
            for m = 1:1:size_series
                if(n <= size_LCS && m == LCS(4,n))
                    PX_series_2 = PX_series_2 + model{2}(LCS(3,n));
                    n = n + 1;
                else
                    PX_series_2 = PX_series_2 + avr_model;
                end
            end
        end
        px_series = PX_series_1/PX_series_2;
    %     px_series = (PX_series_1/(100*size_LCS)) *(size_LCS/size_series);
    elseif(mode == 4)
        if(series(1,size_series) == 0)
            series_end = 1;
        else
            series_end = 0;
        end
        PX_model_1 = 0;PX_model_2 = 0;
        if(series_end == 1) %ingnore the last_zero
            for m = 1:1:(size_LCS-1)
                PX_model_1 = PX_model_1 + model{2}(LCS(2,m));
            end
            for m = 1:1:(LCS(2,size_LCS)-1)
                PX_model_2 = PX_model_2 + model{2}(m);
            end
            px_model_3 = PX_model_1;
            model_flag = PX_model_2;
        else
            for m = 1:1:size_LCS
                PX_model_1 = PX_model_1 + model{2}(LCS(2,m));
            end
            for m = 1:1:LCS(2,size_LCS)
                PX_model_2 = PX_model_2 + model{2}(m);
            end
            px_model_3 = PX_model_1;
            model_flag = PX_model_2;
%             for m = 1:1:size_model-1
%                 PX_model_2 = PX_model_2 + model{2}(m);
%             end
        end
        px_model = px_model_3/model_flag;
%         if(px_model_3/model_flag >= 0.5)
%             px_model = 1;
%         else
%             px_model = 0;
%         end
    %     [max_model,~] = max(model{2});
    %     if(max_model <= 60)
    %         px_model = PX_model_1/PX_model_2;
    %     else
    %         px_model = PX_model_1/PX_model_2;
    %     end

        PX_series_1 = 0;PX_series_2 = 0;n = 1;
        avr_model = 25;
        for m = 1:1:size_model-1
            avr_model = avr_model + model{2}(m);
        end
        avr_model = avr_model/(size_model-1);
        if(series_end == 1)
            for m = 1:1:size_LCS-1
                PX_series_1 = PX_series_1 + series(2,LCS(3,m));
            end
            for m = 1:1:size_series-1
                PX_series_2 = PX_series_2 + series(2,m);
            end
        else
            for m = 1:1:size_LCS
                PX_series_1 = PX_series_1 + series(2,LCS(3,m));
            end
            for m = 1:1:size_series
                PX_series_2 = PX_series_2 + series(2,m);
            end
        end
        px_series = PX_series_1/PX_series_2;
    %     px_series = (PX_series_1/(100*size_LCS)) *(size_LCS/size_series);

    end
else
    px_model = 0;
    px_series = 0;
end
end

