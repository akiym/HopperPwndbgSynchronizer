#import "XMLRPCServer.h"
#import <Hopper/HopperTool.h>

@interface PwndbgSynchronizer : NSObject<HopperTool>
{
    NSObject<HPHopperServices> *_services;
    XMLRPCServer *_xmlrpcServer;
}

@end

