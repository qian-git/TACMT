function [ LCS_table ] = match_direct( model,series )
[~,size_axis] = size(series);
[~,size_model] = size(model);
LCS_table = zeros(3,size_axis);
compare_table = zeros(size_axis+1,size_model+1);
for i = 1:1:size_axis
    for j = 1:1: size_model
        if(series(1,i) == model(1,j))
            compare_table(i+1,j+1) = compare_table(i,j) + 1;
        else
            compare_table(i+1,j+1) = max(compare_table(i+1,j),compare_table(i,j+1));
        end
    end
end
LCS_length = compare_table(size_axis + 1,size_model + 1);
axis_i = size_axis + 1;axis_j = size_model + 1;
while(LCS_length >= 1)
    if(compare_table(axis_i,axis_j) > compare_table(axis_i-1,axis_j) && compare_table(axis_i,axis_j) > compare_table(axis_i,axis_j-1))
        LCS_table(1,LCS_length) = model(1,axis_j - 1);
        LCS_table(2,LCS_length) = axis_j - 1;
        LCS_table(3,LCS_length) = axis_i - 1;
        LCS_length = LCS_length - 1;
        axis_i = axis_i - 1; axis_j = axis_j - 1;
    elseif(compare_table(axis_i,axis_j) > compare_table(axis_i-1,axis_j) && compare_table(axis_i,axis_j) == compare_table(axis_i,axis_j-1))
        axis_j = axis_j - 1;
    elseif(compare_table(axis_i,axis_j) == compare_table(axis_i-1,axis_j) && compare_table(axis_i,axis_j) > compare_table(axis_i,axis_j-1))
        axis_i = axis_i - 1;
    else
        if(compare_table(axis_i,axis_j) == compare_table(axis_i-1,axis_j-1))
            axis_i = axis_i - 1; axis_j = axis_j - 1;
        else
            axis_i = axis_i - 1;
        end
    end
end

for i = size_axis:-1:1
    if(LCS_table(:,i) == zeros(3,1))
        LCS_table(:,i) = [];
    end
end
end

