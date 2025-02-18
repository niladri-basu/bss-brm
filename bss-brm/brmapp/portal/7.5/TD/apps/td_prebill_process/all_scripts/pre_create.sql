DROP TABLE TD_PREBILL_REPORT_HIST_T;

CREATE TABLE TD_PREBILL_REPORT_HIST_T
(
  CREATED_DATE     DATE,
  ACTG_DOM            NUMBER,
  LAST_BILL_T         INTEGER,
  NEXT_BILL_T         INTEGER,
  ACCOUNT_NO          VARCHAR2(60 BYTE),
  CUST_SEG_DESC       VARCHAR2(1023 BYTE),
  BILL_INFO_ID        VARCHAR2(60 BYTE),
  NAME                VARCHAR2(255 BYTE),
  TAX_CODE            VARCHAR2(255 BYTE),
  CHARGE_FROM         INTEGER,
  CHARGE_TO           INTEGER,
  OVERRIDE_FLAG       INTEGER,
  OVERRIDE_AMT        NUMBER,
  FIX_AMOUNT          NUMBER,
  SCALED_AMOUNT       NUMBER,
  PRORATE_FIRST       INTEGER,
  CYCLE_FEE_FLAGS     INTEGER,
  MSISDN              VARCHAR2(128 BYTE),
  P_FLAGS             INTEGER,
  ANTICIPATED_AMOUNT  NUMBER
)
PARTITION BY RANGE (CREATED_DATE) (
    PARTITION P_I_20150601 VALUES LESS THAN (TO_DATE('01-JUL-2015','dd-MON-yyyy')),
    PARTITION P_I_20150701 VALUES LESS THAN (TO_DATE('01-AUG-2015','dd-MON-yyyy')),
    PARTITION P_I_20150801 VALUES LESS THAN (TO_DATE('01-SEP-2015','dd-MON-yyyy')),
    PARTITION P_I_20150901 VALUES LESS THAN (TO_DATE('01-OCT-2015','dd-MON-yyyy')),
    PARTITION P_I_20151001 VALUES LESS THAN (TO_DATE('01-NOV-2015','dd-MON-yyyy')),
    PARTITION P_I_20151101 VALUES LESS THAN (TO_DATE('01-DEC-2015','dd-MON-yyyy')),
    PARTITION P_I_20161201 VALUES LESS THAN (TO_DATE('01-JAN-2016','dd-MON-yyyy')),
    PARTITION P_I_20160101 VALUES LESS THAN (TO_DATE('01-FEB-2016','dd-MON-yyyy')),
    PARTITION P_I_20160201 VALUES LESS THAN (TO_DATE('01-MAR-2016','dd-MON-yyyy')),
    PARTITION P_I_20160301 VALUES LESS THAN (TO_DATE('01-APR-2016','dd-MON-yyyy')),
    PARTITION P_I_20160401 VALUES LESS THAN (TO_DATE('01-MAY-2016','dd-MON-yyyy')),
    PARTITION P_I_20160501 VALUES LESS THAN (TO_DATE('01-JUN-2016','dd-MON-yyyy')),
    PARTITION P_I_20160601 VALUES LESS THAN (TO_DATE('01-JUL-2016','dd-MON-yyyy')),
    PARTITION P_I_LAST VALUES LESS THAN (MAXVALUE));

CREATE OR REPLACE FUNCTION PIN.ISDST
    (i_dt IN DATE, tz IN VARCHAR2 DEFAULT NULL)
  --RETURN     VARCHAR2
  RETURN INTEGER
  AS
