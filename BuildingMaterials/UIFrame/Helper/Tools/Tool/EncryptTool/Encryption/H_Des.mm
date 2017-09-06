//----------------------------------------------------------------------------------------//
// H_Des.cpp : Math Function(Des() e.g) for inner user
// not extern for outside user
//
// Data: 2006.5.15
// Edited by Fenglei
//
//----------------------------------------------------------------------------------------//
#include <string.h>
#include <ctype.h>
#include "H_Des.h"
//#include "GenUtil.h"
#include <stdio.h>
#include <stdarg.h>
#include <time.h>
#include <unistd.h> //lina
//----------------------------------------------------------------------------------------
#define SINGLE             8
#define DOUBLE             16

//----------------------------------------------------------------------------------------
static void SetKey(const IN BYTE *key);
static void Permute(BYTE *inblock, char perm[16][16][8], BYTE *outblock);
static void Round(int num, UINT *block); // DWORD->UINT
static long F_DES(UINT r, BYTE subKey[8]); //DWORD->UINT
static void PermInit(char perm[16][16][8], const char p[64]);
static void SPInit(void);

static UINT ByteSwap(UINT x); //DWORD->UINT

BOOLE Asc2Bcd(char OUT *pcDest, char IN *pcSrc, int IN iSrcLen);
BOOLE Bcd2Asc(char OUT *pcDest, char IN *pcSrc, int IN iSrcLen);


/************************************************************************
*        Tables defined in the Data Encryption Standard documents       *
*                          MAC_DES‘≠ º∫Ø ˝◊È                            *
************************************************************************/

/////////////////////////////////////////////////////////////////////////
//
static const char ip[] =                     /* Initial permutation IP */
{
    58, 50, 42, 34, 26, 18, 10,  2,
    60, 52, 44, 36, 28, 20, 12,  4,
    62, 54, 46, 38, 30, 22, 14,  6,
    64, 56, 48, 40, 32, 24, 16,  8,
    57, 49, 41, 33, 25, 17,  9,  1,
    59, 51, 43, 35, 27, 19, 11,  3,
    61, 53, 45, 37, 29, 21, 13,  5,
    63, 55, 47, 39, 31, 23, 15,  7
}; /* ip[] */

/////////////////////////////////////////////////////////////////////////
static const char fp[] =                     /* Final permutation IP^-1 */
{
    40,  8, 48, 16, 56, 24, 64, 32,
    39,  7, 47, 15, 55, 23, 63, 31,
    38,  6, 46, 14, 54, 22, 62, 30,
    37,  5, 45, 13, 53, 21, 61, 29,
    36,  4, 44, 12, 52, 20, 60, 28,
    35,  3, 43, 11, 51, 19, 59, 27,
    34,  2, 42, 10, 50, 18, 58, 26,
    33,  1, 41,  9, 49, 17, 57, 25
}; /* fp[] */

/////////////////////////////////////////////////////////////////////////
/*
Expansion operation matrix
This is for reference only; it is unused in the code
as the F() function performs it implicitly for speed
*/
#ifdef notdef
static const char ei[] =
{
    32,  1,  2,  3,  4,  5,
    4,  5,  6,  7,  8,  9,
    8,  9, 10, 11, 12, 13,
    12, 13, 14, 15, 16, 17,
    16, 17, 18, 19, 20, 21,
    20, 21, 22, 23, 24, 25,
    24, 25, 26, 27, 28, 29,
    28, 29, 30, 31, 32,  1
};
#endif /* notdef */

/////////////////////////////////////////////////////////////////////////
static const char pc1[] =              /* Permuted choice table (key)  */
{
    57, 49, 41, 33, 25, 17,  9,
    1, 58, 50, 42, 34, 26, 18,
    10,  2, 59, 51, 43, 35, 27,
    19, 11,  3, 60, 52, 44, 36,
    
    63, 55, 47, 39, 31, 23, 15,
    7, 62, 54, 46, 38, 30, 22,
    14,  6, 61, 53, 45, 37, 29,
    21, 13,  5, 28, 20, 12,  4
};

/////////////////////////////////////////////////////////////////////////
static const char totRot[] =           /* Number left rotations of pc1  */
{
    1, 2, 4, 6, 8, 10, 12, 14, 15, 17, 19, 21, 23, 25, 27, 28
}; /* totRot[] */

