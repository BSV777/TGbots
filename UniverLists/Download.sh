#!/bin/bash

function GetListBMSTU()
{
	wget -q https://priem.bmstu.ru/lists/upload/enrollees/first/moscow-1/$Num.pdf -O $Num.pdf
	
	pdftotext -layout -nopgbrk $Num.pdf $Num.txt
}

function GetListMPEI()
{
	wget -q $URL -O $Num.html
}

function GetReportBMSTU()
{
	egrep "Направление подготовки|Специальность|Время формирования" $Num.txt | sed s'/–.*мест//g'
	egrep "количество мест, оставшихся от КЦП на общий конкурс" $Num.txt

	echo -n "Подано согласий: "
	egrep "^ *[1-9]" $Num.txt | egrep -v "^ *[1-9]\." | egrep "[та] *Да.*$" | wc -l
	
	echo -n "Место среди подавших согласие: "

	egrep "^ *[1-9]" $Num.txt | egrep -v "^ *[1-9]\." | egrep "([та] *Да.*$)|(188-514-213 90)" | sed s'/188-514-213/-==СОФЬЯ==-/g' | tr -s " " "^" | tr "^" "\t" | sed s'/^\t*//g' | nl | grep "СОФЬЯ" > $Num.tmp
	
	cat $Num.tmp | awk '{print $1}'
	cat $Num.tmp

	echo -e "============================"
}

function GetReportMAI()
{
	egrep "$Num" List.txt

	echo -n "Данные актуальны на: "
	stat -c %y $Num.txt
	
	egrep "мест по общему конкурсу на данный момент" $Num.txt | sed s'/(.*)//g'

	echo -n "Подано согласий: "
	#egrep "^ *[1-9]" $Num.txt | egrep -v "^ *[1-9]\." | tr -s "✓" "*" | awk -F "\t" '{print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10}' | egrep -a "\*" | wc -l	
	egrep "^ *[1-9]" $Num.txt | egrep -v "^ *[1-9]\." | tr -s "✓" "*" | egrep "[0-9]   \*" | wc -l
	
	echo -n "Место среди подавших согласие: "

	egrep "^ *[1-9]" $Num.txt | egrep -v "^ *[1-9]\." > $Num.debug.tmp

	#egrep "^ *[1-9]" $Num.txt | egrep -v "^ *[1-9]\." | tr -s "✓" "*" | awk -F "\t" '{sub("*", "Наличие преимущ. права", $12);print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$12}' | egrep -a "(\*)|(188-514-213 90)" | sed s'/188-514-213 90/-==СОФЬЯ==-/g' > $Num.tmp
	egrep "^ *[1-9]" $Num.txt | egrep -v "^ *[1-9]\." | tr -s "✓" "*" | egrep -a "([0-9]   \*)|(188-514-213 90)" | sed s'/188-514-213 90/-==СОФЬЯ==-/g' > $Num.tmp

	cat $Num.tmp | nl | grep "СОФЬЯ" | awk '{print $1}'
	cat $Num.tmp | nl | egrep "СОФЬЯ|преимущ"

	echo -e "============================"
}

function GetReportMPEI()
{
	grep "данные о поданных согласиях" $Num.html | sed -f Replaces1.txt | grep -v "^ *$" 
		
	echo -n "Подано согласий: "
	
	grep "СНИЛС" $Num.html | egrep ">подано|18851421390" | grep -v "Балл ниже порога" | grep -v "Зачислен в другой КГ" | grep -v "rejectedForce" | sed s'/18851421390/-==СОФЬЯ==-/g' | sed -f Replaces2.txt > $Num.tmp
	
	cat $Num.tmp | wc -l
	
	
	echo -n "Место среди подавших согласие: "
	cat $Num.tmp | nl | egrep -i "СОФЬЯ" | awk '{print $1}'
	cat $Num.tmp | nl | egrep -i "СОФЬЯ|подано.*[[:alnum:]]$"
	
	echo -e "============================"
}

function GetListMISIS()
{
	wget -q $URL -O $Num.html
}

function GetReportMISIS()
{
	#egrep "$Num" List.txt

	egrep "Дата обновления" $Num.html | sed -f Replaces.txt > $Num.tmp
	grep -v name $Num.tmp > $Num.tmp1

	head -n 10 $Num.tmp1
	
	echo -n "Подано согласий: "
	egrep "^ *[1-9]"  $Num.tmp1 | egrep "\+.*[[:alnum:]].*$" | wc -l
	
	echo -n "Место среди подавших согласие: "
	
	egrep "^ *[1-9]"  $Num.tmp1 | egrep "188-514-213 90|\+.*[[:alnum:]].*$" | sed s'/188-514-213 90/-==СОФЬЯ==-/g' | nl | grep "СОФЬЯ" > $Num.tmp2

	cat $Num.tmp2 | awk '{print $1}'
	cat $Num.tmp2

	echo -e "============================"
}

