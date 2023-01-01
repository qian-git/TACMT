function [show1] = show_1(show,position,sample_direct,x)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
    show1 = show;
    if(sample_direct == 1)
        show1((x*position(1)-1):(x*position(2)),(x*position(3)-1):(x*position(3)+1),1) = 255;
        show1((x*position(1)-1):(x*position(2)),(x*position(4)-1):(x*position(4)),1) = 255;
        show1((x*position(1)-1):(x*position(1)),(x*position(3)-1):(x*position(4)),1) = 255;
        show1((x*position(2)-1):(x*position(2)),(x*position(3)-1):(x*position(4)),1) = 255;
        show1((x*position(1)-1):(x*position(2)),(x*position(3)-1):(x*position(3)+1),2) = 0;
        show1((x*position(1)-1):(x*position(2)),(x*position(4)-1):(x*position(4)),2) = 0;
        show1((x*position(1)-1):(x*position(1)),(x*position(3)-1):(x*position(4)),2) = 0;
        show1((x*position(2)-1):(x*position(2)),(x*position(3)-1):(x*position(4)),2) = 0;
        show1((x*position(1)-1):(x*position(2)),(x*position(3)-1):(x*position(3)+1),3) = 255;
        show1((x*position(1)-1):(x*position(2)),(x*position(4)-1):(x*position(4)),3) = 255;
        show1((x*position(1)-1):(x*position(1)),(x*position(3)-1):(x*position(4)),3) = 255;
        show1((x*position(2)-1):(x*position(2)),(x*position(3)-1):(x*position(4)),3) = 255;
    elseif(sample_direct == 2)
        show1((x*position(1)-1):(x*position(2)),(x*position(3)-1):(x*position(3)+1),1) = 255;
        show1((x*position(1)-1):(x*position(2)),(x*position(4)-1):(x*position(4)),1) = 255;
        show1((x*position(1)-1):(x*position(1)),(x*position(3)-1):(x*position(4)),1) = 255;
        show1((x*position(2)-1):(x*position(2)),(x*position(3)-1):(x*position(4)),1) = 255;
        show1((x*position(1)-1):(x*position(2)),(x*position(3)-1):(x*position(3)+1),2) = 0;
        show1((x*position(1)-1):(x*position(2)),(x*position(4)-1):(x*position(4)),2) = 0;
        show1((x*position(1)-1):(x*position(1)),(x*position(3)-1):(x*position(4)),2) = 0;
        show1((x*position(2)-1):(x*position(2)),(x*position(3)-1):(x*position(4)),2) = 0;
        show1((x*position(1)-1):(x*position(2)),(x*position(3)-1):(x*position(3)+1),3) = 102;
        show1((x*position(1)-1):(x*position(2)),(x*position(4)-1):(x*position(4)),3) = 102;
        show1((x*position(1)-1):(x*position(1)),(x*position(3)-1):(x*position(4)),3) = 102;
        show1((x*position(2)-1):(x*position(2)),(x*position(3)-1):(x*position(4)),3) = 102;
    elseif(sample_direct == 3)
        show1((x*position(1)-1):(x*position(2)),(x*position(3)-1):(x*position(3)+1),1) = 255;
        show1((x*position(1)-1):(x*position(2)),(x*position(4)-1):(x*position(4)),1) = 255;
        show1((x*position(1)-1):(x*position(1)),(x*position(3)-1):(x*position(4)),1) = 255;
        show1((x*position(2)-1):(x*position(2)),(x*position(3)-1):(x*position(4)),1) = 255;
        show1((x*position(1)-1):(x*position(2)),(x*position(3)-1):(x*position(3)+1),2) = 153;
        show1((x*position(1)-1):(x*position(2)),(x*position(4)-1):(x*position(4)),2) = 153;
        show1((x*position(1)-1):(x*position(1)),(x*position(3)-1):(x*position(4)),2) = 153;
        show1((x*position(2)-1):(x*position(2)),(x*position(3)-1):(x*position(4)),2) = 153;
        show1((x*position(1)-1):(x*position(2)),(x*position(3)-1):(x*position(3)+1),3) = 51;
        show1((x*position(1)-1):(x*position(2)),(x*position(4)-1):(x*position(4)),3) = 51;
        show1((x*position(1)-1):(x*position(1)),(x*position(3)-1):(x*position(4)),3) = 51;
        show1((x*position(2)-1):(x*position(2)),(x*position(3)-1):(x*position(4)),3) = 51;
    elseif(sample_direct == 4)
        show1((x*position(1)-1):(x*position(2)),(x*position(3)-1):(x*position(3)+1),1) = 204;
        show1((x*position(1)-1):(x*position(2)),(x*position(4)-1):(x*position(4)),1) = 204;
        show1((x*position(1)-1):(x*position(1)),(x*position(3)-1):(x*position(4)),1) = 204;
        show1((x*position(2)-1):(x*position(2)),(x*position(3)-1):(x*position(4)),1) = 204;
        show1((x*position(1)-1):(x*position(2)),(x*position(3)-1):(x*position(3)+1),2) = 255;
        show1((x*position(1)-1):(x*position(2)),(x*position(4)-1):(x*position(4)),2) = 255;
        show1((x*position(1)-1):(x*position(1)),(x*position(3)-1):(x*position(4)),2) = 255;
        show1((x*position(2)-1):(x*position(2)),(x*position(3)-1):(x*position(4)),2) = 255;
        show1((x*position(1)-1):(x*position(2)),(x*position(3)-1):(x*position(3)+1),3) = 51;
        show1((x*position(1)-1):(x*position(2)),(x*position(4)-1):(x*position(4)),3) = 51;
        show1((x*position(1)-1):(x*position(1)),(x*position(3)-1):(x*position(4)),3) = 51;
        show1((x*position(2)-1):(x*position(2)),(x*position(3)-1):(x*position(4)),3) = 51;
    elseif(sample_direct == 5)
        show1((x*position(1)-1):(x*position(2)),(x*position(3)-1):(x*position(3)+1),1) = 51;
        show1((x*position(1)-1):(x*position(2)),(x*position(4)-1):(x*position(4)),1) = 51;
        show1((x*position(1)-1):(x*position(1)),(x*position(3)-1):(x*position(4)),1) = 51;
        show1((x*position(2)-1):(x*position(2)),(x*position(3)-1):(x*position(4)),1) = 51;
        show1((x*position(1)-1):(x*position(2)),(x*position(3)-1):(x*position(3)+1),2) = 204;
        show1((x*position(1)-1):(x*position(2)),(x*position(4)-1):(x*position(4)),2) = 204;
        show1((x*position(1)-1):(x*position(1)),(x*position(3)-1):(x*position(4)),2) = 204;
        show1((x*position(2)-1):(x*position(2)),(x*position(3)-1):(x*position(4)),2) = 204;
        show1((x*position(1)-1):(x*position(2)),(x*position(3)-1):(x*position(3)+1),3) = 51;
        show1((x*position(1)-1):(x*position(2)),(x*position(4)-1):(x*position(4)),3) = 51;
        show1((x*position(1)-1):(x*position(1)),(x*position(3)-1):(x*position(4)),3) = 51;
        show1((x*position(2)-1):(x*position(2)),(x*position(3)-1):(x*position(4)),3) = 51;
    elseif(sample_direct == 6)
        show1((x*position(1)-1):(x*position(2)),(x*position(3)-1):(x*position(3)+1),1) = 0;
        show1((x*position(1)-1):(x*position(2)),(x*position(4)-1):(x*position(4)),1) = 0;
        show1((x*position(1)-1):(x*position(1)),(x*position(3)-1):(x*position(4)),1) = 0;
        show1((x*position(2)-1):(x*position(2)),(x*position(3)-1):(x*position(4)),1) = 0;
        show1((x*position(1)-1):(x*position(2)),(x*position(3)-1):(x*position(3)+1),2) = 255;
        show1((x*position(1)-1):(x*position(2)),(x*position(4)-1):(x*position(4)),2) = 255;
        show1((x*position(1)-1):(x*position(1)),(x*position(3)-1):(x*position(4)),2) = 255;
        show1((x*position(2)-1):(x*position(2)),(x*position(3)-1):(x*position(4)),2) = 255;
        show1((x*position(1)-1):(x*position(2)),(x*position(3)-1):(x*position(3)+1),3) = 204;
        show1((x*position(1)-1):(x*position(2)),(x*position(4)-1):(x*position(4)),3) = 204;
        show1((x*position(1)-1):(x*position(1)),(x*position(3)-1):(x*position(4)),3) = 204;
        show1((x*position(2)-1):(x*position(2)),(x*position(3)-1):(x*position(4)),3) = 204;
    elseif(sample_direct == 7)
        show1((x*position(1)-1):(x*position(2)),(x*position(3)-1):(x*position(3)+1),1) = 0;
        show1((x*position(1)-1):(x*position(2)),(x*position(4)-1):(x*position(4)),1) = 0;
        show1((x*position(1)-1):(x*position(1)),(x*position(3)-1):(x*position(4)),1) = 0;
        show1((x*position(2)-1):(x*position(2)),(x*position(3)-1):(x*position(4)),1) = 0;
        show1((x*position(1)-1):(x*position(2)),(x*position(3)-1):(x*position(3)+1),2) = 153;
        show1((x*position(1)-1):(x*position(2)),(x*position(4)-1):(x*position(4)),2) = 153;
        show1((x*position(1)-1):(x*position(1)),(x*position(3)-1):(x*position(4)),2) = 153;
        show1((x*position(2)-1):(x*position(2)),(x*position(3)-1):(x*position(4)),2) = 153;
        show1((x*position(1)-1):(x*position(2)),(x*position(3)-1):(x*position(3)+1),3) = 255;
        show1((x*position(1)-1):(x*position(2)),(x*position(4)-1):(x*position(4)),3) = 255;
        show1((x*position(1)-1):(x*position(1)),(x*position(3)-1):(x*position(4)),3) = 255;
        show1((x*position(2)-1):(x*position(2)),(x*position(3)-1):(x*position(4)),3) = 255;
    elseif(sample_direct == 8)
        show1((x*position(1)-1):(x*position(2)),(x*position(3)-1):(x*position(3)+1),1) = 102;
        show1((x*position(1)-1):(x*position(2)),(x*position(4)-1):(x*position(4)),1) = 102;
        show1((x*position(1)-1):(x*position(1)),(x*position(3)-1):(x*position(4)),1) = 102;
        show1((x*position(2)-1):(x*position(2)),(x*position(3)-1):(x*position(4)),1) = 102;
        show1((x*position(1)-1):(x*position(2)),(x*position(3)-1):(x*position(3)+1),2) = 102;
        show1((x*position(1)-1):(x*position(2)),(x*position(4)-1):(x*position(4)),2) = 102;
        show1((x*position(1)-1):(x*position(1)),(x*position(3)-1):(x*position(4)),2) = 102;
        show1((x*position(2)-1):(x*position(2)),(x*position(3)-1):(x*position(4)),2) = 102;
        show1((x*position(1)-1):(x*position(2)),(x*position(3)-1):(x*position(3)+1),3) = 255;
        show1((x*position(1)-1):(x*position(2)),(x*position(4)-1):(x*position(4)),3) = 255;
        show1((x*position(1)-1):(x*position(1)),(x*position(3)-1):(x*position(4)),3) = 255;
        show1((x*position(2)-1):(x*position(2)),(x*position(3)-1):(x*position(4)),3) = 255;
    end