/////////////////////////////////////////////////////////////////////////
static const char pc2[] =              /* Permuted choice key (table)   */
{
    14, 17, 11, 24,  1,  5,
    3, 28, 15,  6, 21, 10,
    23, 19, 12,  4, 26,  8,
    16,  7, 27, 20, 13,  2,
    41, 52, 31, 37, 47, 55,
    30, 40, 51, 45, 33, 48,
    44, 49, 39, 56, 34, 53,
    46, 42, 50, 36, 29, 32
}; /* pc2[] */

/////////////////////////////////////////////////////////////////////////
static const char si[8][64] =          /* The (in)famous S-boxes        */
{
    /* S1 */
    14,  4, 13,  1,  2, 15, 11,  8,  3, 10,  6, 12,  5,  9,  0,  7,
    0, 15,  7,  4, 14,  2, 13,  1, 10,  6, 12, 11,  9,  5,  3,  8,
    4,  1, 14,  8, 13,  6,  2, 11, 15, 12,  9,  7,  3, 10,  5,  0,
    15, 12,  8,  2,  4,  9,  1,  7,  5, 11,  3, 14, 10,  0,  6, 13,
    
    /* S2 */
    15,  1,  8, 14,  6, 11,  3,  4,  9,  7,  2, 13, 12,  0,  5, 10,
    3, 13,  4,  7, 15,  2,  8, 14, 12,  0,  1, 10,  6,  9, 11,  5,
    0, 14,  7, 11, 10,  4, 13,  1,  5,  8, 12,  6,  9,  3,  2, 15,
    13,  8, 10,  1,  3, 15,  4,  2, 11,  6,  7, 12,  0,  5, 14,  9,
    
    /* S3 */
    10,  0,  9, 14,  6,  3, 15,  5,  1, 13, 12,  7, 11,  4,  2,  8,
    13,  7,  0,  9,  3,  4,  6, 10,  2,  8,  5, 14, 12, 11, 15,  1,
    13,  6,  4,  9,  8, 15,  3,  0, 11,  1,  2, 12,  5, 10, 14,  7,
    1, 10, 13,  0,  6,  9,  8,  7,  4, 15, 14,  3, 11,  5,  2, 12,
    
    /* S4 */
    7, 13, 14,  3,  0,  6,  9, 10,  1,  2,  8,  5, 11, 12,  4, 15,
    13,  8, 11,  5,  6, 15,  0,  3,  4,  7,  2, 12,  1, 10, 14,  9,
    10,  6,  9,  0, 12, 11,  7, 13, 15,  1,  3, 14,  5,  2,  8,  4,
    3, 15,  0,  6, 10,  1, 13,  8,  9,  4,  5, 11, 12,  7,  2, 14,
    
    /* S5 */
    2, 12,  4,  1,  7, 10, 11,  6,  8,  5,  3, 15, 13,  0, 14,  9,
    14, 11,  2, 12,  4,  7, 13,  1,  5,  0, 15, 10,  3,  9,  8,  6,
    4,  2,  1, 11, 10, 13,  7,  8, 15,  9, 12,  5,  6,  3,  0, 14,
    11,  8, 12,  7,  1, 14,  2, 13,  6, 15,  0,  9, 10,  4,  5,  3,
    
    /* S6 */
    12,  1, 10, 15,  9,  2,  6,  8,  0, 13,  3,  4, 14,  7,  5, 11,
    10, 15,  4,  2,  7, 12,  9,  5,  6,  1, 13, 14,  0, 11,  3,  8,
    9, 14, 15,  5,  2,  8, 12,  3,  7,  0,  4, 10,  1, 13, 11,  6,
    4,  3,  2, 12,  9,  5, 15, 10, 11, 14,  1,  7,  6,  0,  8, 13,
    
    /* S7 */
    4, 11,  2, 14, 15,  0,  8, 13,  3, 12,  9,  7,  5, 10,  6,  1,
    13,  0, 11,  7,  4,  9,  1, 10, 14,  3,  5, 12,  2, 15,  8,  6,
    1,  4, 11, 13, 12,  3,  7, 14, 10, 15,  6,  8,  0,  5,  9,  2,
    6, 11, 13,  8,  1,  4, 10,  7,  9,  5,  0, 15, 14,  2,  3, 12,
    
    /* S8 */
    13,  2,  8,  4,  6, 15, 11,  1, 10,  9,  3, 14,  5,  0, 12,  7,
    1, 15, 13,  8, 10,  3,  7,  4, 12,  5,  6, 11,  0, 14,  9,  2,
    7, 11,  4,  1,  9, 12, 14,  2,  0,  6, 10, 13, 15,  3,  5,  8,
    2,  1, 14,  7,  4, 10,  8, 13, 15, 12,  9,  0,  3,  5,  6, 11
}; /* si[] */

