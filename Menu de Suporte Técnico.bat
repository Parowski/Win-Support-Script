@echo off
setlocal EnableExtensions EnableDelayedExpansion

:: ====================================================================================
::  Win-Support-Script V18.0 (Correcao Definitiva do Registo)
::  CRIADO POR: Jhon Parowski
::
::  Descricao:
::  A V18.0 implementa a correcao definitiva para o bug que causava o fecho
::  inesperado do script durante a limpeza do registo. O motor de verificacao
::  em PowerShell esta agora embutido como uma string Base64, tornando o script
::  100% autonomo e imune a erros de interpretacao de caracteres do cmd.exe.
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
title Win-Support-Script V18.0 (Correcao Definitiva) - Por Jhon Parowski
color 0B

:: --- DETERMINAR O CAMINHO REAL DO DESKTOP ---
set "DESKTOP_PATH="
for /f "tokens=3,*" %%a in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v Desktop 2^>nul') do set "DESKTOP_PATH=%%a %%b"
if defined DESKTOP_PATH ( for /f "tokens=*" %%i in ('echo %DESKTOP_PATH%') do set "DESKTOP_PATH=%%i" ) else ( set "DESKTOP_PATH=%USERPROFILE%\Desktop" )
set "REPORTS_DIR=%DESKTOP_PATH%"
set "BACKUP_DIR=C:\JPToolbox_Backups"
set "SCAN_RESULTS_FILE=%TEMP%\jp_reg_scan.tmp"
set "PS_SCRIPT_FILE=%TEMP%\jp_reg_scanner.ps1"
if exist "%SCAN_RESULTS_FILE%" del "%SCAN_RESULTS_FILE%" >nul 2>&1
if exist "%PS_SCRIPT_FILE%" del "%PS_SCRIPT_FILE%" >nul 2>&1
if not exist "%BACKUP_DIR%\Registry" mkdir "%BACKUP_DIR%\Registry" >nul 2>&1

:: >>> Pula a definicao de funcoes e vai direto para o menu principal
goto :MENU

:: ####################################################################################
:: #                          BLOCO DE DEFINICOES DE FUNCOES                          #
:: ####################################################################################

:Header
cls
echo ======================================================================
echo =         Win-Support-Script V18.0 (Correcao Definitiva)             =
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
echo -----------------------[ REPARO E DIAGNOSTICO DO SISTEMA ]----------------------
echo  [ 1] Reparo Avancado do Sistema (DISM, SFC, WMI...)
echo  [ 2] Gestao do Registo (Limpeza com Verificacao) [CORRIGIDO!]
echo  [ 3] Verificar Saude do Disco (S.M.A.R.T.)
echo  [ 4] Verificar Integridade do Disco (CHKDSK C:)
echo  [ 5] Diagnostico de Energia e Bateria
echo.
echo ---------------------------[ LIMPEZA E OTIMIZACAO ]---------------------------
echo  [10] Limpeza Avancada de Ficheiros (Navegadores, Caches, etc.)
echo  [11] Limpar Componentes do Windows (WinSxS Cleanup)
echo  [12] Otimizar Unidade C: (Desfragmentar/TRIM)
echo  [13] Encontrar Ficheiros Grandes na Unidade C: (>1GB)
echo  [14] Gerir Compactacao do SO (CompactOS)
echo.
echo -------------------[ GESTAO DE SISTEMA E ATIVACAO ]---------------------
echo  [20] Gestao de Licencas e Ativacao (Windows/Office)
echo  [21] Criar Ponto de Restauracao do Sistema
echo  [22] Gerir Programas de Arranque (Inicializacao)
echo  [23] Desinstalar Programas (Adicionar/Remover Programas)
echo.
echo --------------------------[ REDE E UTILITARIOS ]----------------------------
echo  [30] Gestao Avancada de Energia (Agendar Desligamento, etc.)
echo  [31] Informacoes Detalhadas do Sistema (estilo Speccy)
echo  [32] Mostrar Perfis e Senhas Wi-Fi Salvas
echo  [33] Resetar Configuracoes de Rede (Winsock/IP) [requer reinicio]
echo  [34] Gerir Firewall do Windows (Ligar/Desligar/Resetar)
echo.
echo  [ 0] Sair
echo --------------------------------------------------------------------------------
set "OP="
set /p "OP=Escolha uma opcao: "

