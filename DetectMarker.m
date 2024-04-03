% Detect Marker

PathVideoFile = 'C:\Users\USER\MasterProject\VideoFile\ClipMU20240229\';
videoTop = VideoReader(fullfile(PathVideoFile, '20240229_154325.MP4'));
videoSide = VideoReader(fullfile(PathVideoFile, 'IMG_5388.MOV'));
startTimeTop =	    min2sec(7, 50.4);
videoTop.CurrentTime = startTimeTop;
frame1Start = round(videoTop.CurrentTime * videoTop.FrameRate);
endTimeTop =      	min2sec(7, 52);
videoTop.CurrentTime = endTimeTop;
frame1Stop = round(videoTop.CurrentTime * videoTop.FrameRate);
startTimeSide =	    min2sec(7, 50.4 + 0.16 - 8.5);
videoSide.CurrentTime = startTimeSide;
frame2Start = round(videoSide.CurrentTime * videoSide.FrameRate);

% imshowpair(videoTopFrameReal, videoSideFrameReal, 'montage')
nFrame = 0;
miss = 0;
AXY_PinkTop = [0 0 0 0];
AXY_PinkSide = [0 0 0 0];
AXY_RedTop = [0 0 0 0];
AXY_RedSide = [0 0 0 0];
AXY_GreenTop = [0 0 0 0];
AXY_GreenSide = [0 0 0 0];
depVideoPlayer = vision.DeployableVideoPlayer;
myVideoTop = VideoWriter('TopViewDetected2');
myVideoSide = VideoWriter('SideViewDetected2');
myVideoCombine = VideoWriter('CombineDetected2');
myVideoTop.FrameRate = 60;
myVideoSide.FrameRate = 60;
myVideoCombine.FrameRate = 60;

open(myVideoTop);
open(myVideoSide);
open(myVideoCombine);
for frameNumber1 = frame1Start:frame1Stop
    nFrame = nFrame + 1;
    frameNumber2 = frame2Start + nFrame - 5 ;
    videoTopFrame = read(videoTop, frameNumber1);
    frame2 = read(videoSide, frameNumber2);
    videoSideFrame = imrotate(frame2, 90,"bilinear","loose");
    videoTopFrame = imresize(videoTopFrame, [1080, 1920]);
    videoSideFrame = imresize(videoSideFrame, [1080, 1920]);
    videoTopFrameReal = undistortImage(videoTopFrame, stereoParams.CameraParameters2);
    videoSideFrameReal = undistortImage(videoSideFrame, stereoParams.CameraParameters1);
%     videoTopFrameRealedit = insertShape(videoTopFrameReal,"FilledPolygon",[1920 1 1688 1 1688 840 1 840 1 1080 1920 1080], 'Color', 'black', 'Opacity', 1);
%     videoSideFrameRealedit = insertShape(videoSideFrameReal,"FilledPolygon",[1920 1 1000 1 1736 315 586 1080 1920 1080], 'Color', 'black', 'Opacity', 1);
    videoTopFrameRealedit = videoTopFrameReal;
    videoSideFrameRealedit = videoSideFrameReal;

    PinkmarkTop = imfill(createMaskPink(videoTopFrameRealedit, 1), 'holes');
    propertiesPinkTop   = table2array(struct2table(regionprops(PinkmarkTop, {'Area','centroid'})));
    PinkmarkSide = imfill(createMaskPink(videoSideFrameRealedit, 2), 'holes');
    propertiesPinkSide   = table2array(struct2table(regionprops(PinkmarkSide, {'Area','centroid'})));

    RedmarkTop = createMaskRed(videoTopFrameRealedit, 1);
    propertiesRedTop   = table2array(struct2table(regionprops(RedmarkTop, {'Area','centroid'})));
    RedmarkSide = createMaskRed(videoSideFrameRealedit, 2);
    propertiesRedSide   = table2array(struct2table(regionprops(RedmarkSide, {'Area','centroid'})));

    GreenmarkTop = imfill(createMaskGreen(videoTopFrameRealedit, 1), 'holes');
    propertiesGreenTop   = table2array(struct2table(regionprops(GreenmarkTop, {'Area','centroid'})));
    GreenmarkSide = imfill(createMaskGreen(videoSideFrameRealedit, 2), 'holes');
    propertiesGreenSide   = table2array(struct2table(regionprops(GreenmarkSide, {'Area','centroid'})));

    if((~isempty(propertiesPinkTop)) && (~isempty(propertiesPinkSide)) && (~isempty(propertiesRedTop)) && (~isempty(propertiesRedSide))  && (~isempty(propertiesGreenTop)) && (~isempty(propertiesGreenSide)))
        [AmaxPinkTop, ImaxPinkTop] = max(propertiesPinkTop(:, 1));
        AXY_PinkTop(nFrame, :) = [nFrame propertiesPinkTop(ImaxPinkTop, 1) propertiesPinkTop(ImaxPinkTop, 2) propertiesPinkTop(ImaxPinkTop, 3)];
        [AmaxPinkSide, ImaxPinkSide] = max(propertiesPinkSide(:, 1));
        AXY_PinkSide(nFrame, :) = [nFrame propertiesPinkSide(ImaxPinkSide, 1) propertiesPinkSide(ImaxPinkSide, 2) propertiesPinkSide(ImaxPinkSide, 3)];

        [AmaxRedTop, ImaxRedTop] = max(propertiesRedTop(:, 1));
        AXY_RedTop(nFrame, :) = [nFrame propertiesRedTop(ImaxRedTop, 1) propertiesRedTop(ImaxRedTop, 2) propertiesRedTop(ImaxRedTop, 3)];
        [AmaxRedSide, ImaxRedSide] = max(propertiesRedSide(:, 1));
        AXY_RedSide(nFrame, :) = [nFrame propertiesRedSide(ImaxRedSide, 1) propertiesRedSide(ImaxRedSide, 2) propertiesRedSide(ImaxRedSide, 3)];

        [AmaxGreenTop, ImaxGreenTop] = max(propertiesGreenTop(:, 1));
        AXY_GreenTop(nFrame, :) = [nFrame propertiesGreenTop(ImaxGreenTop, 1) propertiesGreenTop(ImaxGreenTop, 2) propertiesGreenTop(ImaxGreenTop, 3)];
        [AmaxGreenSide, ImaxGreenSide] = max(propertiesGreenSide(:, 1));
        AXY_GreenSide(nFrame, :) = [nFrame propertiesGreenSide(ImaxGreenSide, 1) propertiesGreenSide(ImaxGreenSide, 2) propertiesGreenSide(ImaxGreenSide, 3)];
    else
        AXY_PinkTop(nFrame, :) = AXY_PinkTop(nFrame - 1, :);
        AXY_PinkSide(nFrame, :) = AXY_PinkSide(nFrame - 1, :);
        AXY_RedTop(nFrame, :) = AXY_RedTop(nFrame - 1, :);
        AXY_RedSide(nFrame, :) = AXY_RedSide(nFrame - 1, :);
        AXY_GreenTop(nFrame, :) = AXY_GreenTop(nFrame - 1, :);
        AXY_GreenSide(nFrame, :) = AXY_GreenSide(nFrame - 1, :);
        disp(nFrame);
        disp(propertiesPinkSide);
        disp(propertiesRedSide);
        disp(propertiesGreenSide);
        miss = miss + 1;
    end
    videoTopFrameReal = insertShape(videoTopFrameReal,'rectangle',[AXY_PinkTop(nFrame, 3)-25 AXY_PinkTop(nFrame, 4)-25 50 50], 'LineWidth',5,'Color','magenta');
    videoTopFrameReal = insertShape(videoTopFrameReal,'rectangle',[AXY_RedTop(nFrame, 3)-25 AXY_RedTop(nFrame, 4)-25 50 50], 'LineWidth',5,'Color','blue');
    videoTopFrameReal = insertShape(videoTopFrameReal,'rectangle',[AXY_GreenTop(nFrame, 3)-25 AXY_GreenTop(nFrame, 4)-25 50 50], 'LineWidth',5,'Color','green');
