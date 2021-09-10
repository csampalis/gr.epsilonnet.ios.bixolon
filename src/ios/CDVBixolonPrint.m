//
//  CDVBixolonPrint.m
//
//  Created by Alfonso Vinti on 03/06/13.
//
//

#define __lock      [_lock lock]
#define __unlock    [_lock unlock]

#import "CDVBixolonPrint.h"


//////////////////////////////////////////////////////
// Metodi Del Plugin
//////////////////////////////////////////////////////



@implementation CDVBixolonPrint

- (instancetype)init{
    self = [super init];
    if (self) {
        self.printerCon = [UPOSPrinterController new];
        self.printerList = (UPOSPrinters*)[self.printerCon getRegisteredDevice];
    }
    _isInit = true;
    return self;
}

+(CDVBixolonPrint*)instance {
    static CDVBixolonPrint* object = nil;
    static dispatch_once_t instancePredicate;
    dispatch_once(&instancePredicate, ^{
        object = [[CDVBixolonPrint alloc] init];
    });
    return object;
}

- (void)printerList:(CDVInvokedUrlCommand *)command
{
    if(!_isInit)
        [self init];
    
    [self registerNotiLookupBT];
    [self.printerCon refreshBTLookup];
    
    
    if([self.printerList getList].count > 0) {
        NSMutableArray *list = [NSMutableArray array];
        for( UPOSPrinter *p in [self.printerList getList] )
        {
            NSString* name = p.modelName;
            if(![[name uppercaseString] hasPrefix:@"SPP"]&&![[name uppercaseString] hasPrefix:@"XMP"]) {
                name = @"SPP";
            }
            NSDictionary *jsonObj = @{@"name": name,@"address":  p.modelName};
            [list addObject:jsonObj];
        }
        NSArray *array = [NSArray arrayWithArray:list];
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:array];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
    
}

- (void) printImage:(CDVInvokedUrlCommand *)command
{
    NSDictionary *conf = [command.arguments objectAtIndex:1];
    NSString *mac =  [conf objectForKey:@"mac"];
    
    NSDictionary *args = [command.arguments objectAtIndex:0];
    NSString *path =[args objectForKey:@"path"];
    
    [self connectBT :mac];
    UIImage *image = [UIImage imageNamed:path];
    [self.printerCon
     printBitmap:PTR_S_RECEIPT
     image:image
     width:self.printerCon.RecLineWidth
     alignment:PTR_BM_CENTER];
    
    CDVPluginResult* pluginResult =[CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) printText:(CDVInvokedUrlCommand*)command
{
    NSDictionary *printConfig = [command.arguments objectAtIndex:1];
    NSString *mac =  [printConfig objectForKey:@"mac"];
    NSArray *textLines = [command.arguments objectAtIndex:0];
    id arg = [textLines objectAtIndex:0];
    NSDictionary *textLine  = arg;
    NSString *data          = [textLine objectForKey:@"text"];
    [self connectBT :mac];
    self.printerCon.characterSet = 1253;
    [self.printerCon
     printNormal:PTR_S_RECEIPT
     data:[data stringByAppendingFormat:@"\r\n"]];
    
    CDVPluginResult* pluginResult =[CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) printerDisconnect:(CDVInvokedUrlCommand*)command
{
    [self.printerCon releaseDevice];
    [self.printerCon close];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

-(void) connectBT:(NSString*)model {
    if([self.printerList getList].count > 0) {
        for( UPOSPrinter *p in [self.printerList getList] )
        {
            NSString* newModel = p.modelName;
            if([newModel isEqualToString: model]){
                [self.printerCon connect:p.modelName ];
                return;
            }
        }
    }
}

-(void) registerNotiLookupBT {
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc addObserverForName: __NOTIFICATION_NAME_BT_WILL_LOOKUP_ object:nil
                     queue: NSOperationQueue.currentQueue
                usingBlock: ^(NSNotification * _Nonnull n){
        NSLog(@"%s bt start",__FUNCTION__);
    }];
    
    [nc addObserverForName: __NOTIFICATION_NAME_BT_FOUND_PRINTER_
                    object: nil
                     queue: NSOperationQueue.currentQueue
                usingBlock: ^(NSNotification * _Nonnull n)
     {
        UPOSPrinter* lookupDevice = (UPOSPrinter*)[[n userInfo]objectForKey:__NOTIFICATION_NAME_BT_FOUND_PRINTER_];
        NSLog(@"%s modelname = %@",__FUNCTION__, lookupDevice.modelName);
        UPOSPrinter* devicePrinter = (UPOSPrinter*)lookupDevice;
        [self.printerList addDevice:devicePrinter];
    }];
}

- (NSInteger)printerOpenClose:(BOOL)open
{
    if([[self.printerList getList] count] == 0) {
        NSLog(@"Error: No Devices");
        return UPOS_E_NOHARDWARE;
    }
    
    UPOSPrinter* device  = [[self.printerList getList] objectAtIndex:0];
    if(!open)
        return [self.printerCon close];
    else
        return [self.printerCon open:device.modelName];
}

- (NSInteger)printerClaimRelease:(BOOL)claim
{
    if(!claim)
        return [self.printerCon releaseDevice];
    else
        return [self.printerCon claim:5000];
}

- (void)printerEnableDisable:(BOOL)enable
{
    if(!enable)
        self.printerCon.DeviceEnabled = NO;
    else
        self.printerCon.DeviceEnabled = YES;
}


@end
