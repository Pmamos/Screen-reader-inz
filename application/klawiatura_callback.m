function klawiatura_callback(~, event)
    % Sprawdzamy, czy naciśnięto klawisz Shift
    if strcmp(event.Key,'shift')
        disp('Naciśnięto klawisz Shift. Kończę program.');
        close(gcf); % Zamknij okno, aby zakończyć program
    end
    if strcmp(event.Key, 'control')
        disp('Naciśnięto klawisz Control.');
        import java.awt.Robot;
        robot = java.awt.Robot;
        
        global last_pos;    
          
        for ix = last_pos(1)-5:last_pos(1)
            robot.mouseMove(ix, last_pos(2));
            pause(0.01)
        end
       
    end
    if strcmp(event.Key, 'space')
        disp('Naciśnięto klawisz Spacji.');
        
        global center_pos; 
        %wczytanie myszy za pomocą której będziemy mogli poruszyć myszką
        import java.awt.Robot;
        robot = java.awt.Robot;
       
        for ix = center_pos(1)-5:center_pos(1)
            robot.mouseMove(ix, center_pos(2));
            pause(0.01)
        end
       
        % Symuluj naciśnięcie lewego przycisku myszy
  
        import java.awt.event.InputEvent;
        robot = Robot;
        robot.mousePress(InputEvent.BUTTON1_MASK);
        
        % Symuluj zwolnienie lewego przycisku myszy
        robot.mouseRelease(InputEvent.BUTTON1_MASK);
        robot.mousePress(InputEvent.BUTTON1_MASK);
        
        % Symuluj zwolnienie lewego przycisku myszy
        robot.mouseRelease(InputEvent.BUTTON1_MASK);
    end
end