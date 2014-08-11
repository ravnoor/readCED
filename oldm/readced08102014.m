% close all; clear all; clear classes;

function [d, s] = readced(filename, varargin)

	ns_SetLibrary('nsCedSon.dll');

	[ns_RESULT, hFile] = ns_OpenFile(filename);

	%dx = struct('Data', [], 'temp', []);
    dx = struct('Data', [], 'Data2', [], 'temp', []);

% total number of time points = sampling rate * time (1000Hz * 325 secs)

	[ns_RESULT, nsFileInfo] = ns_GetFileInfo(hFile);
	totaltime = nsFileInfo.TimeSpan;
	timeres = nsFileInfo.TimeStampResolution;
    countr = nsFileInfo.EntityCount - 1;

	[ns_RESULT, nsAnalogInfo] = ns_GetAnalogInfo(hFile, countr);
	samprate = nsAnalogInfo.SampleRate;
	units = nsAnalogInfo.Units;
	ampres = nsAnalogInfo.Resolution;
    
    [ns_RESULT, nsEntityInfo] = ns_GetEntityInfo(hFile, countr - 5);
     if nsEntityInfo.EntityLabel == 'Marker (1'
         [ns_RESULT, TimeStamp, Data, DataSize] = ns_GetEventData(hFile, countr - 5, 2);
         timestamp2 = TimeStamp;
         [ns_RESULT, TimeStamp, Data, DataSize] = ns_GetEventData(hFile, countr - 5, 1);
         timestamp1 = TimeStamp;
         ts = timestamp2 - timestamp1;
     else
         ts = 'NoMarkerFound';
     end




	[ns_RESULT, nsEntityInfo] = ns_GetEntityInfo(hFile, countr);
	timepoints = nsEntityInfo.ItemCount;
	tt = -1 + timepoints/1000;
    
    R = [];

	for channel = 1:5

		for n = 0:tt
		
			[ns_RESULT, ContCount, dx(channel).temp] = ns_GetAnalogData(hFile, channel + countr - 5, n+1, 1000);
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

	dd.SamplingRate = samprate;
	dd.TimeSpan = totaltime;
	dd.TimeStampResolution = timeres;
	dd.Units = units;
	dd.Resolution = ampres;

	dd.Channel1 = dx(1).Data;
	dd.Channel2 = dx(2).Data;
	dd.Channel3 = dx(3).Data;
	dd.Channel4 = dx(4).Data;
	dd.Channel5 = dx(5).Data;

	dd.MarkerSecs = ts;

	[pathstr,name,ext] = fileparts(filename);

	%[folder, oldBaseName, oldExt] = fileparts(oldFileName);
	filename_new = sprintf('%s.mat',name);
	
	save(filename_new, 'dd');

	ns_CloseFile(hFile);

	close all;



% plot(d.Data[1:3000])
