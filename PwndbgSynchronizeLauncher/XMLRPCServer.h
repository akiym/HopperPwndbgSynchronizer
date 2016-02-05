#import <CocoaHTTPServer/HTTPServer.h>
#import <Hopper/HPHopperServices.h>
#import <Hopper/HPDocument.h>

@interface XMLRPCServer : HTTPServer
{
    NSObject<HPDocument> *hopperDocument;
}

- (void)setHopperDocument:(NSObject<HPDocument>*)document;

@end
