#ifndef _ISSACWEB_H_
#define _ISSACWEB_H_

#include <time.h>

#ifdef __cplusplus
extern "C"
{
#endif

typedef int IW_RETURN;

typedef struct _certificate {
	void *certificate;
} CERTIFICATE;

typedef struct _privatekey {
	void *privatekey;
} PRIVATEKEY;


IW_RETURN IW_CERTIFICATE_Create(CERTIFICATE *cert);

IW_RETURN IW_CERTIFICATE_Delete(CERTIFICATE *cert);

IW_RETURN IW_CERTIFICATE_Read(CERTIFICATE *cert, const char *pszEncodedCertificate);

enum {
	IW_SUBJECT_NAME = 1,
	IW_ISSUER_NAME,
	IW_ISSUE_DATE,
	IW_EXPIRE_DATE,
	IW_CERT_SERIAL,
	IW_KEY_USAGE,   // 6
	IW_ALGORITHM,
	IW_BASIC_CONSTRAINTS,
	IW_CERT_POLICY
};
IW_RETURN IW_CERTIFICATE_GetInfo(CERTIFICATE *cert, int nInfo, char *pszBuf, int nBufLen);

IW_RETURN IW_PRIVATEKEY_Create(PRIVATEKEY *privKey);

IW_RETURN IW_PRIVATEKEY_Delete(PRIVATEKEY *privKey);

IW_RETURN IW_PRIVATEKEY_Read(PRIVATEKEY *privKey, const char *pszEncodedPrivateKey, const char *pszPin);

IW_RETURN IW_PRIVATEKEY_Write (void *buffer, int buffer_alloc_len, PRIVATEKEY *privatekey, const char *pin);

IW_RETURN IW_PRIVATEKEY_CheckPair(PRIVATEKEY *privKey, CERTIFICATE *cert);


IW_RETURN IW_CheckVID(CERTIFICATE *cert, PRIVATEKEY *privKey, const char *pszVid);

IW_RETURN IW_Encrypt(char *pszEncodedEncryptedMsg, const unsigned int nBufferSize, const unsigned char *pszSecretKey, const int nSecretKeyLen, const int nAlgorithm, const unsigned char *pszPlainMsg, const int nPlainMsgLen);

IW_RETURN IW_Decrypt( unsigned char *pszPlainMsg, unsigned int *nPlainMsgLen, const unsigned int nBufferSize, const unsigned char *pszSecretKey, const int nSecretKeyLen, const int nAlgorithm, const char *pszEncodedEncryptedMsg);

IW_RETURN IW_MakeResponse(char *pszEncodedResponse, int *nBufferSize, const void *pszEncodedChallenge, int nChallnegeLen, PRIVATEKEY *private_key, CERTIFICATE *certificate);

IW_RETURN IW_MakeSignature(char *pszEncodedSignature, int *nBufferSize, const void *pszMessage, int nMessageLen, PRIVATEKEY *private_key, CERTIFICATE *certificate, time_t sign_time);

IW_RETURN IW_VerifySignature(const char *pszEncodedSignedData);

IW_RETURN IW_HybridEncrypt(char *pszEncodedEncData, const int nBufferSize, void *pKey, const void *pPlainData, const int nPlainLen, const char *pszPubKey, int nCipher_id);
IW_RETURN IW_HybridEncryptEx(char *pszEncodedEncData, const int nBufferSize, void *pKey, int key_len, const void *pPlainData, const int nPlainLen, const char *pszPubKey, int nCipher_id);


IW_RETURN IW_CERTIFICATE_Read_From_PKCS12(CERTIFICATE *cert, PRIVATEKEY *privKey, const char *pszEncodedPfx, const char *pszPin);

IW_RETURN IW_CERTIFICATE_Write_To_PKCS12(char *pszEncodedPfx, const int nBufferSize, const char *pszPin, CERTIFICATE *cert, PRIVATEKEY *privKey);

IW_RETURN IW_CERTIFICATE_GetSubjectName(char *pszSubjectDN, const int nSubjectNameSize, CERTIFICATE *cert);
IW_RETURN IW_CERTIFICATE_GetIssuerName(char *pszIssuerName, const int nIssuerNameSize, CERTIFICATE *cert);

IW_RETURN IW_PRIVATEKEY_GetRandomNum(char *pszEncodedRandomNum, const unsigned int nBufferSize, PRIVATEKEY *privKey);

enum IW_SUPPORTED_BCIPHER_ALGORITHM
{
	ALG_SEED,
	ALG_ARIA,
	ALG_AES
};

enum IW_ERR_LIST
{
	IW_SUCCESS = 0,
	IW_ERR_INVALID_CERTIFICATE = 3000,
	IW_ERR_INVALID_PRIVATEKEY,
	IW_ERR_INVALID_INPUT,
	IW_ERR_FAIL_TO_GET_RANDNUM,
	IW_ERR_FAIL_TO_VERIFY_VID,
	IW_ERR_BASE64_DECODE_FAIL,
	IW_ERR_BASE64_ENCODE_FAIL,
	IW_ERR_CERTIFICATE_READ_FAIL,
	IW_ERR_INVALID_DATA,
	IW_ERR_WRONG_PIN,
  IW_ERR_CANNOT_MAKE_SIGNEDDATA,  // 3010
  IW_ERR_CANNOT_WRITE_FILE,
  IW_ERR_INSUFFICIENT_ALLOC_LEN,
	IW_ERR_CANNOT_ENCRYPT_PRIVATEKEY,
	IW_ERR_INVALID_ALGORITHM,
	IW_ERR_CANNOT_READ_FILE,				
	IW_ERR_ENCRYPT_FAIL,
	IW_ERR_DECRYPT_FAIL,
	IW_ERR_PRIVATEKEY_MISMATCH,
	IW_ERR_INVALID_SIGNATURE_FORMAT,
	IW_ERR_VERIFYSIGNATURE_FAILURE,  // 3020
	IW_ERR_INPUTDATA_TOOSHORT_OR_TOOLONG,
	IW_ERR_PUBKEY_DECODE_FAIL,
	IW_ERR_INVALID_PUBKEY,
	IW_ERR_PUB_FAIL_TO_ENC_MSG,
	IW_ERR_PUB_FAIL_TO_DEC_MSG,
	IW_ERR_LICENSE_EXPIRED,
	IW_ERR_LICENSE_INVALID_CERT,
	IW_ERR_LICENSE_INVALID_IP,
	IW_ERR_LICENSE_INVALID_TYPE,
	IW_ERR_LICENSE_CANNOT_LOAD_CERT, // 3030
	IW_ERR_LICENSE_CANNOT_LOAD_CACERT,
	IW_ERR_WRONG_PIN_PFX,
	IW_ERR_CANNOT_CREATE_PFX,
	IW_ERR_CANNOT_MAKE_RESPONSE,
};

#ifdef __cplusplus
}
#endif


#endif // _ISSACWEB_H_