/////////////////////////////////////////////////////////////////////////
/* 32-bit permutation function P used on the output of the S-boxes */
static const char p32i[] =
{
    16,  7, 20, 21,
    29, 12, 28, 17,
    1, 15, 23, 26,
    5, 18, 31, 10,
    2,  8, 24, 14,
    32, 27,  3,  9,
    19, 13, 30,  6,
    22, 11,  4, 25
}; /* p32i[] */

/************************************************************************
*                       End of DES-defined tables                       *
************************************************************************/

/////////////////////////////////////////////////////////////////////////
static int sp[8][64];              /* Combined S and P boxes          */  //lina long->int
static char iperm[16][16][8];       /* Initial and final permutations  */
static char fperm[16][16][8];
static int  desInited = 0;

/* 8 6-bit subkeys for each of 16 rounds, initialized by SetKey() */
static BYTE kn[16][8];
/* bit 0 is left-most in byte */
static const int byteBit[] =
{
    0200, 0100, 040, 020, 010, 04, 02, 01
}; /* byteBit[] */

static const int nibbleBit[] =
{
    010, 004, 002, 001
}; /* nibbleBit[] */


/////////////////////////////////////////////////////////////////////////
// DES
//
LPSTR Des(LPCSTR IN psData, LPCSTR IN psKey, BOOLE IN bEncrypt,LPSTR psOutResult,int* psOutLen) //lina LPCSTR->LPSTR
{
	int iMsgLen= 0, iKeyLen= 0, i;
	BYTE bMsg[1024+ 8], bKey[16], b3DES[(1024+ 8)* 2+ 1];
	char *psResult= NULL;
	try
	{
		// Parameter Checking
        iMsgLen= strlen(psData) > 0 ? 1 : 0;
		iKeyLen= strlen(psKey) > 0 ? 1 : 0;

		if(!iMsgLen || !iKeyLen) return NULL;
		
		// Initial
		memset(bMsg, 0, sizeof(bMsg));
		if(!Asc2Bcd((char *)bMsg, (char *)psData, iMsgLen)) return NULL;

		memset(bKey, 0, sizeof(bKey));
		if(!Asc2Bcd((char *)bKey, (char *)psKey, iKeyLen)) return NULL; 

		// Filling
		iMsgLen= iMsgLen/ 2; iKeyLen= iKeyLen/ 2;
		if(iMsgLen% 8)
		{
			bMsg[iMsgLen++]= 0x80;
			for(; iMsgLen% 8 && iMsgLen< 1024+ 8; ) bMsg[iMsgLen++]= 0x00;
		}

		// Calculate
		for(i= 0; i< iMsgLen/ 8; i++)
		{
			if(iKeyLen== 16)
			{
				if(bEncrypt) DES_C_DDES(bKey, &bMsg[i* 8], TRUE);
				else DES_C_DDES(bKey, &bMsg[i* 8], FALSE);
			}
			else if(iKeyLen== 8)
			{
				if(bEncrypt) DES_C_DES(bKey, &bMsg[i* 8], TRUE);
				else DES_C_DES(bKey, &bMsg[i* 8], FALSE);
			}
		}

		// Result
		memset(b3DES, 0, sizeof(b3DES));
		if(!Bcd2Asc((char *)b3DES, (char *)bMsg, iMsgLen)) return NULL;
		psResult= (char *)b3DES;
		int len = (int)strlen((char *)b3DES);
		if(NULL != psOutResult)
		{
			if(*psOutLen >= len)
			{
				strcpy(psOutResult,(char *)b3DES);
				*psOutLen = len;
			}
			else
			{
				*psOutLen = len;
			}
		}
		return psResult;
	}
	catch(...)
	{
		return NULL;
	}
}

