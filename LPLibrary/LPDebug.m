//
//  LPDebug.m
//  LPLibrary
//
//  Created by Jong Pil Park on 10. 8. 24..
//  Copyright 2010 Lilac Studio. All rights reserved.
//

#include "LPDebug.h"

// 디버그.
void _Debug(const char *file, int lineNumber, const char *funcName, NSString *format,...) {
	va_list ap;
	
	va_start (ap, format);
	if (![format hasSuffix: @"\n"]) {
		format = [format stringByAppendingString: @"\n"];
	}
	
	NSString *body = [[NSString alloc] initWithFormat: format arguments: ap];
	va_end (ap);
	const char *threadName = [[[NSThread currentThread] name] UTF8String];
	NSString *fileName = [[NSString stringWithUTF8String:file] lastPathComponent];
	if (threadName) {
		fprintf(stderr, "%s/%s (%s:%d) %s", threadName, funcName, [fileName UTF8String], lineNumber, [body UTF8String]);
	} 
	else {
		fprintf(stderr,"%p/%s (%s:%d) %s", [NSThread currentThread], funcName, [fileName UTF8String], lineNumber, [body UTF8String]);
	}
	[body release];	
}


// 얼럿.
void showAlert(int line, char *functname, id formatstring,...) {
	va_list arglist;
	if (!formatstring) return;
	va_start(arglist, formatstring);
	id outstring = [[[NSString alloc] initWithFormat:formatstring arguments:arglist] autorelease];
	va_end(arglist);
	
	NSString *filename = [[NSString stringWithCString:__FILE__ encoding:NSUTF8StringEncoding] lastPathComponent];
	NSString *debugInfo = [NSString stringWithFormat:@"%@:%d\n%s", filename, line, functname];
    
    UIAlertView *av = [[[UIAlertView alloc] initWithTitle:outstring message:debugInfo delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil] autorelease];
	[av show];
}
