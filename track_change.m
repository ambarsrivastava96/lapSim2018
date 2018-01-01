% Function corrects racing line and track data for changes in wheel track
% Includes modification to straights before and after
% Array Structure:
%       Arc Length | Racing Radius | Grade | Corner Outer Radius | Corner
%       Entry Straight

function TRACKdef_corrected=track_change(TRACKdef,course_width,current_track,original_track)

for i = 1:length(TRACKdef(:,1))
    % Check for corner
    if ((TRACKdef(i,2) ~= 0))
        % Calculate corner radius
        cornerRad = TRACKdef(i,1)/((TRACKdef(i,2)*pi()/180));
        % Reengineer racing line for outer radius ro
        TRACKdef(i,4) = get_ro(cornerRad,TRACKdef(i,2), course_width, original_track);
        % Find original change in entry straight
        TRACKdef(i,6) = corner_entry_straight(TRACKdef(i,1),TRACKdef(i,4),TRACKdef(i,2));
    end
end

check=0;

for i = 2:1000
    if ((TRACKdef(i,2) ~= 0))
        % Compute new racing radius
        TRACKdef(i,5) = racing_radius(TRACKdef(i,4),TRACKdef(i,4)-course_width, TRACKdef(i,2),current_track);
        % Compute new arc length
        TRACKdef(i,1) = TRACKdef(i,5)*TRACKdef(i,2)*pi()/180;
        % Compute final change in entry straight
        TRACKdef(i,6) = TRACKdef(i,6) - corner_entry_straight(TRACKdef(i,1),TRACKdef(i,4),TRACKdef(i,2));
     
        % If there is an adjacent straight, correct the distance,
        % Otherwise insert a new straight
        type=(TRACKdef(i-1,2) ~= 0)+2*(TRACKdef(i+1,2) ~= 0);
        switch type
            case 1 % Corner before, straight after
                TRACKdef(i+1,1)=TRACKdef(i+1,1)+TRACKdef(i,6);
                TRACKdef=[TRACKdef(1:(i-1),:);...
                    [TRACKdef(i,6) 0 0 0 0 0]; TRACKdef(i:end,:)];
            case 2 % Straight before, corner after
                TRACKdef(i-1,1)=TRACKdef(i-1,1)+TRACKdef(i,6);
                TRACKdef=[TRACKdef(1:i,:);...
                    [TRACKdef(i,6) 0 0 0 0 0]; TRACKdef(i+1:end,:)];
            case 3 % Corner before, corner after
                TRACKdef=[TRACKdef(1:(i-1),:);[TRACKdef(i,6) 0 0 0 0 0];...
                    TRACKdef(i,:);[TRACKdef(i,6) 0 0 0 0 0];...
                    TRACKdef(i+1:end,:)];
            case 0 % Straight before, straight after
                TRACKdef(i-1,1)=TRACKdef(i-1,1)+TRACKdef(i,6);
                TRACKdef(i+1,1)=TRACKdef(i+1,1)+TRACKdef(i,6);
                
        end
    end
    
    % Avoid subcript indice error at final iteration
    if check==1
        break
    end
    if i==length(TRACKdef)-2;
        check=1;
    end
    TRACKdef_corrected=TRACKdef;
end


