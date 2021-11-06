#!/bin/bash


function GetReportBMSTU()
{
	egrep "^ *[1-9]" $Num.txt | egrep -v "^ *[1-9]\." | tr -s " " "^" | tr "^" "\t" | sed s'/^\t*//g' | awk '{print $2,$3}' | tr -d ' ' | tr -d '-' | egrep -v "^ *$" | egrep -v [[:alpha:]] | grep "18851421390" -B 10000 > SNILS_BMSTU_$Num.txt

}

function GetReportMAI()
{
	egrep "^ *[1-9]" $Num.debug.tmp | egrep -v "^ *[1-9]\."  | awk -F "\t" '{print $3}' | tr -d ' ' | tr -d '-' | tr -d '.' | tr -d '–' | egrep -v "^ *$" | egrep -v [[:alpha:]] | grep "18851421390" -B 10000 > SNILS_MAI_$Num.txt
	
}

function GetReportMPEI()
{
	grep "СНИЛС" $Num.html | sed -f ReplacesMPEI2.txt | awk -F "\t" '{print $9,$10}' | awk -F ":" '{print $2}' | egrep -v "^ *$" | tr -d ' ' | egrep -v [[:alpha:]] | grep "18851421390" -B 10000 > SNILS_MPEI_$Num.txt
	
}


function GetReportMISIS()
{
	egrep "^ *[1-9]" $Num.tmp1 | awk -F "\t" '{print $3}' | tr -d '-' | tr -d ' ' | egrep -v "^ *$" | grep "18851421390" -B 10000 > SNILS_MISIS_$Num.txt
}

clear
cd /home/bsv/Documents/UniverLists/_tests/AllStudents

Num="14.03.01"
GetReportBMSTU

Num="14.05.01"
GetReportBMSTU

Num="16.03.01"
GetReportBMSTU

Num="24.03.00"
GetReportMAI

Num="24.05.00"
GetReportMAI

Num="27.05.01"
GetReportMAI


Num="list20bacc"
GetReportMPEI

Num="list7bacc"
GetReportMPEI

Num="list19bacc"
GetReportMPEI

Num="list10bacc"
GetReportMPEI

Num="list5bacc"
GetReportMPEI


Num="13.03.02"
GetReportMISIS

Num="03.03.02"
GetReportMISIS

Num="22.03.01"
GetReportMISIS

Num="11.03.04"
GetReportMISIS

Num="28.03.00"
GetReportMISIS