end


% 
%     if(sample_direct == 1)
% %             show1((2*position(1)-1):(2*position(2)-1),(2*position(3)-1):(2*position(4)-1))
% %             show(position_1(1):position_1(2),position_1(3):position_1(4),2)
%         show1((2*position(1)-1):(2*position(2)-1),(2*position(3)-1):(2*position(4)-1),1) = 255;
%         show1((2*position(1)-1):(2*position(2)-1),(2*position(3)-1):(2*position(4)-1),2) = 0;
%         show1((2*position(1)-1):(2*position(2)-1),(2*position(3)-1):(2*position(4)-1),3) = 255;
%     elseif(sample_direct == 2)
%         show1((2*position(1)-1):(2*position(2)-1),(2*position(3)-1):(2*position(4)-1),1) = 255;
%         show1((2*position(1)-1):(2*position(2)-1),(2*position(3)-1):(2*position(4)-1),2) = 0;
%         show1((2*position(1)-1):(2*position(2)-1),(2*position(3)-1):(2*position(4)-1),3) = 102;
%     elseif(sample_direct == 3)
%         show1((2*position(1)-1):(2*position(2)-1),(2*position(3)-1):(2*position(4)-1),1) = 255;
%         show1((2*position(1)-1):(2*position(2)-1),(2*position(3)-1):(2*position(4)-1),2) = 153;
%         show1((2*position(1)-1):(2*position(2)-1),(2*position(3)-1):(2*position(4)-1),3) = 51;
%     elseif(sample_direct == 4)
%         show1((2*position(1)-1):(2*position(2)-1),(2*position(3)-1):(2*position(4)-1),1) = 204;
%         show1((2*position(1)-1):(2*position(2)-1),(2*position(3)-1):(2*position(4)-1),2) = 255;
%         show1((2*position(1)-1):(2*position(2)-1),(2*position(3)-1):(2*position(4)-1),3) = 51;
%     elseif(sample_direct == 5)
%         show1((2*position(1)-1):(2*position(2)-1),(2*position(3)-1):(2*position(4)-1),1) = 51;
%         show1((2*position(1)-1):(2*position(2)-1),(2*position(3)-1):(2*position(4)-1),2) = 204;
%         show1((2*position(1)-1):(2*position(2)-1),(2*position(3)-1):(2*position(4)-1),3) = 51;
%     elseif(sample_direct == 6)
%         show1((2*position(1)-1):(2*position(2)-1),(2*position(3)-1):(2*position(4)-1),1) = 0;
%         show1((2*position(1)-1):(2*position(2)-1),(2*position(3)-1):(2*position(4)-1),2) = 255;
%         show1((2*position(1)-1):(2*position(2)-1),(2*position(3)-1):(2*position(4)-1),3) = 204;
%     elseif(sample_direct == 7)
%         show1((2*position(1)-1):(2*position(2)-1),(2*position(3)-1):(2*position(4)-1),1) = 0;
%         show1((2*position(1)-1):(2*position(2)-1),(2*position(3)-1):(2*position(4)-1),2) = 153;
%         show1((2*position(1)-1):(2*position(2)-1),(2*position(3)-1):(2*position(4)-1),3) = 255;
%     elseif(sample_direct == x)
%         show1((2*position(1)-1):(2*position(2)-1),(2*position(3)-1):(2*position(4)-1),1) = 102;
%         show1((2*position(1)-1):(2*position(2)-1),(2*position(3)-1):(2*position(4)-1),2) = 102;
%         show1((2*position(1)-1):(2*position(2)-1),(2*position(3)-1):(2*position(4)-1),3) = 255;
%     else
%         show1((2*position(1)-1):(2*position(2)-1),(2*position(3)-1):(2*position(4)-1),1) = 0;
%         show1((2*position(1)-1):(2*position(2)-1),(2*position(3)-1):(2*position(4)-1),2) = 0;
%         show1((2*position(1)-1):(2*position(2)-1),(2*position(3)-1):(2*position(4)-1),3) = 0;
%     end


