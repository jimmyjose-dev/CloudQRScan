


#import "DDLog.h"
#import "DDAbstractDatabaseLogger.h"
#import "DDASLLogger.h"
#import "DDFileLogger.h"
#import "DDTTYLogger.h"

#import "Extensions/ContextFilterLogFormatter.h"
#import "Extensions/DispatchQueueLogFormatter.h"


#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_ERROR;
#endif


//For Xcode Colors -> In Xcode bring up the Scheme Editor (Product -> Edit Scheme...)
//                    Select "Run" (on the left), and then the "Arguments" tab
//                    Add a new Environment Variable named "XcodeColors", with a value of "YES"

//  DDLog Usage
//  Log levels: off, error, warn, info, verbose
//  static const int ddLogLevel = LOG_LEVEL_VERBOSE;
//  [DDLog addLogger:[DDTTYLogger sharedInstance]];
//  [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
//  DDLogVerbose(@"Verbose");
//  DDLogInfo(@"Info");
//  DDLogWarn(@"Warn");
//  DDLogError(@"Error");
//  for logging to file
//  fileLogger = [[DDFileLogger alloc] init];
//  fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
//  fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
//  [DDLog addLogger:fileLogger];
