# Setup de serviços usados

## antes de usar:

- verificar .env e alterar o nome de usuário;
- criar uma network docker chamada serviços `docker network create servicos`;
- caso for usar o postgres em produçnao, atentar para a variável de ambiente `POSTGRES_HOST_AUTH_METHOD`, alterar para `md5`;

## comandos postgres direto no terminal host:

para atalhar seus comandos básicos do postgres como `psql`,`pg_restore`,`createdb` entre outros...
será necessário duas coisas:

- instalar os comandos(se já não tiver instalado):
  pode fazer isso do jeito mais fácil instalando um cliente postgres e deixando adormecido
  ou pode instalar(se disponível pro seu sistema) a libpq-dev
  no mack `brew install libpq && brew link --force libpq`
- adicionar duas constantes no seu `.bashrc` ou `.zshrc`:
  ```bash
  export PGHOST="localhost"
  export PGUSER="<usuário que você colocou lá no .env>"
  ```

# Recomendação

faça um fork deste repositório para fazer seus próprios ajustes e ter disponível no seu próprio github