/////////////////////////////////////////////////////////////////////////
// MAC
//
LPSTR Mac(LPCSTR IN psInitValue, LPCSTR IN psData, LPCSTR IN psKey, int IN imaclength, char* pResult,int* psOutLen)//lina LPCSTR->LPSTR
{
	int iInitValLen= 0, iMsgLen= 0, iKeyLen= 0, i, j;
	BYTE bXOR[8], bMsg[1024+ 8], bKey[16], bMAC[imaclength* 2+ 1];
	char *pMAC= NULL;

	try
	{
		// Parameter Checking
		iInitValLen= (int)strlen(psInitValue);
		iKeyLen= (int)strlen(psKey);
		iMsgLen= (int)strlen(psData);

		if(!iInitValLen || !iMsgLen || !iKeyLen) return NULL;

		// Initial
		memset(bXOR, 0, 8);
		if(!Asc2Bcd((char *)bXOR, (char *)psInitValue, iInitValLen)) return NULL;

		memset(bMsg, 0, 1024+ 8);
		if(!Asc2Bcd((char *)bMsg, (char *)psData, iMsgLen)) return NULL;

		memset(bKey, 0, 16);
		if(!Asc2Bcd((char *)bKey, (char *)psKey, iKeyLen)) return NULL;

		// Filling
		iMsgLen= iMsgLen/ 2; iKeyLen= iKeyLen/ 2;
		bMsg[iMsgLen++]= 0x80;
		
		if(iMsgLen% 8)
		{		
			for(; iMsgLen% 8 && iMsgLen< 1024+ 8; ) bMsg[iMsgLen++]= 0x00;
		}

		// Calculate
		for(i= 0; i< iMsgLen/ 8; i++)
		{
			for(j= 0; j< 8; j++) bXOR[j]= bXOR[j]^ bMsg[i* 8+ j];

			if(i!= iMsgLen/ 8- 1) 
				DES_C_DES(bKey, bXOR, TRUE);
			else
			{
				if(iKeyLen== 16) DES_C_DDES(bKey, bXOR, TRUE);
				if(iKeyLen== 8) DES_C_DES(bKey, bXOR, TRUE);
			}
		}

		// Result
		memset(bMAC, 0, imaclength* 2+ 1);
		if(!Bcd2Asc((char *)bMAC, (char *)bXOR, imaclength)) return NULL;
		pMAC= (char *)bMAC;
		if(NULL != pResult)
		{
			if(*psOutLen >= (int)strlen((char *)bMAC))
			{
				strcpy(pResult,(char *)bMAC);
				*psOutLen = (int)strlen((char *)bMAC);
			}
			else
				*psOutLen = (int)strlen((char *)bMAC);
		}
		return pMAC;
	}
	catch(...)
	{
		return NULL;
	}
}



/////////////////////////////////////////////////////////////////////////
// MAC2 (For 3DES Arithmetic Simulator)
//
LPCSTR MAC2(LPCSTR IN psInitValue, LPCSTR IN psData, LPCSTR IN psKey) //lina »•µÙstatic
{
	int iInitValLen= 0, iMsgLen= 0, iKeyLen= 0, i, j;
	BYTE bXOR[8], bMsg[1024+ 8], bKey[16], bMAC[4* 2+ 1];
	char *pMAC= NULL;

	try
	{
		// Parameter Checking
		iInitValLen= (int)strlen(psInitValue);
		iKeyLen= (int)strlen(psKey);
		iMsgLen= (int)strlen(psData);

		if(!iInitValLen || !iMsgLen || !iKeyLen) return NULL;

		// Initial
		memset(bXOR, 0, 8);
		if(!Asc2Bcd((char *)bXOR, (char *)psInitValue, iInitValLen)) return NULL;

		memset(bMsg, 0, 1024+ 8);
		if(!Asc2Bcd((char *)bMsg, (char *)psData, iMsgLen)) return NULL;

		memset(bKey, 0, 16);
		if(!Asc2Bcd((char *)bKey, (char *)psKey, iKeyLen)) return NULL;

		// Filling
		iMsgLen= iMsgLen/ 2; iKeyLen= iKeyLen/ 2;
		bMsg[iMsgLen++]= 0x80;
		
		if(iMsgLen% 8)
		{		
			for(; iMsgLen% 8 && iMsgLen< 1024+ 8; ) bMsg[iMsgLen++]= 0x00;
		}

		// Calculate
		for(i= 0; i< iMsgLen/ 8; i++)
		{
			for(j= 0; j< 8; j++) bXOR[j]= bXOR[j]^ bMsg[i* 8+ j];
			DES_C_DDES(bKey, bXOR, TRUE);
		}

		// Result
		memset(bMAC, 0, 4* 2+ 1);
		if(!Bcd2Asc((char *)bMAC, (char *)bXOR, 4)) return NULL;
		pMAC= (char *)bMAC;

		return pMAC;
	}
	catch(...)
	{
		return NULL;
	}
}

