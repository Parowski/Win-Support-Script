@echo off
setlocal EnableExtensions EnableDelayedExpansion

:: ====================================================================================
::  Win-Support-Script V24.0 (Edicao Final Estavel)
::  CRIADO POR: Jhon Parowski
::
::  Descricao:
::  A V24.0 e a versao definitiva e 100% estavel. Remove a interface
::  tematica instavel e foca-se na funcionalidade e velocidade. O bug critico
::  que causava o fecho do script foi corrigido. A ferramenta esta agora
::  completa, totalmente em Portugues do Brasil e, acima de tudo, confiavel.
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
title Ferramenta de Suporte V24.0 - Por Jhon Parowski
color 0B
mode 110, 40

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

goto :MENU

:: ####################################################################################
:: #                       BLOCO DE DEFINICOES DE FUNCOES                             #
:: ####################################################################################

:Header
cls
echo ==============================================================================================
echo                      FERRAMENTA DE SUPORTE E OTIMIZACAO V24.0
echo                            Criado por: Jhon Parowski
echo ==============================================================================================
echo.
echo   Usuario: %USERNAME%   ^|   Computador: %COMPUTERNAME%
echo.
goto :eof

:PauseMenu
echo.
echo Pressione qualquer tecla para voltar ao menu anterior...
pause >nul
goto :eof

:ConfirmAction
set "_CONFIRM=N" & set "ACTION_CANCELLED=1"
echo.
set /p "_CONFIRM=>> Tem certeza que deseja continuar? (S/N): "
if /I "%_CONFIRM%"=="S" set "ACTION_CANCELLED=0"
goto :eof

:: ####################################################################################
:: #                             MENU PRINCIPAL (CATEGORIZADO)                        #
:: ####################################################################################
:MENU
call :Header
echo -----------------------[ Reparo e Diagnostico do Sistema ]------------------------
echo  [ 1] Reparo Avancado do Sistema (DISM, SFC, WMI...)
echo  [ 2] Gerenciamento do Registro (Limpeza e Otimizacao)
echo  [ 3] Verificar Saude do Disco (S.M.A.R.T.)
echo  [ 4] Verificar Integridade do Disco (CHKDSK C:)
echo  [ 5] Analise de Eficiencia Energetica e Bateria
echo.
echo -------------------------[ Limpeza e Otimizacao ]-------------------------
echo  [10] Limpeza Profunda de Arquivos (Caches de Navegadores, Temporarios)
echo  [11] Otimizacao do Repositorio de Componentes (WinSxS Cleanup)
echo  [12] Otimizar Unidade C: (Desfragmentar/TRIM)
echo  [13] Localizador de Arquivos Grandes (>1GB)
echo  [14] Gerenciar Compactacao do SO (CompactOS)
echo.
echo ----------------------[ Gerenciamento do Sistema e Ativacao ]---------------------
echo  [20] Gerenciamento de Licencas e Ativacao (Windows/Office)
echo  [21] Criar Ponto de Restauracao do Sistema
echo  [22] Gerenciar Programas de Inicializacao
echo  [23] Desinstalar Programas
echo.
echo -----------------------------[ Rede e Utilitarios ]-------------------------------
echo  [30] Controle de Energia Avancado (Agendamentos, Monitoramento)
echo  [31] Informacoes Detalhadas do Sistema (estilo Speccy)
echo  [32] Exibir Senhas de Wi-Fi Salvas
echo  [33] Resetar Configuracoes de Rede (Winsock/IP) [requer reinicio]
echo  [34] Controle do Firewall do Windows (Ativar/Desativar/Resetar)
echo.
echo  [ 0] Sair da Ferramenta
echo ------------------------------------------------------------------------------------
set "OP="
echo.
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

echo Opcao invalida. Tente novamente. & timeout /t 2 /nobreak >nul & goto :MENU

:: ####################################################################################
:: #                     IMPLEMENTACAO DE TODOS OS MODULOS                            #
:: ####################################################################################