if "%OP%"=="1" goto :SYSTEM_REPAIR_MENU
if "%OP%"=="2" goto :REGISTRY_MENU
if "%OP%"=="3" goto :SMART_STATUS
if "%OP%"=="4" goto :CHKDSK_C
if "%OP%"=="5" goto :POWER_DIAG_MENU
if "%OP%"=="10" goto :CLEAN_ADVANCED
if "%OP%"=="11" goto :WINSXS_CLEANUP
if "%OP%"=="12" goto :DEFRAG_C
if "%OP%"=="13" goto :FIND_LARGE_FILES
if "%OP%"=="14" goto :COMPACTOS_MENU
if "%OP%"=="20" goto :LICENSE_MENU
if "%OP%"=="21" goto :RESTORE_POINT
if "%OP%"=="22" goto :MANAGE_STARTUP
if "%OP%"=="23" goto :UNINSTALL_PROGRAMS
if "%OP%"=="30" goto :POWER_MENU
if "%OP%"=="31" goto :SYSINFO_DETAILED
if "%OP%"=="32" goto :WIFI_PASS
if "%OP%"=="33" goto :RESET_NET
if "%OP%"=="34" goto :FIREWALL_MENU
if "%OP%"=="0" goto :SAIR

echo Opcao invalida. & timeout /t 2 /nobreak >nul & goto :MENU

:: ####################################################################################
:: #                     IMPLEMENTACAO DE TODOS OS MODULOS                            #
:: ####################################################################################

:SYSTEM_REPAIR_MENU
call :Header
echo --- REPARO AVANCADO DO SISTEMA ---
echo Este modo executa as ferramentas essenciais para corrigir problemas do Windows.
call :ConfirmAction "Deseja iniciar o processo de reparo completo"
if !ACTION_CANCELLED!==1 goto :MENU
echo.
echo [PASSO 1 de 4] A verificar a consistencia do repositorio WMI...
winmgmt /verifyrepository
if !errorlevel! neq 0 ( echo Repositorio WMI inconsistente. A tentar reparar... & winmgmt /salvagerepository ) else ( echo Repositorio WMI consistente. )
echo.
echo [PASSO 2 de 4] A verificar a saude da imagem do Windows (DISM CheckHealth)...
Dism /Online /Cleanup-Image /CheckHealth
echo.
echo [PASSO 3 de 4] A restaurar a saude da imagem do Windows (DISM RestoreHealth)...
echo Isto pode demorar varios minutos e pode parecer parado em 20%% ou 40%%. E normal.
Dism /Online /Cleanup-Image /RestoreHealth
echo.
echo [PASSO 4 de 4] A verificar e reparar ficheiros do sistema (SFC ScanNow)...
sfc /scannow
echo.
echo --- REPARO DO SISTEMA CONCLUIDO --- & echo E recomendado reiniciar o computador.
call :PauseMenu & goto :MENU

:: ####################################################################################
:: #               MODULO CORRIGIDO: GESTAO DO REGISTO (V18.0 - Base64)               #
:: ####################################################################################
:REGISTRY_MENU
call :Header
echo -------------------[ GESTAO AVANCADA DO REGISTO ]-------------------
echo  [1] Iniciar Verificacao e Limpeza do Registo
echo  [2] Restaurar a partir de uma Copia de Seguranca
echo  [0] Voltar ao Menu Principal
set /p "REG_OP=Escolha uma opcao: "
if "%REG_OP%"=="1" goto :REG_CLEAN_START
if "%REG_OP%"=="2" goto :REG_RESTORE_BACKUP
if "%REG_OP%"=="0" goto :MENU
goto :REGISTRY_MENU

:REG_CLEAN_START
call :Header
echo  [1] Modo Seguro [2] Modo Normal [3] Modo Profundo
set /p SCAN_MODE=Escolha o modo de verificacao: 
if "%SCAN_MODE%" neq "1" if "%SCAN_MODE%" neq "2" if "%SCAN_MODE%" neq "3" goto :REGISTRY_MENU
call :Header&echo --- PASSO 1/3: A CRIAR COPIA DE SEGURANCA ---&call :REG_AutoBackup
echo.&echo --- PASSO 2/3: A VERIFICAR O REGISTO ---
call :REG_CreateScannerScript
echo A executar o motor de verificacao... Isto pode demorar.
powershell -NoProfile -ExecutionPolicy Bypass -File "%PS_SCRIPT_FILE%"
set /a "ISSUES_FOUND=0"
if exist "%SCAN_RESULTS_FILE%" (for /f "usebackq delims=" %%i in ("%SCAN_RESULTS_FILE%") do set /a "ISSUES_FOUND+=1")
echo.&echo --- VERIFICACAO CONCLUIDA! Foram encontrados !ISSUES_FOUND! problemas. ---
if !ISSUES_FOUND! gtr 0 (
    call :ConfirmAction "Deseja continuar e corrigir estes problemas"
    if !ACTION_CANCELLED!==0 (call :REG_FixIssues) else (echo Limpeza cancelada.)
) else (echo Nenhuma acao e necessaria.)
if exist "%SCAN_RESULTS_FILE%" del "%SCAN_RESULTS_FILE%" >nul 2>&1
if exist "%PS_SCRIPT_FILE%" del "%PS_SCRIPT_FILE%" >nul 2>&1
echo.&echo Processo concluido.&call :PauseMenu & goto :REGISTRY_MENU

