# puppet_sslforfree #

[Português]: #português
[Requisitos]: #requisitos
[Instruções]: #instruções-de-uso
[Hiera]: #hiera
[English]: #english
[Requirements]: #requirements
[Instructions]: #instructions
[Hiera]: #hiera
[Developers]: #developers
[License]: #license

#### Menu

1. [Português][Português]
    - [Requisitos][requisitos]
    - [Instruções de uso][Instruções]
    - [Hiera][Hiera]
    - [TASK_README.md](TASK_README.md)
2. [English][English]
    - [Requirements][requirements]
    - [Instructions][instructions]
    - [Hiera][Hiera]
    - [TASK_README.md](TASK_README.md)
3. [Developers][Developers]
4. [CHANGELOG.md](CHANGELOG.md)
5. [License][License]

# Português

Este é o modulo *puppet_sslforfree*.

Instala e gerencia o certificado gerado pelo site:
 https://www.sslforfree.com.

Também cria o certificado no formato JKS.

## Requisitos

1. Gerar o certificado no site: https://www.sslforfree.com, que usa a API
do Let's encrypt para gerar certificados válidos e gratuitos com duração
de 90 dias.

  O tutorial para gerar e renovar o certificado é:

  a) Acesse o site https://www.sslforfree.com/login e crie uma conta
gratuita.

  b) Após fazer login, clique em: ``Create one now``.

  c) No campo que começa com https://, informe o nome do domínio.
Exemplo: *.domain.com.br

  d) Acesse o serviço de DNS externo e execute as instruções citadas pelo
let's encrypt. Basicamente as instruções envolvem:

Criar uma entrada do tipo ``TXT`` para o ``host _acme-challenge.domain.com.br``,
com o TTL 1 e o valor que for informado pelo site (exemplo: Q-ienMwRBHS1bBnJPgdfasdfasdfasdfasdfasfasdfsdfasf).

Quando faltar uma semana para expirar o certificado, o site enviará um
email para o endereço informado na criação da conta. Basta repetir os
procedimentos anteriores.

2. Puppet 4.x ou superior
3. Sistema operacional: Debian 8.x, 9.x, CentOS 6.x, 7.x, Red Hat 6.x e
7.x, Ubuntu 14.04, 16.04 e 18.04.
4. Instalar os pacotes ``keytool`` obtido junto com o Java. Este módulo não
instala o Java.
5. Módulos puppet requisitos:

* https://forge.puppetlabs.com/puppetlabs/stdlib

Observações:

1. Para atualizar/renovar o certificado basta mudar os valores dos
parâmetros: ``ca_cert_alias``, ``cert_alias`` e ``cert_download_url_base``,
após gerar o novo certificado no site https://www.sslforfree.com e salvar
em um servidor web.
2. Este módulo não configura os serviços para usar o certificado. Isso
deve ser feito por outro módulo Puppet ou manualmente.

## Instruções de Uso

Para usar o módulo *puppet_sslforfree*, é necessário:

* Baixar o módulo em:

**https://github.com/aeciopires/puppet_sslforfree/releases**

* Descompactar o pacote e copiar o diretório **puppet_sslforfree** para a máquina **puppetserver**.
* Na máquina **puppetserver**, mova o diretório **puppet_sslforfree**
para o diretório de módulos, por exemplo: **/etc/puppetlabs/code/environments/NAME_ENVIRONMENT/modules/**

Onde ``NAME_ENVIRONMENT`` deve ser trocado pelo nome do environment que você quer usar no PuppetServer.

* Editar o aquivo **/etc/puppetlabs/code/environments/NAME_ENVIRONMENT/manifests/site.pp**
e definir quais hosts usarão o módulo, conforme o exemplo abaixo. Exemplo
 da configuração do arquivo site.pp

~~~ puppet
node "node1.domain.com.br" {
    include puppet_sslforfree
}
~~~

* Executar o Puppet Agent no servidor ``node1.domain.com.br``.

~~~ bash
puppet agent -t
~~~

## Hiera

O módulo *puppet_sslforfree* instala e configura o certificado com as
configurações definidas em parâmetros ou variáveis declaradas no
manifest **params.pp**.

