% Capture CheckerBoard

PathVideoFile = 'C:\Users\USER\MasterProject\VideoFile\ClipMU20240229\';
videoTop = VideoReader(fullfile(PathVideoFile, '20240229_154325.MP4'));
videoSide = VideoReader(fullfile(PathVideoFile, 'IMG_5388.MOV'));
videoTop.CurrentTime = min2sec(0, 43);
frameNumber1 = round(videoTop.CurrentTime * videoTop.FrameRate);
frameNumber2 = frameNumber1 - 506;
nFrameMove = 300;
frameWidth = videoTop.Width;
frameHeight = videoTop.Height;
while videoTop.CurrentTime <= min2sec(2, 25)
    frame1 = read(videoTop, frameNumber1);
    frame2 = read(videoSide, frameNumber2);
    frame2 = imresize(frame2, [frameWidth, frameHeight]);
    imwrite(frame1, "Calibrate-Top_" + frameNumber1 + ".png");
    imwrite(imrotate(frame2, 90,"bilinear","loose"), "Calibrate-Side_" + frameNumber2 + ".png");
    frameNumber1 = frameNumber1 + nFrameMove;
    frameNumber2 = frameNumber2 + nFrameMove;
end