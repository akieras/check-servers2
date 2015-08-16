# Check::Servers2

## Objetivo

Script utilizado para verificar a conexão com serviços de rede que devem estar acessíveis e atualizar os resultados em uma planilha do Google Sheets.

Pode ser usado para validar os acessos a serviços de rede de um cliente dentro de uma VPN, por exemplo.


## Agradecimentos

Baseado no script do `joaog [at] ciandt.com` (Joao Vitor Lacerda Guimaraes), originalmente a partir deste repositório: https://bitbucket.org/ciandt_it/check-servers. **S2**


## Planilha

1- Crie a sua planilha do Google Sheets, baseando-se [neste exemplo][1].

2- Adicione os IP's e portas na planilha:

> * Idealmente, coloque uma porta a ser testada por linha.
> * É também possível especificar um conjunto de portas separadas por vírgula: **80,81,82**.
> * Pode-se também especificar um range de portas separadas por traço: **8000-9000**.
> * E pode-se misturar as duas abordagens: **80,81,90-99,100**.

A primeira porta da lista que falhar gera o resultado de **FALHA**, e as outras portas não são testadas!


## Utilização

1- Crie o diretório `%HOME%/.check-servers2` onde ficarão os arquivos de configuracao.

2- Copie os arquivos de exemplo `sample/check-servers2/*.yml` para o diretório `%HOME%/.check-servers2`.

3- Edite os arquivos de configuração com valores desejados.

4- Obtenha os tokens de autorização para conexão com o Google Drive. Utilize o script `get-tokens-google-drive-api.rb` e siga as instruções.

5- Com os arquivos configurados e o token de autorização atualizado, execute `ruby check_servers.rb`.



[1]: https://docs.google.com/spreadsheets/d/1v-MmdCbQc-1omVC6GJBMsldtY1wL7c_E6HY57R6DadI