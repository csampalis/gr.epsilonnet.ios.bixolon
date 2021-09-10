/*
 *
 * Copyright (C) 2013 Alfonso Vinti <me@alfonsovinti.it>
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 *
 */

//
//  CDVBixolonPrint.h
//

#import <Foundation/Foundation.h>
#import <Cordova/CDV.h>


#import "UPOSPrinterController.h"
#import "UPOSMSRController.h"
#import "UPOSSCRController.h"
#import "UPOSCDController.h"

#define p1  UPOSDeviceObjects1.instance.printerCon
#define m1  UPOSDeviceObjects1.instance.msrCon
#define s1  UPOSDeviceObjects1.instance.scrCon
#define c1  UPOSDeviceObjects1.instance.cdCon
#define pL1 UPOSDeviceObjects1.instance.printerList
#define mL1 UPOSDeviceObjects1.instance.msrList
#define sL1 UPOSDeviceObjects1.instance.scrList
#define cL1 UPOSDeviceObjects1.instance.cdList

#define p2  UPOSDeviceObjects2.instance.printerCon
#define m2  UPOSDeviceObjects2.instance.msrCon
#define s2  UPOSDeviceObjects2.instance.scrCon
#define c2  UPOSDeviceObjects2.instance.cdCon

#define pL2 UPOSDeviceObjects2.instance.printerList
#define mL2 UPOSDeviceObjects2.instance.msrList
#define sL2 UPOSDeviceObjects2.instance.scrList
#define cL2 UPOSDeviceObjects2.instance.cdList


@interface CDVBixolonPrint : CDVPlugin <UPOSDeviceControlDelegate>{
    
    NSMutableArray* btList;
    NSMutableArray* wifiList;
    NSMutableArray* ethernetList;
    NSMutableArray* bleList;
    UPOSPrinterController*  printerCon;
    UPOSPrinters*           printerList;
    BOOL                    _isInit;
    
}


- (void) printerList:(CDVInvokedUrlCommand *)command;
- (void) printText:(CDVInvokedUrlCommand *)command;
- (void) printImage:(CDVInvokedUrlCommand *)command;
- (void) printerDisconnect:(CDVInvokedUrlCommand *)command;

@property UPOSPrinterController*  printerCon;
@property UPOSPrinters*           printerList;
@property UPOSMSRController*      msrCon;
@property UPOSMSRs*               msrList;
@property UPOSSCRController*      scrCon;
@property UPOSSCRs*               scrList;
@property UPOSCDController*       cdCon;
@property UPOSCashDrawers*        cdList;


@property id observerBTStart;
@property id observerBTFound;
@property id observerBTEnd;
@property id observerWifiStart;
@property id observerWifiFound;
@property id observerWifiEnd;
@property id observerEthernetStart;
@property id observerEthernetFound;
@property id observerEthernetEnd;
@property id observerBLEStart;
@property id observerBLEFound;
@property id observerBLEEnd;


+(CDVBixolonPrint*)instance;


@end


@interface UPOSDeviceObjects2 : NSObject
@property UPOSPrinterController*  printerCon;
@property UPOSPrinters*           printerList;
@property UPOSMSRController*      msrCon;
@property UPOSMSRs*               msrList;
@property UPOSSCRController*      scrCon;
@property UPOSSCRs*               scrList;
@property UPOSCDController*       cdCon;
@property UPOSCashDrawers*        cdList;
+(UPOSDeviceObjects2*)instance;
@end

