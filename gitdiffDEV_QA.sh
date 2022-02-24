cd /home/helio.neto/admcom
echo "TEM APENAS NO QA"
diff -Bbir /admcom ./branches/qa/ | grep Only | grep admcom/branches/qa
diff -Bbir /u/bsweb/progr ./branches/qa/BSWEB | grep Only | grep admcom/branches/qa
diff -Bbir /var/www/html/prophp ./branches/qa/BSWEB/prophp | grep Only | grep admcom/branches/qa


echo "--------"
echo "TEM APENAS NO DEV"
diff -Bbir /admcom ./branches/qa/ | grep Only | grep admcom
diff -Bbir /u/bsweb/progr ./branches/qa/BSWEB | grep Only | grep bsweb
diff -Bbir /var/www/html/prophp ./branches/qa/BSWEB/prophp | grep Only | grep html


echo "--------"
echo "DIFERENCAS"
diff -Bbir /admcom ./branches/qa/ | grep diff
diff -Bbir /u/bsweb/progr ./branches/qa/BSWEB | grep diff
diff -Bbir /var/www/html/prophp ./branches/qa/BSWEB/prophp | grep diff 
echo "--------"


