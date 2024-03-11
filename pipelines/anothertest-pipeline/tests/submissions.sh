#!/bin/sh

gcloud builds submit . --config anotherTest.yaml --substitutions _SUB_VALUE=wassup
