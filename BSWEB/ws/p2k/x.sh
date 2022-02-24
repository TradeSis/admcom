 curl --location --request POST 'http://lebes-hml.k8s.lebes.com.br/auth/connect/token' \
   --header 'Content-Type: application/x-www-form-urlencoded' \
   --data-urlencode 'grant_type=password' \
   --data-urlencode 'username=ADMCOM' \
   --data-urlencode 'password=LL908521' \
   --data-urlencode 'scope=sicred.usuario' \
   --data-urlencode 'client_id=sicred-client' \
   --data-urlencode 'client_secret=5fb7c802-9b5a-46a8-b022-cec03327a7e9'