/////////////////////////////////////////////////////////////////////////
// MAC3 (For Normal MAC)
//
LPCSTR MAC3(LPCSTR IN psInitValue, LPCSTR IN psData, LPCSTR IN psKey) //lina »•µÙstatic
{
	int iInitValLen= 0, iMsgLen= 0, iKeyLen= 0, i, j;
	BYTE bXOR[8], bMsg[1024+ 8], bKey[16], bMAC[4* 2+ 1];
	char *pMAC= NULL;
//	DWORD dwStatus = 0;

	try
	{
		// Parameter Checking
		iInitValLen= (int)strlen(psInitValue);
		iMsgLen= (int)strlen(psData);
		iKeyLen= (int)strlen(psKey);

		if(!iInitValLen || !iMsgLen || !iKeyLen) return NULL;

		// Initial
		memset(bXOR, 0, sizeof(bXOR));
		if(!Asc2Bcd((char *)bXOR, (char *)psInitValue, iInitValLen)) return NULL;

		memset(bMsg, 0, sizeof(bMsg));
		if(!Asc2Bcd((char *)bMsg, (char *)psData, iMsgLen)) return NULL;

		memset(bKey, 0, sizeof(bKey));
		if(!Asc2Bcd((char *)bKey, (char *)psKey, iKeyLen)) return NULL;

		// Filling
		iMsgLen= iMsgLen/ 2; iKeyLen= iKeyLen/ 2;
		bMsg[iMsgLen++]= 0x80;
		
		if(iMsgLen% 8)
		{		
			for(; iMsgLen% 8 && iMsgLen< 1024+ 8; ) bMsg[iMsgLen++]= 0x00;
		}

		// Calculate
		for(i= 0; i< iMsgLen/ 8; i++)
		{
			for(j= 0; j< 8; j++) bXOR[j]= bXOR[j]^ bMsg[i* 8+ j];

			if(i!= iMsgLen/ 8- 1)
			{
				DES_C_DES(bKey, bXOR, TRUE);
			}
			else
			{
				DES_C_DDES(bKey, bXOR, TRUE);
			}
		}

		// Result
		memset(bMAC, 0, 4* 2+ 1);
		if(!Bcd2Asc((char *)bMAC, (char *)bXOR, 4)) return NULL;
		pMAC= (char *)bMAC;

		return pMAC;
	}
	catch(...)
	{
		return NULL;
	}
}

/////////////////////////////////////////////////////////////////////////
// 3desº”√‹Ω‚√‹∫Ø ˝
//
void DES_C_DDES(const BYTE IN *key, BYTE IN_OUT *data, bool IN encrypt) //lina »•µÙstatic
{
    if (encrypt)
    {
        DES_C_DES(key,          data,1);
        DES_C_DES(key + SINGLE, data,0);
        DES_C_DES(key,          data,1);
    } /* end of if */
    else
    {
        DES_C_DES(key,          data,0);
        DES_C_DES(key + SINGLE, data,1);
        DES_C_DES(key,          data,0);
    } /* end of else */
    
    return;
} // DDES()


/////////////////////////////////////////////////////////////////////////
// µ•desº”√‹Ω‚√‹∫Ø ˝
//
static void DES_C_DES(const BYTE IN *key, BYTE IN_OUT *data, int IN doEncrypt)
{
    int            i;
    UINT  work[2];    /* Working data storage */ //DWROD->UINT
    long           tmp;
    
    if (!desInited)
    {
        SPInit();
        PermInit(iperm, ip);
        PermInit(fperm, fp);
        desInited = 1;
    } /* end of if */
    
    SetKey(key);
    
    /* Initial Permutation */
    Permute(data, iperm, (BYTE *)work);
    
    work[0] = ByteSwap(work[0]);
    work[1] = ByteSwap(work[1]);
    
    if (doEncrypt)
    {
        /* Do the 16 rounds */
        for (i = 0; i < 16; i++)
            Round(i, work);
        
        /* Left/right half swap */
        tmp     = work[0];
        work[0] = work[1];
        work[1] = (int)tmp;
    } /* end of if */
    else
    {
        /* Left/right half swap */
        tmp     = work[0];
        work[0] = work[1];
        work[1] = (int)tmp;
        
        /* Do the 16 rounds in reverse order */
        for (i = 15; i >= 0; i--)
            Round(i, work);
    } /* end of else */
    
    work[0] = ByteSwap(work[0]);
    work[1] = ByteSwap(work[1]);
    
    /* Inverse initial permutation */
    Permute((BYTE *)work, fperm, data);
} /* DES() */


