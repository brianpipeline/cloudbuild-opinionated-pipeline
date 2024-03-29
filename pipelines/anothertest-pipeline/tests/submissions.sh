#!/bin/sh

gcloud builds submit . --config anotherTest.yaml --substitutions "_SUB_VALUE=wassup,_SHORT_BUILD_ID="build id"" --region=us-central1