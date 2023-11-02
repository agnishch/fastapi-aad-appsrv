#!/bin/bash
docker build . -t agnishacr.azurecr.io/demo-first-img:latest
docker push agnishacr.azurecr.io/demo-first-img:latest