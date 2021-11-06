cd /home/bsv/Documents/UniverLists
./Download.sh > Ratings.txt
egrep -i "общ.*конкурс|Количество вакантных мест|Место среди подавших согласие" Ratings.txt | sed -f Replaces1.txt > RaitingShort.tmp

cat ./RaitingShort.tmp | egrep "^ " | tr -d ' ' > InsertToXL.txt

echo "Кратко:" > MailBody.txt
cat ./RaitingShort.tmp | tr -d '\n' | tr -d '\r' | sed -f Replaces2.txt | grep -v "^ *$" | awk '$1 >= $2 {print $1,$2,"OK"}; $1 < $2 {print $1,$2,"-"}' >> MailBody.txt
echo "" >> MailBody.txt
cat Ratings.txt >> MailBody.txt

./GetSNILS.sh

echo "Дубли СНИЛС" >> MailBody.txt
echo -n "" > allSNILS.txt
cat /home/bsv/Documents/UniverLists/CheckDubles/*SNILS*.txt >> allSNILS.txt
cat allSNILS.txt | sort | uniq -c > allSNILSuniq.txt
egrep -v "18851421390|^ *1 " allSNILSuniq.txt >> MailBody.txt

#cat MailBody.txt | mail -s "Uni-ratings" baykov-sv@yandex.ru,sofy.sakur@gmail.com -aFrom:baykov-sv@yandex.ru
#cat MailBody.txt | mail -s "Uni-ratings" baykov-sv@yandex.ru -aFrom:baykov-sv@yandex.ru 
