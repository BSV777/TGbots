echo -n "" > all.txt
cat *SNILS*.txt >> all.txt
cat all.txt | wc -l
cat all.txt | sort | uniq -c | sort > allunic.txt
cat allunic.txt | wc -l
grep 18851421390 allunic.txt

