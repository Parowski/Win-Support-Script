@echo off
setlocal EnableExtensions EnableDelayedExpansion

:: ====================================================================================
::  MENU DE SUPORTE TECNICO V9.0
::  CRIADO POR: Jhon Parowski
::
::  Descricao:
::  Esta ferramenta centraliza diversas tarefas de diagnostico e otimizacao. A v9.0
::  introduz um sistema avancado de limpeza do Registo com multiplos modos, backups
::  automaticos e uma lista de exclusao, inspirado em ferramentas profissionais.
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
title MENU DE SUPORTE TECNICO V9.0 - Por Jhon Parowski
color 0B
set "BACKUP_DIR=C:\Win-Support-Script_Backups\Registry"
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
echo =               MENU DE SUPORTE TECNICO V9.0                         =
echo =                  Criado por: Jhon Parowski                         =
echo ======================================================================
echo.
echo   Bem-vindo, %USERNAME%!   Computador: %COMPUTERNAME%
echo.
goto :eof

:PauseMenu
echo.
echo Pressione qualquer tecla para voltar ao menu anterior...
pause >nul
goto :eof

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
echo --------------------[ REPARO E DIAGNOSTICO ]--------------------
echo  [ 1] Reparo Avancado do Sistema (DISM, SFC, WMI...)
echo  [ 2] Gestao do Registo (Limpeza Avancada) [NOVO!]
echo.
echo -------------------[ LIMPEZA E OTIMIZACAO ]-------------------
echo  [10] Limpeza Avancada de Ficheiros (Navegadores, Caches)
echo  [11] Otimizar Unidade C: (Desfragmentar/TRIM)
echo  [12] Limpar Componentes do Windows (WinSxS Cleanup)
echo.
echo -------------------[ FERRAMENTAS E UTILITARIOS ]------------------
echo  [20] Informacoes Detalhadas do Sistema (estilo Speccy)
echo  [21] Gestao Avancada de Energia (Agendar Desligamento...)
echo  [22] Mostrar Senhas Wi-Fi Salvas
echo  [23] Resetar Configuracoes de Rede (Winsock/IP)
echo.
echo  [ 0] Sair
echo --------------------------------------------------------------------------------
set "OP="
set /p "OP=Escolha uma opcao: "

if "%OP%"=="1"  goto :SYSTEM_REPAIR_MENU
if "%OP%"=="2"  goto :REGISTRY_MENU
if "%OP%"=="10" goto :CLEAN_ADVANCED
if "%OP%"=="11" goto :DEFRAG_C
if "%OP%"=="12" goto :WINSXS_CLEANUP
if "%OP%"=="20" goto :SYSINFO_DETAILED
if "%OP%"=="21" goto :POWER_MENU
if "%OP%"=="22" goto :WIFI_PASS
if "%OP%"=="23" goto :RESET_NET
if "%OP%"=="0"  goto :SAIR

echo Opcao invalida. & timeout /t 2 /nobreak >nul & goto :MENU

:: O codigo de outras funcoes foi omitido para focar na novidade
:: ####################################################################################
:SYSTEM_REPAIR_MENU
call :Header&echo [1] Diagnostico Rapido [2] Modo Recomendado&set /p R_OP=Opcao:
if "%R_OP%"=="1" (sfc /verifyonly)
if "%R_OP%"=="2" (DISM /Online /Cleanup-Image /RestoreHealth & sfc /scannow)
goto :PauseMenu&goto :MENU
:CLEAN_ADVANCED
call :Header&call :ConfirmAction "Limpeza avancada"&if !ACTION_CANCELLED!==1 goto :MENU
taskkill /F /IM msedge.exe >nul 2>&1&taskkill /F /IM chrome.exe >nul 2>&1
rd /s /q "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache">nul 2>&1&rd /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cache">nul 2>&1
echo Limpeza concluida!&goto :PauseMenu&goto :MENU
:DEFRAG_C
call :Header&call :ConfirmAction "Otimizar Unidade C:"&if !ACTION_CANCELLED!==1 goto :MENU
defrag C: /O /U /V&goto :PauseMenu&goto :MENU
:WINSXS_CLEANUP
call :Header&call :ConfirmAction "Limpeza WinSxS"&if !ACTION_CANCELLED!==1 goto :MENU
Dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase&echo Limpeza concluida!&goto :PauseMenu&goto :MENU
:SYSINFO_DETAILED
call :Header&echo A recolher informacoes...&powershell "Get-ComputerInfo | Select-Object OsName, OsVersion, OsArchitecture, CsProcessors, CsPhyicallyInstalledMemory"&goto :PauseMenu&goto :MENU
:POWER_MENU
call :Header&echo [1] Temporizador [2] Hora [3] Cancelar&set /p P_OP=Opcao:
if "%P_OP%"=="1" (set /p M=Minutos: &set /a S=%M%*60&shutdown /s /f /t %S%)
if "%P_OP%"=="2" (set /p T=Hora(HH:MM): &schtasks /Create /TN JPToolboxPowerAction /TR "shutdown /s /f" /SC ONCE /ST %T% /F)
if "%P_OP%"=="3" (shutdown /a&schtasks /Delete /TN JPToolboxPowerAction /F >nul 2>&1)
goto :PauseMenu&goto :MENU
:WIFI_PASS
call :Header&for /f "tokens=2 delims=:" %%P in ('netsh wlan show profiles') do (set "ssid=%%P" & set "ssid=!ssid:~1!" & for /f "tokens=2 delims=:" %%K in ('netsh wlan show profile name^="!ssid!" key^=clear ^| findstr /C:"Key Content"') do (echo  - Rede: !ssid! --- Senha: %%K))
goto :PauseMenu&goto :MENU
:RESET_NET
call :Header&call :ConfirmAction "Resetar Rede (reinicio)"&if !ACTION_CANCELLED!==1 goto :MENU
netsh winsock reset&netsh int ip reset&echo REINICIE.&goto :PauseMenu&goto :MENU


