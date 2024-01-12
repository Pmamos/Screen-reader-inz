function [min_ind, flaga_zblizanie, komunikat_end, center_pos] = inObject(bboxes, size_p, pos, movementDirection)
    size_b = size(bboxes);
    flaga_zblizanie = 0;
    min_ind = -1;
    komunikat_end = '';
    center_pos = pos;
    
    % Sprawdzenie, czy istnieją obiekty
    if(size_b(1))
        distances = zeros(1,size_b(1));
        center = size_p/2;
        point = center * ones(1,2);

        % Sprawdzenie, czy kursor jest zbyt blisko krawędzi
        if(pos(1) < center)
            point(1) = pos(1);
        elseif (pos(1) > 1920-center)
            point(1) = pos(1)+size_p-1920;
        end

        if(pos(2) < center)
            point(2) = pos(2);
        elseif (pos(2)>1080-center)
            point(2) = pos(2)+size_p-1080;
        end

        % Określenie, gdzie jest obiekt
        whereObject = zeros(1,2);
        komunikat = [];

        % Przechodzenie po kolejnych obiektach
        for i = 1:size_b(1)
            if(point(1) > bboxes(i,1) && point(1) < (bboxes(i,1)+bboxes(i,3)) && point(2) > bboxes(i,2) && point(2) < (bboxes(i,2)+bboxes(i,4)))
                komunikat = [komunikat,"w"];
            elseif(point(1) < bboxes(i,1))
                if(point(2) < bboxes(i,2))
                    distances(i) = distance_points(point(1)-bboxes(i,1), point(2) - bboxes(i,2));
                    whereObject(i,1) = -1;
                    whereObject(i,2) = 1;
                    komunikat = [komunikat, "na prawo i w dół"];
                elseif (point(2) > (bboxes(i,2)+bboxes(i,4)))
                    distances(i) = distance_points(point(1)-bboxes(i,1), point(2) - (bboxes(i,2)+bboxes(i,4)));
                    whereObject(i,1) = 1;
                    whereObject(i,2) = 1;
                    komunikat = [komunikat,"na prawo i w górę"];
                else
                    distances(i) = distance_points(point(1)-bboxes(i,1), 0);
                    whereObject(i,2) = 1;
                    komunikat = [komunikat,"na prawo"];
                end

            elseif(point(1) > (bboxes(i,1) + bboxes(i,3)))
                if(point(2) < bboxes(i,2))
                    distances(i) = distance_points(point(1)-bboxes(i,1), point(2) - bboxes(i,2));
                    whereObject(i,1) = -1;
                    whereObject(i,2) = -1;
                    komunikat = [komunikat,"na lewo i w dół"];
                elseif (point(2) > (bboxes(i,2)+bboxes(i,4)))
                    distances(i) = distance_points(point(1)-bboxes(i,1), point(2) - (bboxes(i,2)+bboxes(i,4)));
                    whereObject(i,1) = 1;
                    whereObject(i,2) = -1;
                    komunikat = [komunikat,"na lewo i w górę"];
                else
                    distances(i) = distance_points(point(1)-bboxes(i,1), 0);
                    whereObject(i,2) = -1;
                    komunikat = [komunikat,"na lewo"];
                end
            elseif (point(2) < bboxes(i,2))
                distances(i) = distance_points(0, point(2) - bboxes(i,2));
                whereObject(i,1) = -1;
                komunikat = [komunikat,"w dół"];

            elseif (point(2) > (bboxes(i,2)+bboxes(i,4)))
                distances(i) = distance_points(0, point(2) - (bboxes(i,2)+bboxes(i,4)));
                whereObject(i,1) = 1;
                komunikat = [komunikat,"w górę"];
            end
        end

        min_ind = find(distances == min(distances));
        komunikat_end = komunikat(min_ind);

        center_pos = [pos(1)-point(1)+round(bboxes(min_ind, 1) + 0.5 * bboxes(min_ind, 3)), pos(2)-point(2)+round(bboxes(min_ind, 2) + 0.5 * bboxes(min_ind, 4))];

        % Określenie, czy zachodzi zjawisko zbliżania się
        if (movementDirection == zeros(1,2))
            flaga_zblizanie = 0;
        else
            if(whereObject(min_ind) == movementDirection )
                flaga_zblizanie = 1;
            elseif(whereObject == movementDirection)
                flaga_zblizanie = 1;
            end
        end
    end
end