/************************************************************************
*  Function name   : SetKey
*  Description     : initialize key schedule array
*                  :
*  Parameters      : key
*  Returns         : -
*  Author          : Richard Shen
* ----------------------------------------------------------------------
*  Date     By       Description
* ----------------------------------------------------------------------
*  20Jan99  RCS      Created.
************************************************************************/
static void SetKey(const IN BYTE *key)
{
    char           pc1m[56];      /* Place to modify pc1 into */
    char           pcr[56];       /* Place to rotate pc1 into */
    int   i ,j , k;
    int            m;
    
    #if 0
    /*
    In mode 2, the 128 bytes of subkey are set directly from the
    user's key, allowing him to use completely independent
    subkeys for each round. Note that the user MUST specify a
    full 128 bytes.
    
    I would like to think that this technique gives the NSA a real
    headache, but I'm not THAT naive.
    */
    if (desmode == 2)
    {
        for (i = 0; i < 16; i++)
        {
            for (j = 0; j < 8; j++)
                kn[i][j] = *key++;
        } /* end of for i */
        
        return;
    } /* end of if */
    #endif
    
    /* Clear key schedule */
    for (i = 0; i < 16; i++)
    {
        for (j = 0; j < 8; j++)
            kn[i][j] = 0;
    } /* end of for i */
    
    /* Convert pc1 to bits of key */
    for (j = 0; j < 56; j++)
    {
        k = pc1[j] - 1;      /* Integer bit location */
        m = k & 07;          /* find bit             */
        
        /*
        Find which key byte l is in and which bit of that byte
        and store 1-bit result
        */
        pc1m[j] = (key[k >> 3] & byteBit[m]) ? 1 : 0;
    } /* end of for j */
    
    /* Key chunk for each iteration */
    for (i = 0; i < 16; i++)
    {
        /* rotate pc1 the right amount */
        for (j = 0; j < 56; j++)
        {
            k      = j + totRot[i];
            pcr[j] = pc1m[(k < (j < 28 ? 28 : 56)) ? k : k - 28];
        } /* end of for j */
        
        /* Rotate left and right halves independently */
        for (j=0; j<48; j++)
        {
            /* Select bits individually, check bit that goes to kn[j] */
            if (pcr[pc2[j] - 1])
            {
                /* mask it in if it's there */
                k             = j % 6;
                kn[i][j / 6] |= byteBit[k] >> 2;
            } /* end of if */
        } /* end of j */
    } /* end of for i */
    
    return;
} /* SetKey() */


/************************************************************************
*  Function name   : Permute
*  Description     :
*                  :
*  Parameters      : inBlock  -
*                  : perm     -
*                  : outBlock -
*  Returns         : -
*  Author          : Richard Shen
* ----------------------------------------------------------------------
*  Date     By       Description
* ----------------------------------------------------------------------
*  20Jan99  RCS      Created.
************************************************************************/
static void Permute(BYTE *inBlock, char perm[16][16][8],BYTE *outBlock)
{
    int            i;
    int            j;
    char           *p;
    char           *q;
    BYTE  *oBlock;
    
    if (perm == NULL)
    {
        /* No permutation, just copy */
        for (i = 8; i != 0; i--)
            *outBlock++ = *inBlock++;
        
        return;
    } /* end of if */
    
    /* Clear output block    */
    memset(outBlock, 0, 8);
    
    for (j = 0; j < 16; j += 2)
    {
        oBlock = outBlock;
        
        /* For each input nibble and each output byte, OR the masks together */
        p = perm[j][(*inBlock >> 4) & 017];
        q = perm[j + 1][*inBlock & 017];
        for (i = 8; i != 0; i--)
            *oBlock++ |= *p++ | *q++;
        
        inBlock++;
    } /* end of for j */
    
    return;
} /* Permute() */


