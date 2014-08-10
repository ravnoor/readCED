% close all; clear all; clear classes;

function [d, s] = readced(filename, varargin)

	ns_SetLibrary('nsCedSon.dll');

	[ns_RESULT, hFile] = ns_OpenFile(filename);

	dx = struct('Data', [], 'temp', []);

% total number of time points = sampling rate * time (1000Hz * 325 secs)

	[ns_RESULT, nsFileInfo] = ns_GetFileInfo(hFile);
	totaltime = nsFileInfo.TimeSpan;
	timeres = nsFileInfo.TimeStampResolution;

	[ns_RESULT, nsAnalogInfo] = ns_GetAnalogInfo(hFile, 7);
	samprate = nsAnalogInfo.SampleRate;
	units = nsAnalogInfo.Units;
	ampres = nsAnalogInfo.Resolution;

	[ns_RESULT, nsEntityInfo] = ns_GetEntityInfo(hFile, 7);
	timepoints = nsEntityInfo.ItemCount;
	tt = -1 + timepoints/1000;

	for channel = 1:5

		for n = 0:tt
		
			[ns_RESULT, ContCount, dx(channel).temp] = ns_GetAnalogData(hFile, channel + 6, n+1, 1000);
			dx(channel).Data = [dx(channel).Data dx(channel).temp];
				
		end

		[r c] = size(dx(channel).Data);
		dx(channel).Data = reshape(dx(channel).Data, r*c, 1);

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

	[pathstr,name,ext] = fileparts(filename);

	%[folder, oldBaseName, oldExt] = fileparts(oldFileName);
	filename_new = sprintf('%s.mat',name);
	
	save(filename_new, 'dd');



% plot(d.Data[1:3000])
