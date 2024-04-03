function plot3DPath ()
    worldPointsPink = evalin('base', 'worldPointsPink');
    worldPointsRed = evalin('base', 'worldPointsRed');
    worldPointsGreen = evalin('base', 'worldPointsGreen');
    figure;
    plot3(worldPointsPink(:,1), -1 .* worldPointsPink(:,2), -1 .* worldPointsPink(:,3), 'm.-');
    hold on
    plot3(worldPointsRed(:,1), -1 .* worldPointsRed(:,2), -1 .* worldPointsRed(:,3), 'b.-');
    plot3(worldPointsGreen(:,1), -1 .* worldPointsGreen(:,2), -1 .* worldPointsGreen(:,3), 'g.-');
    grid on;
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    title('3D Motion Path');
    hold off
end