#import "XMLRPCServer.h"
#import "XMLRPCConnection.h"

@implementation XMLRPCServer

- (HTTPConfig *)config
{
    return [[HTTPConfig alloc] initWithServer:self documentRoot:documentRoot queue:connectionQueue];
}

- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
    XMLRPCConnection *newConnection = (XMLRPCConnection *)[[connectionClass alloc] initWithAsyncSocket:newSocket
                                                                                     configuration:[self config]];
    [newConnection setHopperDocument:hopperDocument];
    
    [connectionsLock lock];
    [connections addObject:newConnection];
    [connectionsLock unlock];
    
    [newConnection start];
}

- (void)setHopperDocument:(NSObject<HPDocument>*)document
{
    hopperDocument = document;
}

@end
