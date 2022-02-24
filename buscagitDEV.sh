cd /home/helio.neto/admcom/branches/dev
rm -Rf /home/helio.neto/admcom/branches/dev/*
cp -R /admcom/barramento .
cp -R /admcom/verus .
cp -R /admcom/progr .
cp -R /admcom/bs .
cp -R /admcom/linux .

mkdir -p ./BSWEB
cp -R /u/bsweb/progr/ws ./BSWEB/.
cp -R /u/bsweb/progr/erp ./BSWEB/.
cp -R /u/bsweb/progr/php ./BSWEB/.
cp -R /u/bsweb/progr/js ./BSWEB/.
cp -R /u/bsweb/progr/app ./BSWEB/.
cp -R /u/bsweb/progr/api ./BSWEB/.

cp /u/bsweb/progr/* ./BSWEB/.

cp -R /var/www/html/prophp ./BSWEB/.


rm -Rf ./barramento/works
rm -Rf ./barramento/logs

find . -name "*.r" -print -exec rm -f {} \;



