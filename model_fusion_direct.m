function [ new_model ] = model_fusion_direct( LCS,model_1,model_2,model_upper )
[~,size_model_1] = size(model_1{1});
[~,size_model_2] = size(model_2{1});
[~,size_LCS] = size(LCS);

new_model = {};[~,size_new_model] = size(new_model);
cnt_model_1 = 1;cnt_model_2 = 1;cnt_LCS = 1;
while(cnt_model_1 <= size_model_1 || cnt_model_2 <= size_model_2)
    if(cnt_LCS <= size_LCS)
        if(cnt_model_1 < LCS(2,cnt_LCS))
            new_model{1}(:,size_new_model+1) = model_1{1}(:,cnt_model_1);
            new_model{2}(1,size_new_model+1) = model_1{2}(1,cnt_model_1);
            size_new_model = size_new_model + 1;
            cnt_model_1 = cnt_model_1 + 1;
        else
            if(cnt_model_2 < LCS(3,cnt_LCS))
                new_model{1}(:,size_new_model+1) = model_2{1}(:,cnt_model_2);
                new_model{2}(1,size_new_model+1) = model_2{2}(1,cnt_model_2);
                size_new_model = size_new_model + 1;
                cnt_model_2 = cnt_model_2 + 1;
            else
                new_model{1}(:,size_new_model+1) = model_1{1}(:,cnt_model_1);
                if(model_1{2}(1,cnt_model_1) > 75)
                    new_model{2}(1,size_new_model+1) = model_1{2}(1,cnt_model_1) + 2;
                    if(new_model{2}(1,size_new_model+1) >= model_upper)
                        new_model{2}(1,size_new_model+1) = model_upper;
                    end
                elseif(model_1{2}(1,cnt_model_1) > 50)
                    new_model{2}(1,size_new_model+1) = model_1{2}(1,cnt_model_1) + 3;
                elseif(model_1{2}(1,cnt_model_1) > 25)
                    new_model{2}(1,size_new_model+1) = model_1{2}(1,cnt_model_1) + 4;
                else
                    new_model{2}(1,size_new_model+1) = model_1{2}(1,cnt_model_1) + 4;
                end
%                 if(model_1{2}(1,cnt_model_1) > 75)
%                     new_model{2}(1,size_new_model+1) = model_1{2}(1,cnt_model_1) + 5;
%                     if(new_model{2}(1,size_new_model+1) >= model_upper)
%                         new_model{2}(1,size_new_model+1) = model_upper;
%                     end
%                 elseif(model_1{2}(1,cnt_model_1) > 50)
%                     new_model{2}(1,size_new_model+1) = model_1{2}(1,cnt_model_1) + 6;
%                 elseif(model_1{2}(1,cnt_model_1) > 25)
%                     new_model{2}(1,size_new_model+1) = model_1{2}(1,cnt_model_1) + 8;
%                 else
%                     new_model{2}(1,size_new_model+1) = model_1{2}(1,cnt_model_1) + 10;
%                 end
                
%                 new_model{2}(1,size_new_model+1) = fix((model_1{2}(1,cnt_model_1) + model_2{2}(1,cnt_model_2))/2);
                size_new_model = size_new_model + 1;
                cnt_model_1 = cnt_model_1 + 1;
                cnt_model_2 = cnt_model_2 + 1;
                cnt_LCS = cnt_LCS + 1;
            end
        end
    else
        if(cnt_model_1 <= size_model_1)
            new_model{1}(:,size_new_model+1) = model_1{1}(:,cnt_model_1);
            new_model{2}(1,size_new_model+1) = model_1{2}(1,cnt_model_1);
            size_new_model = size_new_model + 1;
            cnt_model_1 = cnt_model_1 + 1;
        else
            if(cnt_model_2 <= size_model_2)
                new_model{1}(:,size_new_model+1) = model_2{1}(:,cnt_model_2);
                new_model{2}(1,size_new_model+1) = model_2{2}(1,cnt_model_2);
                size_new_model = size_new_model + 1;
                cnt_model_2 = cnt_model_2 + 1;
            end
        end
    end
end
end

