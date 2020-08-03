#!/bin/bash
#
# Copyright (C) 2020 SebaUbuntu's HomeBot
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

ci_upload() {
	if [ "$CI_ARTIFACTS_UPLOAD_METHOD" = "gdrive" ]; then
		gupload "$1" | grep "https://drive.google.com/open?id=" | sed "s/[][]//g" | tr -d '[:space:]'
	elif [ "$CI_ARTIFACTS_UPLOAD_METHOD" = "mega" ]; then
		mega-put "$1" / > /dev/null 2>&1 && mega-export -a "/$(basename $1)" | awk '{print $3}'
	elif [ "$CI_ARTIFACTS_UPLOAD_METHOD" = "sourceforge" ]; then
		# Upload file
		sshpass -p '$CI_SF_PASS' scp $CI_MAIN_DIR/$CI_AOSP_PROJECT/out/target/product/$CI_DEVICE/$CI_OUT_ARTIFACTS_NAME $CI_SF_USER@frs.sourceforge.net:/home/frs/project/$CI_SF_PROJECT/$CI_DEVICE
		# Pass download link to the CI project script
		echo "https://sourceforge.net/projects/$CI_SF_PROJECT/files/$CI_DEVICE/$(basename "$1")/download"
	fi
}

ci_name() {
	if [ "$CI_ARTIFACTS_UPLOAD_METHOD" = "gdrive" ]; then
		printf "Google Drive"
	elif [ "$CI_ARTIFACTS_UPLOAD_METHOD" = "mega" ]; then
		printf "MEGA"
	elif [ "$CI_ARTIFACTS_UPLOAD_METHOD" = "sourceforge" ]; then
		printf "SourceForge"
	fi
}