#clear

echo -e "\n============================\n"

echo "      Бауманский университет"

cd /home/bsv/Documents/UniverLists/bmstu
#rm -rf ./*

echo -e "\n============================\n"
Num="14.03.01"
GetListBMSTU
echo "https://bmstu.ru/bachelor/majors/adernaa-energetika-i-teplofizika-140301"
GetReportBMSTU

Num="14.05.01"
GetListBMSTU
echo "https://bmstu.ru/bachelor/majors/adernye-reaktory-i-materialy-140501"
GetReportBMSTU

Num="16.03.01"
GetListBMSTU
echo "https://bmstu.ru/bachelor/majors/tehniceskaa-fizika-160301"
GetReportBMSTU

echo -e "\n============================\n"

echo "      МАИ"
echo "!!! Обновите списки вручную с сайта https://priem.mai.ru/rating/"

cd /home/bsv/Documents/UniverLists/mai
echo -e "\n============================\n"

Num="24.03.00"
echo "https://mai.ru/education/space/bakalavriat/#b160400"
GetReportMAI

Num="24.05.00"
echo "https://mai.ru/education/space/specialitet/#160400-s"
echo "https://yandex.ru/maps/org/mai_institut_aerokosmicheskiy/1051782110/?ll=37.500618%2C55.816428&utm_source=main_stripe_big&z=14.83"
GetReportMAI

Num="27.05.01"
echo "https://mai.ru/education/space/specialitet/#160400-s"
GetReportMAI

echo -e "\n============================\n"

echo "      МЭИ"

cd /home/bsv/Documents/UniverLists/mpei
#rm -rf ./*
echo -e "\n============================\n"

Num="list20bacc"
URL="https://www.pkmpei.ru/inform/list20bacc.html"
GetListMPEI
echo "https://www.pkmpei.ru/info/speclist.html?"
GetReportMPEI

Num="list7bacc"
URL="https://www.pkmpei.ru/inform/list7bacc.html"
GetListMPEI
echo "https://www.pkmpei.ru/info/speclist.html?"
GetReportMPEI

Num="list19bacc"
URL="https://www.pkmpei.ru/inform/list19bacc.html"
GetListMPEI
echo "https://www.pkmpei.ru/info/speclist.html?"
GetReportMPEI

Num="list10bacc"
URL="https://www.pkmpei.ru/inform/list10bacc.html"
GetListMPEI
echo "https://www.pkmpei.ru/info/speclist.html?"
GetReportMPEI

Num="list5bacc"
URL="https://www.pkmpei.ru/inform/list5bacc.html"
GetListMPEI
echo "https://www.pkmpei.ru/info/speclist.html?"
GetReportMPEI

echo -e "\n============================\n"

echo "      МИСИС"

cd /home/bsv/Documents/UniverLists/misis
#rm -rf ./*

echo -e "\n============================\n"

Num="13.03.02"
URL="https://misis.ru/applicants/admission/progress/baccalaureate-and-specialties/list-of-applicants/list/?id=BAC-BUDJ-O-130302"
GetListMISIS
echo "https://misis.ru/applicants/admission/baccalaureate-and-specialty/faculties/electroenergetika/"
GetReportMISIS

Num="03.03.02"
URL="https://misis.ru/applicants/admission/progress/baccalaureate-and-specialties/list-of-applicants/list/?id=BAC-BUDJ-O-030302"
GetListMISIS
echo "https://misis.ru/applicants/admission/baccalaureate-and-specialty/faculties/physics/"
GetReportMISIS

Num="22.03.01"
URL="https://misis.ru/applicants/admission/progress/baccalaureate-and-specialties/list-of-applicants/list/?id=BAC-BUDJ-O-220301"
GetListMISIS
echo "https://misis.ru/applicants/admission/baccalaureate-and-specialty/faculties/materialoved/"
GetReportMISIS

Num="11.03.04"
URL="https://misis.ru/applicants/admission/progress/baccalaureate-and-specialties/list-of-applicants/list/?id=BAC-BUDJ-O-110304"
GetListMISIS
echo "https://misis.ru/applicants/admission/baccalaureate-and-specialty/faculties/electro/"
GetReportMISIS

Num="28.03.00"
URL="https://misis.ru/applicants/admission/progress/baccalaureate-and-specialties/list-of-applicants/list/?id=BAC-BUDJ-O-280300"
GetListMISIS
echo "https://misis.ru/applicants/admission/baccalaureate-and-specialty/faculties/nanotech/"
GetReportMISIS
