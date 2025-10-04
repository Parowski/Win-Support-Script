@echo off
setlocal EnableExtensions EnableDelayedExpansion

:: ====================================================================================
::  MENU DE SUPORTE TECNICO V10.0 (VERSAO DEFINITIVA)
::  CRIADO POR: Jhon Parowski
::
::  Descricao:
::  A versao mais completa da ferramenta, reintegrando todas as funcionalidades
::  anteriores com os novos modulos de reparo e gestao do registo. Organizada
::  para acesso rapido a diagnostico, limpeza, reparo e utilitarios.
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
title MENU DE SUPORTE TECNICO V10.0 - Por Jhon Parowski
color 0B
set "BACKUP_DIR=C:\JPToolbox_Backups\Registry"
set "EXCLUSION_FILE=%~dp0registry_exclusions.txt"
if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%" >nul 2>&1

:: >>> Pula a definicao de funcoes e vai direto para o menu principal
goto :MENU

:: ####################################################################################
:: #                          BLOCO DE DEFINICOES DE FUNCOES                          #
:: ####################################################################################

:Header
cls
echo ======================================================================
echo =           MENU DE SUPORTE TECNICO V10.0 (Definitiva)               =
echo =                  Criado por: Jhon Parowski                         =
echo ======================================================================
echo.
echo   Bem-vindo, %USERNAME%!   Computador: %COMPUTERNAME%
echo.
goto :eof

:PauseMenu
echo.
echo Pressione qualquer tecla para voltar ao menu principal...
pause >nul
goto :MENU

:ConfirmAction
set "_CONFIRM=N" & set "ACTION_CANCELLED=1"
set /p "_CONFIRM=%~1 (S/N): "
if /I "%_CONFIRM%"=="S" set "ACTION_CANCELLED=0"
goto :eof

:: ####################################################################################
:: #                             MENU PRINCIPAL (CATEGORIZADO)                        #
:: ####################################################################################
:MENU
call :Header
echo -----------------------[ REPARO E DIAGNOSTICO DO SISTEMA ]----------------------
echo  [ 1] Reparo Avancado do Sistema (DISM, SFC, WMI...)
echo  [ 2] Gestao do Registo (Limpeza Avancada com Modos e Backup)
echo  [ 3] Verificar Saude do Disco (S.M.A.R.T.)
echo  [ 4] Verificar Integridade do Disco (CHKDSK C:) [demorado]
echo  [ 5] Criar Ponto de Restauracao do Sistema
echo.
echo ---------------------------[ LIMPEZA E OTIMIZACAO ]---------------------------
echo  [10] Limpeza Avancada de Ficheiros (Navegadores, Caches de Apps)
echo  [11] Limpeza Basica do Windows (Ficheiros Temporarios, Lixeira)
echo  [12] Limpar Componentes do Windows (WinSxS Cleanup)
echo  [13] Otimizar Unidade C: (Desfragmentar/TRIM)
echo  [14] Gerir Programas de Arranque (Inicializacao)
echo.
echo -------------------------------[ REDE E INTERNET ]------------------------------
echo  [20] Diagnostico e Reparacao Rapida de Rede
echo  [21] Resetar Configuracoes de Rede (Winsock/IP) [requer reinicio]
echo  [22] Mostrar Perfis e Senhas Wi-Fi Salvas
echo.
echo -----------------------[ FERRAMENTAS E UTILITARIOS ]------------------------
echo  [30] Informacoes Detalhadas do Sistema (estilo Speccy)
echo  [31] Gestao Avancada de Energia (Agendar Desligamento, etc.)
echo  [32] Verificar Status da Ativacao do Windows e Office
echo  [33] Resetar Componentes do Windows Update
echo  [34] Gerir Firewall do Windows (Ligar/Desligar/Resetar)
echo  [35] Desinstalar Programas (Adicionar/Remover Programas)
echo  [36] Encontrar Arquivos Grandes na Unidade C: (acima de 1GB)
echo.
echo  [ 0] Sair
echo --------------------------------------------------------------------------------
set "OP="
set /p "OP=Escolha uma opcao: "

