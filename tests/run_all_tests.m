function results = run_all_tests()
%RUN_ALL_TESTS Run the current BMLA MATLAB test suite.

    testsFolder = fileparts(mfilename('fullpath'));
    repositoryRoot = fileparts(testsFolder);

    addpath(repositoryRoot);
    setup_bmla();

    suite = testsuite( ...
        testsFolder, ...
        'IncludeSubfolders', true);

    results = run(suite);

    disp(results);

    if any([results.Failed])
        error( ...
            'bmla:tests:Failure', ...
            '%d BMLA tests failed.', ...
            sum([results.Failed]));
    end
end
