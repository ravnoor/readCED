%close all; clear all; clear classes;

% data path is path to input data directory
datapath = 'H:\CEDdata';

% matpath is output path for mat files
matpath = 'H:\MATdata';

if ~exist(matpath, 'dir')
	error('%s: output dir %s not found', mfilename, matpath)
end

% look for SMR/CED files in data directory
smrfilelist = dir(fullfile(datapath, '*.smr'));

%save('smrlist.mat', 'smrfilelist');
nSMRfiles = length(smrfilelist);


fprintf('Found %d .SMR file(s) in %s\n\n', nSMRfiles, datapath);

%------------------------------------------------------------
%% convert to matfiles
%------------------------------------------------------------

for n = 1:nSMRfiles
%for n = 7:10

	smrfile = fullfile(datapath, smrfilelist(n).name);
	[tmppath, tmpfile, tmpext] = fileparts(smrfile);
	matfile = fullfile(matpath, [tmpfile '.mat']);

	if ~exist(matfile, 'file')
		fprintf('Converting:\n');
		fprintf('\t%s\n', smrfile);
		fprintf('\t\t--TO--\n');
		fprintf('\t%s\n\n', matfile);
 		readced(smrfile);
		%clear D;
	else
		fprintf('File %s already converted....\n\n', smrfile);
	end

	%pause
end