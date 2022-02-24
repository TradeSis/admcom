cd /home/helio.neto/admcom/branches/qa
rm -Rf /home/helio.neto/admcom/branches/qa/*
echo 2Et*MNY1oJul
scp -rC 10.2.0.44:/admcom/verus .
scp -rC 10.2.0.44:/admcom/barramento .
scp -rC 10.2.0.44:/admcom/progr .
scp -rC 10.2.0.44:/admcom/bs .
scp -rC 10.2.0.44:/admcom/linux .
scp -rC 10.2.0.44:/admcom/scripts .


mkdir -p ./BSWEB
scp -rC 10.2.0.44:/u/bsweb/progr/ws ./BSWEB/.
scp -rC 10.2.0.44:/u/bsweb/progr/erp ./BSWEB/.
scp -rC 10.2.0.44:/u/bsweb/progr/php ./BSWEB/.
scp -rC 10.2.0.44:/u/bsweb/progr/js ./BSWEB/.
scp -rC 10.2.0.44:/u/bsweb/progr/app ./BSWEB/.
scp -rC 10.2.0.44:/u/bsweb/progr/api ./BSWEB/

scp -C 10.2.0.44:/u/bsweb/progr/* ./BSWEB/.

scp -rC 10.2.0.44:/var/www/html/prophp ./BSWEB/.


rm -Rf ./barramento/works
rm -Rf ./barramento/logs

find . -name "*.r" -print -exec rm -f {} \;



