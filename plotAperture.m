function plotAperture (shiftTime, shiftAmp , EMstatus, nTry)
    worldPointsPink = evalin('base', 'worldPointsPink');
    worldPointsRed = evalin('base', 'worldPointsRed');
    if (EMstatus == 1)
        EM = evalin('base', 'EM');
    end
    figure;
    plot((1:length(worldPointsRed(:,2)))/60, sqrt((worldPointsPink(:,1) - worldPointsRed(:,1)).^2 + (worldPointsPink(:,2) - worldPointsRed(:,2)).^2) + shiftAmp, 'm.-');
    hold on
    if (EMstatus == 1)
        plot(EM(:, 1) + shiftTime, EM(:, 2), 'b.-');
    end
    if isnumeric(nTry)
        nTry = '_?_';
    end
    grid on;
    xlabel('Second');
    ylabel('Millimeter');
    title(['Aperture - ', nTry]);
    if (EMstatus == 1)
        legend('Image Processing', 'Electromagnetic')
    else
        legend('Image Processing')
    end
    hold off
end