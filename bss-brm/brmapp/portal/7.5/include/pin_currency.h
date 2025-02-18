/*
 *	@(#)%Portal Version: pin_currency.h:PlatformR2Int:3:2006-Sep-12 03:34:04 %
 *
 *      Copyright (c) 1996 - 2006 Oracle. All rights reserved.
 *      
 *      This material is the confidential property of Oracle Corporation or its
 *      licensors and may be used, reproduced, stored or transmitted only in
 *      accordance with a valid Oracle license or sublicense agreement.
 */

#ifndef _PIN_CURRENCY_H_
#define _PIN_CURRENCY_H_

#ifdef __cplusplus
extern "C" {
#endif

/***********************************************************************
 * This is a SUBSET of the ISO 4217 'Currency and funds code list'
 * alphabetical by codes. This list is obtained from the fifth edition
 * of the standard 1995-12-15.
 *
 * IMPORTANT:
 * If you make changes to this file, make sure you update the macros
 * PIN_CURRENCY_VAL_MIN and PIN_CURRENCY_VAL_MAX defined at the end of 
 * this file.
 *
 ***********************************************************************/
#define PIN_CURRENCY_ADP   20	/* Andorran Peseta			*/
#define PIN_CURRENCY_AED   784	/* UAE Dirham				*/
#define PIN_CURRENCY_AFA   4	/* Afghanistan Afghani			*/
#define PIN_CURRENCY_ALL   8	/* Albanian Lek				*/
#define PIN_CURRENCY_AMD   51	/* Armenian Dram			*/
#define PIN_CURRENCY_ANG   532	/* Netherlands Antillian Guilder	*/
#define PIN_CURRENCY_AON   24	/* Angolan Kwanza			*/
#define PIN_CURRENCY_ARS   32	/* Argentine Peso			*/
#define PIN_CURRENCY_ATS   40	/* Austrian Schilling			*/
#define PIN_CURRENCY_AUD   36	/* Australian Dollar			*/
#define PIN_CURRENCY_AWG   533	/* Aruban Guilder			*/
#define PIN_CURRENCY_AZM   31	/* Azerbaijanian Manat			*/

#define PIN_CURRENCY_BBD   52	/* Barbados Dollar			*/
#define PIN_CURRENCY_BDT   50	/* Bangladeshi Taka			*/
#define PIN_CURRENCY_BEF   56	/* Belgian Franc			*/
#define PIN_CURRENCY_BGL   100	/* Bulgarian Lev			*/
#define PIN_CURRENCY_BHD   48	/* Bahraini Dinar			*/
#define PIN_CURRENCY_BIF   108	/* Burundi Franc			*/
#define PIN_CURRENCY_BMD   60	/* Bermudan Dollar			*/
#define PIN_CURRENCY_BND   96	/* Brunei Dollar			*/
#define PIN_CURRENCY_BOB   68	/* Bolivia Boliviano			*/
#define PIN_CURRENCY_BRL   986	/* Brazilian Real    			*/
#define PIN_CURRENCY_BSD   44	/* Bahamian Dollar			*/
#define PIN_CURRENCY_BTN   64	/* Bhutan Ngultrum			*/
#define PIN_CURRENCY_BWP   72	/* Botswanian Pula			*/
#define PIN_CURRENCY_BYB   112	/* Belarussian Ruble			*/
#define PIN_CURRENCY_BZD   84	/* Belize Dollar			*/

#define PIN_CURRENCY_CAD   124	/* Canadian Dollar			*/
#define PIN_CURRENCY_CHF   756	/* Swiss Franc				*/
#define PIN_CURRENCY_CLP   152	/* Chilean Peso				*/
#define PIN_CURRENCY_CNY   156	/* Yuan Renminbi			*/
#define PIN_CURRENCY_COP   170	/* Colombian Peso			*/
#define PIN_CURRENCY_CRC   188	/* Costa Rican Colon			*/
#define PIN_CURRENCY_CUP   192	/* Cuban Peso				*/
#define PIN_CURRENCY_CVE   132	/* Cape Verde Escudo			*/
#define PIN_CURRENCY_CYP   196	/* Cyprus Pound				*/
#define PIN_CURRENCY_CZK   203	/* Czech Koruna				*/

#define PIN_CURRENCY_DEM   280	/* Deutsche Mark			*/
#define PIN_CURRENCY_DJF   262	/* Djibouti Franc			*/
#define PIN_CURRENCY_DKK   208	/* Danish Krone				*/
#define PIN_CURRENCY_DOP   214	/* Dominican Peso			*/
#define PIN_CURRENCY_DZD   12	/* Algerian Dinar			*/

#define PIN_CURRENCY_ECS   218	/* Ecuador Sucre			*/
#define PIN_CURRENCY_EEK   233	/* Estonia Kroon 			*/
#define PIN_CURRENCY_EGP   818	/* Egyptian Pound			*/
#define PIN_CURRENCY_EUR   978	/* Euro   				*/
#define PIN_CURRENCY_ESP   724	/* Spanish Peseta			*/
#define PIN_CURRENCY_ETB   230	/* Ethiopian Birr			*/

#define PIN_CURRENCY_FIM   246	/* Finnish Markka			*/
#define PIN_CURRENCY_FJD   242	/* Fiji Dollar				*/
#define PIN_CURRENCY_FKP   238	/* Falkland Islands Pound		*/
#define PIN_CURRENCY_FRF   250	/* French Franc				*/

#define PIN_CURRENCY_GBP   826	/* British Pound Sterling		*/
#define PIN_CURRENCY_GHC   288	/* Ghanaian Cedi			*/
#define PIN_CURRENCY_GIP   292	/* Gibraltar Pound			*/
#define PIN_CURRENCY_GMD   270	/* Gambian Dalasi			*/
#define PIN_CURRENCY_GNF   324	/* Guinea Franc  			*/
#define PIN_CURRENCY_GRD   300	/* Greek Drachma			*/
#define PIN_CURRENCY_GTQ   320	/* Guatemalan Quetzal			*/
#define PIN_CURRENCY_GWP   624	/* Guinea-Bissau Peso			*/
#define PIN_CURRENCY_GYD   328	/* Guyana Dollar			*/

#define PIN_CURRENCY_HKD   344	/* Hong Kong Dollar			*/
#define PIN_CURRENCY_HNL   340	/* Honduran Lempira			*/
#define PIN_CURRENCY_HRK   191	/* Croatian Kuna			*/
#define PIN_CURRENCY_HTG   332	/* Haitian Gourde			*/
#define PIN_CURRENCY_HUF   348	/* Hungarian Forint			*/

#define PIN_CURRENCY_IDR   360	/* Indonesian Rupiah			*/
#define PIN_CURRENCY_IEP   372	/* Irish Pound				*/
#define PIN_CURRENCY_ILS   376	/* Israeli Shekel			*/
#define PIN_CURRENCY_INR   356	/* Indian Rupee				*/
#define PIN_CURRENCY_IQD   368	/* Iraqi Dinar				*/
#define PIN_CURRENCY_IRR   364	/* Iranian Rial				*/
#define PIN_CURRENCY_ISK   352	/* Iceland Kr—na			*/
#define PIN_CURRENCY_ITL   380	/* Italian Lira				*/

#define PIN_CURRENCY_JMD   388	/* Jamaican Dollar			*/
#define PIN_CURRENCY_JOD   400	/* Jordanian dinar			*/
#define PIN_CURRENCY_JPY   392	/* Japanese Yen				*/

#define PIN_CURRENCY_KES   404	/* Kenyan Shilling			*/
#define PIN_CURRENCY_KGS   417	/* Kyrgyzstan Som			*/
#define PIN_CURRENCY_KHR   116  /* Kampuchean (Cambodian) Riel          */
#define PIN_CURRENCY_KMF   174  /* Comoros Franc          		*/
#define PIN_CURRENCY_KPW   408  /* North Korean Won       		*/
#define PIN_CURRENCY_KRW   410  /* (South) Korean Won                   */
#define PIN_CURRENCY_KWD   414  /* Kuwaiti Dinar          		*/
#define PIN_CURRENCY_KYD   136  /* Cayman Islands Dollar  		*/
#define PIN_CURRENCY_KZT   398	/* Kazakhstan Tenge			*/

#define PIN_CURRENCY_LAK   418  /* Lao Kip                    		*/
#define PIN_CURRENCY_LBP   422  /* Lebanese Pound         		*/
#define PIN_CURRENCY_LKR   144  /* Sri Lanka Rupee        		*/
#define PIN_CURRENCY_LRD   430  /* Liberian Dollar        		*/
#define PIN_CURRENCY_LSL   426	/* Lesotho Loti				*/
#define PIN_CURRENCY_LTL   440	/* Lithuanian Litus			*/
#define PIN_CURRENCY_LUF   442  /* Luxembourg Franc       		*/
#define PIN_CURRENCY_LVL   428	/* Latvian Lats				*/
#define PIN_CURRENCY_LYD   434  /* Libyan Dinar           		*/

#define PIN_CURRENCY_MAD   504  /* Moroccan Dirham        		*/
#define PIN_CURRENCY_MDL   498	/* Moldovan Leu				*/
#define PIN_CURRENCY_MGF   450  /* Malagasy Franc         		*/
#define PIN_CURRENCY_MKD   807	/* Macedonian Denar			*/
#define PIN_CURRENCY_MMK   104	/* Myanmar Kyat				*/
#define PIN_CURRENCY_MNT   496  /* Mongolian Tugrik                 	*/
#define PIN_CURRENCY_MOP   446  /* Macau Pataca                 	*/
#define PIN_CURRENCY_MRO   478  /* Mauritanian Ouguiya                	*/
#define PIN_CURRENCY_MTL   470	/* Maltese Lira				*/
#define PIN_CURRENCY_MUR   480  /* Mauritius Rupee        		*/
#define PIN_CURRENCY_MVR   462  /* Maldive Rupee          		*/
#define PIN_CURRENCY_MWK   454  /* Malawi Kwacha                 	*/
#define PIN_CURRENCY_MXP   484  /* Mexican Peso           		*/
#define PIN_CURRENCY_MYR   458  /* Malaysian Ringgit      		*/
#define PIN_CURRENCY_MZM   508  /* Mozambique Metical                	*/

#define PIN_CURRENCY_NAD   516	/* Namibia Dollar			*/
#define PIN_CURRENCY_NGN   566  /* Nigerian Naira                  	*/
#define PIN_CURRENCY_NIC   558  /* Nicaraguan Cordoba                	*/
#define PIN_CURRENCY_NLG   528  /* Netherlands Guilder    		*/
#define PIN_CURRENCY_NOK   578  /* Norwegian Krone        		*/
#define PIN_CURRENCY_NPR   524  /* Nepalese Rupee         		*/
#define PIN_CURRENCY_NZD   554  /* New Zealand Dollar     		*/

#define PIN_CURRENCY_OMR   512  /* Omani Rial             		*/

#define PIN_CURRENCY_PAB   590  /* Panamanian Balboa                 	*/
#define PIN_CURRENCY_PEN   604	/* Peru Nuevo Sol			*/
#define PIN_CURRENCY_PGK   598  /* Papua New Guinea Kina                */
#define PIN_CURRENCY_PHP   608  /* Philippine Peso        		*/
#define PIN_CURRENCY_PKR   586  /* Pakistan Rupee         		*/
#define PIN_CURRENCY_PLN   985	/* Poland Zloty				*/
#define PIN_CURRENCY_PLZ   616  /* Polish Zloty                  	*/
#define PIN_CURRENCY_PTE   620  /* Portugese Escudo       		*/
#define PIN_CURRENCY_PYG   600  /* Paraguay Guarani                	*/

#define PIN_CURRENCY_QAR   634  /* Qatari Rial            		*/

#define PIN_CURRENCY_ROL   642  /* Romanian Leu                    	*/
#define PIN_CURRENCY_RUR   810	/* Russian Ruble			*/
#define PIN_CURRENCY_RWF   646  /* Rwanda Franc           		*/

#define PIN_CURRENCY_SAR   682  /* Saudi Riyal            		*/
#define PIN_CURRENCY_SBD   90  /* Solomon Islands Dollar 		*/
#define PIN_CURRENCY_SCR   690  /* Seychelles Rupee       		*/
#define PIN_CURRENCY_SDD   736	/* Sudanese Dinar			*/
#define PIN_CURRENCY_SDP   736  /* Sudanese Pound       -phased out	*/
#define PIN_CURRENCY_SEK   752  /* Swedish Krona          		*/
#define PIN_CURRENCY_SGD   702  /* Singapore Dollar       		*/
#define PIN_CURRENCY_SHP   654  /* St. Helena Pound       		*/
#define PIN_CURRENCY_SIT   705	/* Slovenian Tolar			*/
#define PIN_CURRENCY_SKK   703	/* Slovak Koruna			*/
#define PIN_CURRENCY_SLL   694  /* Sierra Leone Leone                  	*/
#define PIN_CURRENCY_SOS   706  /* Somali Shilling        		*/
#define PIN_CURRENCY_SRG   740  /* Suriname Guilder       		*/
#define PIN_CURRENCY_STD   678  /* Sao Tome and Principe Dobra          */
#define PIN_CURRENCY_SVC   222  /* El Salvador Colon      		*/
#define PIN_CURRENCY_SYP   760  /* Syrian Pound           		*/
#define PIN_CURRENCY_SZL   748  /* Swaziland Lilangeni              	*/

#define PIN_CURRENCY_THB   764  /* Thai Baht                   		*/
#define PIN_CURRENCY_TJR   762	/* Tajik Ruble				*/
#define PIN_CURRENCY_TMM   795	/* Turkmenistan Manat			*/
#define PIN_CURRENCY_TND   788  /* Tunisian Dinar         		*/
#define PIN_CURRENCY_TOP   776  /* Tongan Pa'anga                	*/
#define PIN_CURRENCY_TPE   626  /* Timor Escudo           		*/
#define PIN_CURRENCY_TRL   792  /* Turkish Lira           		*/
#define PIN_CURRENCY_TTD   780  /* Trinidad and Tobago Dollar 		*/
#define PIN_CURRENCY_TWD   901  /* Taiwan Dollar      			*/
#define PIN_CURRENCY_TZS   834  /* Tanzanian Shilling     		*/

#define PIN_CURRENCY_UAK   804	/* Ukraine Karbovanet			*/
#define PIN_CURRENCY_UGX   800  /* Uganda Shilling        		*/
#define PIN_CURRENCY_USD   840  /* US Dollar              		*/
#define PIN_CURRENCY_UYU   858  /* Uruguayan Peso         		*/
#define PIN_CURRENCY_UZS   860	/* Uzbekistan Sum			*/

#define PIN_CURRENCY_VEB   862  /* Venezualan Bolivar                	*/
#define PIN_CURRENCY_VND   704  /* Vietnamese Dong                   	*/
#define PIN_CURRENCY_VUV   548  /* Vanuatu Vatu                   	*/

#define PIN_CURRENCY_WST   882  /* Samoan Tala                   	*/

#define PIN_CURRENCY_YER   886  /* Yemeni Rial            		*/
#define PIN_CURRENCY_YUN   890  /* New Yugoslavian Dinar       		*/

#define PIN_CURRENCY_ZAR   710  /* South African Rand                   */
#define PIN_CURRENCY_ZMK   894  /* Zambian Kwacha                 	*/
#define PIN_CURRENCY_ZRN   180  /* Zaire Zaire                  	*/
#define PIN_CURRENCY_ZWD   716  /* Zimbabwe Dollar        		*/
#define PIN_CURRENCY_SDR   999  /*SDR currency for roaming settlement 	*/

/***********************************************************************
 * END OF CURRENCY DEFINES FROM ISO 4217.
 ***********************************************************************/


/* The default currency for rates and folds is hardcoded to 
 * 0 (PIN_CURRENCY_NONE) in  create_tables.source.  If the value of
 * of PIN_CURRENCY_NONE changes then this should be reflected in 
 * create_tables.source.
 */
#define PIN_CURRENCY_NONE		0

/* The currency field in account_t for account 1 is hardcoded to 
 * PIN_CURRENCY_DOLLARS (840).  If the value of PIN_CURRENCY_DOLLARS 
 * changes then this should be reflected in init_tables.source.
 */

#define PIN_CURRENCY_DOLLARS		PIN_CURRENCY_USD

/*
 * The following two macros define the range of currencies.
 */
#define PIN_CURRENCY_VAL_MIN 		PIN_CURRENCY_AFA

/* Resource numbers 1 - 1000 are reserved for currencies  */
#define PIN_CURRENCY_VAL_MAX		1000

#ifdef __cplusplus /* */
}
#endif /* */
#endif /*_PIN_CURRENCY_H_*/ /* */