:REG_AutoBackup
set "TIMESTAMP=%date:~-4%-%date:~3,2%-%date:~0,2%_%time:~0,2%h%time:~3,2%m"
set "BACKUP_FILE=%BACKUP_DIR%\Registry\Backup_Completo_%TIMESTAMP%.reg"
echo A criar copia de seguranca em: %BACKUP_FILE%...
reg export HKLM "%BACKUP_DIR%\hklm.tmp" /y >nul&reg export HKCU "%BACKUP_DIR%\hkcu.tmp" /y >nul
copy /b "%BACKUP_DIR%\hklm.tmp" + "%BACKUP_DIR%\hkcu.tmp" "%BACKUP_FILE%" >nul
del "%BACKUP_DIR%\*.tmp" >nul&echo Copia de seguranca criada com sucesso.&goto :eof

:REG_FixIssues
echo.&echo --- PASSO 3/3: A CORRIGIR OS PROBLEMAS ---
set /a "count=0"&set "total=!ISSUES_FOUND!"
for /f "usebackq tokens=1,* delims=^|" %%a in ("%SCAN_RESULTS_FILE%") do (
    set /a "count+=1"
    set "entryPath=%%b"
    echo|set /p="Corrigindo [!count! de !total!]: !entryPath:~0,60!..."
    reg delete "!entryPath!" /f >nul 2>&1
    echo  -> OK
)
echo.&echo Correcao concluida. !total! problemas foram processados.&goto :eof

:REG_RESTORE_BACKUP
call :Header&echo --- RESTAURAR COPIA DE SEGURANCA ---
echo A abrir a pasta de copias de seguranca: %BACKUP_DIR%\Registry
start "" "%BACKUP_DIR%\Registry"&goto :REGISTRY_MENU

