#!/bin/sh

gcloud builds submit . --config anotherTest.yaml --substitutions "_SUB_VALUE=wassup,_SHORT_BUILD_ID=\"buildid\"" --region=us-central1
