#import "PwndbgSynchronizer.h"
#import "XMLRPCConnection.h"
#import "XMLRPCServer.h"
#import <Hopper/HPHopperServices.h>
#import <Hopper/HPDocument.h>

@implementation PwndbgSynchronizer

- (NSArray *)toolMenuDescription {
    return @[
             @{HPM_TITLE: @"Synchronize with pwndbg",
               HPM_SELECTOR: @"startSynchronize:"}
             ];
}

- (void)startSynchronize:(id)sender {
    NSObject<HPDocument> *doc = [_services currentDocument];
    [doc beginToWait:@"Launching Server..."];
    
    if ([_xmlrpcServer isRunning]) {
        [_xmlrpcServer stop];
    }
    
    [_xmlrpcServer setHopperDocument:[_services currentDocument]];

    NSError *error = nil;
    if (![_xmlrpcServer start:&error]) {
        [doc displayAlertWithMessageText:@"Failed to start XMLRPC server"
                           defaultButton:@"OK"
                         alternateButton:nil
                             otherButton:nil
                         informativeText:[error localizedDescription]];
    }

    [doc endWaiting];
}

- (instancetype)initWithHopperServices:(NSObject <HPHopperServices> *)services {
    if (self = [super init]) {
        _services = services;
        _xmlrpcServer = [[XMLRPCServer alloc] init];
        [_xmlrpcServer setPort:8889];
        [_xmlrpcServer setConnectionClass:[XMLRPCConnection class]];
    }
    return self;
}

- (HopperUUID *)pluginUUID {
    return [_services UUIDWithString:@"4ece9493-1d58-48a4-a362-352b9f6835bc"];
}

- (HopperPluginType)pluginType {
    return Plugin_Tool;
}

- (NSString *)pluginName {
    return @"Pwndbg Synchronizer";
}

- (NSString *)pluginDescription {
    return @"Pwndbg Synchronizer";
}

- (NSString *)pluginAuthor {
    return @"akiym";
}

- (NSString *)pluginCopyright {
    return @"©2016 - akiym";
}

- (NSString *)pluginVersion {
    return @"0.0.1";
}

@end
