function repositoryRoot = setup_bmla()
%SETUP_BMLA Add the public BMLA MATLAB source folder to the path.
%
%   REPOSITORYROOT = SETUP_BMLA() adds <repository>/src to the MATLAB path.

    repositoryRoot = fileparts(mfilename('fullpath'));
    sourceFolder = fullfile(repositoryRoot, 'src');

    if ~isfolder(sourceFolder)
        error( ...
            'bmla:setup:MissingSourceFolder', ...
            'The source folder was not found: %s', ...
            sourceFolder);
    end

    addpath(sourceFolder);

    fprintf('BMLA source path added from:\n%s\n', repositoryRoot);
end
