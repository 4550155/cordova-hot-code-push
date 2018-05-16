//
//  HCPContentConfig.m
//
//  Created by Nikolay Demyankov on 10.08.15.
//

#import "HCPContentConfig.h"

@interface HCPContentConfig()

@property (nonatomic, strong, readwrite) NSString *releaseVersion;
@property (nonatomic, readwrite) NSInteger minimumNativeVersion;
@property (nonatomic, strong, readwrite) NSURL *contentURL;
@property (nonatomic, readwrite) HCPUpdateTime updateTime;

/*edit by carl*/
@property (nonatomic, strong, readwrite) NSString *displayLog;
@property (nonatomic, strong, readwrite) NSURL *androidDownloadUrl;
@property (nonatomic, strong, readwrite) NSURL *iosDownloadUrl;
@property (nonatomic, strong, readwrite) NSString *verLogZh;
@property (nonatomic, strong, readwrite) NSString *verLogEn;
@end

#pragma mark Json keys declaration

static NSString *const RELEASE_VERSION_JSON_KEY = @"release";
static NSString *const MINIMUM_NATIVE_VERSION_JSON_KEY = @"min_native_interface";
static NSString *const UPDATE_TIME_JSON_KEY = @"update";
static NSString *const CONTENT_URL_JSON_KEY = @"content_url";

/*edit by carl*/
static NSString *const DISPLAY_LOG_JSON_KEY = @"display_log";
static NSString *const ANDROID_DOWNLOAD_URL_JSON_KEY = @"android_download_url";
static NSString *const IOS_DOWNLOAD_URP_JSON_KEY = @"ios_download_url";
static NSString *const VER_LOG_ZH_JSON_KEY = @"ver_log_zh";
static NSString *const VER_LOG_EN_JSON_KEY = @"ver_log_en";
#pragma mark HCPUpdateTime enum strings declaration

static NSString *const UPDATE_TIME_NOW = @"now";
static NSString *const UPDATE_TIME_ON_START = @"start";
static NSString *const UPDATE_TIME_ON_RESUME = @"resume";

@implementation HCPContentConfig

#pragma mark Private API

/**
 *  Convert HCPUpdateTime instance to string.
 *
 *  @param updateTime
 *
 *  @return string representation of the update time option
 */
- (NSString *)updateTimeEnumToString:(HCPUpdateTime)updateTime {
    NSString *value = @"";
    switch (updateTime) {
        case HCPUpdateNow: {
            value = UPDATE_TIME_NOW;
            break;
        }
        case HCPUpdateOnResume: {
            value = UPDATE_TIME_ON_RESUME;
            break;
        }
        case HCPUpdateOnStart: {
            value = UPDATE_TIME_ON_START;
            break;
        }
        
        case HCPUpdateTimeUndefined:
        default: {
            break;
        }
    }
    
    return value;
}

/**
 *  Convert update time option from string to enum
 *
 *  @param updateTime string version
 *
 *  @return enum version of the string
 */
- (HCPUpdateTime)updateTimeStringToEnum:(NSString *)updateTime {
    HCPUpdateTime value = HCPUpdateTimeUndefined;
    if ([updateTime isEqualToString:UPDATE_TIME_NOW]) {
        value = HCPUpdateNow;
    } else if ([updateTime isEqualToString:UPDATE_TIME_ON_START]) {
        value = HCPUpdateOnStart;
    } else if ([updateTime isEqualToString:UPDATE_TIME_ON_RESUME]) {
        value = HCPUpdateOnResume;
    }
    
    return value;
}

#pragma mark HCPJsonConvertable implementation

- (id)toJson {
    NSMutableDictionary *jsonObject = [[NSMutableDictionary alloc] init];
    if (_releaseVersion) {
        jsonObject[RELEASE_VERSION_JSON_KEY] = _releaseVersion;
    }
    
    if (_minimumNativeVersion > 0) {
        jsonObject[MINIMUM_NATIVE_VERSION_JSON_KEY] = [NSNumber numberWithInteger:_minimumNativeVersion];
    }
    
    NSString *updateTimeStr = [self updateTimeEnumToString:_updateTime];
    if (updateTimeStr) {
        jsonObject[UPDATE_TIME_JSON_KEY] = updateTimeStr;
    }
    
    if (_contentURL) {
        jsonObject[CONTENT_URL_JSON_KEY] = _contentURL.absoluteString;
    }
    
    /*edit by carl*/
    if (_displayLog) {
        jsonObject[DISPLAY_LOG_JSON_KEY] = _displayLog;
    }
    
    if (_androidDownloadUrl) {
        jsonObject[ANDROID_DOWNLOAD_URL_JSON_KEY] = _androidDownloadUrl.absoluteString;
    }
    
    if (_iosDownloadUrl) {
        jsonObject[IOS_DOWNLOAD_URP_JSON_KEY] = _iosDownloadUrl.absoluteString;
    }
    
    if (_verLogZh) {
        jsonObject[VER_LOG_ZH_JSON_KEY] = _verLogZh;
    }
    
    if (_verLogEn) {
        jsonObject[VER_LOG_EN_JSON_KEY] = _verLogEn;
    }
    return jsonObject;
}

+ (instancetype)instanceFromJsonObject:(id)json {
    if (![json isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    NSDictionary *jsonObject = json;
    
    HCPContentConfig *contentConfig = [[HCPContentConfig alloc] init];
    contentConfig.releaseVersion = jsonObject[RELEASE_VERSION_JSON_KEY];
    contentConfig.minimumNativeVersion = [(NSNumber *)jsonObject[MINIMUM_NATIVE_VERSION_JSON_KEY] integerValue];
    contentConfig.contentURL = [NSURL URLWithString:jsonObject[CONTENT_URL_JSON_KEY]];
    
    NSString *updateTime = jsonObject[UPDATE_TIME_JSON_KEY];
    contentConfig.updateTime = [contentConfig updateTimeStringToEnum:updateTime];

    /*edit by carl*/
    contentConfig.displayLog =jsonObject[DISPLAY_LOG_JSON_KEY];
    contentConfig.androidDownloadUrl =[NSURL URLWithString:jsonObject[ANDROID_DOWNLOAD_URL_JSON_KEY]];
    contentConfig.iosDownloadUrl =[NSURL URLWithString:jsonObject[IOS_DOWNLOAD_URP_JSON_KEY]];
    contentConfig.verLogZh =jsonObject[VER_LOG_ZH_JSON_KEY];
    contentConfig.verLogEn =jsonObject[VER_LOG_EN_JSON_KEY];

    return contentConfig;
}

@end
