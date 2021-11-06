#!/bin/bash


function GetReportBMSTU()
{
	egrep "^ *[1-9]" /home/bsv/Documents/UniverLists/bmstu/$Num.txt | egrep -v "^ *[1-9]\." | egrep "([та] *Да.*$)|(188-514-213 90)" | tr -s " " "^" | tr "^" "\t" | sed s'/^\t*//g' | awk '{print $2,$3}' | tr -d ' ' | tr -d '-' | egrep -v "^ *$" | egrep -v [[:alpha:]] | grep "18851421390" -B 10000 > SNILS_BMSTU_$Num.txt

}

function GetReportMAI()
{
	egrep "^ *[1-9]" /home/bsv/Documents/UniverLists/mai/$Num.debug.tmp | egrep -v "^ *[1-9]\."  | tr -s "✓" "*" | awk -F "\t" '{sub("*", "Наличие преимущ. права", $12);print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$12}' | egrep -a "(\*)|(188-514-213 90)" | awk -F "  " '{print $3}' | tr -d ' ' | tr -d '-' | tr -d '.' | tr -d '–' | tr -d '*' | egrep -v "^ *$" | egrep -v [[:alpha:]] | grep "18851421390" -B 10000 > SNILS_MAI_$Num.txt
	
}

function GetReportMPEI()
{
	grep "СНИЛС" /home/bsv/Documents/UniverLists/mpei/$Num.html | egrep ">подано|18851421390" | sed -f ReplacesMPEI2.txt | awk -F "\t" '{print $9,$10}' | awk -F ":" '{print $2}' | egrep -v "^ *$" | tr -d ' ' | egrep -v [[:alpha:]] | grep "18851421390" -B 10000 > SNILS_MPEI_$Num.txt
	
}


function GetReportMISIS()
{
	egrep "^ *[1-9]" /home/bsv/Documents/UniverLists/misis/$Num.tmp1 | egrep "188-514-213 90|\+.*[[:alnum:]].*$" | awk -F "\t" '{print $3}' | tr -d '-' | tr -d ' ' | egrep -v "^ *$" | grep "18851421390" -B 10000 > SNILS_MISIS_$Num.txt
}

cd /home/bsv/Documents/UniverLists/CheckDubles

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
