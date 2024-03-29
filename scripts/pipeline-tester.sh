#!/bin/bash
pipelineTestSuite() {
    testDirectory="$1"
    topLevelDirectory=$(pwd)
    testFailures=false
    testFailuresList=""

    while read -r file; do
        currentDir=$(dirname "$file")

        cd "$currentDir" || exit 1

        # TODO: Use git diff to check if the actual pipeline file or test files have changed. If so, run the tests. Do this after you get a Dockerfile deploy pipeline working.
        ./tests/submissions.sh
        exit_code=$?
        if [[ $exit_code != 0 ]]; then
            echo "Tests in $currentDir failed with $exit_code"
            testFailures=true
            testFailuresList="$testFailuresList $currentDir"
        fi
        cd "$topLevelDirectory" || exit 1
    done < <(find "$testDirectory" -type d -name tests -prune -o -type f -print)

    if [[ $testFailures == true ]]; then
        echo "The following tests failed: $testFailuresList"
        exit 1
    fi
    echo "All tests passed."
}