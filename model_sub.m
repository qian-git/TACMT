function [ model ] = model_sub( model,flag )
[~,size_model] = size(model{1});
if(size_model ~= 0)
    for j = 1:1:size_model
        if(model{2}(j) >= flag)
            model{2}(j) = flag;
        else
            if(model{2}(j) >=75)
                model{2}(j) = model{2}(j) - 3;
            elseif(model{2}(j)>=50)
                model{2}(j) = model{2}(j) - 2;
            else
                model{2}(j) = model{2}(j) - 1;
            end
            
        end
    end
    for j = size_model:-1:1
        if(model{2}(j) <= 0)
            model{2}(j) = [];
            model{1}(:,j) = [];
        end
    end
    [~,size_model] = size(model{1});
    if(size_model == 0)
        model{1} = [];
        model{2} = [];
        
    end
end
end

