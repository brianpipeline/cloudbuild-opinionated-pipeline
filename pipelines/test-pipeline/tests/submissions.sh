#!/bin/sh

gcloud builds submit . --config test-pipeline.yaml --substitutions "_SUB_VALUE=howdy,_SHORT_BUILD_ID="build id"" --region=us-central1