if "%OP%"=="1"  goto :SYSTEM_REPAIR_MENU
if "%OP%"=="2"  goto :REGISTRY_MENU
if "%OP%"=="3"  goto :SMART_STATUS
if "%OP%"=="4"  goto :CHKDSK_C
if "%OP%"=="5"  goto :RESTORE_POINT
if "%OP%"=="10" goto :CLEAN_ADVANCED
if "%OP%"=="11" goto :CLEAN_BASIC
if "%OP%"=="12" goto :WINSXS_CLEANUP
if "%OP%"=="13" goto :DEFRAG_C
if "%OP%"=="14" goto :MANAGE_STARTUP
if "%OP%"=="20" goto :FIX_SLOW_NET
if "%OP%"=="21" goto :RESET_NET
if "%OP%"=="22" goto :WIFI_PASS
if "%OP%"=="30" goto :SYSINFO_DETAILED
if "%OP%"=="31" goto :POWER_MENU
if "%OP%"=="32" goto :CHECK_ACTIVATION
if "%OP%"=="33" goto :RESET_WU
if "%OP%"=="34" goto :FIREWALL_MENU
if "%OP%"=="35" goto :UNINSTALL_PROGRAMS
if "%OP%"=="36" goto :FIND_LARGE_FILES
if "%OP%"=="0"  goto :SAIR

echo Opcao invalida. & timeout /t 2 /nobreak >nul & goto :MENU

:: ####################################################################################
:: #                     IMPLEMENTACAO DAS FUNCOES RESTAURADAS                        #
:: ####################################################################################

:SMART_STATUS
call :Header
echo --- STATUS DE SAUDE DO DISCO (S.M.A.R.T.) ---
wmic diskdrive get model,status
call :PauseMenu

:CHKDSK_C
call :Header
echo --- VERIFICAR INTEGRIDADE DO DISCO C: ---
echo AVISO: Este processo pode ser muito demorado.
call :ConfirmAction "Deseja continuar com o CHKDSK na unidade C:"
if !ACTION_CANCELLED!==1 goto :MENU
chkdsk C: /f /r
echo Verificacao agendada para a proxima reinicializacao, se necessario.
call :PauseMenu

:RESTORE_POINT
call :Header
echo --- CRIAR PONTO DE RESTAURACAO ---
call :ConfirmAction "Deseja criar um ponto de restauracao agora"
if !ACTION_CANCELLED!==1 goto :MENU
powershell -NoProfile "Checkpoint-Computer -Description 'PontoManual_JPToolbox'"
echo Ponto de restauracao criado com sucesso.
call :PauseMenu

:CLEAN_BASIC
call :Header
echo --- LIMPEZA BASICA DO WINDOWS ---
call :ConfirmAction "Iniciar limpeza de ficheiros temporarios e lixeira"
if !ACTION_CANCELLED!==1 goto :MENU
echo [1/3] A esvaziar a Lixeira...
rd /s /q C:\$Recycle.Bin >nul 2>&1
echo [2/3] A limpar temporarios do utilizador (%TEMP%)...
del /q /f /s "%TEMP%\*.*" >nul 2>&1
echo [3/3] A limpar temporarios do sistema (C:\Windows\Temp)...
del /q /f /s "C:\Windows\Temp\*.*" >nul 2>&1
echo Limpeza basica concluida!
call :PauseMenu

:MANAGE_STARTUP
call :Header
echo A abrir a gestao de aplicacoes de arranque...
start "" ms-settings:startupapps
goto :MENU

:FIX_SLOW_NET
call :Header
echo --- DIAGNOSTICO E REPARACAO RAPIDA DE REDE ---
echo A executar comandos rapidos de reparacao...
echo [1/3] A limpar o cache de DNS...
ipconfig /flushdns
echo [2/3] A libertar o endereco IP...
ipconfig /release >nul
echo [3/3] A renovar o endereco IP...
ipconfig /renew >nul
echo Diagnostico rapido concluido.
call :PauseMenu

:CHECK_ACTIVATION
call :Header
echo --- STATUS DA ATIVACAO DO WINDOWS E OFFICE ---
echo.
echo [WINDOWS]
cscript //nologo C:\Windows\System32\slmgr.vbs /dli
echo.
echo [OFFICE]
if exist "%ProgramFiles%\Microsoft Office\Office16\ospp.vbs" (
    cscript //nologo "%ProgramFiles%\Microsoft Office\Office16\ospp.vbs" /dstatus
) else if exist "%ProgramFiles(x86)%\Microsoft Office\Office16\ospp.vbs" (
    cscript //nologo "%ProgramFiles(x86)%\Microsoft Office\Office16\ospp.vbs" /dstatus
) else (
    echo Instalacao do Office nao encontrada ou versao nao suportada.
)
call :PauseMenu

