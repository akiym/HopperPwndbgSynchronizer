#import <Hopper/HPHopperServices.h>
#import <Hopper/HPDocument.h>
#import <Hopper/HPDisassembledFile.h>

@interface HopperCommands : NSObject
{
    NSObject<HPDocument> *hopperDocument;
}

- (id)initWithDocument:(NSObject<HPDocument> *)_document;

- (void)here;
- (void)Jump:(NSNumber *)virtualAddress;
- (NSString *)GetType:(NSNumber *)virtualAddress;
- (NSString *)Name:(NSNumber *)virtualAddress;
- (NSString *)GetFunctionName:(NSNumber *)virtualAddress;
- (NSString *)GetFuncOffset:(NSNumber *)virtualAddress;
- (NSNumber *)LocByName:(NSString *)name;
- (NSString *)GetCommentEx:(NSNumber *)virtualAddress repeatable:(BOOL)repeatable;
- (void)SetColor:(NSNumber *)virtualAddress what:(NSUInteger)what color:(Color)color;
- (NSString *)LineA:(NSNumber *)virtualAddress num:(size_t)lines;
- (NSNumber *)NextSeg:(NSNumber *)virtualAddress;
- (NSNumber *)GetBptQty;
- (NSNumber *)GetBptEA:(size_t)numberOfBreakpoint;

@end
