function [Speed,Cars] = shift(Car_now, TempCells)
    Cars = zeros(size(Car_now));
    Speed = zeros(size(TempCells));
    totalCellNum = numel(Car_now);
    
    for j=1:totalCellNum
        % shift only the cars not the empty ones
        if(Car_now(j) ~= 0);
            % update
            %TODO VLLT errordetection
            new_pos = mod(j+TempCells(j), totalCellNum);
            if new_pos == 0
                new_pos = totalCellNum;
            end
            Speed(new_pos) = TempCells(j);
            Cars(new_pos) = Car_now(j);
        end
    end

end

