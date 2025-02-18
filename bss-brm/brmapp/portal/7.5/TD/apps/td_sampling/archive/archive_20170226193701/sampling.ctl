LOAD DATA
  INFILE './input_files/scenario10_697.sql.dat'
  APPEND
  INTO TABLE td_sample_account_t
  FIELDS TERMINATED BY ","
  TRAILING NULLCOLS
  ( BILLINFO_OBJ_ID0,
    SCENARIO_NO,
    STATUS constant "N"
  )
