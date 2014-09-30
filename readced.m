%29 September 2014.
%Modified to automatically read CED files with 4-8 channels.

function [d, s] = readced(filename, varargin)

	ns_SetLibrary('nsCedSon.dll');

	[ns_RESULT, hFile] = ns_OpenFile(filename);

	%dx = struct('Data', [], 'temp', []);
    dx = struct('Data', [], 'Data2', [], 'temp', []);

% total number of time points = sampling rate * time (1000Hz * 325 secs)

    %[ns_RESULT, nsEntityInfo] = ns_GetEntityInfo(hFile, countr - 5);

    [ns_RESULT, nsFileInfo] = ns_GetFileInfo(hFile);
	totaltime = nsFileInfo.TimeSpan;
	timeres = nsFileInfo.TimeStampResolution;
    [nsresult, EntityInfo] = ns_GetEntityInfo(hFile, [1 : 1 : nsFileInfo.EntityCount]);
	AnalogList = find([EntityInfo.EntityType] == 2);
	cAnalog = length(AnalogList);



    %countr = [1 : 1 : FileInfo.EntityCount];

	[ns_RESULT, nsAnalogInfo] = ns_GetAnalogInfo(hFile, AnalogList(1));
	samprate = nsAnalogInfo.SampleRate;
	units = nsAnalogInfo.Units;
	ampres = nsAnalogInfo.Resolution;
    
	[ns_RESULT, nsEntityInfo] = ns_GetEntityInfo(hFile, AnalogList(1));
	timepoints = nsEntityInfo.ItemCount;
	tt = -1 + timepoints/1000;

    if nsEntityInfo.ItemCount == 2
         [ns_RESULT, TimeStamp, Data, DataSize] = ns_GetEventData(hFile, AnalogList(1), 2);
         timestamp2 = TimeStamp;
         [ns_RESULT, TimeStamp, Data, DataSize] = ns_GetEventData(hFile, AnalogList(1), 1);
         timestamp1 = TimeStamp;
         ts = timestamp2 - timestamp1;
     else
         ts = 'NoMarkerFound';
     end

    
	for channel = 1:cAnalog

		for n = 0:tt
		
			[ns_RESULT, ContCount, dx(channel).temp] = ns_GetAnalogData(hFile, AnalogList(channel), 1000*n + 1, 1000);
			dx(channel).Data2 = [dx(channel).Data2; dx(channel).temp];
            %if n > 0
            %    R[n] = corrcoef(dx(channel).Data2(1:1000), dx(channel).Data2(1+n*1000:1000*(n+1)));
            %else
            %    break
            %end				
        end

		%[r c] = size(dx(channel).Data);
		%dx(channel).Data = reshape(dx(channel).Data, r*c, 1);
        dx(channel).Data = dx(channel).Data2(:);

	end

	%dd = struct('Channel1', [], 'Channel2', [], 'Channel3', [], 'Channel4', [], 'Channel5', []);
	dd.Channels = cAnalog;
	dd.SamplingRate = samprate;
	dd.TimeSpan = totaltime;
	dd.TimeStampResolution = timeres;
	dd.Units = units;
	dd.Resolution = ampres;
	dd.MarkerSecs = ts;

	dd.Channel1 = dx(1).Data;
	dd.Channel2 = dx(2).Data;
	dd.Channel3 = dx(3).Data;
	dd.Channel4 = dx(4).Data;
	if cAnalog == 5
		dd.Channel5 = dx(5).Data;
	end

	if cAnalog == 6
		dd.Channel5 = dx(5).Data;
		dd.Channel6 = dx(6).Data;
	end
	
	if cAnalog == 7
		dd.Channel5 = dx(5).Data;
		dd.Channel6 = dx(6).Data;
		dd.Channel7 = dx(7).Data;
	end

	if cAnalog == 8
		dd.Channel5 = dx(5).Data;
		dd.Channel6 = dx(6).Data;
		dd.Channel7 = dx(7).Data;
		dd.Channel8 = dx(8).Data;
	end

	

	matpath = 'C:\MATdata';

	if ~exist(matpath, 'dir')
		error('%s: output dir %s not found', mfilename, matpath)
	end

	[pathstr,name,ext] = fileparts(filename);

	%[folder, oldBaseName, oldExt] = fileparts(oldFileName);
	filename_new = sprintf('%s.mat',name);
	matfile = fullfile(matpath, filename_new);
	
	save(matfile, 'dd');

	ns_CloseFile(hFile);

	close all;






% plot(d.Data[1:3000])
