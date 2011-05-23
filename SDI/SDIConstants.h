//
//  SDIConstants.h
//  SDI
//
//  Created by Jong Pil Park on 11. 3. 23..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

// APNS Provider
#define APNS_PROVIDER_URL @"10.200.2.47:8081/apns"  // 테스트.

// RQ/RP 서버.
#define RQ_RP_SERVER_URL @"10.200.2.47"    // 테스트.

// 마스터 코드 URL.
#define STOCK_CODE_MASTER_URL @"http://10.200.2.47/common/master/%@.mast"    // 테스트.

// RQ/RP 통합 서버 URL.
#define RQRP_SERVER_URL @"http://10.200.2.47/common/jsp/hdstrToJson.jsp?HDSTR_SRC=trcode/%@" // 테스트.

// RQ/RP 통합 암/복호화 서버 URL.
#define RQRP_ENCRYPT_SERVER_URL @"http://10.200.2.47/common/jsp/hdstrToJson.jsp?issacweb_data=%@" // 테스트.

// 지점 정보 서버 URL.
#define SERVER_URL_FOR_BRANCH @"http://m.youfirst.co.kr/app/branch_list.xml"    

// 마스터 코드 저장용 파일명(확장자 제외).
// 필드 구분: 종목코드, 종목명, 장구분코드(K,Q,T), 주문단위, 증거금율(A,B,C,D,E), 신용증거금율, 투자주의/경고(감리), 투자경고(위험)거래정지구분
#define JONGMOK_MASTER @"JongMok"           // 종목: 한글.
// 필드 구분: 종목코드, 종목명, 장구분코드, 주문단위
#define JONGMOK_ENG_MASTER @"JongMokEng"    // 종목: 영어.
// 필드 구분: 종목코드, 발행주식수, 상한가, 하한가
#define JONGMOK_PRS_MASTER @"JongMokPrs"    // 종목발행주수.
// 필드 구분: 업종코드, 업종명
#define UPJONG_MASTER @"UpJong"             // 업종.
// 필드 구분: 그룹코드, 그룹명
#define GROUP_MASTER @"Group"               // 그룹.
// 필드 구분: 종목코드, 종목명
#define FUTURE_MASTER @"Future"             // 선물.
// 필드 구분: 종목코드, 종목명, 종목영문명
#define SPREAD_MASTER @"Spread"             // 스프레드.
// 필드 구분: 종목코드, 한글종목명, 구분
#define OPTION_MASTER @"Option"             // 옵션.
// 필드 구분: 종목코드, 종목한글명, 기초자산코드, 기초자산명, 한글발행기관명, 만기일구분, 콜/풋구분, 만기일, 기초자산KOSPI200구분, 행사가격, LP1, LP2, LP3, 권리형태
#define ELW_MASTER @"ELW"                   // ELW.
// 필드 구분: 종목코드, 종목명
#define BOND_MASTER @"Bond"                 // 채권.
// 필드 구분: 종목코드, 종목명
#define SMALDBOND_MASTER @"SmallBond"       // 소매채권.
// 필드 구분: 종목코드, 종목명
#define SUIK_MASTER @"Suik"                 // 상장수익증권.

// RQ/RP용 TR 코드.
#define TRCD_MAIN5007 @"MAIN5007"           // 현재가: 메인, 관심종목.
#define TRCD_JS01BASE @"JS01BASE"           // 실시간지수: 코스피.
#define TRCD_SVC10313 @"SVC10313"           // 매매동향: 가로 바 차트.
#define TRCD_DL01BASE @"DL01BASE"           // 등락종목: 파이 차트(코스피).
#define TRCD_OUTDBASE @"OUTDBASE"           // 등락종목: 파이 차트(코스닥).
#define TRCD_POWR5011 @"POWR5011"           // 업종테마흐름: 세로 바 차트.