:RESET_WU
call :Header
echo --- RESETAR COMPONENTES DO WINDOWS UPDATE ---
echo Isto ira parar os servicos de update, renomear as pastas de cache e reinicia-los.
call :ConfirmAction "Deseja continuar com o reset"
if !ACTION_CANCELLED!==1 goto :MENU
net stop wuauserv & net stop cryptSvc & net stop bits & net stop msiserver
ren C:\Windows\SoftwareDistribution SoftwareDistribution.old
ren C:\Windows\System32\catroot2 catroot2.old
net start wuauserv & net start cryptSvc & net start bits & net start msiserver
echo Processo concluido! Os problemas de update devem ser resolvidos.
call :PauseMenu

:FIREWALL_MENU
call :Header
echo --- GERIR FIREWALL DO WINDOWS ---
echo [1] Ligar Firewall (Recomendado)
echo [2] Desligar Firewall (Nao recomendado)
echo [3] Resetar para as Configuracoes Padrao
echo [0] Voltar
set /p "FW_OP=Escolha uma opcao: "
if "%FW_OP%"=="1" (netsh advfirewall set allprofiles state on & echo Firewall ATIVADO.)
if "%FW_OP%"=="2" (netsh advfirewall set allprofiles state off & echo Firewall DESATIVADO.)
if "%FW_OP%"=="3" (netsh advfirewall reset & echo Firewall RESETADO.)
if "%FW_OP%"=="0" goto :MENU
call :PauseMenu

:UNINSTALL_PROGRAMS
call :Header
echo A abrir o painel 'Adicionar ou Remover Programas'...
start "" appwiz.cpl
goto :MENU

:FIND_LARGE_FILES
call :Header
echo --- ENCONTRAR ARQUIVOS GRANDES NA UNIDADE C: (>1GB) ---
call :ConfirmAction "A procura pode demorar. Deseja continuar"
if !ACTION_CANCELLED!==1 goto :MENU
powershell -NoProfile "Get-ChildItem C:\ -Recurse -ErrorAction SilentlyContinue | Where-Object { !$_.PSIsContainer -and $_.Length -gt 1GB } | Sort-Object Length -Descending | Select-Object -First 20 | Format-Table @{Name='Tamanho (GB)';E={[math]::Round($_.Length/1GB,2)}},FullName -A"
call :PauseMenu

:: ####################################################################################
:: #              OUTRAS FUNCOES (MODULOS AVANCADOS E UTILITARIOS)                    #
:: ####################################################################################

:SYSTEM_REPAIR_MENU
:: (Este modulo ja existe e mantem-se igual a v8.0)
call :Header&echo [1] Diagnostico Rapido [2] Modo Recomendado&set /p R_OP=Opcao:
if "%R_OP%"=="1" (sfc /verifyonly)
if "%R_OP%"=="2" (DISM /Online /Cleanup-Image /RestoreHealth & sfc /scannow)
call :PauseMenu&goto :MENU

:REGISTRY_MENU
:: (Este modulo ja existe e mantem-se igual a v9.0)
call :Header&echo [1] Iniciar Limpeza [2] Gerir Exclusoes [3] Restaurar Backup&set /p R_OP=Opcao:
if "%R_OP%"=="1" (goto :REG_CLEAN_START)
if "%R_OP%"=="2" (notepad "%EXCLUSION_FILE%"&goto :REGISTRY_MENU)
if "%R_OP%"=="3" (start "" "%BACKUP_DIR%"&goto :REGISTRY_MENU)
call :PauseMenu&goto :MENU

:REG_CLEAN_START
call :Header&echo [1] Seguro [2] Normal [3] Profundo&set /p S_MODE=Modo:
if "%S_MODE%" equ "" goto :REGISTRY_MENU
set "T=%date:~-4%-%date:~3,2%-%date:~0,2%_%time:~0,2%h%time:~3,2%m"&reg export HKCU "%BACKUP_DIR%\Backup_HKCU_%T%.reg" /y >nul
echo Backup criado. A iniciar limpeza...
if "%S_MODE%"=="1" (powershell "try { Remove-Item -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU' -Force -Recurse -ErrorAction Stop } catch {}")
if "%S_MODE%"=="2" (powershell "try { Remove-Item -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU' -Force -Recurse -ErrorAction Stop } catch {}"&powershell "Get-ChildItem -Path 'HKCU:\Software' -ErrorAction SilentlyContinue | Where-Object { $_.SubKeyCount -eq 0 -and $_.ValueCount -eq 0 } | Remove-Item -Recurse -Force")
if "%S_MODE%"=="3" (powershell "try { Remove-Item -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU' -Force -Recurse -ErrorAction Stop } catch {}"&powershell "Get-ChildItem -Path 'HKCU:\Software' -ErrorAction SilentlyContinue | Where-Object { $_.SubKeyCount -eq 0 -and $_.ValueCount -eq 0 } | Remove-Item -Recurse -Force")
echo Limpeza concluida.&call :PauseMenu&goto :REGISTRY_MENU

