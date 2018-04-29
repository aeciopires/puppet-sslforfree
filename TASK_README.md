# puppet_sslforfree #

[Português]: #português
[Requisitos]: #requisitos
[Instruções]: #instruções-de-uso
[Tasks]: #tasks
[English]: #english
[Requirements]: #requirements
[Instructions]: #instructions
[Tasks]: #tasks
[Developers]: #developers
[License]: #license

#### Menu

1. [Português][Português]
    - [Requisitos][requisitos]
    - [Instruções de uso][Instruções]
    - [Tasks][Tasks]
2. [English][English]
    - [Requirements][requirements]
    - [Instructions][instructions]
    - [Tasks][Tasks]
3. [Developers][Developers]
4. [License][License]

# Português

Este é o modulo *puppet_sslforfree*.

Instala e gerencia o certificado assinado pelos sites:
https://www.sslforfree.com
https://zerossl.com
https://gethttpsforfree.com

Também cria o certificado no formato JKS.

## Requisitos

1. Acesse um dos sites abaixo e gere o certificado de host ou wildcard conforme
as instruções disponíveis. Ambos usam a API do Let's encrypt para assinar os
certificados válidos e gratuitos com duração de 90 dias.

https://www.sslforfree.com
https://zerossl.com
https://gethttpsforfree.com

2. Instale o Puppet-Bolt seguindo as instruções da página:
https://puppet.com/docs/bolt/latest/bolt_installing.html

3. Sistema operacional: Debian 8.x, 9.x, CentOS 6.x, 7.x, Red Hat 6.x e
7.x, Ubuntu 14.04, 16.04 e 18.04.
4. Instale os pacotes ``keytool`` nos servidores. Este pacote é obtido junto
com o Java. Este módulo não instala o Java.

Observações:

1. Para atualizar/renovar o certificado basta gerar o novo certificado e salvar
em um servidor web.
2. Este módulo não configura os serviços para usar o certificado. Isso
deve ser feito por outro módulo Puppet ou manualmente.

## Instruções de Uso

Para obter mais informações sobre o Puppet Bolt e sobre as tasks acesse:

https://puppet.com/products/puppet-bolt#get-it-now
https://puppet.com/docs/bolt/latest/bolt.html
https://puppet.com/docs/bolt/latest/running_bolt_commands.html
https://puppet.com/docs/bolt/latest/running_tasks_and_plans_with_bolt.html
https://puppet.com/docs/bolt/latest/bolt_options.html

* No host que tem o Puppet-Bolt, você precisa criar o arquivo no padrão por
exemplo: ``/home/user/hosts_puppet_bolt/HOSTS.txt``.

  Exemplo do conteudo do arquivo:

  server1.domain.com.br:22
  server2.domain.com.br:2220

* Você precisa usar uma conta que tenha permissão para executar o ``sudo`` em
cada host remoto.

* Baixe o módulo em:

**https://github.com/aeciopires/puppet_sslforfree/releases**

* Descompacte o pacote e salve em ``/home/user``, por exemplo.

## Task

* Execute o comando abaixo para visualizar a documentação das tasks

~~~ bash
bolt task show puppet_sslforfree --modulepath /home/user
~~~

Exemplo de execução da task:

~~~ bash
bolt task run --node @/home/aecio/hosts_puppet_bolt/HOSTS.txt \
 -u LOGIN \
 --no-host-key-check \
 -p PASS \
 --sudo-password PASS \
 --run_as LOGIN puppet_sslforfree \
 --modulepath ~/ \
 certs_dir=/etc/sslfree \
 keystore_file=/etc/sslfree/keystore.jks \
 cacerts_file=/etc/sslfree/cacerts.jks ca_cert=ca_bundle.crt \
 download_ca_cert=http://192.168.0.1/ca_bundle.crt \
 host_cert_key=private.key\
 download_host_cert_key=http://192.168.0.1/private.key \
 host_cert_crt=certificate.crt \
 download_host_cert_crt=http://192.168.0.1/certificate.crt \
 cert_alias=sslfree host_cert_pass=' ' \
 ca_cert_alias=ca_sslfree \
 java_cacert=/usr/lib/jvm/java-8-oracle/jre/lib/security/cacerts \
 keystore_pass_default=changeit keystore_pass=changeit \
 --verbose
~~~

# English

This is the *puppet_sslforfree* module.

Installs and manages the certificate signed by the sites:
https://www.sslforfree.com
https://zerossl.com
https://gethttpsforfree.com

It also creates the certificate in JKS format.

## Requirements

1. Access one of the sites below and generate the host or wildcard certificate.
Both use the Let's encrypt API to sign the valid and free certificates with a
duration of 90 days.

https://www.sslforfree.com
https://zerossl.com
https://gethttpsforfree.com

2. Install the Puppet-Bolt following the instructions on the page:
https://puppet.com/docs/bolt/latest/bolt_installing.html
3. Operating system: Debian 8.x, 9.x, CentOS 6.x, 7.x, Red Hat 6.x, and 7.x,
Ubuntu 14.04, 16.04 and 18.04.
4. Install the `` keytool`` packages on the servers. This package is obtained
along with Java. This module does not installs Java.

Comments:

1. To update/renew the certificate, simply generate the new certificate and save
 on a web server.
2. This module does not configure services to use the certificate. That must be
done by another Puppet module or manually.

## Instructions

For more information about Puppet Bolt and about tasks go to:

https://puppet.com/products/puppet-bolt#get-it-now
https://puppet.com/docs/bolt/latest/bolt.html
https://puppet.com/docs/bolt/latest/running_bolt_commands.html
https://puppet.com/docs/bolt/latest/running_tasks_and_plans_with_bolt.html
https://puppet.com/docs/bolt/latest/bolt_options.html

* In the host that has the Puppet-Bolt, you need to create the file in the
default example: ``/home/user/hosts_puppet_bolt/HOSTS.txt``.

  Example of file content:

  server1.domain.com.br:22
  server2.domain.com.br:2220

* You need to use an account that has permission to run sudo on each remote host.

* Download the module in:

**https://github.com/aeciopires/puppet_sslforfree/releases**

* Unpack the package and save it to ``/home/user``, for example.

## Task

* Execute the command below to view the documentation of the tasks

~~~ bash
bolt task show puppet_sslforfree --modulepath /home/user
~~~

Example of task execution:

~~~ bash
bolt task run --node @/home/aecio/hosts_puppet_bolt/HOSTS.txt \
 -u LOGIN \
 --no-host-key-check \
 -p PASS \
 --sudo-password PASS \
 --run_as LOGIN puppet_sslforfree \
 --modulepath ~/ \
 certs_dir=/etc/sslfree \
 keystore_file=/etc/sslfree/keystore.jks \
 cacerts_file=/etc/sslfree/cacerts.jks ca_cert=ca_bundle.crt \
 download_ca_cert=http://192.168.0.1/ca_bundle.crt \
 host_cert_key=private.key\
 download_host_cert_key=http://192.168.0.1/private.key \
 host_cert_crt=certificate.crt \
 download_host_cert_crt=http://192.168.0.1/certificate.crt \
 cert_alias=sslfree host_cert_pass=' ' \
 ca_cert_alias=ca_sslfree \
 java_cacert=/usr/lib/jvm/java-8-oracle/jre/lib/security/cacerts \
 keystore_pass_default=changeit keystore_pass=changeit \
 --verbose
~~~

## Developers

developer: Aecio dos Santos Pires<br>
mail: aeciopires at gmail.com<br>

## License

Apache 2.0 2018 Aécio dos Santos Pires