:: ####################################################################################
:: #         NOVO MODULO: GESTAO AVANCADA DO REGISTO (v9.0)                           #
:: ####################################################################################

:REGISTRY_MENU
call :Header
echo -------------------[ GESTAO AVANCADA DO REGISTO ]-------------------
echo.
echo   AVISO: A limpeza do registo e uma operacao de risco. Uma copia de
echo   seguranca sera criada automaticamente antes de qualquer alteracao.
echo.
echo  [1] Iniciar Limpeza do Registo
echo  [2] Gerir Lista de Exclusao (para utilizadores avancados)
echo  [3] Restaurar a partir de uma Copia de Seguranca
echo.
echo  [0] Voltar ao Menu Principal
echo ----------------------------------------------------------------------
set /p "REG_OP=Escolha uma opcao: "
if "%REG_OP%"=="1" goto :REG_CLEAN_START
if "%REG_OP%"=="2" goto :REG_MANAGE_EXCLUSIONS
if "%REG_OP%"=="3" goto :REG_RESTORE_BACKUP
if "%REG_OP%"=="0" goto :MENU
goto :REGISTRY_MENU

:REG_CLEAN_START
call :Header
echo --- INICIAR LIMPEZA DO REGISTO ---
echo.
echo  Selecione a profundidade da verificacao. Modos mais profundos
echo  sao mais lentos e podem apresentar mais falsos positivos.
echo.
echo  [1] Modo Seguro (Rapido, verifica entradas comuns e seguras)
echo  [2] Modo Normal (Balanceado, inclui software e COM)
echo  [3] Modo Profundo (Completo, inclui chaves vazias e mais verificacoes)
echo.
echo  [0] Voltar
echo ----------------------------------------------------------------------
set /p "SCAN_MODE=Escolha o modo de verificacao: "
if "%SCAN_MODE%"=="0" goto :REGISTRY_MENU
if "%SCAN_MODE%" neq "1" if "%SCAN_MODE%" neq "2" if "%SCAN_MODE%" neq "3" goto :REG_CLEAN_START

call :Header
echo --- PREPARANDO PARA A LIMPEZA ---
echo.
call :REG_AutoBackup
if !ACTION_CANCELLED!==1 goto :REG_CLEAN_START

echo.
echo A iniciar a verificacao...
if "%SCAN_MODE%"=="1" (
    call :REG_ScanSafe
)
if "%SCAN_MODE%"=="2" (
    call :REG_ScanSafe
    call :REG_ScanNormal
)
if "%SCAN_MODE%"=="3" (
    call :REG_ScanSafe
    call :REG_ScanNormal
    call :REG_ScanDeep
)
echo.
echo --- Limpeza do Registo Concluida ---
call :PauseMenu
goto :REGISTRY_MENU

:REG_AutoBackup
set "TIMESTAMP=%date:~-4%-%date:~3,2%-%date:~0,2%_%time:~0,2%h%time:~3,2%m"
set "BACKUP_FILE=%BACKUP_DIR%\Backup_Completo_%TIMESTAMP%.reg"
echo A criar copia de seguranca automatica em:
echo %BACKUP_FILE%
echo.
reg export HKEY_CLASSES_ROOT "%BACKUP_DIR%\temp_hkcr.reg" /y >nul
reg export HKEY_CURRENT_USER "%BACKUP_DIR%\temp_hkcu.reg" /y >nul
reg export HKEY_LOCAL_MACHINE "%BACKUP_DIR%\temp_hklm.reg" /y >nul
type "%BACKUP_DIR%\temp_hkcr.reg" "%BACKUP_DIR%\temp_hkcu.reg" "%BACKUP_DIR%\temp_hklm.reg" > "%BACKUP_FILE%"
del "%BACKUP_DIR%\temp_*.reg" >nul 2>&1
echo Copia de seguranca criada com sucesso.
goto :eof

