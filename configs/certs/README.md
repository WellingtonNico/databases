# Criar e usar certificado SSL para expor os serviços

## Criando certificado auto assinado

Este comando irá gerar os arquivos de certificado, rode o comando de dentro da pasta `./configs/certs/`, lembre de copiar o arquivo `openssl-ip.cnf` e mudar o IP.

```bash
openssl req -x509 -newkey rsa:4096 -keyout server.key -out server.crt -days 36500 -nodes -config openssl-ip.cnf
```

Após criar os arquivos deve dar permissão para o arquivo `server.key` use o comando abaixo:

```bash
sudo chown 999 ./server.key
```

# Para cada serviço há um jeito diferente de usar o SSL

## Postgres

Na configuração docker do postgres precisam ser inseridos alguns argumentos na inicialização, configurar o volume dos certificados e expor a porta.

```yaml
servicos_postgres:
  ...
  command:
    ...
    - -c
    - ssl=on
    - -c
    - ssl_cert_file=/configs/postgresql/certs/server.crt
    - -c
    - ssl_key_file=/configs/postgresql/certs/server.key
  ...
  ports:
    - 5432:5432
```

No arquivo `pg_hba.conf` precisam ser removidas todas as configurações de segurança e adicionar estas:

```bash
# permite acessar direto na máquina sem senha e pode usar na rede interna do docker
local   all   all   trust
# exige senha e ssl para acessos externos
hostssl   all   all   0.0.0.0/0   scram-sha-256
```

## RabbitMQ

No rabbitmq precisa fazer duas alterações:

- Alterar as portas expostas para as portas que suportam SSL:

```yaml
servicos_rabbitmq:
  ports:
    - 15671:15671
    - 5671:5671
```

- Descomentar a sessão de configuração de SSL no arquivo de configurações `./configs/rabbitmq/rabbitmq.conf`.

## Redis

No arquivo de configuração do redis, precisa desabilitar a porta 6379 e ativar a porta 6380 e apontar para os certificados SSL:

```bash
# Disable non-TLS
port 0

# Enable TLS port
tls-port 6380

tls-cert-file /configs/certs/server.crt
tls-key-file /configs/certs/server.key
tls-ca-cert-file /configs/certs/server.crt

# If self-signed and no mutual TLS:
tls-auth-clients no
```

No docker compose basta alterar a porta exposta:

```yaml
servicos_redis:
  ports:
    - 6380:6380
```
