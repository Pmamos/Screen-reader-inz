function mouse_move(pos)
%wczytanie myszy za pomocą której będziemy mogli poruszyć myszką
import java.awt.Robot;
mouse = Robot;

mouse.mouseMove(pos(1),pos(2));
% Symuluj naciśnięcie lewego przycisku myszy
import java.awt.event.InputEvent;
robot = Robot;
robot.mousePress(InputEvent.BUTTON1_MASK);

% Symuluj zwolnienie lewego przycisku myszy
robot.mouseRelease(InputEvent.BUTTON1_MASK);
end