@echo off
setlocal EnableExtensions EnableDelayedExpansion

:: ====================================================================================
::  MENU DE SUPORTE TECNICO V5.0
::  CRIADO POR: Jhon Parowski
::
::  Descricao:
::  Esta ferramenta centraliza diversas tarefas de diagnostico, reparo e otimizacao
::  para sistemas Windows. A v5.0 introduz um modulo de gestao de energia avancado
::  inspirado no DShutdown, permitindo agendamentos por hora e por processo.
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
title MENU DE SUPORTE TECNICO V5.0 - Por Jhon Parowski
color 0B

:: >>> Pula a definicao de funcoes e vai direto para o menu principal
goto :MENU

:: ####################################################################################
:: #                          BLOCO DE DEFINICOES DE FUNCOES                          #
:: ####################################################################################

:Header
cls
echo ======================================================================
echo =               MENU DE SUPORTE TECNICO V5.0                         =
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
echo  [50] Gestao Avancada de Energia (Desligar, Agendar, etc.)
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
if "%OP%"=="50" goto :POWER_MENU
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

:: A implementacao das funcoes antigas (1-42, 51-52) permanece a mesma...
:: O codigo foi omitido aqui para focar nas novidades, mas esta no script completo.

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
call :ConfirmAction "Deseja iniciar a limpeza da pasta WinSxS"
Dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase
echo.
echo Limpeza concluida!
goto :PauseMenu

:RESET_WU
call :Header
echo --- RESETAR COMPONENTES DO WINDOWS UPDATE ---
call :ConfirmAction "Deseja resetar os componentes do Windows Update"
net stop wuauserv & net stop cryptSvc & net stop bits & net stop msiserver
ren C:\Windows\SoftwareDistribution SoftwareDistribution.old
ren C:\Windows\System32\catroot2 catroot2.old
net start wuauserv & net start cryptSvc & net start bits & net start msiserver
echo.
echo Processo concluido!
goto :PauseMenu

:MANAGE_WU
call :Header
echo [1] Ativar Atualizacoes Automaticas [2] Desativar
set /p "WU_OP=Opcao: "
if "%WU_OP%"=="1" ( sc config wuauserv start=auto & net start wuauserv )
if "%WU_OP%"=="2" ( net stop wuauserv & sc config wuauserv start=disabled )
goto :PauseMenu

:: -------------------[ LIMPEZA AVANCADA E GESTAO DE PROGRAMAS ]-------------------
:CLEAN_ADVANCED
call :Header
call :ConfirmAction "Deseja continuar com a limpeza avancada"
taskkill /F /IM msedge.exe >nul 2>&1 & taskkill /F /IM chrome.exe >nul 2>&1 & taskkill /F /IM firefox.exe >nul 2>&1
rd /s /q "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache" >nul 2>&1
rd /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cache" >nul 2>&1
rd /s /q "%APPDATA%\discord\Cache" >nul 2>&1
del /f /s /q "%LOCALAPPDATA%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1
echo Limpeza avancada concluida!
goto :PauseMenu

:CLEAN_BASIC
call :Header
call :ConfirmAction "Deseja iniciar a limpeza basica"
rd /s /q C:\$Recycle.Bin >nul 2>&1
del /q /f /s "%TEMP%\*.*" >nul 2>&1
del /q /f /s "C:\Windows\Temp\*.*" >nul 2>&1
echo Limpeza basica concluida!
goto :PauseMenu

:MANAGE_STARTUP
start "" ms-settings:startupapps
goto :PauseMenu

:UNINSTALL_PROGRAMS
start "" appwiz.cpl
goto :PauseMenu

:FIND_LARGE_FILES
call :Header
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
DISM /Online /Cleanup-Image /RestoreHealth
sfc /scannow
echo Reparo concluido. Recomenda-se reiniciar.
goto :PauseMenu

:RESTORE_POINT
call :Header
call :ConfirmAction "Deseja criar um ponto de restauracao do sistema"
powershell -NoProfile -Command "Checkpoint-Computer -Description 'PontoManual_JPToolbox'"
echo Ponto de restauracao criado com sucesso.
goto :PauseMenu

