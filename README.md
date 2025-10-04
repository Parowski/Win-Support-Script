# Windows Support Script

![Versão]('https://img.shields.io/badge/Version-4.2-blue.svg') ![Licença]('https://img.shields.io/badge/License-MIT-green.svg') ![Plataforma]('https://img.shields.io/badge/Platform-Windows-lightgrey.svg')

Este repositório contém um script Batch (`.bat`) completo para realizar tarefas de suporte técnico, manutenção e otimização em sistemas operativos Windows. O projeto, criado por **Jhon Parowski**, foi desenvolvido para ser uma ferramenta "tudo-em-um" para administradores de sistemas e utilizadores que procuram resolver problemas comuns de forma eficiente.

## Funcionalidades

Este script inclui, entre outras, as seguintes funcionalidades:

- **Reparo do Sistema:** Execução automatizada de 'DISM /Online /Cleanup-Image /RestoreHealth' e 'sfc /scannow'.
- **Limpeza de Disco:**
    - Limpeza de ficheiros temporários, lixeira e caches de aplicações (Chrome, Edge, Discord).
    - Limpeza de componentes de sistema desnecessários (pasta WinSxS).
- **Diagnóstico de Rede:**
    - Reparação rápida (flushdns, release/renew).
    - Reset completo de Winsock e IP.
    - Visualização de senhas de redes Wi-Fi guardadas.
- **Gestão de Sistema:**
    - Verificação de estado de ativação do Windows e Office.
    - Controlo do serviço do Windows Update.
    - Criação de pontos de restauro.
- **Ferramentas de Otimização:**
    - Desfragmentação e otimização de discos (TRIM).
    - Atalho para gestão de aplicações de arranque.

## Como Usar

1.  Clone este repositório ou faça o download do ficheiro '.bat'.
2.  Para executar, clique com o botão direito do rato no ficheiro e selecione **"Executar como administrador"**.
3.  Siga as instruções apresentadas no menu da consola.

## Requisitos

- Sistema Operativo Windows.
- É necessário executar o script com permissões de Administrador para que todas as funções operem corretamente.

## Autor

- **Jhon Parowski**
