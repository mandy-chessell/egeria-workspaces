#!/bin/bash
#
# SPDX-License-Identifier: Apache-2.0
# Copyright Contributors to the ODPi Egeria project.
#
# Coco Pharmaceuticals Lab Docker Compose configuration
#
# This shell script is automatically invoked when the Jupyter Container is initiated as part of the Docker Compose
# configuration.The script configures and activates the Egeria OMAG servers on each of the three Egeria OMAG Server
# Platforms that are part of the sample Coco Pharmaceuticals deployment environment.

#export PYTHONDONTWRITEBYTECODE=1
#python3 /home/jovyan/egeria-labs/common/config_coco_core.py
#python3 /home/jovyan/egeria-labs/common/config_coco_datalake.py
#python3 /home/jovyan/egeria-labs/common/config_coco_development.py
#echo "Launching Jupyter notebook server.."

/opt/conda/bin/activate python312
