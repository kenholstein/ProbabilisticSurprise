function output_v = plus_minus_boolean(input_v, target)

    for i = 1:length(input_v)
        if input_v(i)~=target
            output_v(i)=-1;
        else
            output_v(i)=1;
        end;
    end;

end