--======================================================================
-- Author: Gurvinder Minhas
-- Function to determine input date is DST ( NZ specific ) or not
--======================================================================
  p_year NUMBER;
  v_april    DATE;
  v_sep  DATE ;
  
  t_st_dt DATE;
  t_en_dt DATE;
  
    BEGIN

    select TO_CHAR(i_dt,'YYYY') into p_year from dual;
  
  
      v_april    := TO_DATE ('0401' || p_year, 'MMDDYYYY');
      v_sep  := TO_DATE ('0930' || p_year, 'MMDDYYYY');
    
      FOR i IN 1.. 6 LOOP

        IF TO_CHAR (v_april, 'DY') != 'SUN' THEN
         v_april := v_april + 1;
        END IF;

       IF TO_CHAR (v_sep, 'DY') != 'SUN' THEN
         v_sep := v_sep - 1;
       END IF;

     END LOOP;

    --Update Apr and Sep date to define 2AM and 3AM 
    v_april := v_april + 3/24;
    v_sep := v_sep + 2/24;
    

    t_st_dt    := TO_DATE ('0101' || p_year || '000000', 'MMDDYYYYHH24MISS');
      t_en_dt  := TO_DATE ('1231' || p_year || '235959', 'MMDDYYYYHH24MISS');
    
    if ( tz = 'GMT') THEN
      v_april := v_april - 13/24;
      v_sep := v_sep - 12/24;
    end if;
    
    if ( i_dt >= t_st_dt AND i_dt <= t_en_dt ) then
          if ( i_dt >= v_april AND i_dt <= v_sep ) then
            -- NZ ST time
            return 0;
          else  
              -- it is part of DST, i.e. between 1st Sun of Apr and last Sun of Sep
              return 1;
          end if;
    end if;
        
    --RETURN TO_CHAR (v_april, 'fmMonth dd')      || ' and ' || TO_CHAR (v_sep, 'fmMonth dd');
    return 0;

END ISDST;
/

CREATE OR REPLACE FUNCTION PIN.TD_UNIX_TO_NZ (unix_date IN NUMBER)
   RETURN DATE
IS
        /**
         * Converts Oracle DATE into a UNIX timestamp
         */
--select to_char( to_date('01011970','ddmmyyyy') + 1/24/60/60 * 1094165422, 'dd-mon-yyyy hh24:mi:ss') from dual;
   unix_epoch   DATE        := TO_DATE ('19700101000000', 'YYYYMMDDHH24MISS');
   max_ts       PLS_INTEGER := 2145916799;             -- 2938-12-31 23:59:59
   min_ts       PLS_INTEGER := -2114380800;            -- 1903-01-01 00:00:00
   max_ora_dt   DATE
                := TO_DATE ('31-DEC-2938 23:59:59', 'DD-MON-YYYY hh24:mi:ss');
   min_ora_dt   DATE
                := TO_DATE ('01-JAN-1903 00:00:00', 'DD-MON-YYYY hh24:mi:ss');
   ora_date     DATE;
   

   
   
BEGIN
   IF ora_date > max_ora_dt
   THEN
      raise_application_error (-20901,
                               'UNIX timestamp too large for 32 bit limit'
                              );
   ELSIF ora_date < min_ora_dt
   THEN
      raise_application_error (-20901,
                               'UNIX timestamp too small for 32 bit limit'
                              );
   ELSE
      ora_date := unix_epoch + 1/24/60/60 * unix_date;
   END IF;
   
   IF ISDST(ora_date,'GMT')=0
   then
   ora_date := ora_date +12/24;
   elsif ISDST(ora_date,'GMT')=1
   then
   ora_date := ora_date +13/24;
   END IF;

   RETURN (ora_date);
END;
/




CREATE OR REPLACE FUNCTION PIN.td_nz_to_unix(ora_date IN DATE) RETURN PLS_INTEGER IS
        /**
#
         * Converts Oracle DATE into a UNIX timestamp
#
         */

        unix_epoch DATE := TO_DATE('19700101000000','YYYYMMDDHH24MISS');

        max_ts PLS_INTEGER := 2145916799; -- 2938-12-31 23:59:59

        min_ts PLS_INTEGER := -2114380800; -- 1903-01-01 00:00:00

    max_ora_dt DATE := TO_DATE('31-DEC-2938 23:59:59','DD-MON-YYYY hh24:mi:ss');

    min_ora_dt DATE := TO_DATE('01-JAN-1903 00:00:00','DD-MON-YYYY hh24:mi:ss');

        unix_date PLS_INTEGER;
  mon varchar2(10000);

    BEGIN

           

            IF ora_date> max_ora_dt THEN

                RAISE_APPLICATION_ERROR(

                    -20901,

                    'UNIX timestamp too large for 32 bit limit'

                );

            ELSIF ora_date <min_ora_dt  THEN

                RAISE_APPLICATION_ERROR(

                    -20901,

                    'UNIX timestamp too small for 32 bit limit' );

            ELSE

                  unix_date := (ora_date - unix_epoch)*86400 ;
                  

            END IF;
            
            
               IF ISDST(ora_date,'NZT')=0
               then
               unix_date := unix_date - 43200;
               elsif ISDST(ora_date,'NZT')=1
               then
               unix_date := unix_date - 46800;
               END IF;
              
           

            RETURN (unix_date);
       

END;
/


