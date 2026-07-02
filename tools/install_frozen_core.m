function targetFile = install_frozen_core(sourceFile)
%INSTALL_FROZEN_CORE Verify and install the exact BMLA v4.1-RC core.
%
%   TARGETFILE = INSTALL_FROZEN_CORE(SOURCEFILE) verifies the SHA-256
%   identity of the frozen numerical source and copies it into:
%
%       src/+bmla/private/
%
%   The only accepted SHA-256 identity is:
%
%       363ff1986c1cfee8ca3438fbb779bf574de792b15edfc38a1c1aff6949491d69
%
%   Example:
%
%       install_frozen_core( ...
%           "C:\path\to\bmla_v4_1_radius_consistent_solver.m");

    arguments
        sourceFile (1,1) string
    end

    expectedSHA256 = ...
        "363ff1986c1cfee8ca3438fbb779bf574de792b15edfc38a1c1aff6949491d69";

    if ~isfile(sourceFile)
        error( ...
            'bmla:install:SourceNotFound', ...
            'Frozen core file not found: %s', ...
            sourceFile);
    end

    [~, name, extension] = fileparts(sourceFile);

    expectedName = ...
        "bmla_v4_1_radius_consistent_solver.m";

    actualName = string(name) + string(extension);

    if actualName ~= expectedName
        error( ...
            'bmla:install:UnexpectedFilename', ...
            'Expected "%s", received "%s".', ...
            expectedName, ...
            actualName);
    end

    actualSHA256 = local_sha256(sourceFile);

    if actualSHA256 ~= expectedSHA256
        error( ...
            'bmla:install:HashMismatch', ...
            ['The selected file is not the frozen BMLA v4.1-RC core.\n' ...
             'Expected SHA-256: %s\n' ...
             'Actual SHA-256:   %s'], ...
            expectedSHA256, ...
            actualSHA256);
    end

    toolsFolder = fileparts(mfilename('fullpath'));
    repositoryRoot = fileparts(toolsFolder);
    targetFolder = fullfile( ...
        repositoryRoot, ...
        'src', ...
        '+bmla', ...
        'private');

    if ~isfolder(targetFolder)
        mkdir(targetFolder);
    end

    targetFile = fullfile(targetFolder, expectedName);

    copyfile(sourceFile, targetFile, 'f');

    copiedSHA256 = local_sha256(targetFile);

    if copiedSHA256 ~= expectedSHA256
        error( ...
            'bmla:install:CopiedHashMismatch', ...
            'The copied core failed SHA-256 verification.');
    end

    fprintf('\nFrozen BMLA v4.1-RC core installed successfully.\n');
    fprintf('Target: %s\n', targetFile);
    fprintf('SHA-256: %s\n\n', copiedSHA256);
end


function digest = local_sha256(filename)

    messageDigest = ...
        java.security.MessageDigest.getInstance('SHA-256');

    inputStream = ...
        java.io.FileInputStream(java.io.File(char(filename)));

    digestStream = ...
        java.security.DigestInputStream( ...
            inputStream, ...
            messageDigest);

    buffer = zeros(1, 1024 * 1024, 'int8');

    while digestStream.read(buffer, 0, numel(buffer)) ~= -1
    end

    digestStream.close();

    hashBytes = typecast(messageDigest.digest(), 'uint8');

    digest = lower(join(compose('%02x', hashBytes), ""));
end
