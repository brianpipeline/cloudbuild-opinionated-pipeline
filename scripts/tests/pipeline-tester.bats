#!/usr/bin/env bats

load $(pwd)/scripts/pipeline-tester.sh
BATS_TEST_DIRNAME=$(pwd)
export PATH="$BATS_TEST_DIRNAME/stub:$PATH"

stub() {
    if [ ! -d $BATS_TEST_DIRNAME/stub ]; then
        mkdir $BATS_TEST_DIRNAME/stub
    fi
    echo $2 >$BATS_TEST_DIRNAME/stub/$1
    chmod +x $BATS_TEST_DIRNAME/stub/$1
}

rm_stubs() {
    rm -rf $BATS_TEST_DIRNAME/stub
}

teardown() {
    rm_stubs
}

@test "pipelineTestSuite should handle successful build submission" {
    # Stub gcloud builds submit command to return success
    stub gcloud "exit 0"
    # Run your function
    run pipelineTestSuite "pipelines"
    # Check if it succeeds
    [ "$status" -eq 0 ]
    [[ "$output" == *"All tests passed."* ]]
}

@test "pipelineTestSuite should handle failed build submission" {
    # Stub gcloud builds submit command to return failure
    stub gcloud "exit 1"
    # Run your function
    run pipelineTestSuite "pipelines"
    echo $output
    # Check if it fails
    [ "$status" -eq 1 ]
    [[ "$output" == *"The following tests failed:"* ]]
    echo $PATH
}
