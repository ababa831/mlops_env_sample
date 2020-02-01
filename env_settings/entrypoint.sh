#!/bin/bash

mkdir ~/.aws 
echo -e "[dev]\naws_access_key_id=$AWS_ACCESS_KEY_ID_DEV\naws_secret_access_key=$AWS_SECRET_ACCESS_KEY_DEV\n" > ~/.aws/credentials
echo -e "[stg]\naws_access_key_id=$AWS_ACCESS_KEY_ID_STG\naws_secret_access_key=$AWS_SECRET_ACCESS_KEY_STG\n" >> ~/.aws/credentials
echo -e "[prd]\naws_access_key_id=$AWS_ACCESS_KEY_ID_PRD\naws_secret_access_key=$AWS_SECRET_ACCESS_KEY_PRD\n" >> ~/.aws/credentials
echo -e "[dev]\nregion=$REGION\n[stg]\nregion=$REGION\n[prd]\nregion=$REGION\n" > ~/.aws/config
poetry run jupyter lab --allow-root --ip=0.0.0.0 --no-browser --NotebookApp.token='sha1:32bdbb42ed45:5e0b1d1681e9eaf60ee8bd158921a90ac30705a3'