/************************************************************************
*  Function name   : Round
*  Description     : Do one DES cipher round
*                  :
*  Parameters      : num   -
*                  : block -
*  Returns         : -
*  Author          : Richard Shen
* ----------------------------------------------------------------------
*  Date     By       Description
* ----------------------------------------------------------------------
*  20Jan99  RCS      Created.
************************************************************************/
static void Round(int num, UINT *block) //lina DWORD ->UINT
{
    /*
    The rounds are numbered from 0 to 15. On even rounds
    the right half is fed to f() and the result exclusive-ORs
    the left half; on odd rounds the reverse is done.
    */
    if (num & 1)
        block[1] ^= F_DES(block[0], kn[num]);
    else
        block[0] ^= F_DES(block[1], kn[num]);
    
    return;
} /* Round() */


/************************************************************************
*  Function name   : F_DES
*  Description     : The nonlinear function F(r, k), the heart of DES
*                  :
*  Parameters      : r        -
*                  : subKey   -
*  Returns         : ...
*  Author          : Richard Shen
* ----------------------------------------------------------------------
*  Date     By       Description
* ----------------------------------------------------------------------
*  20Jan99  RCS      Created.
************************************************************************/
static long F_DES(UINT r, BYTE subKey[8]) //DWORD->UINT
{
    UINT  rVal, rt; //DWORD->UINT
    
    /*
    Run E(R) ^ K through the combined S & P boxes
    This code takes advantage of a convenient regularity in
    E, namely that each group of 6 bits in E(R) feeding
    a single S-box is a contiguous segment of R.
    */
    rt    = (r >> 1) | ((r & 1) ? 0x80000000 : 0);
    rVal  = 0;
    rVal |= sp[0][((rt >> 26) ^ *subKey++) & 0x3f];
    rVal |= sp[1][((rt >> 22) ^ *subKey++) & 0x3f];
    rVal |= sp[2][((rt >> 18) ^ *subKey++) & 0x3f];
    rVal |= sp[3][((rt >> 14) ^ *subKey++) & 0x3f];
    rVal |= sp[4][((rt >> 10) ^ *subKey++) & 0x3f];
    rVal |= sp[5][((rt >> 6)  ^ *subKey++) & 0x3f];
    rVal |= sp[6][((rt >> 2)  ^ *subKey++) & 0x3f];
    rt    = (r << 1) | ((r & 0x80000000) ? 1 : 0);
    rVal |= sp[7][(rt ^ *subKey) & 0x3f];
    
    return rVal;
} /* F_DES() */


/************************************************************************
*  Function name   : PermInit
*  Description     : Initialize a perm array
*                  :
*  Parameters      :
*  Returns         :
*  Author          : Richard Shen
* ----------------------------------------------------------------------
*  Date     By       Description
* ----------------------------------------------------------------------
*  20Jan99  RCS      Created.
************************************************************************/
static void PermInit(char perm[16][16][8], const char p[64])
{
    int i, j, k, m, n;
    
    /* Clear the permutation array */
    for (i = 0; i < 16; i++)
    {
        for (j = 0; j < 16; j++)
        {
            for (k = 0; k < 8; k++)
                perm[i][j][k]=0;
        } /* end of for j */
    } /* end of for i */
    
    for (i = 0; i < 16; i++)         /* Each input nibble position */
    {
        for (j = 0; j < 16; j++)      /* Each possible input nibble */
        {
            for (k = 0; k < 64; k++)   /* Each output bit position   */
            {
                n = p[k] - 1;
                
                /* Does this bit come from input position ? */
                if ((n >> 2) != i)
                    continue;            /* No, bit k is 0             */
                
                if (!(j & nibbleBit[n & 3]))
                    continue;
                
                m                   = k & 07; /* Which bit is this in the byte */
                perm[i][j][k >> 3] |= byteBit[m];
            } /* end of for k */
        } /* end of for j */
    } /* end of for i */
    
    return;
} /* PermInit() */


