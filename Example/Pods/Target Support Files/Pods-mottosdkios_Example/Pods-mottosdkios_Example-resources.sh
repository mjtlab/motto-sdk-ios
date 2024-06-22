#!/bin/sh
set -e
set -u
set -o pipefail

function on_error {
  echo "$(realpath -mq "${0}"):$1: error: Unexpected failure"
}
trap 'on_error $LINENO' ERR

if [ -z ${UNLOCALIZED_RESOURCES_FOLDER_PATH+x} ]; then
  # If UNLOCALIZED_RESOURCES_FOLDER_PATH is not set, then there's nowhere for us to copy
  # resources to, so exit 0 (signalling the script phase was successful).
  exit 0
fi

mkdir -p "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"

RESOURCES_TO_COPY=${PODS_ROOT}/resources-to-copy-${TARGETNAME}.txt
> "$RESOURCES_TO_COPY"

XCASSET_FILES=()

# This protects against multiple targets copying the same framework dependency at the same time. The solution
# was originally proposed here: https://lists.samba.org/archive/rsync/2008-February/020158.html
RSYNC_PROTECT_TMP_FILES=(--filter "P .*.??????")

case "${TARGETED_DEVICE_FAMILY:-}" in
  1,2)
    TARGET_DEVICE_ARGS="--target-device ipad --target-device iphone"
    ;;
  1)
    TARGET_DEVICE_ARGS="--target-device iphone"
    ;;
  2)
    TARGET_DEVICE_ARGS="--target-device ipad"
    ;;
  3)
    TARGET_DEVICE_ARGS="--target-device tv"
    ;;
  4)
    TARGET_DEVICE_ARGS="--target-device watch"
    ;;
  *)
    TARGET_DEVICE_ARGS="--target-device mac"
    ;;
esac

