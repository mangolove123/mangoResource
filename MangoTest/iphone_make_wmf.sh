
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
source adhoc_deploy.config

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

xcodebuild -project ${TARGET_NAME}.xcodeproj -configuration ${RELEASE_OR_DEBUG} -alltargets

xcodebuild -project ${TARGET_NAME}.xcodeproj -scheme ${TARGET_NAME}

ARCHIVE_PATH="${PWD_STR}/build/${TARGET_NAME}.xcarchive"
APP_PATH="${PWD_STR}/build/Payload/${TARGET_NAME}.app"
IPA_PATH="${PWD_STR}/build/${PRODUCT_NAME}.ipa"

# 生成archive文件
xcodebuild archive -project ${TARGET_NAME}.xcodeproj -scheme ${TARGET_NAME} -archivePath ${ARCHIVE_PATH}
echo "create achieve success"

# 签名并且导出ipa文件


xcodebuild -exportArchive -archivePath ${ARCHIVE_PATH} -exportPath ${IPA_PATH} -exportFormat ipa
#-exportProvisioningProfile "${ADHOC_PROVISION}"
echo "create ipa success"