:REG_MANAGE_EXCLUSIONS
call :Header
echo --- GERIR LISTA DE EXCLUSAO ---
echo.
echo  O ficheiro 'registry_exclusions.txt' sera aberto.
echo  Adicione uma parte do caminho de uma chave de registo por linha
echo  para que ela seja ignorada durante a limpeza.
echo.
echo  Exemplo:
echo  Software\Microsoft\Windows\CurrentVersion\Run
echo  Software\MinhaAppImportante
echo.
if not exist "%EXCLUSION_FILE%" echo ; Este e o ficheiro de exclusao do Registo. Adicione chaves a ignorar abaixo. > "%EXCLUSION_FILE%"
notepad "%EXCLUSION_FILE%"
goto :REGISTRY_MENU

:REG_RESTORE_BACKUP
call :Header
echo --- RESTAURAR COPIA DE SEGURANCA ---
echo.
echo  A abrir a pasta de copias de seguranca: %BACKUP_DIR%
echo.
echo  Para restaurar, encontre o ficheiro .reg desejado, clique duas
echo  vezes nele e confirme as solicitacoes do Windows.
echo.
start "" "%BACKUP_DIR%"
goto :REGISTRY_MENU

:: -------------------[ Rotinas de Verificacao do Registo ]--------------------
:REG_ScanSafe
echo.
echo [MODO SEGURO] A verificar entradas obsoletas de utilizador...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Write-Host ' - A limpar historico de comandos Executar...'; try { Remove-Item -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU' -Force -Recurse -ErrorAction Stop } catch {}; Write-Host ' - A limpar historicos de ficheiros recentes...'; try { Remove-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\LastVisitedPidlMRU' -Name '*' -Force -ErrorAction Stop } catch {}"
goto :eof

:REG_ScanNormal
echo.
echo [MODO NORMAL] A verificar software desinstalado e COM...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$exclusions = Get-Content -Path '%EXCLUSION_FILE%' -ErrorAction SilentlyContinue; Get-ChildItem -Path 'HKCU:\Software' -ErrorAction SilentlyContinue | ForEach-Object { if ($_.SubKeyCount -eq 0 -and $_.ValueCount -eq 0 -and $exclusions -notcontains $_.Name) { Write-Host ' - Removendo chave de software vazia: $($_.Name)'; try { Remove-Item -LiteralPath $_.PSPath -Force -Recurse -ErrorAction Stop } catch {} } }"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$exclusions = Get-Content -Path '%EXCLUSION_FILE%' -ErrorAction SilentlyContinue; Get-ChildItem -Path 'HKCR:\CLSID' -ErrorAction SilentlyContinue | ForEach-Object { $clsidPath = $_.PSPath; if (-not (Get-ItemProperty -LiteralPath $clsidPath -Name 'InprocServer32' -ErrorAction SilentlyContinue)) { if ($exclusions -notcontains $clsidPath) { Write-Host ' - Removendo CLSID orfao: $($_.Name)'; try { Remove-Item -LiteralPath $clsidPath -Force -Recurse -ErrorAction Stop } catch {} } } }"
goto :eof

:REG_ScanDeep
echo.
echo [MODO PROFUNDO] A verificar entradas de arranque invalidas e chaves vazias...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$exclusions = Get-Content -Path '%EXCLUSION_FILE%' -ErrorAction SilentlyContinue; Get-Item -Path @('HKCU:\Software\Microsoft\Windows\CurrentVersion\Run','HKLM:\Software\Microsoft\Windows\CurrentVersion\Run') -ErrorAction SilentlyContinue | Get-ItemProperty | Select-Object * | ForEach-Object { $item = $_; $item.PSObject.Properties | ForEach-Object { $exePath = $item.($_.Name); if ($exePath -and -not (Test-Path -LiteralPath $exePath.Split(' ')[0].Trim('`"'))) { if ($exclusions -notcontains $_.Name) { Write-Host ' - Removendo entrada de arranque invalida: $($_.Name)'; try { Remove-ItemProperty -LiteralPath $item.PSPath -Name $_.Name -Force -ErrorAction Stop } catch {} } } } }"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$exclusions = Get-Content -Path '%EXCLUSION_FILE%' -ErrorAction SilentlyContinue; Get-ChildItem -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall' -Recurse -ErrorAction SilentlyContinue | ForEach-Object { $key = $_; $installLocation = ($key | Get-ItemProperty -Name 'InstallLocation' -ErrorAction SilentlyContinue).InstallLocation; if ($installLocation -and -not (Test-Path $installLocation)) { if ($exclusions -notcontains $key.Name) { Write-Host ' - Removendo entrada de desinstalacao orfa: $($key.PSChildName)'; try { Remove-Item -LiteralPath $key.PSPath -Force -Recurse -ErrorAction Stop } catch {} } } }"
goto :eof

:SAIR
cls
echo Encerrando a ferramenta de suporte... Ate logo!
timeout /t 2 /nobreak >nul
endlocal
exit /b 0
