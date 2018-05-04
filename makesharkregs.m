function makesharkregs
% created 8.31.2016

task_data=initialize_task_tracking_data('shark');

%if directories do not exist create them
if ~exist('regs','dir')
    mkdir('regs')
end

%call up subject folder
dirs=dir('subjects');

%destination folder on Thorndike (server) to house regressors
dest_folder='/Volumes/bek/explore/shark/regs';

%get file paths
scriptName = mfilename('fullpath');
[currentpath, ~, ~]= fileparts(scriptName);

%run through sharkmakeregressor
for k=3:length(dirs)
    if dirs(k).bytes <=0
        try
            %Grab id
            id=str2double(dirs(k).name);
            
            %Update task_tracking data
            task_data.behave_completed=1;
            
            %Process shark data
            sharkmakeregressor(id);
            
            %Update task_tracking data
            task_data.behave_processed=1;
            
            %More the resgressors to the server
            moveregs(currentpath,id,dest_folder);
            
            %write the task data to file
            record_subj_to_file(id,task_data)
            
        catch exception
            %write the task data to file
            record_subj_to_file(id,task_data)
            
            %errorlog
            errorlog('shark',id,exception)
        end
    end
end

