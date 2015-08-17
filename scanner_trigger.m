function scanner_trigger


% create KbQueue
keys = zeros(1, 256);
keys(KbName('+')) = 1;
keys(KbName('=+')) = 1;
keys(KbName('space')) = 1;
keys(KbName('6^')) = 1;
KbQueueCreate([], keys);
KbQueueFlush;
KbQueueStart;
KbQueueWait;

% then re-set time
KbQueueFlush;
KbQueueStop;
KbQueueRelease;

