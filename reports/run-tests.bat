@echo off
echo Executando testes Robot Framework...

REM Criar estrutura de diretorios
if not exist "reports\html" mkdir reports\html
if not exist "reports\xml" mkdir reports\xml
if not exist "reports\logs" mkdir reports\logs

REM Executar testes JSON
echo Executando testes JSON...
robot --outputdir reports\html --output reports\xml\json-output.xml --log reports\logs\json-log.html --include JSON --name "Testes JSON" tests/

REM Executar testes dinamicos
echo Executando testes dinamicos...
robot --outputdir reports\html --output reports\xml\dinamico-output.xml --log reports\logs\dinamico-log.html --include dinamico --name "Testes Dinamicos" tests/

echo Testes concluidos! Verifique os resultados em reports\html\report.html