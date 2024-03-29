#!/bin/sh

gcloud builds submit . --config test-pipeline.yaml --substitutions "_SUB_VALUE=howdy,_SHORT_BUILD_ID=\"buildid\"" --region=us-central1
