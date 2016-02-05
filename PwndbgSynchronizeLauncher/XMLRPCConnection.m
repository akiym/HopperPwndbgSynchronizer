#import "XMLRPCConnection.h"
#import "HopperCommands.h"
#import <CocoaHTTPServer/HTTPMessage.h>
#import <CocoaHTTPServer/HTTPDataResponse.h>
#import <WPXMLRPCDecoder.h>
#import <WPXMLRPCEncoder.h>
#import <Hopper/HPHopperServices.h>
#import <Hopper/HPDocument.h>

@implementation XMLRPCConnection

- (BOOL)supportsMethod:(NSString *)method atPath:(NSString *)path
{

    if ([method isEqualToString:@"POST"] && [path isEqualToString:@"/RPC2"]) {
        return YES;
    }
    
    return [super supportsMethod:method atPath:path];
}

- (BOOL)expectsRequestBodyFromMethod:(NSString *)method atPath:(NSString *)path
{
    if ([method isEqualToString:@"POST"] && [path isEqualToString:@"/RPC2"]) {
        NSString* contentType = [request headerField:@"Content-Type"];
        if (![contentType isEqualToString:@"text/xml"]) return NO;
        
        return YES;
    }
    return [super expectsRequestBodyFromMethod:method atPath:path];
}

- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path
{
    if ([method isEqualToString:@"POST"] && [path isEqualToString:@"/RPC2"]) {
        NSData *postData = [request body];
        WPXMLRPCDecoder *decoder = [[WPXMLRPCDecoder alloc] initWithData:postData];
        if (![decoder isFault]) {
            id data = [decoder object];
            NSString *methodName = [[data objectForKey:@"methodName"]
                                    stringByReplacingOccurrencesOfString:@"_" withString:@":"];
            NSArray *params = [data objectForKey:@"params"];
            
            HopperCommands *commands = [[HopperCommands alloc] initWithDocument:hopperDocument];
    
            WPXMLRPCEncoder *encoder = nil;
            NSMethodSignature *sig = nil;
            SEL sel = NSSelectorFromString(methodName);
            if (sel) {
                sig = [commands methodSignatureForSelector:sel];
            }
            if (sig) {
                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
                [invocation setSelector:sel];
                [invocation setTarget:commands];
                
                size_t size = [sig numberOfArguments] - 2;
                if (size == [params count]) {
                    for (size_t i = 0; i < size; i++) {
                        id param = params[i];
                        [invocation setArgument:&param atIndex:i+2];
                    }
                    [invocation invoke];
                    
                    if ([sig methodReturnLength] > 0) {
                        __unsafe_unretained id returnValue;
                        [invocation getReturnValue:&returnValue];
                        NSArray *responseParams = [NSArray arrayWithObject:returnValue];
                        encoder = [[WPXMLRPCEncoder alloc] initWithResponseParams:responseParams];
                    } else {
                        encoder = [[WPXMLRPCEncoder alloc] initWithResponseParams:@[]];
                    }
                } else {
                    encoder = [[WPXMLRPCEncoder alloc]
                               initWithResponseFaultCode:@4 andString:@"invalid parameters"];
                }
            } else {
                NSString *faultString = [NSString stringWithFormat:@"method \"%@\" is not supported",
                                         [data objectForKey:@"methodName"]];
                encoder = [[WPXMLRPCEncoder alloc]
                           initWithResponseFaultCode:@1 andString:faultString];
            }
            NSError *error = nil;
            NSData *encodedData = [encoder dataEncodedWithError:&error];
            return [[HTTPDataResponse alloc] initWithData:encodedData];
        }
        
        return [[HTTPDataResponse alloc] initWithData:nil];
    }
    
    return [super httpResponseForMethod:method URI:path];
}

- (void)prepareForBodyWithSize:(UInt64)contentLength
{
}

- (void)processBodyData:(NSData *)postDataChunk
{
    [request appendData:postDataChunk];
}

- (void)setHopperDocument:(NSObject<HPDocument>*)document
{
    hopperDocument = document;
}

@end
