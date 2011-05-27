//
//  DHConstants.h
//  LPWebSocket
//
//  Created by Jong Pil Park on 11. 2. 7..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

//#define SERVER_URL @"ws://202.30.200.180:9090/socket.io/websocket/"    // 테스트 외부.
#define SERVER_URL @"ws://10.200.2.47:9090/socket.io/websocket/"     // 테스트 내부.


// Node.js 프리 헤더: 데이터 전송 시 사용!
#define NODE_PRE_HEADER @"~m~%d~m~"

// SB 등록 구분.
#define SB_CMD_REGSITER @"1"            // 등록.
#define SB_CMD_CLEAR @"2"               // 해제.
#define SB_CMD_INIT_OR_FINISH @"3"      // 최초접속/접속종료.

// 매체 구분.
#define MDCLSF_iPHONE @"364"            // 아이폰.
#define MDCLSF_ANDROID @"366"           // 안드로이드.
#define MDCLSF_iPAD @"382"              // 아이패드.
#define MDCLSF_ANDROID_PAD @"383"       // 안드로이드 패드.

// TODO: 전체 리얼 TR 코드 추가할 것.
// TR 코드.
#define TRCD_MAINSTRT @"MAINSTRT"       // SB 등록/해제/최초접속/접속종료.
#define TRCD_MAINEXIT @"MAINEXIT"       // SB 접속종료.
#define TRCD_SS01REAL @"SS01REAL"       // 종목시세.
#define TRCD_ELWSREAL @"ELWSREAL"       // ELW시세.
#define TRCD_SHNNREAL @"SHNNREAL"       // 시황.
#define TRCD_RJ03REAL @"RJ03REAL"       // 지수.
#define TRCD_HG01REAL @"HG01REAL"       // 호가.
#define TRCD_OK01REAL @"OK01REAL"       // 외국인.
#define TRCD_DL01REAL @"DL01REAL"       // 등락: DL01REAL.
#define TRCD_OUTDREAL @"OUTDREAL"       // 등락: OUTDREAL.
#define TRCD_ESTSREAL @"ESTSREAL"       // 예상체결.
#define TRCD_EXCHREAL @"EXCHREAL"       // 환율.
#define TRCD_MEMBREAL @"MEMBREAL"       // 거래원.
#define TRCD_ELWSREAL @"ELWSREAL"       // ELW종홥: ELW시세.
#define TRCD_ELWVREAL @"ELWVREAL"       // ELW종홥: ELW투자지표.
#define TRCD_ELWHREAL @"ELWHREAL"       // ELW종홥: ELW호가.
#define TRCD_ELWHREAL @"ELWHREAL"       // ELW종홥: ELW호가.
#define TRCD_ELWOREAL @"ELWOREAL"       // ELW종홥: ELW외국인.
#define TRCD_ELWMREA @"ELWMREA"         // ELW종홥: ELW거래원.
#define TRCD_SS03REAL @"SS03REAL"       // 선물: 선물시세.
#define TRCD_HG03REAL @"HG03REAL"       // 선물: 선물지표
#define TRCD_FM03REAL @"FM03REAL"       // 선물: 선물미결제.
#define TRCD_FS03REAL @"FS03REAL"       // 선물: 선물시세2.
#define TRCD_SS05REAL @"SS05REAL"       // 선물스프레드.
#define TRCD_SS04REAL @"SS04REAL"       // 옵션: 옵션시세.
#define TRCD_OM04REAL @"OM04REAL"       // 옵션: 옵션미결제약정.
#define TRCD_OV04REAL @"OV04REAL"       // 옵션: 옵션변동성.
#define TRCD_JANGREAL @"JANGREAL"       // 장운영: 시세.
#define TRCD_ROIKUKSE @"ROIKUKSE"       // 외국계증권사 매매동향.
#define TRCD_IV01REAL @"IV01REAL"       // 주체별매매동향: 주식주체별매매동향.
#define TRCD_IV02REAL @"IV02REAL"       // 주체별매매동향: 선물옵션주체별매매동향.
#define TRCD_HWUIREAL @"HWUIREAL"       // 해외지수리얼.
#define TRCD_PG01REAL @"PG01REAL"       // 프로그램매매종합.
#define TRCD_PG02REAL @"PG02REAL"       // 프로그램매매종목별.

// TR 포맷 길이.
#define COMM_HEADER_LEN 22
#define DATA_HEADER_LEN 87
#define LENGTH_FIELD_LEN 5
#define SB_HEADER_LEN 10
#define SB_BODY_LEN 13

// TR Function(funccode) 필드 코드.
#define INITIATE_PACKET @"I"
#define TERMINATE_PACKET @"T"
#define STATUS_PACKET @"S"
#define HEART_BIT_PACKET @"*"
#define	PUSH_DATA @"U"			// (통신 헤더 + 데이터 패킷).
#define IS_CONCLUSION @"L"		// 체결/미체결 처리용.
#define FEP_SB_PACKET @"C"		// FEP 시세 패킷.
#define DATA_PACKET @"D"
#define TCP_SB @"R"				// TCP 시세.
#define BROADCAST_SB @"B"		// 브로트캐스트 시세.
#define IP_ADDRESS @"P"			// 공인 IP 전송.

// Status Packet의 Status Type.
#define STATUS_TYPE_S @"S"		// 세션과 관련된 상태.
#define STATUS_TYPE_E @"E"		// 에러와 관련된 상태.
#define STATUS_TYPE_I @"I"		// Identification.
#define STATUS_TYPE_R @"R"		// Reconnect.

// Status Packet의 Status Code.
// TODO: 전체 항목 추가!
#define S_STATUS_CODE_T @"T"	// 접속 시간 통보(buffer에 "hhmmsscc00" 형태).
#define E_STATUS_CODE_P @"P"	// Invalid packet or protocal 에러.
#define E_STATUS_CODE_Q @"Q"	// 접속 서버에 Queud full로 단말의 신규 요청 처리 불가.

// TR과 관련된 JSON KEY
// TODO: 테스트 개발 완료 후 최종 정리 필요함.