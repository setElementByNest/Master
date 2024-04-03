% Show both video for looking start time

PathVideoFile = 'C:\Users\USER\MasterProject\VideoFile\ClipMU20240229\';
videoTop = VideoReader(fullfile(PathVideoFile, '20240229_154325.MP4'));
videoSide = VideoReader(fullfile(PathVideoFile, 'IMG_5388.MOV'));

% Create new video (Show compare videos)
frameHeight = max(videoTop.Height, videoSide.Height);
%%outputVideoFile = 'combined_video.mp4';
%%outputVideo = VideoWriter(outputVideoFile, 'MPEG-4');
%%outputVideo.FrameRate = videoTop.FrameRate;

%%open(outputVideo);
% ::::::::::::: Setting Time ::::::::::::::
% Time in second unit when checker board appear in each video frame
videoTop.CurrentTime = min2sec(0, 43);
% videoSide.CurrentTime = min2sec(0, 38);
% :::::::::::::::::::::::::::::::::::::::::
frameNumber1 = round(videoTop.CurrentTime * videoTop.FrameRate);
frameNumber2 = frameNumber1 - 506;
% Read frames from both videos and combine them
depVideoPlayer = vision.DeployableVideoPlayer;
while hasFrame(videoTop) && hasFrame(videoSide)
    frame1 = read(videoTop, frameNumber1);
    frame2 = read(videoSide, frameNumber2);
    
    % Check if the current frame is within the specified time range
    if videoTop.CurrentTime <= min2sec(2, 1) && videoSide.CurrentTime <= min2sec(1, 0)
        % Resize frame2 to match the height of frame1 if needed
        if size(frame2, 1) < frameHeight
            frame2 = imresize(frame2, [frameHeight, NaN]);
        end
        newFrame2 = imrotate(frame2, 90,"bilinear","loose");
        combinedFrame = [frame1, zeros(size(frame1, 1), size(frame1, 2), size(frame1, 3))]; % Initialize combinedFrame with zeros
    
        % Rotate newFrame2 if necessary
        newFrame2_rotated = newFrame2;
        if size(newFrame2_rotated, 1) ~= size(frame1, 1) || size(newFrame2_rotated, 2) ~= size(frame1, 2)
            newFrame2_rotated = imresize(newFrame2_rotated, [size(frame1, 1), size(frame1, 2)]);
        end
        
        combinedFrame(:, size(frame1, 2)+1:end, :) = newFrame2_rotated;

        % Combine frames side by side
        % combinedFrame = [frame1, frame2];
        
        % Write the combined frame to the output video
        %%writeVideo(outputVideo, combinedFrame);
    end
    
    % Break the loop when the specified time ranges are reached
    if videoTop.CurrentTime >= 120 || videoSide.CurrentTime >= 60
        break;
    end
    depVideoPlayer(combinedFrame);
    frameNumber1 = frameNumber1 + 1;
    frameNumber2 = frameNumber2 + 1;
end

% Close the output video file
%%close(outputVideo);
%%disp(['Combined video', outputVideoFile]);