install_resource()
{
  if [[ "$1" = /* ]] ; then
    RESOURCE_PATH="$1"
  else
    RESOURCE_PATH="${PODS_ROOT}/$1"
  fi
  if [[ ! -e "$RESOURCE_PATH" ]] ; then
    cat << EOM
error: Resource "$RESOURCE_PATH" not found. Run 'pod install' to update the copy resources script.
EOM
    exit 1
  fi
  case $RESOURCE_PATH in
    *.storyboard)
      echo "ibtool --reference-external-strings-file --errors --warnings --notices --minimum-deployment-target ${!DEPLOYMENT_TARGET_SETTING_NAME} --output-format human-readable-text --compile ${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$RESOURCE_PATH\" .storyboard`.storyboardc $RESOURCE_PATH --sdk ${SDKROOT} ${TARGET_DEVICE_ARGS}" || true
      ibtool --reference-external-strings-file --errors --warnings --notices --minimum-deployment-target ${!DEPLOYMENT_TARGET_SETTING_NAME} --output-format human-readable-text --compile "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$RESOURCE_PATH\" .storyboard`.storyboardc" "$RESOURCE_PATH" --sdk "${SDKROOT}" ${TARGET_DEVICE_ARGS}
      ;;
    *.xib)
      echo "ibtool --reference-external-strings-file --errors --warnings --notices --minimum-deployment-target ${!DEPLOYMENT_TARGET_SETTING_NAME} --output-format human-readable-text --compile ${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$RESOURCE_PATH\" .xib`.nib $RESOURCE_PATH --sdk ${SDKROOT} ${TARGET_DEVICE_ARGS}" || true
      ibtool --reference-external-strings-file --errors --warnings --notices --minimum-deployment-target ${!DEPLOYMENT_TARGET_SETTING_NAME} --output-format human-readable-text --compile "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$RESOURCE_PATH\" .xib`.nib" "$RESOURCE_PATH" --sdk "${SDKROOT}" ${TARGET_DEVICE_ARGS}
      ;;
    *.framework)
      echo "mkdir -p ${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}" || true
      mkdir -p "${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      echo "rsync --delete -av "${RSYNC_PROTECT_TMP_FILES[@]}" $RESOURCE_PATH ${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}" || true
      rsync --delete -av "${RSYNC_PROTECT_TMP_FILES[@]}" "$RESOURCE_PATH" "${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      ;;
    *.xcdatamodel)
      echo "xcrun momc \"$RESOURCE_PATH\" \"${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH"`.mom\"" || true
      xcrun momc "$RESOURCE_PATH" "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcdatamodel`.mom"
      ;;
    *.xcdatamodeld)
      echo "xcrun momc \"$RESOURCE_PATH\" \"${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcdatamodeld`.momd\"" || true
      xcrun momc "$RESOURCE_PATH" "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcdatamodeld`.momd"
      ;;
    *.xcmappingmodel)
      echo "xcrun mapc \"$RESOURCE_PATH\" \"${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcmappingmodel`.cdm\"" || true
      xcrun mapc "$RESOURCE_PATH" "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcmappingmodel`.cdm"
      ;;
    *.xcassets)
      ABSOLUTE_XCASSET_FILE="$RESOURCE_PATH"
      XCASSET_FILES+=("$ABSOLUTE_XCASSET_FILE")
      ;;
    *)
      echo "$RESOURCE_PATH" || true
      echo "$RESOURCE_PATH" >> "$RESOURCES_TO_COPY"
      ;;
  esac
}
if [[ "$CONFIGURATION" == "Debug" ]]; then
  install_resource "${PODS_CONFIGURATION_BUILD_DIR}/UnityAds/UnityAdsResources.bundle"
  install_resource "${PODS_CONFIGURATION_BUILD_DIR}/VungleAds/VungleAds.bundle"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/bg_slot_machine.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/btn_mission_info.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/btn_motto_start.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/btn_motto_ticket.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/icon_check_circle.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/icon_close.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/icon_home_title_dark2.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/icon_home_title_light2.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/icon_motto_draw.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/icon_notice_dark.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/icon_notice_light.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/icon_retry.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/icon_ticket.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/ic_arrow_left.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/ic_clock.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/ic_launcher_foreground.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/lens.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/like.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/main_mpago_ment.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/main_top_ment.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/ment_save_nplace.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/motto_balloon_yellow.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/motto_slot_bg.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0000.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0001.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0003.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0005.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0006.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0007.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0009.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0010.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0012.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0013.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0015.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0016.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0018.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0019.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0021.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0023.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0024.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0026.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0027.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0029.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0030.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0032.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0033.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0036.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0037.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0039.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0043.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0045.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0046.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0049.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0050.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0053.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0055.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0057.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0060.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/mpago_head1.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/mpago_head2.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/mpago_head3.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/naver_place_alarm_save_guide.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/naver_place_bottom_bar_alarm.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/naver_place_bottom_bar_save.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/naver_process2.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/naver_process_alarm.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/naver_process_blog.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/naver_process_blog2.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/naver_process_heart2.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/naver_process_login.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/naver_process_place1.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/naver_process_zzim.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/place_traffic_guide1.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/save.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/splash_img1.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/splash_img2.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/ticket1.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/ticket2.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/ticket3.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/traffic.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Data/MissionData.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Data/Motto.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Data/Network/Model/DefaultResponseModel.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Global/Extensions/Date+.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Global/Extensions/Notificatoin+.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Global/Extensions/NSObject+.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Global/Extensions/String+.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Global/Extensions/UIButton+.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Global/Extensions/UIColor+.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Global/Extensions/UIImageView+.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Global/Extensions/UIPickerView+.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Global/Extensions/UITextView+.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Global/Extensions/UIView+.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Global/font/gmarketsansbold.ttf"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Global/Literal/Const.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Global/Literal/Images.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Global/Utils/Utils.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/Cells/TopTabBarCollectionViewCell.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/AccountViewController.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/AdMissionViewController.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/ads/AdCpcViewController.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/ads/AdCpvViewController.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/ads/AdNetworkViewController.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/ads/adunit/AdUnitAdmob.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/ads/adunit/AdUnitAdpopcorn.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/ads/adunit/AdUnitBase.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/ads/adunit/AdUnitPangle.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/ads/adunit/AdUnitUnity.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/ads/adunit/AdUnitVungle.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/BaseCampaignViewController.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/BaseLibVC.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/BaseViewController.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/DialogViewController.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/FavorViewController.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/GuideCommViewController.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/GuideViewController.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/HallOfFameViewController.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/human/AutoKeywordViewController.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/human/HumanNaverViewController.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/human/SiteTrafficViewController.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/inapp/SiteTrafficInappViewController.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/IndexViewController.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/MissionFailViewController.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/MyMottoViewController.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/NewHallOfFameViewController.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/NewHomeViewController.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/PrizeNumberViewController.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/RewardFailViewController.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/TestVC.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/TestViewController.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/Views/AdBaseView.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/Views/AdCrawlingView.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/Views/AdHumanView.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/Views/AdNBlogView.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/Views/AdNFavorView.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/Views/AdNPlaceAlarmSaveView.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/Views/AdNPlaceView.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/Views/AdNPTrafficView.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/Views/AdNSTrafficView.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/Views/BaseView.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/Views/DialogView.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/Views/FavorView.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/Views/GuideCommView.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/Views/GuideNplaceHomeView.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/Views/GuideView.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/Views/inapp/AdInstagramView.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/Views/LoadingIndicator.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/Views/MissionFailView.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/Views/RewardFailView.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/Views/TopTabBarView.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/ReplaceMe.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/temp.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Data"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Data/Network"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Data/Network/Model"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Global"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Global/Extensions"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Global/font"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Global/Literal"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Global/Utils"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/Cells"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/ads"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/ads/adunit"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/human"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/inapp"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/Views"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/Views/ads"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/Views/inapp"
  install_resource "${PODS_CONFIGURATION_BUILD_DIR}/mottosdkios/mottosdk.bundle"
fi
if [[ "$CONFIGURATION" == "Release" ]]; then
  install_resource "${PODS_CONFIGURATION_BUILD_DIR}/UnityAds/UnityAdsResources.bundle"
  install_resource "${PODS_CONFIGURATION_BUILD_DIR}/VungleAds/VungleAds.bundle"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/bg_slot_machine.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/btn_mission_info.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/btn_motto_start.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/btn_motto_ticket.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/icon_check_circle.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/icon_close.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/icon_home_title_dark2.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/icon_home_title_light2.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/icon_motto_draw.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/icon_notice_dark.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/icon_notice_light.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/icon_retry.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/icon_ticket.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/ic_arrow_left.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/ic_clock.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/ic_launcher_foreground.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/lens.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/like.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/main_mpago_ment.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/main_top_ment.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/ment_save_nplace.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/motto_balloon_yellow.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/motto_slot_bg.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0000.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0001.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0003.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0005.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0006.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0007.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0009.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0010.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0012.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0013.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0015.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0016.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0018.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0019.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0021.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0023.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0024.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0026.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0027.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0029.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0030.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0032.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0033.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0036.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0037.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0039.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0043.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0045.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0046.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0049.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0050.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0053.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0055.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0057.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/move_0060.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/mpago_head1.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/mpago_head2.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/mpago_head3.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/naver_place_alarm_save_guide.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/naver_place_bottom_bar_alarm.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/naver_place_bottom_bar_save.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/naver_process2.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/naver_process_alarm.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/naver_process_blog.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/naver_process_blog2.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/naver_process_heart2.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/naver_process_login.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/naver_process_place1.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/naver_process_zzim.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/place_traffic_guide1.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/save.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/splash_img1.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/splash_img2.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/ticket1.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/ticket2.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/ticket3.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets/traffic.png"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Data/MissionData.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Data/Motto.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Data/Network/Model/DefaultResponseModel.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Global/Extensions/Date+.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Global/Extensions/Notificatoin+.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Global/Extensions/NSObject+.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Global/Extensions/String+.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Global/Extensions/UIButton+.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Global/Extensions/UIColor+.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Global/Extensions/UIImageView+.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Global/Extensions/UIPickerView+.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Global/Extensions/UITextView+.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Global/Extensions/UIView+.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Global/font/gmarketsansbold.ttf"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Global/Literal/Const.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Global/Literal/Images.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Global/Utils/Utils.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/Cells/TopTabBarCollectionViewCell.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/AccountViewController.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/AdMissionViewController.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/ads/AdCpcViewController.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/ads/AdCpvViewController.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/ads/AdNetworkViewController.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/ads/adunit/AdUnitAdmob.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/ads/adunit/AdUnitAdpopcorn.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/ads/adunit/AdUnitBase.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/ads/adunit/AdUnitPangle.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/ads/adunit/AdUnitUnity.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/ads/adunit/AdUnitVungle.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/BaseCampaignViewController.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/BaseLibVC.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/BaseViewController.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/DialogViewController.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/FavorViewController.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/GuideCommViewController.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/GuideViewController.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/HallOfFameViewController.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/human/AutoKeywordViewController.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/human/HumanNaverViewController.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/human/SiteTrafficViewController.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/inapp/SiteTrafficInappViewController.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/IndexViewController.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/MissionFailViewController.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/MyMottoViewController.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/NewHallOfFameViewController.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/NewHomeViewController.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/PrizeNumberViewController.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/RewardFailViewController.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/TestVC.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/TestViewController.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/Views/AdBaseView.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/Views/AdCrawlingView.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/Views/AdHumanView.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/Views/AdNBlogView.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/Views/AdNFavorView.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/Views/AdNPlaceAlarmSaveView.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/Views/AdNPlaceView.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/Views/AdNPTrafficView.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/Views/AdNSTrafficView.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/Views/BaseView.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/Views/DialogView.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/Views/FavorView.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/Views/GuideCommView.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/Views/GuideNplaceHomeView.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/Views/GuideView.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/Views/inapp/AdInstagramView.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/Views/LoadingIndicator.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/Views/MissionFailView.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/Views/RewardFailView.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/Views/TopTabBarView.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/ReplaceMe.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/temp.swift"
  install_resource "${PODS_ROOT}/../../mottosdkios/Assets"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Data"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Data/Network"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Data/Network/Model"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Global"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Global/Extensions"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Global/font"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Global/Literal"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Global/Utils"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/Cells"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/ads"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/ads/adunit"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/human"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/VCs/inapp"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/Views"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/Views/ads"
  install_resource "${PODS_ROOT}/../../mottosdkios/Classes/Presentation/Views/inapp"
  install_resource "${PODS_CONFIGURATION_BUILD_DIR}/mottosdkios/mottosdk.bundle"
fi

mkdir -p "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
if [[ "${ACTION}" == "install" ]] && [[ "${SKIP_INSTALL}" == "NO" ]]; then
  mkdir -p "${INSTALL_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
  rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${INSTALL_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi
rm -f "$RESOURCES_TO_COPY"

if [[ -n "${WRAPPER_EXTENSION}" ]] && [ "`xcrun --find actool`" ] && [ -n "${XCASSET_FILES:-}" ]
then
  # Find all other xcassets (this unfortunately includes those of path pods and other targets).
  OTHER_XCASSETS=$(find -L "$PWD" -iname "*.xcassets" -type d)
  while read line; do
    if [[ $line != "${PODS_ROOT}*" ]]; then
      XCASSET_FILES+=("$line")
    fi
  done <<<"$OTHER_XCASSETS"

  if [ -z ${ASSETCATALOG_COMPILER_APPICON_NAME+x} ]; then
    printf "%s\0" "${XCASSET_FILES[@]}" | xargs -0 xcrun actool --output-format human-readable-text --notices --warnings --platform "${PLATFORM_NAME}" --minimum-deployment-target "${!DEPLOYMENT_TARGET_SETTING_NAME}" ${TARGET_DEVICE_ARGS} --compress-pngs --compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
  else
    printf "%s\0" "${XCASSET_FILES[@]}" | xargs -0 xcrun actool --output-format human-readable-text --notices --warnings --platform "${PLATFORM_NAME}" --minimum-deployment-target "${!DEPLOYMENT_TARGET_SETTING_NAME}" ${TARGET_DEVICE_ARGS} --compress-pngs --compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}" --app-icon "${ASSETCATALOG_COMPILER_APPICON_NAME}" --output-partial-info-plist "${TARGET_TEMP_DIR}/assetcatalog_generated_info_cocoapods.plist"
  fi
fi
