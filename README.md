# Fred's Arch Linux Installer

Script interativo, em português do Brasil, que possibilita instalar o Arch Linux de forma pratica e rápida, sem a necessidade de ficar digitando comandos e configurando tudo manualmente. :)

1. [Antes de começar](#Antes-de-começar)
2. [Instalação](#Instalação)
3. [Execução](#Execução)
4. [O que será instalado](#O-que-será-instalado)
5. [Features](#Features)
6. [Features em implementação](#Features-em-implementação)
7. [Licença](#Licença)
8. [Agradecimentos](#Agradecimentos)


## Antes de começar

### Sistema x64

O Arch Linux **só** funcionará em dispositivos compatíveis com **x86_64**. 

### ISO do Arch Linux

Faça o download da ISO do sistema diretamente do [site oficial do Arch Linux](https://www.archlinux.org/download/).

É recomendado verificar a assinatura da imagem baixada para checar a autenticidade e integridade da ISO.

### Mídia bootavel

Para instalar o sistema em um dispositivo que não seja uma maquina virtual, será necessário criar um dispositivo de mídia bootavel. Recomenda-se o uso de um pendrive com no minimo 2gb de capacidade.

Instruções detalhadas de como criar a mídia bootavel podem ser obtidas na [Wiki do Arch Linux](https://wiki.archlinux.org/index.php/USB_flash_installation_media_(Portugu%C3%AAs)).

### Conexão com a internet

A instalação do sistema necessita de uma conexão com a internet para baixar os pacotes que serão instalados.

É recomendado o uso de uma conexão cabeada devido a estabilidade e não necessitar, na maioria dos casos, de nenhuma configuração extra.

#### Ethernet (cabo)

A imagem de instalação do Arch Linux já deixa habilitado o dhcpcd na inicialização. Sendo assim, ligando o cabo de rede estiver ao dispositivo já deve ser o suficiente para que ele conecte.
Para  verificar a conexão digite:

`ping -c3 google.com`

#### Wireless

Para se conectar na rede wifi, use a ferramenta wifi-menu, digitando no terminal:

`wifi-menu`

Ele vai escanear as redes disponíveis e em seguida mostrará uma janela listando as redes detectadas. Basta selecionar a rede que deseja conectar e informar a senha, caso tenha.

Verifique se esta conectado digitando:

`ping -c3 google.com`

Dependendo do driver de rede do dispositivo, pode ser que essa solução não funcione. Caso seja essa a situação, verificar a [pagina de configuração de rede da Wiki do Arch Linux](https://wiki.archlinux.org/index.php/Network_configuration_(Portugu%C3%AAs)/Wireless_(Portugu%C3%AAs)).

### Particionamento

O **FALI** identifica  e exibe para o usuário na tela inicial, em que modo de inicialização a imagem do Arch Linux foi inicializado. Essa informação é importante para que o usuário crie as partições necessárias para que o sistema seja instalado de forma adequada.

A instalação do sistema exige uma partição para o ponto de montagem **/** (root) e caso o modo de inicialização seja **UEFI**, uma partição para o mesmo.

Exemplo básico de layout para o particionamento do disco:

#### BIOS com MBR

| Ponto de montagem | Partição  | Tipo de partição | Tamanho sugerido        |
| ----------------- | --------- | ---------------- | ----------------------- |
| / (root)          | /dev/sdX1 | Linux            | Restante do dispositivo |
| Swap              | /dev/sdX2 | Linux Swap       | > 512 MB                |

#### UEFI com GPT

| Ponto de montagem | Partição  | Tipo de partição        | Tamanho sugerido        |
| ----------------- | --------- | ----------------------- | ----------------------- |
| efi               | /dev/sdX1 | Partição de sistema EFI | 260–512 MB              |
| / (root)          | /dev/sdX2 | Linux x86-64 root (/)   | Restante do dispositivo |
| Swap              | /dev/sdX3 | Linux swap              | > 512 MB                |

**Obs**: Atualmente o script permite criar partições para os pontos de montagem **/** (root), **boot**, **swap** e **home**. Em breve outras opções serão disponibilizadas.


## Instalação

Ao entrar na live do Arch Linux, basta usar o comando a seguir para baixar o script:

`git clone https://github.com/fredericofavaro/fali`


## Execução 

`bash ./fali/core.sh`


## O que será instalado

- Pacote base
- Pacote base-devel
- Kernel
- Firmware
- vim ou nano (Escolha do usuário)
- grub
- efibootmgr (Apenas em sistemas EFI)


## Features

- [x] Menu interativo e simplificado
- [x] Em português do Brasil
- [x] Identificação automática do fuzo horário (Com base no IP)
- [x] Seleção do mirrorlist (Padrão, Manual ou baseado nos mais rápidos)
- [x] Suporte a sistemas legado (BIOS) e UEFI (Configuração automatizada)
- [x] Instalação e configuração do sistema base


## Features em implementação

- [ ] Log de erros

- [ ] Instalação de drive de vídeo

- [ ] Instalação de interface gráfica

- [ ] Instalação de softwares essenciais

- [ ] Suporte a softwares 86x

- [ ] Suporte wifi

- [ ] Suporte a multiboot

- [ ] Suporte AUR (yay)

- [ ] Suporte a  Flatpak

- [ ] Suporte a Snap

  ...


## Licença 

LGPL3.


## Agradecimentos

Ao meu amigo **Murilo de Morais**.
