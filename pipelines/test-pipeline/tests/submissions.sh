#!/bin/sh

gcloud builds submit . --config ../test-pipeline.yaml --substitutions _SUB_VALUE=howdy