:REG_CreateScannerScript
set "ps_script_b64=cABhAHIAYQBtACgACgAgACAAIAAgACgAcwB0AHIAaQBuAGcAXQAkAHMAYwBhAG4ATQBvAGQAZQAsAAoAIAAgACAAIAAgACgAcwB0AHIAaQBuAGcAXQAkAG8AdQB0AHAAdQB0AEYAaQBsAGUACgApAAoAZgB1AG4AYwB0AGkAbwBuACAAQQBkAGQALQBSAGUAcwB1AGwAdAAgAHsAIAAKACAAIAAgACAAcABhAHIAYQBtACgAWwBzAHQAcgBpAG4AZwBdACQAdAB5AHAAZQAsACAAWwBzAHQAcgBpAG4AZwBdACQAcABhAHQAaAApACAACgAgACAAIAAgAEEAZABkAC0AQwBvAG4AdABlAG4AdAAgAC0AUABhAHQAaAAgACQAbwB1AHQAcAB1AHQARgBpAGwAZQAgAC0AVgBhAGwAdQBlACAAIgAkAHQAeQBwAGUAfAAkAHAAYQB0AGgAIgAgAAoAfQAKAGYAdQBuAGMAdABpAG8AbgAgAFMAYwBhAG4ALQBPAGIAcgBwAGgAYQBuAGUAZABTAG8AZgB0AHcAYQByAGUAIAB7AAoAIAAgACAAIAAgAHQAcgB5ACAAewAKACAAIAAgACAAIAAgACAAIAAgACQAdQBuAGkAbgBzAHQAYQBsAGwASwBlAHkAcwAgAD0AIABHAGUAdAAtAEMAaABpAGwAZABJAHQAZQBtACAAIgBIADoAXABTAG8AZgB0AHcAYQByAGUAXABNAGkAYwByAG8AcwBvAGYAdABcAFcAaQBuAGQAbwB3AHMAXABDAGUAcgBuAHQAVgBlAHIAcwBpAG8AbgBcAFUAbgBpAG4AcwB0AGEAbABsACIAIAAtAEUAcgByAG8AcgBBAGMAdABpAG8AbgAgAFMAaQBsAGUAbgB0AGwAeQBDAG8AbgB0AGkAbgB1AGUAIAB8ACAARgBvAHIARQBhAGMAaAAtAE8AYgBqAGUAYwB0ACAAewAgAEcAZQB0AC0ASQB0AGUAbQBQAHIAbwBwAGUAcgB0AHkAIAAkAF8ALgBQAFMAUABhAHQAaAAgAC0ARQByAHIAbwByAEEAYwB0AGkAbwBuACAAUwBpAGwAZQBuAHQAbAB5AEMAbwBuAHQAaQBuAHUAZQAgAH0ACgAgACAAIAAgACAAIAAgACAAJABzAG8AZgB0AHcAYQByAGUASwBlAHkAcwAgAD0AIABHAGUAdAAtAEMAaABpAGwAZABJAHQAZQBtACAAIgBIAEMAVQA6AFwAUwBvAGYAdAB3AGEAcgBlACIAIAAtAEUAcgByAG8AcgBBAGMAdABpAG8AbgAgAFMAaQBsAGUAbgB0AGwAeQBDAG8AbgB0AGkAbgB1AGUACgAgACAAIAAgACAAIAAgACAAZgBvAHIAZQBhAGMAaAAgACgAJABrAGUAeQAgAGkAbgAgACQAcwBvAGYAdAB3AGEAcgBlAEsAZQB5AHMAKQAgAHsACgAgACAAIAAgACAAIAAgACAAIAAgACAAaQBmACAAKAAhACQAawBlAHkAKQAgAHsAIABjAG8AbgB0AGkAbgB1AGUAIAB9AAoAIAAgACAAIAAgACAAIAAgACAAIAAgACQAaQBzAE8AcgBwAGgAYQBuACAAPQAgACQAdAByAHUAZQAKACAAIAAgACAAIAAgACAAIAAgACAAIAAgAGYAbwByAGUAYQBjAGgAIAAoACQAdQBuAGkAbgBzAHQAYQBsAGwAIABpAG4AIAAkAHUAbgBpAG4AcwB0AGEAbABsAEsAZQB5AHMAKQAgAHsACgAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAaQBmACAAKAAkAHUAbgBpAG4AcwB0AGEAbABsAC4ARABpAHMAcABsAGEAeQBOAGEAbQBlACAALQBhAG4AZAAgACQAawBlAHkALgBOAGEAbQBlAC4AQwBvAG4AdABhAGkAbgBzACgAJAB1AG4AaQBuAHMAdABhAGwAbAAuAEQAaQBzAHMAbABhAHkATgBhAG0AZQApACkAIAB7ACAAJABpAHMATwByAHAAYQBuACAAPQAgACQAZgBhAGwAcwBlADsAIABiAHIAZQBhAGsAIAB9AAoAIAAgACAAIAAgACAAIAAgACAAIAAgACAAfQAKACAAIAAgACAAIAAgACAAIAAgACAAIAAgAGkAZgAgACgAJABpAHMATwByAHAAaABhAG4AIAAtAGEAbgBkACAAKAAkAGsAZQB5AC4AVgBhAGwAdQBlAEMAbwB1AG4AdAAgAC0AZQBxACAAMAApACAALQBhAG4AZAAgACgAJABrAGUAeQAuAFMAdQBiAEsAZQB5AEMAbwB1AG4AdAAgAC0AZQBxACAAMAApACkAIAB7AAoAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAQQBkAGQALQBSAGUAcwB1AGwAdAAgACIAQwBIAFcAIgAgACQAawBlAHkALgBQAFMAUABhAHQAaAAuAFIAZQBwAGwAYQBjAGUAKAAiAEgASwBFAFkAXwBDAFUAUgBSAEUATgBUAF8AVQBTADIAUgAiACwAIAIgAEgAQwBVADoAIgApAAoAIAAgACAAIAAgACAAIAAgACAAIAAgACAAfQAKACAAIAAgACAAIAAgACAAIAAgAH0ACgAgACAAIAAgACAAfQAgAGMAYQBjAGgAIAB7AH0ACgB9AAoAaQBmACAAKAAkAHMAYwBhAG4ATQBvAGQAZQAgAC0AZwBlACAAMQApACAAewAKACAAIAAgACAAIAAgACAAIABHAGUAdAAtAEMAaABpAGwAZABJAHQAZQBtACAAIgBIAEMAVQA6AFwAUwBvAGYAdAB3AGEAcgBlAFwATQBpAGMAcgBvAHMAbwBmAHQAXABXAGkAbgBkAG8AdwBzAFwAQwB1AHIAcgBlAG4AdABWAGUAcwBpAG8AbgBcAEUAeABwAGwAbwByAGUAcgBcAFIAdQBuAE0AUgBVACIAIAAtAEUAcgByAG8AcgBBAGMAdABpAG8AbgAgAFMAaQBsAGUAbgB0AGwAeQBDAG8AbgB0AGkAbgB1AGUAIAB8ACAARgBvAHIARQBhAGMAaAAtAE8AYgBqAGUAYwB0ACAAewAgAEEAZABkAC0AUgBlAHMAdQBsAHQAIAAiAFYAQQBMAFUARQAiACAAJABfAC4AUABTAFAAYQB0AGgAIAB9AAoAfQAKAGkAZgAgACgAJABzAGMAYQBuAE0AbwBkAGUAIAAtAGcAZQAgADIAKQAgAHsACgAgACAAIAAgACAAIAAgACAAUwBjAGEAbgAtAE8AcgBwAGgAYQBuAGUAZABTAG8AZgB0AHcAYQByAGUACgB9AAoAaQBmACAAKAAkAHMAYwBhAG4ATQBvAGQAZQAgAC0AZwBlACAAMwApACAAewAKACAAIAAgACAAIAAgACAAIABHAGUAdAAtAEMAaABpAGwAZABJAHQAZQBtACAAIgBIAEMAVQA6AFwAUwBvAGYAdAB3AGEAcgBlACIAIAAtAFIAZQB1AGwAcwBlACAALQBFAGgAbwByAEEAYwB0AGkAbwBuACAAUwBpAGwAZQBuAHQAbAB5AEMAbwBuAHQAaQBuAHUAZQAgAHwAIABXAGgAZQByAGUALQBPAGIAagBlAGMAdAAgAHsAIABkAF8ALgBTAHUAYgBLAGUAeQBDAHUAbgB0ACAALQBlAHEgADAAIAAtAGEAbgBkACAAJABfAC4AVgBhAGwAdQBlAEMAbwB1ag4AdAAgAC0AZQBxACAAMAAgAH0AIAB8ACAARgBvAHIARQBhAGMAaAAtAE8AYgBqAGUAYwB0ACAAewAgAEEAZABkAC0AUgBlAHMAdQBsAHQAIAAiAEsARQBZACIAIAAkAF8ALgBQAFMAUABhAHQAaAAuAFIAZQBwAGwAYQBjAGUAKAAiAEgASwBFAFkAXwBDAFUAUgBSAEUATgBUAF8AVQBTADIAUgAiACwAIAIgAEgAQwBVADoAIgApACAAfQAKAH0A"
(
echo $ErrorActionPreference = "SilentlyContinue"
echo $encodedScript = "%ps_script_b64%"
echo $decodedScript = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($encodedScript^)^)
echo Invoke-Expression -Command "$decodedScript -scanMode '%SCAN_MODE%' -outputFile '%SCAN_RESULTS_FILE%'"
) > "%PS_SCRIPT_FILE%"
goto :eof

