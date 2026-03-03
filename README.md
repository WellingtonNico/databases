# Setup de serviços usados

## antes de usar:

- copiar o arquivo `template.env` para o `.env` e alterar o nome de usuário;
- criar uma network docker chamada serviços `docker network create servicos`;
- caso for usar o postgres em produção, atentar para a variável de ambiente `POSTGRES_HOST_AUTH_METHOD`, alterar para `md5`;
- copie os arquivos de configuração dos serviços que for usar na pasta `configs` removendo `.sample` do final dos nomes;

## comandos postgres direto no terminal host:

para atalhar seus comandos básicos do postgres como `psql`,`pg_restore`,`createdb` entre outros...
será necessário duas coisas:

- instalar os comandos(se já não tiver instalado):
  pode fazer isso do jeito mais fácil instalando um cliente postgres e deixando adormecido
  ou pode instalar(se disponível pro seu sistema) a libpq-dev
  no macos `brew install libpq && brew link --force libpq`
- adicionar duas constantes no seu `.bashrc` ou `.zshrc`:
  ```bash
  export PGHOST="localhost"
  export PGUSER="<usuário que você colocou lá no .env>"
  ```

# Recomendação

faça um fork deste repositório para fazer seus próprios ajustes e ter disponível no seu próprio github

## ORACLE

- comando para logar no sqlplus:

```bash
sqlplus <usuario>/<senha>@localhost/<database>
```

# Criar e usar certificado SSL para export os serviços

## Criando certificado auto assinado

Este comando irá gerar os arquivos de certificado, coloque onde preferir

```bash
openssl req -x509 -newkey rsa:4096 \
  -keyout server.key \
  -out server.crt \
  -days 36500 \
  -nodes \
  -subj "/CN=<ip_onde_será_hospedado_o_banco>"
```

## Para cada serviço há um jeito diferente de usar o SSL

### Postgres

Na configuração docker do postgres precisam ser inseridos alguns argumentos na inicialização e expor a porta.

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
