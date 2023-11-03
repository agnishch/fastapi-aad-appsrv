#!/bin/bash
# copy dockerfile to 
cd ..
ls
docker build -t agnishacr.azurecr.io/demo-first-img .
az acr login -n agnishacr
docker push agnishacr.azurecr.io/demo-first-img