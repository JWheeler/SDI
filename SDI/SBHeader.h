//
//  SBHeader.h
//  LPWebSocket
//
//  Created by Jong Pil Park on 11. 2. 9..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SBHeader : NSObject 
{
    NSString *GID;      // 서버마다 10개의 Node.js 서버가 서비스를 하고 그 중 몇 번째 Node 인지 표시.
    NSString *MGL;      // Node 마다 200 커넥션을 관리하며 해당 접속이 Node가 관리하는 커넥션 풀의 몇 번째 접속 인지 표시.
    NSString *SID;      // Socket.io가 관리하는 고유의 Session ID로 같은 Node 안에서는 커넥션마다 유니크한 값을 갖는다.
}

@property (nonatomic, retain) NSString *GID;
@property (nonatomic, retain) NSString *MGL;
@property (nonatomic, retain) NSString *SID;

@end
