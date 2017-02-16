
#!/bin/bash
set -e

##  @Date 2014-11-28


PWD_STR=`pwd`
if [[ $PWD_STR =~ "/scripts" ]]; then
  echo ""
  echo "ERROR:  You should not call iphone_make_ipa.sh within DIR: scripts"
  echo "SYNTAX: bash script/iphone_make_ipa.sh"
  echo ""
  exit -1
fi

## 参考: http://stackoverflow.com/questions/14793329/fixing-file-project-pch-has-been-modified-since-the-precompiled-header-was-bui

## 1. 读取用户以及应用程序的配置
source scripts/adhoc_deploy.config

touch ${PCH_FILE}

PRODUCT_NAME="${TARGET_NAME}_${RELEASE_OR_DEBUG}"
CERTIFICATE="${DIST_SIGN}"

## 1.4 清除历史
if [ -d build ]; then
    rm -rf build
fi

# 新流程 2014-10-28
# 首先clean一下
xcodebuild clean -project ${TARGET_NAME}.xcodeproj -configuration ${RELEASE_OR_DEBUG} -alltargets

ARCHIVE_PATH="${PWD_STR}/build/${TARGET_NAME}.xcarchive"
APP_PATH="${PWD_STR}/build/Payload/${TARGET_NAME}.app"
IPA_PATH="${PWD_STR}/build/${PRODUCT_NAME}.ipa"

# 生成archive文件
xcodebuild archive -project ${TARGET_NAME}.xcodeproj -scheme ${TARGET_NAME} -archivePath ${ARCHIVE_PATH}
echo "create achieve success"

# 签名并且导出ipa文件
xcodebuild -exportArchive -archivePath ${ARCHIVE_PATH} -exportPath ${IPA_PATH} -exportFormat ipa -exportProvisioningProfile "${ADHOC_PROVISION}"
echo "create ipa success"

# cd "${PWD_STR}"
#
# ### 上传到蒲公英
# #python ../ThirdParties/scripts/upload_app.py "${IPA_PATH}" "${UPLOAD_APP_KEY}" "${UPLOAD_API_KEY}" "${DOWN_PASSWORD}"
# #
# #echo "Installation complete"
#
# ## 上传到fir.im
# IPA=${IPA_PATH}
#
# if [ -z "$IPA" ]
# then
# 	echo "Syntax: upload_fir.sh {my-application.ipa}"
# 	exit 1
# fi
#
# USER_TOKEN=${FIR_USER_TOKEN}
# APP_ID=${FIR_APP_ID}
#
# echo "getting token"
#
# echo url http://api.fir.im/apps/${APP_ID}/releases?api_token=${USER_TOKEN}
#
# INFO=`curl -F "api_token=${USER_TOKEN}" http://api.fir.im/apps/${APP_ID}/releases`
#
# #echo response ${INFO}
#
# KEY=$(echo ${INFO} | grep "binary.*upload_url" -o | grep "key.*$" -o | awk -F '"' '{print $3;}')
# TOKEN=$(echo ${INFO} | grep "binary.*upload_url" -o | grep "token.*$" -o | awk -F '"' '{print $3;}')
# UPLOADURL=$(echo ${INFO} | grep "binary.*" -o | grep "upload_url.*$" -o | awk -F '"' '{print $3;}')
#
# echo key ${KEY}
# echo token ${TOKEN}
# echo upload_url ${UPLOADURL}
#
# echo "uploading"
# APP_INFO=`curl -# -F file=@${IPA} -F "key=${KEY}" -F "token=${TOKEN}" ${UPLOADURL}`
#
# if [ $? != 0 ]
# then
# 	echo "upload error"
# 	exit 1
# fi
#
# echo ${APP_INFO}
# #APPOID=`echo ${APP_INFO} | grep "appOid.*," -o | awk -F '"' '{print $3;}'`
# #
# ##echo ${APP_INFO}
# ##echo ${APPOID}
# #
# #curl -X PUT -d changelog="update version" http://fir.im/api/v2/app/${APPOID}?token=${USER_TOKEN}
#
#
# echo "/n upload success"
