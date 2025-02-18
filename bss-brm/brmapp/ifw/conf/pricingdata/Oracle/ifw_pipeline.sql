INSERT INTO IFW_PIPELINE ( PIPELINE, NAME, EDRC_DESC ) VALUES ( 
'ALL_RATE', 'Wireless Sample Pipeline', 'ALL_RATE'); 
INSERT INTO IFW_PIPELINE ( PIPELINE, NAME, EDRC_DESC ) VALUES ( 
'ALL_RERATE', 'Wireless Sample Re-Rating Pipeline', 'ALL_RATE'); 
INSERT INTO IFW_PIPELINE ( PIPELINE, NAME, EDRC_DESC ) VALUES ( 
'ALL_BCKOUT', 'Wireless Sample Back-Out Pipeline', 'ALL_RATE'); 
INSERT INTO IFW_PIPELINE ( PIPELINE, NAME, EDRC_DESC ) VALUES ( 
'RealtimePipelineGSM', 'GSM Realtime Wireless Sample Re-Rating and Discounting Pipeline', 'ALL_RATE'); 
INSERT INTO IFW_PIPELINE ( PIPELINE, NAME, EDRC_DESC ) VALUES ( 
'RealtimePipelineGPRS', 'GPRS Realtime Wireless Sample Re-Rating and Discounting Pipeline', 'ALL_RATE'); 
INSERT INTO IFW_PIPELINE ( PIPELINE, NAME, EDRC_DESC ) VALUES ( 
'PRE_PROCESS', 'Wireless Sample PRE_PROCESS Pipeline', 'ALL_RATE'); 
INSERT INTO IFW_PIPELINE ( PIPELINE, NAME, EDRC_DESC ) VALUES ( 
'PRE_RECYCLE', 'Wireless Sample PRE_RECYCLE Pipeline', 'ALL_RATE'); 
INSERT INTO IFW_PIPELINE ( PIPELINE, NAME, EDRC_DESC ) VALUES ( 
'DiscountPipeline', 'Wireless Realtime Sample DiscountPipeline0 Pipeline', 'ALL_RATE'); 
INSERT INTO IFW_PIPELINE ( PIPELINE, NAME, EDRC_DESC ) VALUES ( 
'RealtimePipelineZone', 'Zone Realtime Wireless Sample Re-Rating and Discounting Pipeline', 'ALL_RATE'); 
INSERT INTO IFW_PIPELINE ( PIPELINE, NAME, EDRC_DESC ) VALUES ( 
'PreRecyclePipeline', 'Roaming PreRecycle Pipeline', 'ALL_RATE'); 
INSERT INTO IFW_PIPELINE ( PIPELINE, NAME, EDRC_DESC ) VALUES ( 
'RAPInProcessingPipeline', 'Roaming RAPIN Pipeline', 'ALL_RATE'); 
INSERT INTO IFW_PIPELINE ( PIPELINE, NAME, EDRC_DESC ) VALUES ( 
'SplitterPipeline', 'Splitter for Home and Roam', 'ALL_RATE'); 
INSERT INTO IFW_PIPELINE ( PIPELINE, NAME, EDRC_DESC ) VALUES ( 
'TAPOutCollectPipeline', 'Outcollect pipeline for visitor roaming calls', 'ALL_RATE'); 
INSERT INTO IFW_PIPELINE ( PIPELINE, NAME, EDRC_DESC ) VALUES ( 
'TAPOutSettlementPipeline', 'Settlement pipeline for operator in outcollect', 'ALL_RATE'); 
INSERT INTO IFW_PIPELINE ( PIPELINE, NAME, EDRC_DESC ) VALUES ( 
'TAPSettlementBkOutPipeline', 'Settlement Backoutpipeline for operator in outcollect', 'ALL_RATE'); 
INSERT INTO IFW_PIPELINE ( PIPELINE, NAME, EDRC_DESC ) VALUES ( 
'TAPInProcessingPipeline', 'Validation pipeline for TAPIN', 'ALL_RATE'); 
INSERT INTO IFW_PIPELINE ( PIPELINE, NAME, EDRC_DESC ) VALUES ( 
'TAPInSettlementPipeline', 'Settlement pipeline for operator in incollect', 'ALL_RATE'); 
INSERT INTO IFW_PIPELINE ( PIPELINE, NAME, EDRC_DESC ) VALUES ( 
'TAPInRePricePipeline', 'Repricing pipeline for Home subscribers', 'ALL_RATE');
INSERT INTO IFW_PIPELINE ( PIPELINE, NAME, EDRC_DESC ) VALUES ( 
'TAPCorrectionPipeline', 'Correction of TAP file manually done here using custom script', 'ALL_RATE'); 
INSERT INTO IFW_PIPELINE ( PIPELINE, NAME, EDRC_DESC ) VALUES (
'NRTRDEInProcessingPipeline', 'NRTRDE file Processing pipeline', 'ALL_RATE');
commit;