/************************************************************************
*  Function name   : SPInit
*  Description     : Initialize the lookup table for the combined S and P
*                  : boxes
*  Parameters      : -
*  Returns         : -
*  Author          : Richard Shen
* ----------------------------------------------------------------------
*  Date     By       Description
* ----------------------------------------------------------------------
*  20Jan99  RCS      Created.
************************************************************************/
static void SPInit(void)
{
    char  pBox[32];
    int   p, i, s, j, rowCol;
    int  val; //lina long->int
    
    /* Compute pbox, the inverse of p32i. This is easier to work with. */
    for (p = 0; p < 32; p++)
    {
        for (i = 0;i < 32; i++)
        {
            if (p32i[i] - 1 == p)
            {
                pBox[p] = i;
                break;
            } /* end of if */
        } /* end of for i */
    } /* end of for p */
    
    for (s = 0; s < 8; s++)       /* For each S-box          */
    {
        for(i = 0; i < 64; i++)    /* For each possible input */
        {
            val = 0;
            /*
            The row number is formed from the first and last
            bits; the column number is from the middle 4.
            */
            rowCol = (i & 32) | ((i & 1) ? 16 : 0) | ((i >> 1) & 0xf);
            for (j = 0; j < 4; j++)    /* For each output bit */
            {
                if (si[s][rowCol] & (8 >> j))
                    val |= 1L << (31 - pBox[4 * s + j]);
            } /* end of for */
            sp[s][i] = val;
        } /* end of for */
    } /* end of for s */
    
    return;
} /* SPInit() */


/************************************************************************
*  Function name   : ByteSwap
*  Description     : Byte swap a long
*                  :
*  Parameters      : x
*  Returns         : ...
*  Author          : Richard Shen
* ----------------------------------------------------------------------
*  Date     By       Description
* ----------------------------------------------------------------------
*  20Jan99  RCS      Created.
************************************************************************/
static UINT ByteSwap(UINT x) //DWORD->UINT
{
    char  tmp;
    char  *cp;

    cp    = (char *)&x;
    tmp   = cp[3];
    cp[3] = cp[0];
    cp[0] = tmp;

    tmp   = cp[2];
    cp[2] = cp[1];
    cp[1] = tmp;

    return x;
} /* ByteSwap() */

//lina add
char *strupr(char *s) 
{ 
	char *out = s; 
	for(;*s;++s) 
	{
		if(*s>=97&&*s<=122)		
			*s=*s-32;
	}
	return out; 
}

/////////////////////////////////////////////////////////////////////////////
// ASCII To BCD
// Old Name: code_BCD
//
BOOLE Asc2Bcd(char OUT *pcDest, char IN *pcSrc, int IN iSrcLen) //lina »•µÙstatic
{
	int i= 0;
	try
	{
		for (i=0;i<iSrcLen;i++)
		{
			if(!isxdigit(pcSrc[i])) return FALSE;	// ((i+1)&0xff)|((pcSrc[i]<<8)&0xff00);
		}

		strupr(pcSrc);
		for (i=0;i<(iSrcLen/2);i++)
		{
			if(pcSrc[i*2]>'9')
				pcDest[i]=(pcSrc[i*2]-'A'+10)<<4;
			else
				pcDest[i]=(pcSrc[i*2]-'0')<<4;

			if(pcSrc[i*2+1]>'9')
				pcDest[i]|=(pcSrc[i*2+1]-'A'+10)&0xf;
			else
				pcDest[i]|=(pcSrc[i*2+1]-'0')&0xf;
		}

		if(iSrcLen%2)
		{

			if(pcSrc[i*2]>'9')
				pcDest[i]=(pcSrc[i*2]-'A'+10)<<4;
			else
				pcDest[i]=(pcSrc[i*2]-'0')<<4;
		}

		return TRUE;
	}
	catch(...)
	{
		return FALSE;
	}	
}

/////////////////////////////////////////////////////////////////////////////
// BCD To ASCII
// Old Name: decode_BCD
//
BOOLE Bcd2Asc(char OUT *pcDest, char IN *pcSrc, int IN iSrcLen) //lina »•µÙstatic
{
	int i= 0;

	try
	{
		for (i=0;i<iSrcLen;i++)
		{
			if(((pcSrc[i]>>4)&0x0f)<10) 
			   pcDest[i*2]=((pcSrc[i]>>4)&0xf)+'0';
			else 
			   pcDest[i*2]=((pcSrc[i]>>4)&0xf)-10+'A';
			if((pcSrc[i]&0xf)<10) 
			   pcDest[i*2+1]=(pcSrc[i]&0xf)+'0';
			else 
			   pcDest[i*2+1]=(pcSrc[i]&0xf)-10+'A';
		}
		
		return TRUE;
	}
	catch(...)
	{
		return FALSE;
	}
}


