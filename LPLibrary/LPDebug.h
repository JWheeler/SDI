//
//  LPDebug.h
//  LPLibrary
//
//  Created by Jong Pil Park on 10. 8. 24..
//  Copyright 2010 Lilac Studio. All rights reserved.
//

#ifdef DEBUG
	#define Debug(args...) _Debug(__FILE__,__LINE__,__PRETTY_FUNCTION__,args);
#else
	#define Debug(x...)
#endif

#define ShowAlert(format, ...) showAlert(__LINE__, (char *)__FUNCTION__, format, ##__VA_ARGS__)

void _Debug(const char *file, int lineNumber, const char *funcName, NSString *format,...);
