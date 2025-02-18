#!/bin/bash

cd /brmapp/portal/7.5/TD/apps/td_gl_reports/

echo -e "Starting the GL report execution..."

nohup perl /brmapp/portal/7.5/TD/apps/td_gl_reports/td_gl_report.pl -r $1 -d $2 >> run_gl_report.log &

echo -e "GL report execution is started please check the report after some time"