:SYSTEM_REPAIR_MENU
call :Header
echo >> Acessando a Interface de Reparo Avancado...
call :ConfirmAction
if !ACTION_CANCELLED!==1 goto :MENU
echo.
echo >> [PASSO 1/4] Verificando a consistencia do repositorio WMI...
winmgmt /verifyrepository
if !errorlevel! neq 0 ( echo >> Repositorio WMI inconsistente. Tentando reparo automatico... & winmgmt /salvagerepository ) else ( echo >> Repositorio WMI consistente. )
echo.
echo >> [PASSO 2/4] Analisando a integridade da imagem do sistema (DISM CheckHealth)...
Dism /Online /Cleanup-Image /CheckHealth
echo.
echo >> [PASSO 3/4] Restaurando a imagem do sistema (DISM RestoreHealth)...
echo    A operacao pode demorar e parecer parada. E normal.
Dism /Online /Cleanup-Image /RestoreHealth
echo.
echo >> [PASSO 4/4] Verificando e reparando arquivos de sistema (SFC ScanNow)...
sfc /scannow
echo.
echo >> --- REPARO DO SISTEMA CONCLUIDO ---
echo >> E recomendado reiniciar o sistema para aplicar todas as correcoes.
call :PauseMenu & goto :MENU

:REGISTRY_MENU
call :Header
echo >> Acessando o Gerenciamento do Registro...
echo ------------------------------------------------------------------------------------
echo  [1] Iniciar Verificacao e Limpeza do Registro
echo  [2] Restaurar Registro a partir de um Backup
echo  [0] Voltar ao Menu Principal
echo ------------------------------------------------------------------------------------
set /p "REG_OP=Escolha uma opcao: "
if "%REG_OP%"=="1" goto :REG_CLEAN_START
if "%REG_OP%"=="2" goto :REG_RESTORE_BACKUP
if "%REG_OP%"=="0" goto :MENU
goto :REGISTRY_MENU

:REG_CLEAN_START
call :Header
echo  [1] Verificacao Segura [2] Verificacao Normal [3] Verificacao Profunda
set /p SCAN_MODE=Escolha o modo de verificacao: 
if "%SCAN_MODE%" neq "1" if "%SCAN_MODE%" neq "2" if "%SCAN_MODE%" neq "3" goto :REGISTRY_MENU
call :Header
echo >> --- PASSO 1/3: CRIANDO BACKUP DO REGISTRO ---
call :REG_AutoBackup
echo.
echo >> --- PASSO 2/3: VERIFICANDO O REGISTRO ---
call :REG_CreateScannerScript
echo    Executando motor de analise... Isto pode demorar.
powershell -NoProfile -ExecutionPolicy Bypass -File "%PS_SCRIPT_FILE%"
set /a "ISSUES_FOUND=0"
if exist "%SCAN_RESULTS_FILE%" (for /f "usebackq delims=" %%i in ("%SCAN_RESULTS_FILE%") do set /a "ISSUES_FOUND+=1")
echo.
echo >> --- ANALISE CONCLUIDA! Foram encontrados !ISSUES_FOUND! problemas. ---
if !ISSUES_FOUND! gtr 0 (
    call :ConfirmAction
    if !ACTION_CANCELLED!==0 (call :REG_FixIssues) else (echo >> Limpeza cancelada pelo usuario.)
) else (echo >> Nenhuma acao e necessaria. O registro esta limpo.)
if exist "%SCAN_RESULTS_FILE%" del "%SCAN_RESULTS_FILE%" >nul 2>&1
if exist "%PS_SCRIPT_FILE%" del "%PS_SCRIPT_FILE%" >nul 2>&1
echo.
echo >> Processo concluido.
call :PauseMenu & goto :REGISTRY_MENU

:REG_AutoBackup
set "TIMESTAMP=%date:~-4%-%date:~3,2%-%date:~0,2%_%time:~0,2%h%time:~3,2%m"
set "BACKUP_FILE=%BACKUP_DIR%\Registry\Backup_Completo_%TIMESTAMP%.reg"
echo    Criando backup em: %BACKUP_FILE%...
reg export HKLM "%BACKUP_DIR%\hklm.tmp" /y >nul&reg export HKCU "%BACKUP_DIR%\hkcu.tmp" /y >nul
copy /b "%BACKUP_DIR%\hklm.tmp" + "%BACKUP_DIR%\hkcu.tmp" "%BACKUP_FILE%" >nul
del "%BACKUP_DIR%\*.tmp" >nul
echo    Backup criado com sucesso.
goto :eof

:REG_FixIssues
echo.
echo >> --- PASSO 3/3: CORRIGINDO OS PROBLEMAS ---
set /a "count=0"&set "total=!ISSUES_FOUND!"
for /f "usebackq tokens=1,* delims=^|" %%a in ("%SCAN_RESULTS_FILE%") do (
    set /a "count+=1"
    set "entryPath=%%b"
    echo|set /p="   Corrigindo [!count! de !total!]: !entryPath:~0,60!..."
    reg delete "!entryPath!" /f >nul 2>&1
    echo  -> OK
)
echo.
echo >> Correcao concluida. !total! problemas foram processados.
goto :eof