:CLEAN_ADVANCED
call :Header&call :ConfirmAction "Limpeza avancada de caches"&if !ACTION_CANCELLED!==1 goto :MENU
taskkill /F /IM msedge.exe >nul 2>&1&taskkill /F /IM chrome.exe >nul 2>&1&taskkill /F /IM firefox.exe >nul 2>&1
rd /s /q "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache">nul 2>&1&rd /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cache">nul 2>&1
echo Limpeza concluida!&call :PauseMenu

:WINSXS_CLEANUP
call :Header&call :ConfirmAction "Limpeza de Componentes WinSxS"&if !ACTION_CANCELLED!==1 goto :MENU
Dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase&echo Limpeza concluida!&call :PauseMenu

:DEFRAG_C
call :Header&call :ConfirmAction "Otimizar Unidade C:"&if !ACTION_CANCELLED!==1 goto :MENU
defrag C: /O /U /V&call :PauseMenu

:RESET_NET
call :Header&call :ConfirmAction "Resetar Rede (requer reinicio)"&if !ACTION_CANCELLED!==1 goto :MENU
netsh winsock reset&netsh int ip reset&echo Operacao concluida. REINICIE o computador.&call :PauseMenu

:WIFI_PASS
call :Header&echo --- PERFIS E SENHAS WI-FI SALVAS ---
for /f "tokens=2 delims=:" %%P in ('netsh wlan show profiles') do (set "ssid=%%P" & set "ssid=!ssid:~1!" & for /f "tokens=2 delims=:" %%K in ('netsh wlan show profile name^="!ssid!" key^=clear ^| findstr /C:"Key Content"') do (echo  - Rede: !ssid! --- Senha: %%K))
call :PauseMenu

:SYSINFO_DETAILED
call :Header & echo A recolher informacoes... & (echo.&echo --- OS ---&wmic os get Caption,Version,OSArchitecture /format:list&echo.&echo --- CPU ---&wmic cpu get Name,NumberOfCores,NumberOfLogicalProcessors /format:list&echo.&echo --- RAM ---&wmic memorychip get BankLabel,Capacity,Speed /format:table&echo.&echo --- GPU ---&wmic path win32_videocontroller get Name,AdapterRAM /format:list&echo.&echo --- ARMAZENAMENTO ---&wmic diskdrive get Model,Size,Status /format:table&powershell "Get-WmiObject Win32_LogicalDisk -F 'DriveType=3'|FT DeviceID,@{N='GB';E={[math]::Round($_.Size/1GB,2)}},@{N='Livre GB';E={[math]::Round($_.FreeSpace/1GB,2)}} -A")|more
call :PauseMenu

:POWER_MENU
call :Header&echo [1] Temporizador [2] Hora [3] Processo [4] Cancelar&set /p P_OP=Opcao:
if "%P_OP%"=="1" (set /p M=Minutos: &set /a S=%M%*60&shutdown /s /f /t %S%)
if "%P_OP%"=="2" (set /p T=Hora(HH:MM): &schtasks /Create /TN JPToolboxPowerAction /TR "shutdown /s /f" /SC ONCE /ST %T% /F)
if "%P_OP%"=="3" goto :POWER_SCHEDULE_PROCESS
if "%P_OP%"=="4" (shutdown /a&schtasks /Delete /TN JPToolboxPowerAction /F >nul 2>&1&echo Cancelado.)
call :PauseMenu

:POWER_SCHEDULE_PROCESS
call :Header&echo [1] Desligar [2] Reiniciar&set /p A=Acao: &set /p P=Processo:
if "%A%"=="1" (set C=shutdown /s /f /t 15)&if "%A%"=="2" (set C=shutdown /r /f /t 15)
:PCLoop
cls&echo A monitorizar %P%... Prima CTRL+C para cancelar.&tasklist /FI "IMAGENAME eq %P%" 2>NUL|find /I /N "%P%">NUL
if "%ERRORLEVEL%"=="0" (timeout /t 30 /nobreak>nul&goto :PCLoop) else (%C%)&echo Processo %P% terminado. Acao de energia executada.&call :PauseMenu

:SAIR
cls
echo Encerrando a ferramenta de suporte... Ate logo!
timeout /t 2 /nobreak >nul
endlocal
exit /b 0