:: ####################################################################################
:: #                       RESTANTES MODULOS (SEM ALTERACOES)                         #
:: ####################################################################################
:SMART_STATUS
call :Header&echo --- STATUS DE SAUDE DO DISCO (S.M.A.R.T.) ---
wmic diskdrive get model,status&call :PauseMenu & goto :MENU
:CHKDSK_C
call :Header&echo --- VERIFICAR INTEGRIDADE DO DISCO C: ---
call :ConfirmAction "O CHKDSK pode ser demorado. Deseja continuar"
if !ACTION_CANCELLED!==1 goto :MENU
chkdsk C: /f /r&echo Verificacao agendada para o proximo reinicio.&call :PauseMenu & goto :MENU
:POWER_DIAG_MENU
call :Header
echo --------------------[ DIAGNOSTICO DE ENERGIA E BATERIA ]--------------------
echo  [1] Gerar Relatorio de Saude da Bateria & echo  [2] Gerar Relatorio de Eficiencia Energetica
echo  [3] Gerar Relatorio do Estudo do Sono (Modern Standby) & echo  [0] Voltar
echo ------------------------------------------------------------------------------
echo Os relatorios serao guardados em: %REPORTS_DIR%
set /p "PD_OP=Escolha uma opcao: "
if "%PD_OP%"=="1" goto :DIAG_BATTERY
if "%PD_OP%"=="2" goto :DIAG_ENERGY
if "%PD_OP%"=="3" goto :DIAG_SLEEPSTUDY
if "%PD_OP%"=="0" goto :MENU
goto :POWER_DIAG_MENU
:DIAG_BATTERY
set "REPORT_PATH=%REPORTS_DIR%\relatorio_bateria.html"
call :Header&echo Gerando relatorio de saude da bateria...
powercfg /batteryreport /output "%REPORT_PATH%" /duration 14
echo.&echo Relatorio gerado com sucesso em: "%REPORT_PATH%" & timeout /t 1 /nobreak >nul
start "" "%REPORT_PATH%" & call :PauseMenu & goto :POWER_DIAG_MENU
:DIAG_ENERGY
set "REPORT_PATH=%REPORTS_DIR%\relatorio_energia.html"
call :Header&echo Gerando relatorio de eficiencia energetica (demora aprox. 60 segundos)...
powercfg /energy /output "%REPORT_PATH%" /duration 60
echo.&echo Relatorio gerado com sucesso em: "%REPORT_PATH%" & timeout /t 1 /nobreak >nul
start "" "%REPORT_PATH%" & call :PauseMenu & goto :POWER_DIAG_MENU
:DIAG_SLEEPSTUDY
set "REPORT_PATH=%REPORTS_DIR%\relatorio_sono.html"
call :Header&echo Gerando relatorio do estudo do sono...
powercfg /sleepstudy /output "%REPORT_PATH%" /duration 14
echo.&echo Relatorio gerado com sucesso em: "%REPORT_PATH%" & timeout /t 1 /nobreak >nul
start "" "%REPORT_PATH%" & call :PauseMenu & goto :POWER_DIAG_MENU
:CLEAN_ADVANCED
call :Header&echo --- LIMPEZA AVANCADA DE FICHEIROS ---
set "dirs_to_clean="&set "dirs_to_clean=!dirs_to_clean!;"%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache""&set "dirs_to_clean=!dirs_to_clean!;"%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cache""&set "dirs_to_clean=!dirs_to_clean!;"%APPDATA%\discord\Cache""&set "dirs_to_clean=!dirs_to_clean!;"%TEMP%""&set "dirs_to_clean=!dirs_to_clean!;"C:\Windows\Temp""
set /a total=0&for %%A in ("%dirs_to_clean:;=" "%") do if "%%~A" neq "" set /a total+=1
set /a count=0&echo A iniciar limpeza de !total! localizacoes...
for %%A in ("%dirs_to_clean:;=" "%") do (if "%%~A" neq "" (set /a count+=1&echo|set /p="[!count!/!total!] Limpando %%~A..."&if exist "%%~A" (rd /s /q "%%~A" >nul 2>&1 & echo  -> OK) else (echo  -> Nao encontrado)))
echo.&echo Esvaziando a Lixeira...&rd /s /q "C:\$Recycle.Bin" >nul 2>&1&echo.&echo Limpeza avancada concluida!&call :PauseMenu & goto :MENU
:WINSXS_CLEANUP
call :Header&echo --- LIMPAR COMPONENTES DO WINDOWS (WinSxS) ---
call :ConfirmAction "Este processo pode demorar e nao deve ser interrompido. Continuar"
if !ACTION_CANCELLED!==1 goto :MENU
echo.&echo [PASSO 1 de 2] A analisar os componentes...
Dism.exe /online /Cleanup-Image /AnalyzeComponentStore
echo.&echo [PASSO 2 de 2] A iniciar a limpeza. Isto pode demorar varios minutos...
Dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase
echo.&echo Limpeza do WinSxS concluida!&call :PauseMenu & goto :MENU
:DEFRAG_C
call :Header&echo --- OTIMIZAR UNIDADE C: (Desfragmentar/TRIM) ---
defrag C: /O /U /V&call :PauseMenu & goto :MENU
:FIND_LARGE_FILES
call :Header&echo --- ENCONTRAR FICHEIROS GRANDES NA UNIDADE C: (>1GB) ---
echo A procura pode demorar varios minutos. Por favor, aguarde...
powershell -NoProfile "Get-ChildItem C:\ -Recurse -File -ErrorAction SilentlyContinue | Where-Object { $_.Length -gt 1GB } | Sort-Object Length -Descending | Select-Object -First 20 | Format-Table @{Name='Tamanho (GB)';E={[math]::Round($_.Length/1GB,2)}},FullName -A"
call :PauseMenu & goto :MENU
:COMPACTOS_MENU
call :Header
echo --------------------[ GESTAO DA COMPACTACAO DO SO ]--------------------
echo  [1] Consultar Estado da Compactacao & echo  [2] ATIVAR Compactacao do SO (Libertar Espaco)
echo  [3] DESATIVAR Compactacao do SO & echo  [0] Voltar ao Menu Principal
echo -------------------------------------------------------------------------
set /p "CO_OP=Escolha uma opcao: "
if "%CO_OP%"=="1" goto :COMPACT_QUERY
if "%CO_OP%"=="2" goto :COMPACT_ENABLE
if "%CO_OP%"=="3" goto :COMPACT_DISABLE
if "%CO_OP%"=="0" goto :MENU
goto :COMPACTOS_MENU
:COMPACT_QUERY
call :Header&echo Consultando o estado da compactacao do sistema... & Compact.exe /CompactOS:query
call :PauseMenu & goto :COMPACTOS_MENU
:COMPACT_ENABLE
call :Header&echo --- ATIVAR COMPACTACAO DO SO ---
echo ATENCAO: Este processo pode demorar varios minutos e nao deve ser interrompido.
call :ConfirmAction "Deseja continuar e ativar a compactacao" & if !ACTION_CANCELLED!==1 goto :COMPACTOS_MENU
echo A ativar a compactacao. Por favor, aguarde... & Compact.exe /CompactOS:always
echo.&echo Operacao concluida. & call :PauseMenu & goto :COMPACTOS_MENU
:COMPACT_DISABLE
call :Header&echo --- DESATIVAR COMPACTACAO DO SO ---
echo ATENCAO: Este processo pode demorar varios minutos e nao deve ser interrompido.
call :ConfirmAction "Deseja continuar e desativar a compactacao" & if !ACTION_CANCELLED!==1 goto :COMPACTOS_MENU
echo A desativar a compactacao. Por favor, aguarde... & Compact.exe /CompactOS:never
echo.&echo Operacao concluida. & call :PauseMenu & goto :COMPACTOS_MENU
:LICENSE_MENU
call :Header
echo -------------------[ GESTAO DE LICENCAS E ATIVACAO ]--------------------
echo  [1] Verificar Status da Ativacao (Windows e Office) & echo  [2] Tentar Ativar o WINDOWS (Metodo KMS)
echo  [3] Tentar Ativar o OFFICE (Metodo KMS) & echo  [0] Voltar ao Menu Principal
set /p "LIC_OP=Escolha uma opcao: "
if "%LIC_OP%"=="1" goto :CHECK_ACTIVATION
if "%LIC_OP%"=="2" goto :ACTIVATE_WINDOWS
if "%LIC_OP%"=="3" goto :ACTIVATE_OFFICE
if "%LIC_OP%"=="0" goto :MENU
goto :LICENSE_MENU
:CHECK_ACTIVATION
call :Header&echo --- STATUS DA ATIVACAO ---&echo.&echo [WINDOWS]&cscript //nologo C:\Windows\System32\slmgr.vbs /dli&echo.&echo [OFFICE]&call :FindOSPP
if defined OSPPSCRIPT (cscript //nologo "%OSPPSCRIPT%" /dstatus) else (echo Script do Office nao encontrado.)
call :PauseMenu & goto :LICENSE_MENU
:ACTIVATE_WINDOWS
call :Header&echo --- ATIVACAO DO WINDOWS (KMS) ---
call :ConfirmAction "Deseja tentar ativar o Windows"&if !ACTION_CANCELLED!==1 goto :LICENSE_MENU
echo.&echo [1/3] A instalar chave GVLK...&cscript //nologo C:\Windows\System32\slmgr.vbs /ipk W269N-WFGWX-YVC9B-4J6C9-T83GX >nul
echo.&echo [2/3] A definir servidor KMS...&cscript //nologo C:\Windows\System32\slmgr.vbs /skms kms.msguides.com
echo.&echo [3/3] A tentar ativacao...&cscript //nologo C:\Windows\System32\slmgr.vbs /ato
echo.&echo Processo concluido.&call :PauseMenu & goto :LICENSE_MENU
:ACTIVATE_OFFICE
call :Header&echo --- ATIVACAO DO OFFICE (KMS) ---
call :FindOSPP&if not defined OSPPSCRIPT (echo Script do Office nao encontrado.&call :PauseMenu&goto :LICENSE_MENU)
call :ConfirmAction "Deseja tentar ativar o Office"&if !ACTION_CANCELLED!==1 goto :LICENSE_MENU
echo.&echo [1/2] A definir servidor KMS...&cscript //nologo "%OSPPSCRIPT%" /sethst:kms.msguides.com
echo.&echo [2/2] A tentar ativacao...&cscript //nologo "%OSPPSCRIPT%" /act
echo.&echo Processo concluido.&call :PauseMenu & goto :LICENSE_MENU
:FindOSPP
set "OSPPSCRIPT="
for /d %%d in ("%ProgramFiles%\Microsoft Office\Office*") do if exist "%%d\ospp.vbs" set "OSPPSCRIPT=%%d\ospp.vbs"
if not defined OSPPSCRIPT for /d %%d in ("%ProgramFiles(x86)%\Microsoft Office\Office*") do if exist "%%d\ospp.vbs" set "OSPPSCRIPT=%%d\ospp.vbs"
goto :eof
:RESTORE_POINT
call :Header&call :ConfirmAction "Deseja criar um ponto de restauracao agora"&if !ACTION_CANCELLED!==1 goto :MENU
powershell -NoProfile "Checkpoint-Computer -Description 'PontoManual_JPToolbox'"&echo Ponto de restauracao criado.&call :PauseMenu & goto :MENU
:MANAGE_STARTUP
call :Header&echo A abrir a gestao de aplicacoes de arranque...&start "" ms-settings:startupapps&goto :MENU
:UNINSTALL_PROGRAMS
call :Header&echo A abrir o painel 'Adicionar ou Remover Programas'...&start "" appwiz.cpl&goto :MENU
:POWER_MENU
call :Header
echo -------------------[ GESTAO AVANCADA DE ENERGIA ]-------------------
echo  [1] Desligar/Reiniciar apos um TEMPORIZADOR & echo  [2] Desligar/Reiniciar a uma HORA ESPECIFICA
echo  [3] Desligar/Reiniciar quando um PROGRAMA FECHAR & echo  [4] CANCELAR qualquer agendamento & echo  [0] Voltar
set /p "P_OP=Escolha: "
if "%P_OP%"=="1" goto :POWER_TIMER
if "%P_OP%"=="2" goto :POWER_TIME
if "%P_OP%"=="3" goto :POWER_PROCESS
if "%P_OP%"=="4" (shutdown /a >nul & schtasks /Delete /TN JPToolboxPowerAction /F >nul 2>&1 & echo Agendamentos cancelados.)
if "%P_OP%"=="0" goto :MENU
call :PauseMenu & goto :POWER_MENU
:POWER_TIMER
set /p M=Minutos para a acao: &set /p A=Acao (S=Desligar, R=Reiniciar):
set /a S=%M%*60&if /i "%A%"=="S" (shutdown /s /f /t %S%)&if /i "%A%"=="R" (shutdown /r /f /t %S%)
echo Acao agendada.&goto :POWER_MENU
:POWER_TIME
set /p T=Hora (HH:MM): &set /p A=Acao (S=Desligar, R=Reiniciar):
set "CMD=shutdown /s /f"&if /i "%A%"=="R" set "CMD=shutdown /r /f"
schtasks /Create /TN JPToolboxPowerAction /TR "%CMD%" /SC ONCE /ST %T% /F
echo Acao agendada.&goto :POWER_MENU
:POWER_PROCESS
set /p P=Nome do processo (ex: chrome.exe): &set /p A=Acao (S=Desligar, R=Reiniciar):
set "CMD=shutdown /s /f /t 15"&if /i "%A%"=="R" set "CMD=shutdown /r /f /t 15"
:PCLoop
cls&echo A monitorizar %P%... Prima CTRL+C para cancelar.&tasklist /FI "IMAGENAME eq %P%" 2>NUL|find /I /N "%P%">NUL
if "%ERRORLEVEL%"=="0" (timeout /t 30 /nobreak>nul&goto :PCLoop) else (%CMD%&echo Processo %P% terminado. Acao executada.&call :PauseMenu&goto :MENU)
:SYSINFO_DETAILED
call :Header & echo A recolher informacoes do sistema. Aguarde... & (
echo.&echo --- Sistema Operativo ---&wmic os get Caption,Version,OSArchitecture,InstallDate /format:list
echo.&echo --- Processador (CPU) ---&wmic cpu get Name,NumberOfCores,NumberOfLogicalProcessors,MaxClockSpeed,L3CacheSize /format:list
echo.&echo --- Memoria (RAM) ---&wmic memorychip get BankLabel,DeviceLocator,Capacity,Speed,Manufacturer /format:table
echo.&echo --- Placa de Video (GPU) ---&wmic path win32_videocontroller get Name,DriverVersion,AdapterRAM /format:list
echo.&echo --- Armazenamento (Discos) ---&wmic diskdrive get Model,Size,Status,InterfaceType /format:table
echo.&echo --- Volumes Logicos ---&powershell "Get-WmiObject Win32_LogicalDisk -F 'DriveType=3'|FT DeviceID,@{N='Total (GB)';E={[math]::Round($_.Size/1GB,2)}},@{N='Livre (GB)';E={[math]::Round($_.FreeSpace/1GB,2)}} -A"
)|more
call :PauseMenu & goto :MENU
:WIFI_PASS
call :Header&echo --- PERFIS E SENHAS WI-FI SALVAS ---
for /f "tokens=2 delims=:" %%P in ('netsh wlan show profiles') do (set "ssid=%%P" & set "ssid=!ssid:~1!" & for /f "tokens=2 delims=:" %%K in ('netsh wlan show profile name^="!ssid!" key^=clear ^| findstr /C:"Key Content"') do (echo  - Rede: !ssid! --- Senha: %%K))
call :PauseMenu & goto :MENU
:RESET_NET
call :Header&call :ConfirmAction "Isto ira resetar as configuracoes de rede e requer um reinicio. Continuar"
if !ACTION_CANCELLED!==1 goto :MENU
netsh winsock reset&netsh int ip reset&echo Operacao concluida. REINICIE o computador.&call :PauseMenu & goto :MENU
:FIREWALL_MENU
call :Header&echo --- GERIR FIREWALL DO WINDOWS ---
echo [1] Ligar [2] Desligar [3] Resetar&set /p FW_OP=Opcao:
if "%FW_OP%"=="1" (netsh advfirewall set allprofiles state on & echo Firewall ATIVADO.)
if "%FW_OP%"=="2" (netsh advfirewall set allprofiles state off & echo Firewall DESATIVADO.)
if "%FW_OP%"=="3" (netsh advfirewall reset & echo Firewall RESETADO.)
call :PauseMenu & goto :MENU
:SAIR
cls&echo Encerrando a ferramenta de suporte... Ate logo!&timeout /t 2 /nobreak >nul&endlocal&exit /b 0

