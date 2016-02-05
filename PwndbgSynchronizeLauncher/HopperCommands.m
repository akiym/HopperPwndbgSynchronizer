#import "HopperCommands.h"
#import <Hopper/HPHopperServices.h>
#import <Hopper/HPDocument.h>
#import <Hopper/HPDisassembledFile.h>
#import <Hopper/HPProcedure.h>
#import <Hopper/HPBasicBlock.h>
#import <Hopper/HPSegment.h>
#import <Hopper/HPFormattedInstructionInfo.h>
#import <Hopper/DisasmStruct.h>
#import <Hopper/CPUContext.h>


static const Address BADADDR = 4294967295;

@implementation HopperCommands

- (id)initWithDocument:(NSObject<HPDocument> *)_document
{
    if (self = [super init]) {
        hopperDocument = _document;
    }
    return self;
}

// IDA like Hopper commands implementation
// see also https://www.hex-rays.com/products/ida/support/idapython_docs/

// (unimplemented) undocumented
- (void)here
{
}

// Move cursor to the specifed linear address
- (void)Jump:(NSNumber *)virtualAddress
{
    Address va = [virtualAddress longLongValue];
    [hopperDocument moveCursorToVirtualAddress:va];
}

// (unimplemented) Get type of function/variable
- (NSString *)GetType:(NSNumber *)virtualAddress
{
    return @"";
}

// (unimplemented) undocumented
- (NSString *)Name:(NSNumber *)virtualAddress
{
    return @"";
}

// Retrieve function name
- (NSString *)GetFunctionName:(NSNumber *)virtualAddress
{
    Address va = [virtualAddress longLongValue];
    NSString *functionName = [[self disassembledFile] nearestNameBeforeVirtualAddress:va];
    if (functionName != nil) {
        return functionName;
    } else {
        return @"";
    }
}

// Convert address to 'funcname+offset' string
- (NSString *)GetFuncOffset:(NSNumber *)virtualAddress
{
    Address va = [virtualAddress longLongValue];
    NSString *functionName = [self GetFunctionName:virtualAddress];
    Address functionAddress = [[self disassembledFile] findVirtualAddressNamed:functionName];
    size_t offset = (size_t)(va - functionAddress);
    return [NSString stringWithFormat:@"%@+%ld", functionName, offset];
}

// Get linear address of a name
- (NSNumber *)LocByName:(NSString *)name
{
    return [NSNumber numberWithLongLong:[[self disassembledFile] findVirtualAddressNamed:name]];
}

// Get regular indented comment
- (NSString *)GetCommentEx:(NSNumber *)virtualAddress repeatable:(BOOL)repeatable
{
    Address va = [virtualAddress longLongValue];
    NSObject<HPDisassembledFile> *disas = [self disassembledFile];
    if (repeatable) {
        return [disas commentAtVirtualAddress:va];
    } else {
        return [disas inlineCommentAtVirtualAddress:va];
    }
}

// Set item color
- (void)SetColor:(NSNumber *)virtualAddress what:(NSUInteger)what color:(Color)color
{
    Address va = [virtualAddress longLongValue];
    if (color == 0xffffff) {
        [[self disassembledFile] clearColorAt:va];
    } else {
        [[self disassembledFile] setColor:color at:va];
    }
}

// (unimplemented) Get anterior line
- (NSString *)LineA:(NSNumber *)virtualAddress num:(size_t)lines
{
    return @"";
}

// Get next segment
- (NSNumber *)NextSeg:(NSNumber *)virtualAddress
{
    // XXX pwndbg is only used to get an address of the first segment.
    NSObject<HPDisassembledFile> *disas = [self disassembledFile];
    return [NSNumber numberWithLongLong:[[disas firstSegment] startAddress]];
}

// (unimplemented) Get number of breakpoints.
- (NSNumber *)GetBptQty
{
    return @0;
}

// (unimplemented) Get breakpoint address
- (NSNumber *)GetBptEA:(size_t)numberOfBreakpoint
{
    return [NSNumber numberWithLongLong:BADADDR];
}

// (unimplemented) Get previous defined item (instruction or data) in the program
- (NSNumber *)PrevHead:(NSNumber *)virtualAddress
{
    return [NSNumber numberWithLongLong:BADADDR];
}

// (unimplemented) Get next defined item (instruction or data) in the program
- (NSNumber *)NextHead:(NSNumber *)virtualAddress
{
    return [NSNumber numberWithLongLong:BADADDR];
}

// (unimplemented) Get internal flags
- (NSNumber *)GetFlags:(NSNumber *)virtualAddress
{
    return @0;
}

// (unimplemented) undocumented
- (BOOL)isASCII
{
    return NO;
}

- (NSObject<HPDisassembledFile> *)disassembledFile
{
    return [hopperDocument disassembledFile];
}

@end