:: -------------------------------[ REDE E INTERNET ]------------------------------
:FIX_SLOW_NET
call :Header
ping -n 2 8.8.8.8 >nul && (echo  - Conexao com a Internet: OK) || (echo  - Conexao com a Internet: FALHOU)
ipconfig /flushdns
ipconfig /release >nul & ipconfig /renew >nul
echo Diagnostico rapido concluido.
goto :PauseMenu

:RESET_NET
call :Header
call :ConfirmAction "Resetar configuracoes de Rede (requer reinicio)"
netsh winsock reset & netsh int ip reset
echo Operacao concluida. REINICIE o computador.
goto :PauseMenu

:WIFI_PASS
call :Header
for /f "tokens=2 delims=:" %%P in ('netsh wlan show profiles') do (
    set "ssid=%%P" & set "ssid=!ssid:~1!"
    for /f "tokens=2 delims=:" %%K in ('netsh wlan show profile name^="!ssid!" key^=clear ^| findstr /C:"Key Content"') do (
        echo  - Rede: !ssid! --- Senha: %%K
    )
)
goto :PauseMenu

:: ------------------------------[ FERRAMENTAS RAPIDAS ]---------------------------
:FIREWALL_MENU
call :Header
echo [1] Ligar [2] Desligar [3] Resetar
set /p "FW_OP=Opcao: "
if "%FW_OP%"=="1" ( netsh advfirewall set allprofiles state on )
if "%FW_OP%"=="2" ( netsh advfirewall set allprofiles state off )
if "%FW_OP%"=="3" ( netsh advfirewall reset )
goto :PauseMenu

:SYSINFO
call :Header
systeminfo | findstr /B /C:"Nome do host" /C:"Nome do sistema operacional" /C:"Versao do sistema operacional" /C:"Processador(es)" /C:"Memoria fisica total"
goto :PauseMenu


:: ####################################################################################
:: #               NOVO MODULO: GESTAO AVANCADA DE ENERGIA (v5.0)                     #
:: ####################################################################################

:POWER_MENU
call :Header
echo --- GESTAO AVANCADA DE ENERGIA (Inspirado no DShutdown) ---
echo.
echo  [1] Executar acao com TEMPORIZADOR (ex: desligar em 60 min)
echo  [2] Agendar acao para uma HORA ESPECIFICA (ex: reiniciar as 23:00)
echo  [3] Executar acao QUANDO UM PROGRAMA TERMINAR (ex: desligar no fim do download)
echo  [4] CANCELAR todas as acoes de energia agendadas
echo.
echo  [0] Voltar ao Menu Principal
echo --------------------------------------------------------------------------------
set /p "POWER_OP=Escolha uma opcao: "
if "%POWER_OP%"=="1" goto :POWER_TIMER
if "%POWER_OP%"=="2" goto :POWER_SCHEDULE_TIME
if "%POWER_OP%"=="3" goto :POWER_SCHEDULE_PROCESS
if "%POWER_OP%"=="4" goto :POWER_CANCEL
if "%POWER_OP%"=="0" goto :MENU
goto :POWER_MENU

:POWER_TIMER
call :Header
echo --- ACAO COM TEMPORIZADOR ---
set "ACTION_CMD=" & set "ACTION_NAME="
echo Escolha a acao: [1] Desligar  [2] Reiniciar  [3] Hibernar  [4] Suspender
set /p "ACTION_TYPE=Tipo de acao: "
if "%ACTION_TYPE%"=="1" set "ACTION_CMD=shutdown /s /f" & set "ACTION_NAME=Desligamento"
if "%ACTION_TYPE%"=="2" set "ACTION_CMD=shutdown /r /f" & set "ACTION_NAME=Reinicio"
if "%ACTION_TYPE%"=="3" set "ACTION_CMD=shutdown /h /f" & set "ACTION_NAME=Hibernacao"
if "%ACTION_TYPE%"=="4" set "ACTION_CMD=rundll32.exe powrprof.dll,SetSuspendState 0,1,0" & set "ACTION_NAME=Suspensao"
if not defined ACTION_CMD goto :POWER_TIMER