%     depVideoPlayer(videoTopFrameReal);
    videoSideFrameReal = insertShape(videoSideFrameReal,'rectangle',[AXY_PinkSide(nFrame, 3)-25 AXY_PinkSide(nFrame, 4)-25 50 50], 'LineWidth',5,'Color','magenta');
    videoSideFrameReal = insertShape(videoSideFrameReal,'rectangle',[AXY_RedSide(nFrame, 3)-25 AXY_RedSide(nFrame, 4)-25 50 50], 'LineWidth',5,'Color','blue');
    videoSideFrameReal = insertShape(videoSideFrameReal,'rectangle',[AXY_GreenSide(nFrame, 3)-25 AXY_GreenSide(nFrame, 4)-25 50 50], 'LineWidth',5,'Color','green');
%     depVideoPlayer(videoSideFrameReal);
    for i = 1:nFrame
        videoTopFrameReal = insertShape(videoTopFrameReal,'circle',[AXY_PinkTop(i, 3:4),3],...
            'LineWidth',5,'Color','magenta');
        videoTopFrameReal = insertShape(videoTopFrameReal,'circle',[AXY_RedTop(i, 3:4),3],...
            'LineWidth',5,'Color','blue');
        videoTopFrameReal = insertShape(videoTopFrameReal,'circle',[AXY_GreenTop(i, 3:4),3],...
            'LineWidth',5,'Color','green');
        videoSideFrameReal = insertShape(videoSideFrameReal,'circle',[AXY_PinkSide(i, 3:4),3],...
            'LineWidth',5,'Color','magenta');
        videoSideFrameReal = insertShape(videoSideFrameReal,'circle',[AXY_RedSide(i, 3:4),3],...
            'LineWidth',5,'Color','blue');
        videoSideFrameReal = insertShape(videoSideFrameReal,'circle',[AXY_GreenSide(i, 3:4),3],...
            'LineWidth',5,'Color','green');
    end
    combinedFrame = [videoTopFrameReal, videoSideFrameReal];
    depVideoPlayer(combinedFrame);
    writeVideo(myVideoTop, videoTopFrameReal);
    writeVideo(myVideoSide, videoSideFrameReal);
    writeVideo(myVideoCombine, combinedFrame);
    % frameNumber1 = frameNumber1 + nFrameMove;
    % frameNumber2 = frameNumber2 + nFrameMove;
end
worldPointsPink = triangulate([AXY_PinkSide(:, 3) AXY_PinkSide(:, 4)], [AXY_PinkTop(:, 3) AXY_PinkTop(:, 4)], stereoParams);
worldPointsRed = triangulate([AXY_RedSide(:, 3) AXY_RedSide(:, 4)], [AXY_RedTop(:, 3) AXY_RedTop(:, 4)], stereoParams);
worldPointsGreen = triangulate([AXY_GreenSide(:, 3) AXY_GreenSide(:, 4)], [AXY_GreenTop(:, 3) AXY_GreenTop(:, 4)], stereoParams);

close(myVideoTop);
close(myVideoSide);
close(myVideoCombine);