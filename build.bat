chcp 65001
rd /s /q docs
stack build
call :SuccessOrDie

stack exec site clean
stack exec site build
call :SuccessOrDie
xcopy /S /E _site docs\
exit

:SuccessOrDie
if not %errorlevel% == 0 (
echo [ERROR] :P
exit 1
)
exit /b 0
