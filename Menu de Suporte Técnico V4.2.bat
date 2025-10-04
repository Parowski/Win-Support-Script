@echo off
setlocal EnableExtensions EnableDelayedExpansion

:: ====================================================================================
::  MENU DE SUPORTE TECNICO V4.2
::  CRIADO POR: Jhon Parowski
::
::  Descricao:
::  Esta ferramenta centraliza diversas tarefas de diagnostico, reparo e otimizacao
::  para sistemas Windows, incluindo gestao de ativacao, limpeza avancada e
::  solucao de problemas de sistema, rede e disco.
:: ====================================================================================

:: ------------------------------------------------------------------------------------
::  VERIFICACAO E AUTO-ELEVACAO DE PRIVILEGIOS DE ADMINISTRADOR
:: ------------------------------------------------------------------------------------
fltmc >nul 2>&1
if %errorlevel% neq 0 (
    echo Solicitando privilegios de Administrador...
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

:: --- Configuracoes Iniciais ---
cd /d "%~dp0"
title MENU DE SUPORTE TECNICO V4.2 - Por Jhon Parowski
color 0B

:: >>> Pula a definicao de funcoes e vai direto para o menu principal
goto :MENU

:: ####################################################################################
:: #                          BLOCO DE DEFINICOES DE FUNCOES                          #
:: ####################################################################################

:Header
cls
echo ======================================================================
echo =               MENU DE SUPORTE TECNICO V4.2                         =
echo =                  Criado por: Jhon Parowski                         =
echo ======================================================================
echo.
echo   Bem-vindo, %USERNAME%!   Computador: %COMPUTERNAME%
echo   Status: Rodando com privilegios de Administrador.
echo.
goto :eof

:PauseMenu
echo.
echo Pressione qualquer tecla para voltar ao menu principal...
pause >nul
goto :MENU

:ConfirmAction
set "_CONFIRM=N"
set /p "_CONFIRM=%~1 (S/N): "
if /I not "%_CONFIRM%"=="S" goto :MENU
goto :eof

:: ####################################################################################
:: #                             MENU PRINCIPAL (CATEGORIZADO)                        #
:: ####################################################################################
:MENU
call :Header
echo --------------------[ ATIVACAO E SERVICOS DO WINDOWS ]--------------------
echo  [ 1] Verificar Status da Ativacao do Windows e Office
echo  [ 2] Limpar Componentes do Windows (WinSxS Cleanup) [Libera Espaco]
echo  [ 3] Resetar Componentes do Windows Update [Resolve problemas de update]
echo  [ 4] Gerir Atualizacoes Automaticas do Windows (Ativar/Desativar)
echo.
echo -------------------[ LIMPEZA AVANCADA E GESTAO DE PROGRAMAS ]-------------------
echo  [10] Limpeza Avancada (Navegadores, Apps, Caches)
echo  [11] Limpeza Basica do Windows (Temp, Lixeira)
echo  [12] Gerir Programas de Arranque (Inicializacao)
echo  [13] Desinstalar Programas (Adicionar/Remover Programas)
echo  [14] Encontrar Arquivos Grandes na Unidade C: (acima de 1GB)
echo.
echo -----------------------[ OTIMIZACAO E REPARO DE DISCO ]-------------------------
echo  [20] Otimizar Unidade C: (Desfragmentar/TRIM)
echo  [21] Verificar Saude do Disco (S.M.A.R.T.)
echo  [22] Verificar Integridade do Disco (CHKDSK C:) [demorado]
echo.
echo -----------------------[ REPARO E DIAGNOSTICO DO SISTEMA ]----------------------
echo  [30] Reparar Imagem do Windows e Arquivos do Sistema (DISM + SFC)
echo  [31] Criar Ponto de Restauracao do Sistema
echo.
echo -------------------------------[ REDE E INTERNET ]------------------------------
echo  [40] Diagnostico e Reparacao Rapida de Rede
echo  [41] Resetar Configuracoes de Rede (Winsock/IP) [requer reinicio]
echo  [42] Mostrar Perfis e Senhas Wi-Fi Salvas
echo.
echo ------------------------------[ FERRAMENTAS RAPIDAS ]---------------------------
echo  [50] Agendar Desligamento (1h / 2h / Cancelar)
echo  [51] Gerir Firewall do Windows (Ligar/Desligar/Resetar)
echo  [52] Informacoes Resumidas do Sistema
echo.
echo  [ 0] Sair
echo --------------------------------------------------------------------------------
set "OP="
set /p "OP=Escolha uma opcao: "

:: Validacao de entrada numerica
set /a "OP_NUM=%OP%" >nul 2>&1
if !errorlevel! neq 0 goto :INVALID_OPTION

if "%OP%"=="1"  goto :CHECK_ACTIVATION
if "%OP%"=="2"  goto :WINSXS_CLEANUP
if "%OP%"=="3"  goto :RESET_WU
if "%OP%"=="4"  goto :MANAGE_WU
if "%OP%"=="10" goto :CLEAN_ADVANCED
if "%OP%"=="11" goto :CLEAN_BASIC
if "%OP%"=="12" goto :MANAGE_STARTUP
if "%OP%"=="13" goto :UNINSTALL_PROGRAMS
if "%OP%"=="14" goto :FIND_LARGE_FILES
if "%OP%"=="20" goto :DEFRAG_C
if "%OP%"=="21" goto :SMART_STATUS
if "%OP%"=="22" goto :CHKDSK_C
if "%OP%"=="30" goto :REPAIR_SYSTEM
if "%OP%"=="31" goto :RESTORE_POINT
if "%OP%"=="40" goto :FIX_SLOW_NET
if "%OP%"=="41" goto :RESET_NET
if "%OP%"=="42" goto :WIFI_PASS
if "%OP%"=="50" goto :SHUTDOWN_MENU
if "%OP%"=="51" goto :FIREWALL_MENU
if "%OP%"=="52" goto :SYSINFO
if "%OP%"=="0"  goto :SAIR

:INVALID_OPTION
echo.
echo Opcao invalida. Por favor, tente novamente.
timeout /t 2 /nobreak >nul
goto :MENU

:: ####################################################################################
:: #                         IMPLEMENTACAO DAS FUNCOES DO MENU                        #
:: ####################################################################################

:: --------------------[ ATIVACAO E SERVICOS DO WINDOWS ]--------------------
:CHECK_ACTIVATION
call :Header
echo --- VERIFICAR STATUS DA ATIVACAO ---
echo.
echo [ STATUS DO WINDOWS ]
cscript //nologo C:\Windows\System32\slmgr.vbs /dli
echo.
echo ------------------------------------------------------------
echo.
echo [ STATUS DO OFFICE ]
echo Procurando instalacoes do Office (pode levar um momento)...
if exist "%ProgramFiles%\Microsoft Office\Office16\ospp.vbs" (
    cscript //nologo "%ProgramFiles%\Microsoft Office\Office16\ospp.vbs" /dstatus
) else if exist "%ProgramFiles(x86)%\Microsoft Office\Office16\ospp.vbs" (
    cscript //nologo "%ProgramFiles(x86)%\Microsoft Office\Office16\ospp.vbs" /dstatus
) else (
    echo Nenhuma instalacao do Office via Volume Licensing foi encontrada.
)
goto :PauseMenu

:WINSXS_CLEANUP
call :Header
echo --- LIMPAR COMPONENTES DO WINDOWS (WinSxS) ---
echo Esta operacao analisa a pasta de componentes do Windows e remove
echo versoes antigas de atualizacoes, o que pode liberar varios GBs
echo de espaco em disco. O processo pode demorar um pouco.
echo.
call :ConfirmAction "Deseja iniciar a limpeza da pasta WinSxS"
echo.
echo Analisando o armazenamento de componentes...
Dism.exe /online /Cleanup-Image /AnalyzeComponentStore
echo.
echo Pressione qualquer tecla para iniciar a limpeza...
pause >nul
echo.
echo Limpando componentes desnecessarios...
Dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase
echo.
echo Limpeza concluida!
goto :PauseMenu

:RESET_WU
call :Header
echo --- RESETAR COMPONENTES DO WINDOWS UPDATE ---
echo Esta operacao e util quando o Windows Update trava, nao encontra
echo atualizacoes ou apresenta erros. Ela ira parar os servicos,
echo renomear as pastas de cache e reiniciar os servicos.
echo.
call :ConfirmAction "Deseja resetar os componentes do Windows Update"
echo.
echo Parando servicos relacionados...
net stop wuauserv
net stop cryptSvc
net stop bits
net stop msiserver
echo.
echo Renomeando pastas de cache (criando backup)...
ren C:\Windows\SoftwareDistribution SoftwareDistribution.old
ren C:\Windows\System32\catroot2 catroot2.old
echo.
echo Reiniciando servicos...
net start wuauserv
net start cryptSvc
net start bits
net start msiserver
echo.
echo Processo concluido! Tente procurar por atualizacoes novamente.
goto :PauseMenu

:MANAGE_WU
call :Header
echo --- GERIR ATUALIZACOES AUTOMATICAS DO WINDOWS ---
echo [1] Ativar Atualizacoes Automaticas (Padrao)
echo [2] Desativar Atualizacoes Automaticas (Nao Recomendado)
echo [0] Voltar
set /p "WU_OP=Opcao: "
if "%WU_OP%"=="1" (
    sc config wuauserv start=auto
    net start wuauserv
    echo Servico do Windows Update configurado para INICIO AUTOMATICO.
)
if "%WU_OP%"=="2" (
    net stop wuauserv
    sc config wuauserv start=disabled
    echo ATENCAO: Servico do Windows Update foi DESATIVADO.
)
goto :PauseMenu

:: -------------------[ LIMPEZA AVANCADA E GESTAO DE PROGRAMAS ]-------------------
:CLEAN_ADVANCED
call :Header
echo --- LIMPEZA AVANCADA (NAVEGADORES E APLICATIVOS) ---
call :ConfirmAction "Deseja continuar com a limpeza avancada"
echo.
taskkill /F /IM msedge.exe >nul 2>&1 & taskkill /F /IM chrome.exe >nul 2>&1 & taskkill /F /IM firefox.exe >nul 2>&1
echo Limpando caches...
rd /s /q "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache" >nul 2>&1
rd /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cache" >nul 2>&1
rd /s /q "%APPDATA%\discord\Cache" >nul 2>&1
del /f /s /q "%LOCALAPPDATA%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1
echo Limpeza avancada concluida!
goto :PauseMenu

:CLEAN_BASIC
call :Header
echo --- LIMPEZA BASICA DO WINDOWS ---
call :ConfirmAction "Deseja iniciar a limpeza basica"
rd /s /q C:\$Recycle.Bin >nul 2>&1
del /q /f /s "%TEMP%\*.*" >nul 2>&1
del /q /f /s "C:\Windows\Temp\*.*" >nul 2>&1
echo Limpeza basica concluida!
goto :PauseMenu

:MANAGE_STARTUP
call :Header
echo Abrindo 'Aplicativos de Inicializacao'...
start "" ms-settings:startupapps
goto :PauseMenu

:UNINSTALL_PROGRAMS
call :Header
echo Abrindo 'Adicionar ou Remover Programas'...
start "" appwiz.cpl
goto :PauseMenu

:FIND_LARGE_FILES
call :Header
echo --- ENCONTRAR ARQUIVOS GRANDES NA UNIDADE C: ---
call :ConfirmAction "Iniciar busca por arquivos >1GB (pode demorar)"
powershell -NoProfile -Command "Get-ChildItem C:\ -Recurse -ErrorAction SilentlyContinue | Where-Object { !$_.PSIsContainer -and $_.Length -gt 1GB } | Sort-Object Length -Descending | Select-Object -First 20 | Format-Table @{Name='Tamanho (GB)'; Expression={[math]::Round($_.Length / 1GB, 2)}}, FullName -AutoSize"
goto :PauseMenu

:: -----------------------[ OTIMIZACAO E REPARO DE DISCO ]-------------------------
:DEFRAG_C
call :Header
call :ConfirmAction "Deseja otimizar a Unidade C:"
defrag C: /O /U /V
goto :PauseMenu

:SMART_STATUS
call :Header
echo --- VERIFICAR SAUDE DO DISCO (S.M.A.R.T.) ---
wmic diskdrive get model,status
goto :PauseMenu

:CHKDSK_C
call :Header
call :ConfirmAction "Executar CHKDSK na unidade C: (requer reinicio se houver erros)"
chkdsk C: /f /r
goto :PauseMenu

:: -----------------------[ REPARO E DIAGNOSTICO DO SISTEMA ]----------------------
:REPAIR_SYSTEM
call :Header
call :ConfirmAction "Deseja iniciar o reparo completo do sistema (DISM + SFC)"
echo [ETAPA 1/2] Executando DISM...
DISM /Online /Cleanup-Image /RestoreHealth
echo [ETAPA 2/2] Executando SFC...
sfc /scannow
echo Reparo concluido. Recomenda-se reiniciar.
goto :PauseMenu

:RESTORE_POINT
call :Header
call :ConfirmAction "Deseja criar um ponto de restauracao do sistema"
powershell -NoProfile -Command "Checkpoint-Computer -Description 'PontoManual_MenuSuporteV4'"
echo Ponto de restauracao criado com sucesso.
goto :PauseMenu

:: -------------------------------[ REDE E INTERNET ]------------------------------
:FIX_SLOW_NET
call :Header
echo --- DIAGNOSTICO E REPARACAO RAPIDA DE REDE ---
ping -n 2 8.8.8.8 >nul && (echo  - Conexao com a Internet: OK) || (echo  - Conexao com a Internet: FALHOU)
ipconfig /flushdns
ipconfig /release >nul & ipconfig /renew >nul
echo Diagnostico rapido concluido.
goto :PauseMenu

:RESET_NET
call :Header
call :ConfirmAction "Resetar configuracoes de Rede (requer reinicio)"
netsh winsock reset
netsh int ip reset
echo Operacao concluida. REINICIE o computador.
goto :PauseMenu

:WIFI_PASS
call :Header
echo --- PERFIS E SENHAS WI-FI SALVAS ---
for /f "tokens=2 delims=:" %%P in ('netsh wlan show profiles') do (
    set "ssid=%%P" & set "ssid=!ssid:~1!"
    for /f "tokens=2 delims=:" %%K in ('netsh wlan show profile name^="!ssid!" key^=clear ^| findstr /C:"Key Content"') do (
        echo  - Rede: !ssid! --- Senha: %%K
    )
)
goto :PauseMenu

:: ------------------------------[ FERRAMENTAS RAPIDAS ]---------------------------
:SHUTDOWN_MENU
call :Header
echo --- AGENDAR DESLIGAMENTO ---
echo [1] Agendar para 1 HORA [2] Agendar para 2 HORAS [3] CANCELAR
set /p "SHUT_OP=Opcao: "
if "%SHUT_OP%"=="1" ( shutdown /s /t 3600 )
if "%SHUT_OP%"=="2" ( shutdown /s /t 7200 )
if "%SHUT_OP%"=="3" ( shutdown /a )
goto :PauseMenu

:FIREWALL_MENU
call :Header
echo --- GERIR FIREWALL DO WINDOWS ---
echo [1] Ligar [2] Desligar [3] Resetar
set /p "FW_OP=Opcao: "
if "%FW_OP%"=="1" ( netsh advfirewall set allprofiles state on )
if "%FW_OP%"=="2" ( netsh advfirewall set allprofiles state off )
if "%FW_OP%"=="3" ( netsh advfirewall reset )
goto :PauseMenu

:SYSINFO
call :Header
echo --- INFORMACOES RESUMIDAS DO SISTEMA ---
systeminfo | findstr /B /C:"Nome do host" /C:"Nome do sistema operacional" /C:"Versao do sistema operacional" /C:"Processador(es)" /C:"Memoria fisica total"
goto :PauseMenu

:SAIR
cls
echo Encerrando a ferramenta de suporte... Ate logo!
timeout /t 2 /nobreak >nul
endlocal
exit /b 0
