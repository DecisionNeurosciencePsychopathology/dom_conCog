% created 8.31.2016

%call up subject folder
dirs=dir('subjects');

jj=1;
hh=1;

%assign ids to variable ids
i=1;
for j=1:length(dirs)
    if length(dirs(j).name)==6
        x=str2num(dirs(j).name);
        ids(i)=x;
        i=i+1;
    end    
    j=j+1;
end
    
    
%run through sharkmakeregressor
for k=1:length(ids)
    try
    sharkmakeregressor(ids(k));
    
    %move the regressor files to thorndike
    newfolder='/Volumes/bek/explore/shark/regs'; %folder to be place in within thorndike
    moveregs('dom_conCog',num2str(ids(k)),newfolder);
    
    %write the ids that successfully ran into a cell
    ID(jj,1)=ids(k);
    
    
    task={'shark'};
    Task{jj,1}=task; 
     
    trialdone=fopen('idlog_shark.txt');
    trialdone=fscanf(trialdone,'%d');
    
    trialdone1=0;
    for aa=1:length(trialdone)
        if trialdone(aa,1) == ids(k)
            trialdone1=1;
        end
    end
    
    if trialdone1 == 1
        td={'yes'};
    else
        td={'no'};
    end
    fMRI_Preprocess_Complete{jj,1}=td; 
    jj=jj+1;
    
    %turn completed cell into table
    st=table(ID,Task,fMRI_Preprocess_Complete);
    save('completed','st');
    
    catch
        disp(sprintf('\nUnable to run ID %d: does not have correct folder or file in Thorndike...\n',ids(k)))
        
        %put IDs that didn't run into table
        ID2(hh,1)=ids(k); 
    
        task={'shark'};
        Task2{hh,1}=task; 
        
        hh=hh+1;
        
        st2=table(ID2,Task2);
        save('unable_to_run','st2')
        
    end
    
    
    if exist('st2')==0
        ID2=0;
        Task2={'shark'};
        st2=table(ID2,Task2);
        save('unable_to_run','st2')
    end
    

    
end