set /p "MINUTES=Insira o tempo em MINUTOS: "
set /a "SECONDS=%MINUTES%*60"
%ACTION_CMD% /t %SECONDS%
echo %ACTION_NAME% agendado para daqui a %MINUTES% minuto(s).
goto :PauseMenu

:POWER_SCHEDULE_TIME
call :Header
echo --- AGENDAR ACAO PARA HORA ESPECIFICA ---
set "ACTION_CMD=" & set "ACTION_NAME="
echo Escolha a acao: [1] Desligar  [2] Reiniciar
set /p "ACTION_TYPE=Tipo de acao: "
if "%ACTION_TYPE%"=="1" set "ACTION_CMD=shutdown /s /f" & set "ACTION_NAME=Desligamento"
if "%ACTION_TYPE%"=="2" set "ACTION_CMD=shutdown /r /f" & set "ACTION_NAME=Reinicio"
if not defined ACTION_CMD goto :POWER_SCHEDULE_TIME

set /p "SCHEDULE_TIME=Insira a hora no formato 24h (HH:MM): "
:: Cria uma tarefa agendada que se executa uma vez e depois se apaga
schtasks /Create /TN "JPToolboxPowerAction" /TR "%ACTION_CMD%" /SC ONCE /ST %SCHEDULE_TIME% /F
echo %ACTION_NAME% agendado para as %SCHEDULE_TIME%.
goto :PauseMenu

:POWER_SCHEDULE_PROCESS
call :Header
echo --- EXECUTAR ACAO QUANDO UM PROGRAMA TERMINAR ---
set "ACTION_CMD=" & set "ACTION_NAME="
echo Escolha a acao: [1] Desligar  [2] Reiniciar  [3] Hibernar
set /p "ACTION_TYPE=Tipo de acao: "
if "%ACTION_TYPE%"=="1" set "ACTION_CMD=shutdown /s /f /t 15" & set "ACTION_NAME=desligado"
if "%ACTION_TYPE%"=="2" set "ACTION_CMD=shutdown /r /f /t 15" & set "ACTION_NAME=reiniciado"
if "%ACTION_TYPE%"=="3" set "ACTION_CMD=shutdown /h /f" & set "ACTION_NAME=hibernado"
if not defined ACTION_CMD goto :POWER_SCHEDULE_PROCESS

set /p "PROCESS_NAME=Insira o nome do processo (ex: chrome.exe, render.exe): "
echo.
echo OK. A monitorizar o processo '%PROCESS_NAME%'.
echo Esta janela ficara aberta em segundo plano. NAO A FECHE.
echo O computador sera %ACTION_NAME% 15 segundos apos o processo ser fechado.
echo Pressione qualquer tecla para iniciar a monitorizacao...
pause >nul

:ProcessCheckLoop
cls
echo Monitorizando... O computador sera %ACTION_NAME% quando '%PROCESS_NAME%' terminar.
echo Hora atual: %TIME%
tasklist /FI "IMAGENAME eq %PROCESS_NAME%" 2>NUL | find /I /N "%PROCESS_NAME%">NUL
if "%ERRORLEVEL%"=="0" (
    :: Se o processo for encontrado, espera 30 segundos e verifica novamente
    timeout /t 30 /nobreak >nul
    goto :ProcessCheckLoop
) else (
    :: Se o processo NAO for encontrado, executa a acao
    echo Processo '%PROCESS_NAME%' nao encontrado! A iniciar %ACTION_NAME% em 15 segundos...
    %ACTION_CMD%
    goto :PauseMenu
)

:POWER_CANCEL
call :Header
echo --- CANCELAR ACOES DE ENERGIA ---
echo A tentar cancelar qualquer desligamento/reinicio agendado...
shutdown /a
echo A tentar remover tarefas agendadas pela ferramenta...
schtasks /Delete /TN "JPToolboxPowerAction" /F >nul 2>&1
echo.
echo Cancelamento concluido. Se a janela de monitorizacao de processo estiver
echo aberta, pode fecha-la manualmente.
goto :PauseMenu

:SAIR
cls
echo Encerrando a ferramenta de suporte... Ate logo!
timeout /t 2 /nobreak >nul
endlocal
exit /b 0
