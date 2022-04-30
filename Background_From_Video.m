clear all
close all

%% Setting up the constants
CLIP_DATA = '_Clip_';
LABEL_PATH = '/Users/leochang2/Desktop/syringe/input/';
VIDEO_PATH = '/Users/leochang2/Desktop/syringe/videos/';
OUTPUT_PATH = '/Users/leochang2/Desktop/syringe/output/';

% annotation type: 0=vial, 1=draw, 2=syringe, 3=barcode, 4=label
% by default = 5 for no filter by type
ANNOTATION_TYPE = 5;

% name of the spreadsheet. Need to put it in the root directory
opts = detectImportOptions('sample_spreadsheet.xlsx');
opts = setvartype(opts, 3, 'string');
opts = setvartype(opts, 1, 'char');
t = readtable('sample_spreadsheet.xlsx', opts);

%% loop through each row of the table
for i = 1 : height(t)
    folder_type = 'bg/';
    
    % date of the clip
    date = char(t.date(i));
    % clip number of the clip
    clip = t.clip(i);
    video_filename = [VIDEO_PATH, date, ' Edited Clips/', date, CLIP_DATA, num2str(clip), '.mp4'];
    % if video doesn't exist, skip over to the next clip
    if ~exist(video_filename)
        continue
    end
    vid = VideoReader(video_filename);
    max_frames = vid.NumberOfFrames;
    sp_yolo_anno_path = [LABEL_PATH, date, CLIP_DATA, num2str(clip), ...
        '/obj_train_data/frame_'];   
    % frames specified in the spreadsheet
    frames = str2num(t.frame(i));
    % every tenth frame combined with frames specified in the spreadsheet
    frames = [0:10:max_frames-1, frames];

    % loop through each frame
    for f = frames
        if ~exist([sp_yolo_anno_path, num2str(f,'%06.f'), '.txt']);
            
            % image of the current frame
            frame_image = read(vid, f + 1);
            frame_fn_path = [OUTPUT_PATH, folder_type, 'images/'];
            if ~exist(frame_fn_path)
                mkdir(frame_fn_path)
            end
            % filename
            fn=[date, CLIP_DATA, num2str(clip),'_frame_', num2str(f)];

            imwrite(frame_image, [frame_fn_path, fn, '.png'], 'Mode', 'lossless');
        end
    end
end
