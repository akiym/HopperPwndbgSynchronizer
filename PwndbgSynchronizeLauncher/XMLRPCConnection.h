#import <CocoaHTTPServer/HTTPConnection.h>
#import <Hopper/HPHopperServices.h>
#import <Hopper/HPDocument.h>

@interface XMLRPCConnection : HTTPConnection
{
    NSObject<HPDocument> *hopperDocument;
}

- (void)setHopperDocument:(NSObject<HPDocument>*)document;

@end
