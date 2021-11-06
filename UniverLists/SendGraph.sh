cd /home/bsv/Documents/UniverLists

libreoffice --headless --convert-to pdf Uni_graph.xls --outdir  ./
echo "Uni_graph.pdf" | mail -s "Uni-graph" -A Uni_graph.pdf baykov-sv@yandex.ru,sofy.sakur@gmail.com -aFrom:baykov-sv@yandex.ru 
#echo "Uni_graph.pdf" | mail -s "Uni-graph" -A Uni_graph.pdf baykov-sv@yandex.ru -aFrom:baykov-sv@yandex.ru 