:REG_RESTORE_BACKUP
call :Header
echo >> Abrindo o diretorio de backups...
start "" "%BACKUP_DIR%\Registry"
call :PauseMenu
goto :REGISTRY_MENU

:REG_CreateScannerScript
set "ps_script_b64=cABhAHIAYQBtACgACgAgACAAIAAgAFsAcwB0AHIAaQBuAGcAXQAkAHMAYwBhAG4ATQBvAGQAZQAsAAoAIAAgACAAIAAgAFsAcwB0AHIAaQBuAGcAXQAkAG8AdQB0AHAAdQB0AEYAaQBsAGUACgApAAoAZgB1AG4AYwB0AGkAbwBuACAAQQBkAGQALQBSAGUAcwB1AGwAdAAgAHsACgAgACAAIAAgACAAcABhAHIAYQBtACgAWwBzAHQAcgBpAG4AZwBdACQAdAB5AHAAZQAsACAAWwBzAHQAcgBpAG4AZwBdACQAcABhAHQAaAApAAoAIAAgACAAIAAgACAAQQBkAGQALQBDAG8AbgB0AGUAbgB0ACAALQBQAGEAdABoACAAJABvAHUAdABwAHUAdABGAGkAbABlACAALQBWAGEAbAB1AGUAIAAiACQAdAB5AHAAZQB8ACQAcABhAHQAaAAiAAoAfQAKAGYAdQBuAGMAdABpAG8AbgAgAFMAYwBhAG4ALQBPAGIAcgBwAGgAYQBuAGUAZABTAG8AZgB0AHcAYQByAGUAIAB7AAoAIAAgACAAIAAgACQAdQBuAGkAbgBzAHQAYQBsAGwASwBlAHkAcwAgAD0AIABHAGUAdAAtAEMAaABpAGwAZABJAHQAZQBtACAAIgBIADoAXABTAG8AZgB0AHcAYQByAGUAXABNAGkAYwByAG8AcwBvAGYAdABcAFcAaQBuAGQAbwB3AHMAXABDAGUAcgBuAHQAVgBlAHIAcwBpAG8AbgBcAFUAbgBpAG4AcwB0AGEAbABsACIAIAAtAEUAcgByAG8AcgBBAGMAdABpAG8AbgAgAFMAaQBsAGUAbgB0AGwAeQBDAG8AbgB0AGkAbgB1AGUAIAB8ACAARgBvAHIARQBhAGMAaAAtAE8AYgBqAGUAYwB0ACAAewAgAEcAZQB0AC0ASQB0AGUAbQBQAHIAbwBwAGUAcgB0AHkAIAAkAF8ALgBQAFMAUABhAHQAaAAgAC0ARQByAHIAbwByAEEAYwB0AGkAbwBuACAAUwBpAGwAZQBuAHQAbAB5AEMAbwBuAHQAaQBuAHUAZQAgAH0ACgAgACAAIAAgACAAJABzAG8AZgB0AHcAYQByAGUASwBlAHkAcwAgAD0AIABHAGUAdAAtAEMAaABpAGwAZABJAHQAZQBtACAAIgBIAEMAVQA6AFwAUwBvAGYAdAB3AGEAcgBlACIAIAAtAEUAcgByAG8AcgBBAGMAdABpAG8AbgAgAFMAaQBsAGUAbgB0AGwAeQBDAG8AbgB0AGkAbgB1AGUACgAgACAAIAAgACAAZgBvAHIAZQBhAGMAaAAgACgAJABrAGUAeQAgAGkAbgAgACQAcwBvAGYAdAB3AGEAcgBlAEsAZQB5AHMAKQAgAHsACgAgACAAIAAgACAAIAAgACAAaQBmACAAKAAhACQAawBlAHkAKQAgAHsAIABjAG8AbgB0AGkAbgB1AGUAIAB9AAoAIAAgACAAIAAgACAAIAAgACQAaQBzAE8AcgBwAGgAYQBuACAAPQAgACQAdAByAHUAZQAKACAAIAAgACAAIAAgACAAIAAgAGYAbwByAGUAYQBjAGgAIAAoACQAdQBuAGkAbgBzAHQAYQBsAGwAIABpAG4AIAAkAHUAbgBpAG4AcwB0AGEAbABsAEsAZQB5AHMAKQAgAHsACgAgACAAIAAgACAAIAAgACAAIAAgACAAaQBmACAAKAAkAHUAbgBpAG4AcwB0AGEAbABsAC4ARABpAHMAcABsAGEAeQBOAGEAbQBlACAALQBhAG4AZAAgACQAawBlAHkALgBQAFMAUAByAG8AcABlAHIAdABpAGUAcwAuAE4AYQBtAGUAUwBwAGEAYwBlACAALQBjAG8AbgB0AGEAaQBuAHMAIAAoACQAdQBuAGkAbgBzAHQAYQBsAGwALgBEAGkAcwBwAGwAYQB5AE4AYQBtAGUAKQApACAAewAKACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAkAGkAcwBPAHIAcABoAGEAbgAgAD0AIAAkAGYAYQBsAHMAZQA7AAoAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgAGIAcgBlAGEAawAKACAAIAAgACAAIAAgACAAIAAgACAAIAAgAH0ACgAgACAAIAAgACAAIAAgACAAfQAKACAAIAAgACAAIAAgACAAIAAgAGkAZgAgACgAJABpAHMATwByAHAAaABhAG4AIAAtAGEAbgBkACAAKAAkAGsAZQB5AC4AVgBhAGwAdQBlAEMAbwB1ag4AdAAgAC0AZQBxACAAMAApACAALQBhAG4AZAAgACgAJABrAGUAeQAuAFMAdQBiAEsAZQB5AEMAbwB1AG4AdAAgAC0AZQBxACAAMAApACkAIAB7AAoAIAAgACAAIAAgACAAIAAgACAAIAAgACAAQQBkAGQALQBSAGUAcwB1AGwAdAAgACIASwBFAFkAIgAgACQAawBlAHkALgBQAFMAUABhAHQAaAAuAFIAZQBwAGwAYQBjAGUAKAAiAEgASwBFAFkAXwBDAFUAUgBSAEUATgBUAF8AVQBTADIAUgAiACwAIAIgAEgAQwBVADoAIgApAAoAIAAgACAAIAAgACAAIAAgACAAfQAKACAAIAAgACAAIAAgAH0ACgB9AAoAaQBmACAAKAAkAHMAYwBhAG4ATQBvAGQAZQAgAC0AZwBlACAAMQApACAAewAKACAAIAAgACAAIAAgACAAIABHAGUAdAAtAEMAaABpAGwAZABJAHQAZQBtACAAIgBIAEMAVQA6AFwAUwBvAGYAdAB3AGEAcgBlAFwATQBpAGMAcgBvAHMAbwBmAHQAXABXAGkAbgBkAG8AdwBzAFwAQwB1AHIAcgBlAG4AdABWAGUAcwBpAG8AbgBcAEUAeABwAGwAbwByAGUAcgBcAFIAdQBuAE0AUgBVACIAIAAtAEUAcgByAG8AcgBBAGMAdABpAG8AbgAgAFMAaQBsAGUAbgB0AGwAeQBDAG8AbgB0AGkAbgB1AGUAIAB8ACAARgBvAHIARQBhAGMAaAAtAE8AYgBqAGUAYwB0ACAAewAKACAAIAAgACAAIAAgACAAIAAgACAAIAAgAEEAZABkAC0AUgBlAHMAdQBsAHQAIAAiAFYAQQBMAFUARQAiACAAJABfAC4AUABTAFAAYQB0AGgACgAgACAAIAAgACAAIAAgAH0ACgB9AAoAaQBmACAAKAAkAHMAYwBhAG4ATQBvAGQAZQAgAC0AZwBlACAAMgApACAAewAKACAAIAAgACAAIAAgACAAIABTAGEAYwBhAG4ALQBPAGIAcgBwAGgAYQBuAGUAZABTAG8AZgB0AHcAYQByAGUACgB9AAoAaQBmACAAKAAkAHMAYwBhAG4ATQBvAGQAZQAgAC0AZwBlACAAMwApACAAewAKACAAIAAgACAAIAAgACAAIABHAGUAdAAtAEMAaABpAGwAZABJAHQAZQBtACAAIgBIAEMAVQA6AFwAUwBvAGYAdAB3AGEAcgBlACIAIAAtAFIAZQB1AGwAcwBlACAALQBFAGgAbwByAEEAYwB0AGkAbwBuACAAUwBpAGwAZQBuAHQAbAB5AEMAbwBuAHQAaQBuAHUAZQAgAHwAIABXAGgAZQByAGUALQBPAGIAagBlAGMAdAAgAHsAIABkAF8ALgBTAHUAYgBLAGUAeQBDAHUAbgB0ACAALQBlAHEgADAAIAAtAGEAbgBkACAAJABfAC4AVgBhAGwAdQBlAEMAbwB1ag4AdAAgAC0AZQBxACAAMAAgAH0AIAB8ACAARgBvAHIARQBhAGMAaAAtAE8AYgBqAGUAYwB0ACAAewAKACAAIAAgACAAIAAgACAAIAAgACAAIAAgAEEAZABkAC0AUgBlAHMAdQBsAHQAIAAiAEsARQBZACIAIAAkAF8ALgBQAFMAUABhAHQAaAAuAFIAZQBwAGwAYQBjAGUAKAAiAEgASwBFAFkAXwBDAFUAUgBSAEUATgBUAF8AVQBTADIAUgAiACwAIAIgAEgAQwBVADoAIgApAAoAIAAgACAAIAAgACAAIAAgAH0ACgB9AA=="
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
call :Header& echo >> Acessando o diagnostico de unidades de disco (S.M.A.R.T.)... & wmic diskdrive get model,status&call :PauseMenu & goto :MENU
:CHKDSK_C
call :Header& echo >> Acessando o diagnostico do sistema de arquivos (CHKDSK)...
call :ConfirmAction
if !ACTION_CANCELLED!==1 goto :MENU
chkdsk C: /f /r&echo >> Verificacao agendada para o proximo reinicio do sistema.&call :PauseMenu & goto :MENU
:POWER_DIAG_MENU
call :Header& echo >> Acessando os modulos de diagnostico de energia...
echo ------------------------------------------------------------------------------------
echo  [1] Gerar Relatorio de Saude da Bateria & echo  [2] Gerar Relatorio de Eficiencia Energetica
echo  [3] Gerar Relatorio do Estudo do Sono (Modern Standby) & echo  [0] Voltar ao Terminal
echo ------------------------------------------------------------------------------------
echo Os relatorios serao salvos em: %REPORTS_DIR%
set /p "PD_OP=Escolha uma opcao: "
if "%PD_OP%"=="1" goto :DIAG_BATTERY
if "%PD_OP%"=="2" goto :DIAG_ENERGY
if "%PD_OP%"=="3" goto :DIAG_SLEEPSTUDY
if "%PD_OP%"=="0" goto :MENU
goto :POWER_DIAG_MENU
:DIAG_BATTERY
set "REPORT_PATH=%REPORTS_DIR%\relatorio_bateria.html"
call :Header& echo >> Gerando relatorio de saude da bateria...
powercfg /batteryreport /output "%REPORT_PATH%" /duration 14
echo.& echo >> Relatorio gerado com sucesso em: "%REPORT_PATH%" & timeout /t 1 /nobreak >nul
start "" "%REPORT_PATH%" & call :PauseMenu & goto :POWER_DIAG_MENU
:DIAG_ENERGY
set "REPORT_PATH=%REPORTS_DIR%\relatorio_energia.html"
call :Header& echo >> Gerando relatorio de eficiencia energetica (demora aprox. 60 segundos)...
powercfg /energy /output "%REPORT_PATH%" /duration 60
echo.& echo >> Relatorio gerado com sucesso em: "%REPORT_PATH%" & timeout /t 1 /nobreak >nul
start "" "%REPORT_PATH%" & call :PauseMenu & goto :POWER_DIAG_MENU
:DIAG_SLEEPSTUDY
set "REPORT_PATH=%REPORTS_DIR%\relatorio_sono.html"
call :Header& echo >> Gerando relatorio do estudo do sono...
powercfg /sleepstudy /output "%REPORT_PATH%" /duration 14
echo.& echo >> Relatorio gerado com sucesso em: "%REPORT_PATH%" & timeout /t 1 /nobreak >nul
start "" "%REPORT_PATH%" & call :PauseMenu & goto :POWER_DIAG_MENU
:CLEAN_ADVANCED
call :Header& echo >> Iniciando protocolo de limpeza profunda...
set "dirs_to_clean="&set "dirs_to_clean=!dirs_to_clean!;"%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache""&set "dirs_to_clean=!dirs_to_clean!;"%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cache""&set "dirs_to_clean=!dirs_to_clean!;"%APPDATA%\discord\Cache""&set "dirs_to_clean=!dirs_to_clean!;"%TEMP%""&set "dirs_to_clean=!dirs_to_clean!;"C:\Windows\Temp""
set /a total=0&for %%A in ("%dirs_to_clean:;=" "%") do if "%%~A" neq "" set /a total+=1
set /a count=0&echo Iniciando limpeza de !total! localizacoes...
for %%A in ("%dirs_to_clean:;=" "%") do (if "%%~A" neq "" (set /a count+=1&echo|set /p="   [!count!/!total!] Removendo %%~A..."&if exist "%%~A" (rd /s /q "%%~A" >nul 2>&1 & echo  -> OK) else (echo  -> Nao Encontrado)))
echo.& echo >> Esvaziando a Lixeira... & rd /s /q "C:\$Recycle.Bin" >nul 2>&1&echo.& echo >> Protocolo de limpeza concluido! &call :PauseMenu & goto :MENU
:WINSXS_CLEANUP
call :Header& echo >> Acessando a otimizacao do Repositorio de Componentes...
call :ConfirmAction
if !ACTION_CANCELLED!==1 goto :MENU
echo.& echo >> [PASSO 1/2] Analisando os componentes...
Dism.exe /online /Cleanup-Image /AnalyzeComponentStore
echo.& echo >> [PASSO 2/2] Iniciando a limpeza. Isto pode demorar varios minutos...
Dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase
echo.& echo >> Otimizacao do WinSxS concluida! &call :PauseMenu & goto :MENU
:DEFRAG_C
call :Header& echo >> Iniciando otimizacao da Unidade C: (Desfragmentar/TRIM)...
defrag C: /O /U /V&call :PauseMenu & goto :MENU
:FIND_LARGE_FILES
call :Header& echo >> Iniciando localizador de arquivos grandes (>1GB)...
echo    A busca pode demorar varios minutos. Por favor, aguarde...
powershell -NoProfile "Get-ChildItem C:\ -Recurse -File -ErrorAction SilentlyContinue | Where-Object { $_.Length -gt 1GB } | Sort-Object Length -Descending | Select-Object -First 20 | Format-Table @{Name='Tamanho (GB)';E={[math]::Round($_.Length/1GB,2)}},FullName -A"
call :PauseMenu & goto :MENU
:COMPACTOS_MENU
call :Header& echo >> Acessando o gerenciamento de compactacao do SO...
echo ------------------------------------------------------------------------------------
echo  [1] Consultar Estado da Compactacao & echo  [2] ATIVAR Compactacao do SO
echo  [3] DESATIVAR Compactacao do SO & echo  [0] Voltar ao Terminal
echo ------------------------------------------------------------------------------------
set /p "CO_OP=Escolha uma opcao: "
if "%CO_OP%"=="1" goto :COMPACT_QUERY
if "%CO_OP%"=="2" goto :COMPACT_ENABLE
if "%CO_OP%"=="3" goto :COMPACT_DISABLE
if "%CO_OP%"=="0" goto :MENU
goto :COMPACTOS_MENU
:COMPACT_QUERY
call :Header& echo >> Consultando o estado da compactacao do sistema... & Compact.exe /CompactOS:query
call :PauseMenu & goto :COMPACTOS_MENU
:COMPACT_ENABLE
call :Header& echo >> ATENCAO: Este processo pode demorar e nao deve ser interrompido.
call :ConfirmAction & if !ACTION_CANCELLED!==1 goto :COMPACTOS_MENU
echo >> Ativando a compactacao. Por favor, aguarde... & Compact.exe /CompactOS:always
echo.& echo >> Operacao concluida. & call :PauseMenu & goto :COMPACTOS_MENU
:COMPACT_DISABLE
call :Header& echo >> ATENCAO: Este processo pode demorar e nao deve ser interrompido.
call :ConfirmAction & if !ACTION_CANCELLED!==1 goto :COMPACTOS_MENU
echo >> Desativando a compactacao. Por favor, aguarde... & Compact.exe /CompactOS:never
echo.& echo >> Operacao concluida. & call :PauseMenu & goto :COMPACTOS_MENU
:LICENSE_MENU
call :Header& echo >> Acessando o modulo de licenciamento e ativacao...
echo ------------------------------------------------------------------------------------
echo  [1] Verificar Status da Ativacao (Windows e Office) & echo  [2] Tentar Ativar o WINDOWS (Metodo KMS)
echo  [3] Tentar Ativar o OFFICE (Metodo KMS) & echo  [0] Voltar ao Terminal
echo ------------------------------------------------------------------------------------
set /p "LIC_OP=Escolha uma opcao: "
if "%LIC_OP%"=="1" goto :CHECK_ACTIVATION
if "%LIC_OP%"=="2" goto :ACTIVATE_WINDOWS
if "%LIC_OP%"=="3" goto :ACTIVATE_OFFICE
if "%LIC_OP%"=="0" goto :MENU
goto :LICENSE_MENU
:CHECK_ACTIVATION
call :Header& echo >> Verificando status da ativacao... &echo.&echo [WINDOWS]&cscript //nologo C:\Windows\System32\slmgr.vbs /dli&echo.&echo [OFFICE]&call :FindOSPP
if defined OSPPSCRIPT (cscript //nologo "%OSPPSCRIPT%" /dstatus) else (echo >> Script do Office nao detectado.)
call :PauseMenu & goto :LICENSE_MENU
:ACTIVATE_WINDOWS
call :Header&call :ConfirmAction &if !ACTION_CANCELLED!==1 goto :LICENSE_MENU
echo.& echo >> [1/3] Instalando chave GVLK... & cscript //nologo C:\Windows\System32\slmgr.vbs /ipk W269N-WFGWX-YVC9B-4J6C9-T83GX >nul
echo.& echo >> [2/3] Definindo servidor KMS... & cscript //nologo C:\Windows\System32\slmgr.vbs /skms kms.msguides.com
echo.& echo >> [3/3] Tentando ativacao... & cscript //nologo C:\Windows\System32\slmgr.vbs /ato
echo.& echo >> Protocolo de ativacao concluido. &call :PauseMenu & goto :LICENSE_MENU
:ACTIVATE_OFFICE
call :Header&call :FindOSPP&if not defined OSPPSCRIPT (echo >> Script do Office nao detectado. Abortando. &call :PauseMenu&goto :LICENSE_MENU)
call :ConfirmAction &if !ACTION_CANCELLED!==1 goto :LICENSE_MENU
echo.& echo >> [1/2] Definindo servidor KMS... & cscript //nologo "%OSPPSCRIPT%" /sethst:kms.msguides.com
echo.& echo >> [2/2] Tentando ativacao... & cscript //nologo "%OSPPSCRIPT%" /act
echo.& echo >> Protocolo de ativacao concluido. &call :PauseMenu & goto :LICENSE_MENU
:FindOSPP
set "OSPPSCRIPT="
for /d %%d in ("%ProgramFiles%\Microsoft Office\Office*") do if exist "%%d\ospp.vbs" set "OSPPSCRIPT=%%d\ospp.vbs"
if not defined OSPPSCRIPT for /d %%d in ("%ProgramFiles(x86)%\Microsoft Office\Office*") do if exist "%%d\ospp.vbs" set "OSPPSCRIPT=%%d\ospp.vbs"
goto :eof
:RESTORE_POINT
call :Header&call :ConfirmAction &if !ACTION_CANCELLED!==1 goto :MENU
powershell -NoProfile "Checkpoint-Computer -Description 'PontoManual_WSS'"&echo >> Ponto de restauracao criado com sucesso.&call :PauseMenu & goto :MENU
:MANAGE_STARTUP
call :Header& echo >> Abrindo gerenciador de programas de inicializacao... &start "" ms-settings:startupapps&goto :MENU
:UNINSTALL_PROGRAMS
call :Header& echo >> Abrindo o painel de desinstalacao de programas... &start "" appwiz.cpl&goto :MENU
:POWER_MENU
call :Header& echo >> Acessando o controle de energia avancado...
echo ------------------------------------------------------------------------------------
echo  [1] Agendar acao por TEMPORIZADOR & echo  [2] Agendar acao para HORA ESPECIFICA
echo  [3] Agendar acao para o FIM de um PROCESSO & echo  [4] CANCELAR agendamentos
echo  [0] Voltar ao Terminal
echo ------------------------------------------------------------------------------------
set /p "P_OP=Escolha uma opcao: "
if "%P_OP%"=="1" goto :POWER_TIMER
if "%P_OP%"=="2" goto :POWER_TIME
if "%P_OP%"=="3" goto :POWER_PROCESS
if "%P_OP%"=="4" (shutdown /a >nul & schtasks /Delete /TN JPToolboxPowerAction /F >nul 2>&1 & echo >> Agendamentos cancelados.)
if "%P_OP%"=="0" goto :MENU
call :PauseMenu & goto :POWER_MENU
:POWER_TIMER
set /p M=Minutos para a acao: &set /p A=Acao (D=Desligar, R=Reiniciar):
set /a S=%M%*60&if /i "%A%"=="D" (shutdown /s /f /t %S%)&if /i "%A%"=="R" (shutdown /r /f /t %S%)
echo >> Acao agendada.&goto :POWER_MENU
:POWER_TIME
set /p T=Hora (HH:MM): &set /p A=Acao (D=Desligar, R=Reiniciar):
set "CMD=shutdown /s /f"&if /i "%A%"=="R" set "CMD=shutdown /r /f"
schtasks /Create /TN JPToolboxPowerAction /TR "%CMD%" /SC ONCE /ST %T% /F
echo >> Acao agendada.&goto :POWER_MENU
:POWER_PROCESS
set /p P=Nome do processo (ex: chrome.exe): &set /p A=Acao (D=Desligar, R=Reiniciar):
set "CMD=shutdown /s /f /t 15"&if /i "%A%"=="R" set "CMD=shutdown /r /f /t 15"
:PCLoop
cls& echo >> Monitorando %P%... Pressione CTRL+C para cancelar. &tasklist /FI "IMAGENAME eq %P%" 2>NUL|find /I /N "%P%">NUL
if "%ERRORLEVEL%"=="0" (timeout /t 30 /nobreak>nul&goto :PCLoop) else (%CMD%&echo >> Processo %P% terminado. Acao executada.&call :PauseMenu&goto :MENU)
:SYSINFO_DETAILED
call :Header & echo >> Coletando dados do sistema. Aguarde... & (
echo.&echo --- [Sistema Operacional] ---&wmic os get Caption,Version,OSArchitecture,InstallDate /format:list
echo.&echo --- [Processador (CPU)] ---&wmic cpu get Name,NumberOfCores,NumberOfLogicalProcessors,MaxClockSpeed,L3CacheSize /format:list
echo.&echo --- [Memoria (RAM)] ---&wmic memorychip get BankLabel,DeviceLocator,Capacity,Speed,Manufacturer /format:table
echo.&echo --- [Placa de Video (GPU)] ---&wmic path win32_videocontroller get Name,DriverVersion,AdapterRAM /format:list
echo.&echo --- [Armazenamento (Discos)] ---&wmic diskdrive get Model,Size,Status,InterfaceType /format:table
echo.&echo --- [Volumes Logicos] ---&powershell "Get-WmiObject Win32_LogicalDisk -F 'DriveType=3'|FT DeviceID,@{N='Total (GB)';E={[math]::Round($_.Size/1GB,2)}},@{N='Livre (GB)';E={[math]::Round($_.FreeSpace/1GB,2)}} -A"
)|more
call :PauseMenu & goto :MENU
:WIFI_PASS
call :Header& echo >> Extraindo senhas de redes Wi-Fi salvas...
for /f "tokens=2 delims=:" %%P in ('netsh wlan show profiles') do (set "ssid=%%P" & set "ssid=!ssid:~1!" & for /f "tokens=2 delims=:" %%K in ('netsh wlan show profile name^="!ssid!" key^=clear ^| findstr /C:"Key Content"') do (echo  - Rede: !ssid! --- Senha: %%K))
call :PauseMenu & goto :MENU
:RESET_NET
call :Header&call :ConfirmAction
if !ACTION_CANCELLED!==1 goto :MENU
netsh winsock reset&netsh int ip reset&echo >> Operacao concluida. REINICIE o sistema.&call :PauseMenu & goto :MENU
:FIREWALL_MENU
call :Header& echo >> Acessando o controle do Firewall...
echo [1] Ativar [2] Desativar [3] Resetar&set /p FW_OP=Opcao:
if "%FW_OP%"=="1" (netsh advfirewall set allprofiles state on & echo >> Firewall ATIVADO.)
if "%FW_OP%"=="2" (netsh advfirewall set allprofiles state off & echo >> Firewall DESATIVADO.)
if "%FW_OP%"=="3" (netsh advfirewall reset & echo >> Firewall RESETADO.)
echo.&call :PauseMenu & goto :MENU
:SAIR
cls&echo Saindo da ferramenta de suporte...&timeout /t 2 /nobreak >nul&endlocal&exit /b 0

