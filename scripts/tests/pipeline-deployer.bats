#!/usr/bin/env bats

load $(pwd)/scripts/pipeline-deployer.sh
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

@test "deployPipelines should handle successful build submission" {
    # Stub gcloud builds submit command to return success
    stub gcloud "exit 0"
    # Run your function
    run deployPipelines "pipelines"
    # Check if it succeeds
    [ "$status" -eq 0 ]
    [[ "$output" == *"All pipelines deployed"* ]]
}

@test "deployPipelines should handle failed build submission" {
    # Stub gcloud builds submit command to return failure
    stub gcloud "exit 1"
    # Run your function
    run deployPipelines "pipelines"
    echo $output
    # Check if it fails
    [ "$status" -eq 1 ]
    [[ "$output" == *"Failed to update pipeline"* ]]
    echo $PATH
}
