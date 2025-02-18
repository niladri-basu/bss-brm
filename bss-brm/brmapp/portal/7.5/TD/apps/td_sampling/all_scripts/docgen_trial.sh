#!/bin/sh
#
# Copyright (c) 2010, 2013, Oracle and/or its affiliates. All rights reserved.
#
# This material is the confidential property of Oracle Corporation or its
# licensors and may be used, reproduced, stored or transmitted only in
# accordance with a valid Oracle license or sublicense agreement.
#


DOC_GEN_HOME=/brmapp/portal/7.5/apps/pin_inv_doc_gen
export DOC_GEN_HOME
JAVA_HOME=/brmapp/portal/ThirdParty/jre/1.6.0
export JAVA_HOME
PIN_HOME=/brmapp/portal/7.5
export PIN_HOME

DG_LIB="$DOC_GEN_HOME/pin_inv_doc_gen.jar"
PCM_LIB="$PIN_HOME/jars/pcm.jar:$PIN_HOME/jars/pcmext.jar:$PIN_HOME/jars/oraclepki.jar:$PIN_HOME/jars/osdt_cert.jar:$PIN_HOME/jars/osdt_core.jar"
WL_LIB="$DOC_GEN_HOME/lib/wls/wlfullclient.jar"
WL_LIB="$WL_LIB:$DOC_GEN_HOME/lib/wls/ojdbc6.jar"
XERCES_LIB="$DOC_GEN_HOME/lib/xerces/xercesImpl.jar"

XMLP_LIB="$DOC_GEN_HOME/lib/xmlp/xdo-core.jar"
XMLP_LIB="$XMLP_LIB:$DOC_GEN_HOME/lib/xmlp/commons-logging.jar"
XMLP_LIB="$XMLP_LIB:$DOC_GEN_HOME/lib/xmlp/jaxrpc.jar"
XMLP_LIB="$XMLP_LIB:$DOC_GEN_HOME/lib/xmlp/axis_bip.jar"
XMLP_LIB="$XMLP_LIB:$DOC_GEN_HOME/lib/xmlp/orawsdl.jar"
XMLP_LIB="$XMLP_LIB:$DOC_GEN_HOME/lib/xmlp/mail.jar"
XMLP_LIB="$XMLP_LIB:$DOC_GEN_HOME/lib/xmlp/commons-discovery.jar"
XMLP_LIB="$XMLP_LIB:$DOC_GEN_HOME/lib/xmlp/xmlef.jar"
XMLP_LIB="$XMLP_LIB:$DOC_GEN_HOME/lib/xmlp/xmlparserv2.jar"
XMLP_LIB="$XMLP_LIB:$DOC_GEN_HOME/lib/xmlp/xdo-server.jar"

CLASSPATH="$WL_LIB:$XMLP_LIB:$XERCES_LIB:.:$PCM_LIB:$DG_LIB"
export CLASSPATH

# echo CLASSPATH = $CLASSPATH

echo $1
#echo "Executing " $JAVA_HOME/bin/java invoicedocgen.pin_inv_doc_gen -status pending
#$JAVA_HOME/bin/java invoicedocgen.pin_inv_doc_gen -status pending 

#$JAVA_HOME/bin/java invoicedocgen.pin_inv_doc_gen -status pending -schema 0.0.0.2
/brmapp/portal/ThirdParty/jre/1.6.0/bin/java invoicedocgen.pin_inv_doc_gen -accts_list $1

