@echo off
setlocal EnableExtensions EnableDelayedExpansion

:: ====================================================================================
::  Win-Support-Script V19.0 (Edicao NEO)
::  CRIADO POR: Jhon Parowski
::
::  Descricao:
::  A V19.0 transforma a interface da ferramenta numa experiencia imersiva
::  inspirada no universo Matrix. Mantem toda a funcionalidade robusta das
::  versoes anteriores, mas com um novo esquema de cores, efeitos de texto
::  e uma linguagem tematica para uma utilizacao mais estilizada.
:: ====================================================================================

:: ------------------------------------------------------------------------------------
::  VERIFICACAO E AUTO-ELEVACAO DE PRIVILEGIOS
:: ------------------------------------------------------------------------------------
fltmc >nul 2>&1
if %errorlevel% neq 0 (
    echo A solicitar acesso de Administrador...
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

:: --- Configuracoes Iniciais ---
cd /d "%~dp0"
title MATRIX OPERATOR TERMINAL - Jhon Parowski
mode 120, 35
color 0A

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

:: --- INTRODUCAO MATRIX ---
cls
call :MatrixRain 4
cls

:: >>> Pula a definicao de funcoes e vai direto para o menu principal
goto :MENU

:: ####################################################################################
:: #                       BLOCO DE DEFINICOES DE FUNCOES                             #
:: ####################################################################################

:Header
cls
echo.
echo      __      __.__      .__  .__                                       .__       .__.__
echo     /  \    /  \__| ____ |  | |  |   ____   ______ ____   _____   ____ |  |    __| _/|__| ____   ____
echo     \   \/\/   /  |/    \|  | |  | _/ __ \ /  ___// __ \ /     \_/ __ \|  |   / __ | |  |/  _ \ /    \
echo      \        /|  |   |  \  |_|  |_\  ___/ \___ \\  ___/|  Y Y  \  ___/|  |__/ /_/ | |  (  <_> )   |  \
echo       \__/\  / |__|___|  /____/____/\___  >____  >\___  >__|_|  /\___  >____/\____ | |__|\____/|___|  /
echo            \/          \/               \/     \/     \/      \/     \/           \/               \/
echo.
echo ============================ TERMINAL OPERATOR V19.0 - by Jhon Parowski ==============================
echo.
call :Typewriter ">> Acesso concedido, Operador %USERNAME%." 5
echo.
call :Typewriter ">> Sistema alvo: %COMPUTERNAME%." 5
echo.
goto :eof

:PauseMenu
echo.
call :Typewriter ">> Pressione qualquer tecla para regressar ao terminal..." 5
pause >nul
goto :eof

:ConfirmAction
set "_CONFIRM=N" & set "ACTION_CANCELLED=1"
echo.
set /p "_CONFIRM=>> Confirmar operacao (S/N): "
if /I "%_CONFIRM%"=="S" set "ACTION_CANCELLED=0"
goto :eof

:Typewriter
set "line=%~1"
set "delay_ms=%~2"
if "%delay_ms%"=="" set "delay_ms=10"
for /l %%i in (0, 1, 400) do (
    if "!line:~%%i,1!"=="" goto typewriter_end
    <nul set /p "=!line:~%%i,1!"
    >nul ping -n 1 127.0.0.1 -w %delay_ms%
)
:typewriter_end
goto :eof

:MatrixRain
setlocal
set "chars=0123456789"
set /a "duration=%~1 * 10"
if "%duration%"=="0" set "duration=50"
for /L %%i in (1, 1, %duration%) do (
    set "line="
    for /L %%j in (1, 1, 118) do (
        set /a "rand=!random! %% 10"
        for %%k in (!rand!) do set "line=!line!!chars:~%%k,1!"
    )
    echo !line!
    >nul ping -n 1 127.0.0.1 -w 50
)
endlocal
goto :eof

:: ####################################################################################
:: #                             MENU PRINCIPAL (CATEGORIZADO)                        #
:: ####################################################################################
:MENU
call :Header
echo --------------------------[ MODULOS DE REPARO DO SISTEMA ]--------------------------
echo  [ 1] Interface de Reparo Avancado (DISM, SFC, WMI...)
echo  [ 2] Acesso ao Subsistema do Registo (Limpeza e Otimizacao)
echo  [ 3] Diagnostico de Hardware: Unidades de Disco (S.M.A.R.T.)
echo  [ 4] Diagnostico de Hardware: Sistema de Ficheiros (CHKDSK C:)
echo  [ 5] Analise de Eficiencia Energetica e Bateria
echo.
echo ------------------------[ PROTOCOLOS DE LIMPEZA E OTIMIZACAO ]----------------------
echo  [10] Limpeza Profunda de Dados (Caches de Navegadores, Temporarios)
echo  [11] Otimizacao do Armazem de Componentes (WinSxS Cleanup)
echo  [12] Otimizacao de Unidade C: (Desfragmentar/TRIM)
echo  [13] Localizador de Ficheiros de Grande Volume (>1GB)
echo  [14] Gestao de Compactacao do Nucleo do SO (CompactOS)
echo.
echo ------------------------[ GESTAO DO SISTEMA E AUTENTICACAO ]----------------------
echo  [20] Modulo de Licenciamento e Ativacao (Sistema/Office)
echo  [21] Criar Ponto de Restauracao do Sistema
echo  [22] Controlo de Processos de Inicializacao
echo  [23] Interface de Desinstalacao de Software
echo.
echo ----------------------------[ REDE E UTILITARIOS ]--------------------------------
echo  [30] Controlo de Energia Avancado (Agendamentos, Monitorizacao)
echo  [31] Relatorio Detalhado de Sistema (estilo Speccy)
echo  [32] Extrair Credenciais de Rede Wi-Fi Salvas
echo  [33] Resetar Protocolos de Rede (Winsock/IP) [requer reinicio]
echo  [34] Controlo do Firewall do Sistema (Ativar/Desativar/Resetar)
echo.
echo  [ 0] Desconectar do Terminal
echo ------------------------------------------------------------------------------------
set "OP="
echo.
set /p "OP=Operator>: "

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

call :Typewriter ">> Comando invalido. Tente novamente." 5 & timeout /t 2 /nobreak >nul & goto :MENU

:: ####################################################################################
:: #                     IMPLEMENTACAO DE TODOS OS MODULOS                            #
:: ####################################################################################

:SYSTEM_REPAIR_MENU
call :Header
call :Typewriter ">> A aceder a Interface de Reparo Avancado..." 5 & echo.
call :ConfirmAction "Iniciar protocolo de reparo completo"
if !ACTION_CANCELLED!==1 goto :MENU
echo.
call :Typewriter ">> [PASSO 1/4] A verificar a consistencia do repositorio WMI..." 5 & echo.
winmgmt /verifyrepository
if !errorlevel! neq 0 ( call :Typewriter ">> Repositorio WMI inconsistente. A tentar reparo automatico..." 5 & echo. & winmgmt /salvagerepository ) else ( call :Typewriter ">> Repositorio WMI consistente." 5 & echo. )
echo.
call :Typewriter ">> [PASSO 2/4] A analisar a integridade da imagem do sistema (DISM CheckHealth)..." 5 & echo.
Dism /Online /Cleanup-Image /CheckHealth
echo.
call :Typewriter ">> [PASSO 3/4] A restaurar a imagem do sistema (DISM RestoreHealth)..." 5 & echo.
call :Typewriter ">> A operacao pode demorar e parecer parada. E normal." 5 & echo.
Dism /Online /Cleanup-Image /RestoreHealth
echo.
call :Typewriter ">> [PASSO 4/4] A verificar e reparar ficheiros de sistema (SFC ScanNow)..." 5 & echo.
sfc /scannow
echo.
call :Typewriter ">> --- PROTOCOLO DE REPARO CONCLUIDO ---" 5 & echo.
call :Typewriter ">> E recomendado reiniciar o sistema para aplicar todas as correcoes." 5 & echo.
call :PauseMenu & goto :MENU

:REGISTRY_MENU
call :Header
call :Typewriter ">> A aceder ao Subsistema do Registo..." 5 & echo.
echo ------------------------------------------------------------------------------------
echo  [1] Iniciar Verificacao e Limpeza do Registo
echo  [2] Restaurar Registo a partir de uma Copia de Seguranca
echo  [0] Regressar ao Terminal Principal
echo ------------------------------------------------------------------------------------
set /p "REG_OP=Operator>: "
if "%REG_OP%"=="1" goto :REG_CLEAN_START
if "%REG_OP%"=="2" goto :REG_RESTORE_BACKUP
if "%REG_OP%"=="0" goto :MENU
goto :REGISTRY_MENU

:REG_CLEAN_START
call :Header
echo  [1] Verificacao Segura [2] Verificacao Normal [3] Verificacao Profunda
set /p SCAN_MODE=Operator/Modo>: 
if "%SCAN_MODE%" neq "1" if "%SCAN_MODE%" neq "2" if "%SCAN_MODE%" neq "3" goto :REGISTRY_MENU
call :Header
call :Typewriter ">> --- PASSO 1/3: A CRIAR PONTO DE RESTAURO (BACKUP) ---" 5 & echo.
call :REG_AutoBackup
echo.
call :Typewriter ">> --- PASSO 2/3: A VERIFICAR O REGISTO ---" 5 & echo.
call :REG_CreateScannerScript
call :Typewriter ">> A executar motor de analise... Isto pode demorar." 5 & echo.
powershell -NoProfile -ExecutionPolicy Bypass -File "%PS_SCRIPT_FILE%"
set /a "ISSUES_FOUND=0"
if exist "%SCAN_RESULTS_FILE%" (for /f "usebackq delims=" %%i in ("%SCAN_RESULTS_FILE%") do set /a "ISSUES_FOUND+=1")
echo.
call :Typewriter ">> --- ANALISE CONCLUIDA! Foram encontradas !ISSUES_FOUND! anomalias. ---" 5 & echo.
if !ISSUES_FOUND! gtr 0 (
    call :ConfirmAction "Deseja continuar e corrigir estas anomalias"
    if !ACTION_CANCELLED!==0 (call :REG_FixIssues) else (call :Typewriter ">> Limpeza cancelada pelo Operador." 5 & echo.)
) else (call :Typewriter ">> Nenhuma acao e necessaria. O registo esta limpo." 5 & echo.)
if exist "%SCAN_RESULTS_FILE%" del "%SCAN_RESULTS_FILE%" >nul 2>&1
if exist "%PS_SCRIPT_FILE%" del "%PS_SCRIPT_FILE%" >nul 2>&1
echo.
call :Typewriter ">> Processo concluido." 5
call :PauseMenu & goto :REGISTRY_MENU

:REG_AutoBackup
set "TIMESTAMP=%date:~-4%-%date:~3,2%-%date:~0,2%_%time:~0,2%h%time:~3,2%m"
set "BACKUP_FILE=%BACKUP_DIR%\Registry\Backup_Completo_%TIMESTAMP%.reg"
call :Typewriter ">> A criar copia de seguranca em: %BACKUP_FILE%..." 5 & echo.
reg export HKLM "%BACKUP_DIR%\hklm.tmp" /y >nul&reg export HKCU "%BACKUP_DIR%\hkcu.tmp" /y >nul
copy /b "%BACKUP_DIR%\hklm.tmp" + "%BACKUP_DIR%\hkcu.tmp" "%BACKUP_FILE%" >nul
del "%BACKUP_DIR%\*.tmp" >nul
call :Typewriter ">> Copia de seguranca criada com sucesso." 5 & echo.
goto :eof

:REG_FixIssues
echo.
call :Typewriter ">> --- PASSO 3/3: A CORRIGIR AS ANOMALIAS ---" 5 & echo.
set /a "count=0"&set "total=!ISSUES_FOUND!"
for /f "usebackq tokens=1,* delims=^|" %%a in ("%SCAN_RESULTS_FILE%") do (
    set /a "count+=1"
    set "entryPath=%%b"
    echo|set /p=">> Corrigindo [!count! de !total!]: !entryPath:~0,60!..."
    reg delete "!entryPath!" /f >nul 2>&1
    echo  -> OK
)
echo.
call :Typewriter ">> Correcao concluida. !total! anomalias foram processadas." 5 & echo.
goto :eof

:REG_RESTORE_BACKUP
call :Header
call :Typewriter ">> A abrir o diretorio de copias de seguranca..." 5 & echo.
start "" "%BACKUP_DIR%\Registry"
call :PauseMenu
goto :REGISTRY_MENU

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
call :Header&call :Typewriter ">> A aceder ao diagnostico de unidades de disco (S.M.A.R.T.)..." 5 & echo.
wmic diskdrive get model,status&call :PauseMenu & goto :MENU
:CHKDSK_C
call :Header&call :Typewriter ">> A aceder ao diagnostico do sistema de ficheiros (CHKDSK)..." 5 & echo.
call :ConfirmAction "A verificacao pode demorar e requer um reinicio. Continuar"
if !ACTION_CANCELLED!==1 goto :MENU
chkdsk C: /f /r&call :Typewriter ">> Verificacao agendada para o proximo reinicio do sistema." 5 & echo.&call :PauseMenu & goto :MENU
:POWER_DIAG_MENU
call :Header&call :Typewriter ">> A aceder aos modulos de diagnostico de energia..." 5 & echo.
echo ------------------------------------------------------------------------------------
echo  [1] Gerar Relatorio de Saude da Bateria & echo  [2] Gerar Relatorio de Eficiencia Energetica
echo  [3] Gerar Relatorio do Estudo do Sono (Modern Standby) & echo  [0] Regressar ao Terminal
echo ------------------------------------------------------------------------------------
echo Os relatorios serao guardados em: %REPORTS_DIR%
set /p "PD_OP=Operator>: "
if "%PD_OP%"=="1" goto :DIAG_BATTERY
if "%PD_OP%"=="2" goto :DIAG_ENERGY
if "%PD_OP%"=="3" goto :DIAG_SLEEPSTUDY
if "%PD_OP%"=="0" goto :MENU
goto :POWER_DIAG_MENU
:DIAG_BATTERY
set "REPORT_PATH=%REPORTS_DIR%\relatorio_bateria.html"
call :Header&call :Typewriter ">> A gerar relatorio de saude da bateria..." 5 & echo.
powercfg /batteryreport /output "%REPORT_PATH%" /duration 14
echo.&call :Typewriter ">> Relatorio gerado com sucesso em: ^"%REPORT_PATH%^"" 5 & echo. & timeout /t 1 /nobreak >nul
start "" "%REPORT_PATH%" & call :PauseMenu & goto :POWER_DIAG_MENU
:DIAG_ENERGY
set "REPORT_PATH=%REPORTS_DIR%\relatorio_energia.html"
call :Header&call :Typewriter ">> A gerar relatorio de eficiencia energetica (demora aprox. 60 segundos)..." 5 & echo.
powercfg /energy /output "%REPORT_PATH%" /duration 60
echo.&call :Typewriter ">> Relatorio gerado com sucesso em: ^"%REPORT_PATH%^"" 5 & echo. & timeout /t 1 /nobreak >nul
start "" "%REPORT_PATH%" & call :PauseMenu & goto :POWER_DIAG_MENU
:DIAG_SLEEPSTUDY
set "REPORT_PATH=%REPORTS_DIR%\relatorio_sono.html"
call :Header&call :Typewriter ">> A gerar relatorio do estudo do sono..." 5 & echo.
powercfg /sleepstudy /output "%REPORT_PATH%" /duration 14
echo.&call :Typewriter ">> Relatorio gerado com sucesso em: ^"%REPORT_PATH%^"" 5 & echo. & timeout /t 1 /nobreak >nul
start "" "%REPORT_PATH%" & call :PauseMenu & goto :POWER_DIAG_MENU
:CLEAN_ADVANCED
call :Header&call :Typewriter ">> A iniciar protocolo de limpeza profunda..." 5 & echo.
set "dirs_to_clean="&set "dirs_to_clean=!dirs_to_clean!;"%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache""&set "dirs_to_clean=!dirs_to_clean!;"%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cache""&set "dirs_to_clean=!dirs_to_clean!;"%APPDATA%\discord\Cache""&set "dirs_to_clean=!dirs_to_clean!;"%TEMP%""&set "dirs_to_clean=!dirs_to_clean!;"C:\Windows\Temp""
set /a total=0&for %%A in ("%dirs_to_clean:;=" "%") do if "%%~A" neq "" set /a total+=1
set /a count=0&echo A iniciar limpeza de !total! localizacoes...
for %%A in ("%dirs_to_clean:;=" "%") do (if "%%~A" neq "" (set /a count+=1&echo|set /p="[!count!/!total!] A purgar %%~A..."&if exist "%%~A" (rd /s /q "%%~A" >nul 2>&1 & echo  -> OK) else (echo  -> Nao Encontrado)))
echo.&call :Typewriter ">> A esvaziar a Lixeira..." 5 & rd /s /q "C:\$Recycle.Bin" >nul 2>&1&echo.&call :Typewriter ">> Protocolo de limpeza concluido!" 5 & echo.&call :PauseMenu & goto :MENU
:WINSXS_CLEANUP
call :Header&call :Typewriter ">> A aceder a otimizacao do Armazem de Componentes..." 5 & echo.
call :ConfirmAction "Este processo pode demorar e nao deve ser interrompido. Continuar"
if !ACTION_CANCELLED!==1 goto :MENU
echo.&call :Typewriter ">> [PASSO 1/2] A analisar os componentes..." 5 & echo.
Dism.exe /online /Cleanup-Image /AnalyzeComponentStore
echo.&call :Typewriter ">> [PASSO 2/2] A iniciar a limpeza. Isto pode demorar varios minutos..." 5 & echo.
Dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase
echo.&call :Typewriter ">> Otimizacao do WinSxS concluida!" 5 & echo.&call :PauseMenu & goto :MENU
:DEFRAG_C
call :Header&call :Typewriter ">> A iniciar otimizacao da Unidade C: (Desfragmentar/TRIM)..." 5 & echo.
defrag C: /O /U /V&call :PauseMenu & goto :MENU
:FIND_LARGE_FILES
call :Header&call :Typewriter ">> A iniciar localizador de ficheiros de grande volume (>1GB)..." 5 & echo.
call :Typewriter ">> A procura pode demorar varios minutos. Por favor, aguarde..." 5 & echo.
powershell -NoProfile "Get-ChildItem C:\ -Recurse -File -ErrorAction SilentlyContinue | Where-Object { $_.Length -gt 1GB } | Sort-Object Length -Descending | Select-Object -First 20 | Format-Table @{Name='Tamanho (GB)';E={[math]::Round($_.Length/1GB,2)}},FullName -A"
call :PauseMenu & goto :MENU
:COMPACTOS_MENU
call :Header&call :Typewriter ">> A aceder a gestao de compactacao do nucleo do SO..." 5 & echo.
echo ------------------------------------------------------------------------------------
echo  [1] Consultar Estado da Compactacao & echo  [2] ATIVAR Compactacao do SO
echo  [3] DESATIVAR Compactacao do SO & echo  [0] Regressar ao Terminal
echo ------------------------------------------------------------------------------------
set /p "CO_OP=Operator>: "
if "%CO_OP%"=="1" goto :COMPACT_QUERY
if "%CO_OP%"=="2" goto :COMPACT_ENABLE
if "%CO_OP%"=="3" goto :COMPACT_DISABLE
if "%CO_OP%"=="0" goto :MENU
goto :COMPACTOS_MENU
:COMPACT_QUERY
call :Header&call :Typewriter ">> A consultar o estado da compactacao do sistema..." 5 & echo. & Compact.exe /CompactOS:query
call :PauseMenu & goto :COMPACTOS_MENU
:COMPACT_ENABLE
call :Header&call :Typewriter ">> ATENCAO: Este processo pode demorar e nao deve ser interrompido." 5 & echo.
call :ConfirmAction "Deseja continuar e ativar a compactacao" & if !ACTION_CANCELLED!==1 goto :COMPACTOS_MENU
call :Typewriter ">> A ativar a compactacao. Por favor, aguarde..." 5 & echo. & Compact.exe /CompactOS:always
echo.&call :Typewriter ">> Operacao concluida." 5 & call :PauseMenu & goto :COMPACTOS_MENU
:COMPACT_DISABLE
call :Header&call :Typewriter ">> ATENCAO: Este processo pode demorar e nao deve ser interrompido." 5 & echo.
call :ConfirmAction "Deseja continuar e desativar a compactacao" & if !ACTION_CANCELLED!==1 goto :COMPACTOS_MENU
call :Typewriter ">> A desativar a compactacao. Por favor, aguarde..." 5 & echo. & Compact.exe /CompactOS:never
echo.&call :Typewriter ">> Operacao concluida." 5 & call :PauseMenu & goto :COMPACTOS_MENU
:LICENSE_MENU
call :Header&call :Typewriter ">> A aceder ao modulo de licenciamento e ativacao..." 5 & echo.
echo ------------------------------------------------------------------------------------
echo  [1] Verificar Status da Ativacao (Sistema e Office) & echo  [2] Tentar Ativar o SISTEMA (Metodo KMS)
echo  [3] Tentar Ativar o OFFICE (Metodo KMS) & echo  [0] Regressar ao Terminal
echo ------------------------------------------------------------------------------------
set /p "LIC_OP=Operator>: "
if "%LIC_OP%"=="1" goto :CHECK_ACTIVATION
if "%LIC_OP%"=="2" goto :ACTIVATE_WINDOWS
if "%LIC_OP%"=="3" goto :ACTIVATE_OFFICE
if "%LIC_OP%"=="0" goto :MENU
goto :LICENSE_MENU
:CHECK_ACTIVATION
call :Header&call :Typewriter ">> A verificar status da ativacao..." 5 & echo.&echo [SISTEMA]&cscript //nologo C:\Windows\System32\slmgr.vbs /dli&echo.&echo [OFFICE]&call :FindOSPP
if defined OSPPSCRIPT (cscript //nologo "%OSPPSCRIPT%" /dstatus) else (call :Typewriter ">> Script do Office nao detetado." 5 & echo.)
call :PauseMenu & goto :LICENSE_MENU
:ACTIVATE_WINDOWS
call :Header&call :ConfirmAction "Iniciar protocolo de ativacao do Sistema"&if !ACTION_CANCELLED!==1 goto :LICENSE_MENU
echo.&call :Typewriter ">> [1/3] A instalar chave GVLK..." 5 & echo.&cscript //nologo C:\Windows\System32\slmgr.vbs /ipk W269N-WFGWX-YVC9B-4J6C9-T83GX >nul
echo.&call :Typewriter ">> [2/3] A definir servidor KMS..." 5 & echo.&cscript //nologo C:\Windows\System32\slmgr.vbs /skms kms.msguides.com
echo.&call :Typewriter ">> [3/3] A tentar ativacao..." 5 & echo.&cscript //nologo C:\Windows\System32\slmgr.vbs /ato
echo.&call :Typewriter ">> Protocolo de ativacao concluido." 5 & echo.&call :PauseMenu & goto :LICENSE_MENU
:ACTIVATE_OFFICE
call :Header&call :FindOSPP&if not defined OSPPSCRIPT (call :Typewriter ">> Script do Office nao detetado. Abortar." 5 & echo.&call :PauseMenu&goto :LICENSE_MENU)
call :ConfirmAction "Iniciar protocolo de ativacao do Office"&if !ACTION_CANCELLED!==1 goto :LICENSE_MENU
echo.&call :Typewriter ">> [1/2] A definir servidor KMS..." 5 & echo.&cscript //nologo "%OSPPSCRIPT%" /sethst:kms.msguides.com
echo.&call :Typewriter ">> [2/2] A tentar ativacao..." 5 & echo.&cscript //nologo "%OSPPSCRIPT%" /act
echo.&call :Typewriter ">> Protocolo de ativacao concluido." 5 & echo.&call :PauseMenu & goto :LICENSE_MENU
:FindOSPP
set "OSPPSCRIPT="
for /d %%d in ("%ProgramFiles%\Microsoft Office\Office*") do if exist "%%d\ospp.vbs" set "OSPPSCRIPT=%%d\ospp.vbs"
if not defined OSPPSCRIPT for /d %%d in ("%ProgramFiles(x86)%\Microsoft Office\Office*") do if exist "%%d\ospp.vbs" set "OSPPSCRIPT=%%d\ospp.vbs"
goto :eof
:RESTORE_POINT
call :Header&call :ConfirmAction "Criar Ponto de Restauracao do Sistema agora"&if !ACTION_CANCELLED!==1 goto :MENU
powershell -NoProfile "Checkpoint-Computer -Description 'PontoManual_MatrixTerminal'"&call :Typewriter ">> Ponto de restauracao criado com sucesso." 5 & echo.&call :PauseMenu & goto :MENU
:MANAGE_STARTUP
call :Header&call :Typewriter ">> A abrir controlo de processos de inicializacao..." 5 & echo.&start "" ms-settings:startupapps&goto :MENU
:UNINSTALL_PROGRAMS
call :Header&call :Typewriter ">> A abrir interface de desinstalacao de software..." 5 & echo.&start "" appwiz.cpl&goto :MENU
:POWER_MENU
call :Header&call :Typewriter ">> A aceder ao controlo de energia avancado..." 5 & echo.
echo ------------------------------------------------------------------------------------
echo  [1] Agendar acao por TEMPORIZADOR & echo  [2] Agendar acao para HORA ESPECIFICA
echo  [3] Agendar acao para o FIM de um PROCESSO & echo  [4] CANCELAR agendamentos
echo  [0] Regressar ao Terminal
echo ------------------------------------------------------------------------------------
set /p "P_OP=Operator>: "
if "%P_OP%"=="1" goto :POWER_TIMER
if "%P_OP%"=="2" goto :POWER_TIME
if "%P_OP%"=="3" goto :POWER_PROCESS
if "%P_OP%"=="4" (shutdown /a >nul & schtasks /Delete /TN JPToolboxPowerAction /F >nul 2>&1 & call :Typewriter ">> Agendamentos cancelados." 5 & echo.)
if "%P_OP%"=="0" goto :MENU
call :PauseMenu & goto :POWER_MENU
:POWER_TIMER
set /p M=Operator/Minutos>: &set /p A=Operator/Acao (S=Desligar, R=Reiniciar)>:
set /a S=%M%*60&if /i "%A%"=="S" (shutdown /s /f /t %S%)&if /i "%A%"=="R" (shutdown /r /f /t %S%)
call :Typewriter ">> Acao agendada." 5 & echo.&goto :POWER_MENU
:POWER_TIME
set /p T=Operator/Hora (HH:MM)>: &set /p A=Operator/Acao (S=Desligar, R=Reiniciar)>:
set "CMD=shutdown /s /f"&if /i "%A%"=="R" set "CMD=shutdown /r /f"
schtasks /Create /TN JPToolboxPowerAction /TR "%CMD%" /SC ONCE /ST %T% /F
call :Typewriter ">> Acao agendada." 5 & echo.&goto :POWER_MENU
:POWER_PROCESS
set /p P=Operator/Processo (ex: chrome.exe)>: &set /p A=Operator/Acao (S=Desligar, R=Reiniciar)>:
set "CMD=shutdown /s /f /t 15"&if /i "%A%"=="R" set "CMD=shutdown /r /f /t 15"
:PCLoop
cls&call :Typewriter ">> A monitorizar %P%... Prima CTRL+C para cancelar." 5 & echo.&tasklist /FI "IMAGENAME eq %P%" 2>NUL|find /I /N "%P%">NUL
if "%ERRORLEVEL%"=="0" (timeout /t 30 /nobreak>nul&goto :PCLoop) else (%CMD%&call :Typewriter ">> Processo %P% terminado. Acao executada." 5 & echo.&call :PauseMenu&goto :MENU)
:SYSINFO_DETAILED
call :Header & call :Typewriter ">> A recolher dados do sistema. Aguarde..." 5 & echo. & (
echo.&echo --- [Sistema Operativo] ---&wmic os get Caption,Version,OSArchitecture,InstallDate /format:list
echo.&echo --- [Processador (CPU)] ---&wmic cpu get Name,NumberOfCores,NumberOfLogicalProcessors,MaxClockSpeed,L3CacheSize /format:list
echo.&echo --- [Memoria (RAM)] ---&wmic memorychip get BankLabel,DeviceLocator,Capacity,Speed,Manufacturer /format:table
echo.&echo --- [Placa de Video (GPU)] ---&wmic path win32_videocontroller get Name,DriverVersion,AdapterRAM /format:list
echo.&echo --- [Armazenamento (Discos)] ---&wmic diskdrive get Model,Size,Status,InterfaceType /format:table
echo.&echo --- [Volumes Logicos] ---&powershell "Get-WmiObject Win32_LogicalDisk -F 'DriveType=3'|FT DeviceID,@{N='Total (GB)';E={[math]::Round($_.Size/1GB,2)}},@{N='Livre (GB)';E={[math]::Round($_.FreeSpace/1GB,2)}} -A"
)|more
call :PauseMenu & goto :MENU
:WIFI_PASS
call :Header&call :Typewriter ">> A extrair credenciais de rede Wi-Fi salvas..." 5 & echo.
for /f "tokens=2 delims=:" %%P in ('netsh wlan show profiles') do (set "ssid=%%P" & set "ssid=!ssid:~1!" & for /f "tokens=2 delims=:" %%K in ('netsh wlan show profile name^="!ssid!" key^=clear ^| findstr /C:"Key Content"') do (echo  - Rede: !ssid! --- Credencial: %%K))
call :PauseMenu & goto :MENU
:RESET_NET
call :Header&call :ConfirmAction "Isto ira resetar os protocolos de rede e requer um reinicio. Continuar"
if !ACTION_CANCELLED!==1 goto :MENU
netsh winsock reset&netsh int ip reset&call :Typewriter ">> Operacao concluida. REINICIE o sistema." 5 & echo.&call :PauseMenu & goto :MENU
:FIREWALL_MENU
call :Header&call :Typewriter ">> A aceder ao controlo do Firewall..." 5 & echo.
echo [1] Ativar [2] Desativar [3] Resetar&set /p FW_OP=Operator>:
if "%FW_OP%"=="1" (netsh advfirewall set allprofiles state on & call :Typewriter ">> Firewall ATIVADO." 5)
if "%FW_OP%"=="2" (netsh advfirewall set allprofiles state off & call :Typewriter ">> Firewall DESATIVADO." 5)
if "%FW_OP%"=="3" (netsh advfirewall reset & call :Typewriter ">> Firewall RESETADO." 5)
echo.&call :PauseMenu & goto :MENU
:SAIR
cls&call :Typewriter ">> A desconectar do terminal..." 20 & timeout /t 2 /nobreak >nul&endlocal&exit /b 0

