//==============================================================================
//
//      Copyright (c) 1996 - 2006 Oracle. All rights reserved.
//      
//      This material is the confidential property of Oracle Corporation or its
//      licensors and may be used, reproduced, stored or transmitted only in
//      accordance with a valid Oracle license or sublicense agreement.
//
//------------------------------------------------------------------------------
// Block: FMD
//------------------------------------------------------------------------------
// Module Description:
//   Description of a Simple Sample CDR format
//
// Open Points:
//   <open points>
//
// Review Status:
//   in-work
//
// 
// Sample CDR Format:
// ------------------
// plain ASCII, semikolon seperated format, one record per line
// Note: Last record must also contain a NL (new line).
//
// <service-code>;<a-number>;<b-number>;<start-time>;<duration>;<vol-sent>;<vol-received>;<callclass>;<cell-id>;<apn>
//
// <service-code>  : max.  5-chars, e.g. TEL, SMS or GPRS
// <a-number>      : max. 40-chars, e.g. 00491729183333
// <b-number>      : max. 40-chars, e.g. 004941067600
// <start-time>    : YYYYMMDDHHMISS, e.g. 20011114184510 for '14.11.2001 18:45:10'
// <duration>      : max. 11-digits, number of seconds, e.g. 300 for 5min.
// <vol-sent>      : max. 11-digits, number of byte, e.g. 1024 for 1k.
// <vol-received>  : max. 11-digits, number of byte, e.g. 1024 for 1k.
// <callclass>     : max.  5-chars, optional call class, e.g. for ConferenceCall indication
// <cell-id>       : max. 10-digits, optional number of the gsm cell-id, e.g. 123456
// <apn>           : max. 64-chars, optional access-point-name, e.g. url for GPRS
//
// The following <service-code>-values are predefined in the sample rate plan:
// "TEL", "GPRS", "SMS", "WAP", "DATA", "FAX"
// 
// The following <callclass>-values are predefined in the sample rate plan:
// "Conf..." = Conference Call
// "Mail..." = Mailbox Inquiry
// "MOC"     = Mobile-Originated Call (Outgoing Roaming)
// "MTC"     = Mobile-Terminated Call (Incomming Roaming)
//
// Example:
// "TEL;00491729183333;004941067600;20011114184510;300;0;0;;;"
// "TEL;00491729183333;004941067600;20011114184510;300;0;0;Mail;47113;"
// "TEL;00491729183333;004941067600;20011114184510;300;0;0;Conf;98765;"
// "TEL;00491729183333;004941067600;20011114184510;300;0;0;MOC;238476;"
// "GPRS;00491729183333;0049;20011114184510;300;78965;1024;;001121;hamburg.portal.com"
//
//------------------------------------------------------------------------------
// Responsible: bniederg
//
// $RCSfile: SIMPLESAMPLE_v1.dsc,v $
// $Revision: 1.2 $
// $Author: pengelbr $
// $Date: 2001/12/04 08:44:54 $
// $Locker:  $
//------------------------------------------------------------------------------
// $Log: SIMPLESAMPLE_v1.dsc,v $
// Revision 1.2  2001/12/04 08:44:54  pengelbr
// PETS #42170 Simplified comment on sample cdr format. All details have to
// be terminated by NL (new line) but last line is not allowed to be empty.
//
// Revision 1.1  2001/11/20 15:31:48  mf
// New  samples including the "Bernd N." stuff
//
// Revision 1.00  2001/11/14 06:54:55  bniederg
//==============================================================================

SIMPLESAMPLE_V1
{
  //----------------------------------------------------------------------------
  // Header record
  //----------------------------------------------------------------------------
  // no header defined in simple sample

  //----------------------------------------------------------------------------
  // Detail record
  //----------------------------------------------------------------------------
  DETAIL(SEPARATED)
  {
    Info
    {
      Pattern = ".*\n";                 // simple sample will only contain detail lines
      FieldSeparator = ';';
      RecordSeparator = '\n';
    }

    SERVICE                             AscString();
    A_NUMBER                            AscString();
    B_NUMBER                            AscString();
    START_TIMESTAMP                     AscDate();
    DURATION                            AscDecimal();
    VOL_SENT                            AscDecimal();
    VOL_RECEIVED                        AscDecimal();
    CALLCLASS                           AscString();
    CELL_ID                             AscString();    
    APN                                 AscString();
  }

  //----------------------------------------------------------------------------
  // Trailer Record
  //----------------------------------------------------------------------------
  // no trailer defined in simple sample

}