Algumas variáveis possuem valores customizados de acordo com o servidor.
Estes valores são obtidos através do Hiera (com dados armazenados em
arquivos do tipo "*.yaml").

Abaixo está um exemplo do arquivo de configuração do Hiera, que deve
ficar localizado em: **/etc/puppetlabs/code/environments/NAME_ENVIRONMENT/hiera.yaml**

~~~ puppet
---
version: 5
defaults:
  datadir: hieradata
  data_hash: yaml_data
hierarchy:
  - name: "Hosts"
    paths:
      - "host/%{::trusted.certname}.yaml"
      - "host/%{::facts.networking.fqdn}.yaml"
      - "host/%{::facts.networking.hostname}.yaml"

  - name: "Dominios"
    paths:
      - "domain/%{::trusted.domain}.yaml"
      - "domain/%{::domain}.yaml"

  - name: "Dados comuns"
    path: "common.yaml"
~~~

Dessa forma, o Hiera buscará, prioritariamente, os valores definidos nas
variáveis de host (sobrepondo os valores de variáveis de mesmo nome
definidas por domínio). Estas variaveis devem ficar em arquivos como esse:
**/etc/puppetlabs/code/environments/NAME_ENVIRONMENT/hieradata/host/node1.domain.com.br.yaml**.

Caso não sejam definidos valores para variáveis nos arquivos de hosts,
o Hiera buscará valores definidos em variáveis de domínio. As variáveis
de domínio devem ficar em arquivos como esse:
**/etc/puppetlabs/code/environments/NAME_ENVIRONMENT/hieradata/domain/domain.com.br.yaml**.

As variáveis definidas no arquivo **/etc/puppetlabs/code/environments/NAME_ENVIRONMENT/hieradata/common.yaml**,
só serão aplicadas em último caso.

Mesmo que nenhum destes arquivos existam, serão aplicados os valores padrão definidos na classe **params.pp**.

### Exemplo do arquivo *.yaml

~~~ puppet
#---------------------
#BEGIN
#---------------------

#Espaco requerido: 2 MB ou 2.000.000 bytes
space_required: 2000000
tmp_dir: '/tmp'
manage_certificate_jks: true
download_certificate: false
cert_download_url_base: 'https://192.168.0.1/cert'
keytool: '/usr/bin/keytool'
host_cert_key: 'private.key'
host_cert_crt: 'certificate.crt'
ca_cert: 'ca_bundle.crt'
host_cert_pass: ''
cert_alias: 'sslforfree'
ca_cert_alias: 'ca_sslforfree'
java_cacert: '/usr/lib/jvm/java-8-oracle/jre/lib/security/cacerts'

#---------------------
#END
#---------------------
~~~

# English

This is the **puppet_sslforfree** module.

Installs and manages the certificate generated by the site:
https://www.sslforfree.com.

It also creates the certificate in JKS format.

## Requirements

1. Generate the certificate at https://www.sslforfree.com, which uses the API
Let's encrypt to generate valid and free certificates with duration
of 90 days.

The tutorial for generating and renewing the certificate is:

a) Access https://www.sslforfree.com/login and create an account free.

b) After login, click `` Create one now``.

c) In the field that starts with https://, enter the domain name.
Example: *.domain.com.br

d) Access the external DNS service and follow the instructions
let's encrypt. Basically the instructions involve:

Create a `` TXT`` entry for `` host _acme-challenge.domain.com.br``,
with ``TTL`` 1 and the value that is reported by the site
(example: Q-ienMwRBHS1bBnJPgdfasdfasdfasdfasdfasfasdfsdfasf).

When the certificate expires one week, the site will send a you entered
when creating your account. Just repeat the procedures.

2. Puppet 4.x or higher
3. Operating System: Debian 8.x, 9.x, CentOS 6.x, 7.x, Red Hat 6.x and
7.x, Ubuntu 14.04, 16.04 and 18.04.
4. Install the `` keytool`` packages obtained with Java. This module does not
installs Java.
5. Puppet Module Requirements:

* https://forge.puppetlabs.com/puppetlabs/stdlib

Comments:

1. To update/renew the certificate, simply change the values ​​of the
Parameters: ``ca_cert_alias``, ``cert_alias`` and ``cert_download_url_base``,
after generating the new certificate at https://www.sslforfree.com and saving
on a web server.
2. This module does not configure services to use the certificate. what
must be done by another Puppet module or manually.

## Instructions

To use the **puppet_sslforfree** module, you must:

* Download the module in:

**https://github.com/aeciopires/puppet_sslforfree/releases**

* Unzip the package and copy the **puppet_sslforfree** directory to the **puppetserver** machine.
* On the **puppetserver** machine, move the directory **puppet_sslforfree**
to the modules directory, for example: **/etc/puppetlabs/code/environments/NAME_ENVIRONMENT/modules/**

Where `` NAME_ENVIRONMENT`` should be changed by the name of the environment you want to use in PuppetServer.

* Edit the file **/etc/puppetlabs/code/environments/NAME_ENVIRONMENT/manifests/site.pp**
and define which hosts will use the module, as shown in the example below. Example
the configuration of the site.pp file

~~~ puppet
node "node1.domain.com.br" {
    include puppet_sslforfree
}
~~~

* Run the Puppet Agent on the ``node1.domain.com`` server.

~~~ bash
puppet agent -t
~~~

## Hiera

The **puppet_sslforfree** module installs and configures the certificate with the
settings defined in parameters or variables declared in the
manifest **params.pp**.

Some variables have custom values ​​according to the server.
These values ​​are obtained through Hiera (with data stored in
files of type "* .yaml").

Below is an example of the Hiera configuration file, which should
be located at: **/etc/puppetlabs/code/environments/NAME_ENVIRONMENT/hiera.yaml**

~~~ puppet
---
version: 5
defaults:
  datadir: hieradata
  data_hash: yaml_data
hierarchy:
  - name: "Hosts"
    paths:
      - "host/%{::trusted.certname}.yaml"
      - "host/%{::facts.networking.fqdn}.yaml"
      - "host/%{::facts.networking.hostname}.yaml"

  - name: "Dominios"
    paths:
      - "domain/%{::trusted.domain}.yaml"
      - "domain/%{::domain}.yaml"

  - name: "Dados comuns"
    path: "common.yaml"
~~~

In this way, Hiera will seek, as a priority, the values ​​defined in the
variables (overlapping variable values ​​of the same name defined by the domain).
These variables should be in files like this:
**/etc/puppetlabs/code/environments/NAME_ENVIRONMENT/hieradata/host/node1.domain.com.br.yaml**.

If no value is set for variables in the hosts files,
Hiera will look for values ​​defined in domain variables. The variables
domain must be in files like this:
**/etc/puppetlabs/code/environments/NAME_ENVIRONMENT/hieradata/domain/domain.com.br.yaml**.

The variables defined in the **/etc/puppetlabs/code/environments/NAME_ENVIRONMENT/hieradata/common.yaml** file,
will only be applied in the latter case.

Even if none of these files exist, the default values ​​defined in the **params.pp** class will be applied.

### Sample file * .yaml

~~~ puppet
#---------------------
#BEGIN
#---------------------

#Espaco requerido: 2 MB ou 2.000.000 bytes
space_required: 2000000
tmp_dir: '/tmp'
manage_certificate_jks: true
download_certificate: false
cert_download_url_base: 'https://192.168.0.1/cert'
keytool: '/usr/bin/keytool'
host_cert_key: 'private.key'
host_cert_crt: 'certificate.crt'
ca_cert: 'ca_bundle.crt'
host_cert_pass: ''
cert_alias: 'sslforfree'
ca_cert_alias: 'ca_sslforfree'
java_cacert: '/usr/lib/jvm/java-8-oracle/jre/lib/security/cacerts'

#---------------------
#END
#---------------------
~~~

## Developers

developer: Aecio dos Santos Pires<br>
mail: aeciopires at gmail.com<br>

## License

Apache 2.0 2018 Aécio dos Santos Pires
