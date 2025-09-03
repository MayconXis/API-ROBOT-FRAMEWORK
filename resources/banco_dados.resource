*** Settings ***
Library    OperatingSystem
Library    Collections
Library    JSONLibrary
Library    String

*** Variables ***
${BANCO_USUARIOS}        ${CURDIR}${/}..${/}data${/}banco_usuarios.json
${BANCO_ENDPOINTS}       ${CURDIR}${/}..${/}data${/}banco_endpoints.json  
${BANCO_STATUS_CODES}    ${CURDIR}${/}..${/}data${/}banco_status_codes.json

*** Keywords ***
Carregar Dados do Banco
    [Arguments]    ${arquivo_banco}
    [Documentation]    Carrega dados de um arquivo JSON
    ${conteudo}=    Get File    ${arquivo_banco}
    ${dados}=    Convert String To Json    ${conteudo}
    RETURN    ${dados}

Obter Usuario Valido
    [Arguments]    ${indice}=0
    [Documentation]    Retorna dados de um usuário válido pelo índice
    ${dados}=    Carregar Dados do Banco    ${BANCO_USUARIOS}
    ${usuario}=    Get From List    ${dados}[usuarios_validos]    ${indice}
    RETURN    ${usuario}

Obter Usuario Login
    [Arguments]    ${indice}=0
    [Documentation]    Retorna dados de login pelo índice
    ${dados}=    Carregar Dados do Banco    ${BANCO_USUARIOS}
    ${login}=    Get From List    ${dados}[usuarios_login]    ${indice}
    RETURN    ${login}

Obter ID Valido
    [Arguments]    ${indice}=0
    [Documentation]    Retorna um ID válido pelo índice
    ${dados}=    Carregar Dados do Banco    ${BANCO_USUARIOS}
    ${id}=    Get From List    ${dados}[ids_validos]    ${indice}
    RETURN    ${id}

Obter ID Invalido
    [Arguments]    ${indice}=0
    [Documentation]    Retorna um ID inválido pelo índice
    ${dados}=    Carregar Dados do Banco    ${BANCO_USUARIOS}
    ${id}=    Get From List    ${dados}[ids_invalidos]    ${indice}
    RETURN    ${id}

Obter Recurso
    [Arguments]    ${indice}=0
    [Documentation]    Retorna um recurso pelo índice
    ${dados}=    Carregar Dados do Banco    ${BANCO_USUARIOS}
    ${recurso}=    Get From List    ${dados}[recursos]    ${indice}
    RETURN    ${recurso}

Obter Payload Atualizacao
    [Arguments]    ${tipo}
    [Documentation]    Retorna payload de atualização por tipo
    ${dados}=    Carregar Dados do Banco    ${BANCO_ENDPOINTS}
    FOR    ${payload}    IN    @{dados}[payloads_atualizacao]
        IF    '${payload}[tipo]' == '${tipo}'
            RETURN    ${payload}[dados]
        END
    END
    Fail    Tipo de payload não encontrado: ${tipo}

Obter Status Code Esperado
    [Arguments]    ${metodo}    ${operacao}
    [Documentation]    Retorna status code esperado para método e operação
    ${dados}=    Carregar Dados do Banco    ${BANCO_STATUS_CODES}
    ${status}=    Get From Dictionary    ${dados}[status_codes_esperados][${metodo}]    ${operacao}
    RETURN    ${status}

Obter Custom Path
    [Arguments]    ${indice}=0
    [Documentation]    Retorna dados de custom path pelo índice
    ${dados}=    Carregar Dados do Banco    ${BANCO_ENDPOINTS}
    ${path}=    Get From List    ${dados}[custom_paths]    ${indice}
    RETURN    ${path}

Gerar Usuario Aleatorio
    [Documentation]    Gera dados de usuário com valores aleatórios
    ${palavra_aleatoria}=    Generate Random String    length=6    chars=[LETTERS]
    ${palavra_aleatoria}=    Convert To Lower Case    ${palavra_aleatoria}
    ${usuario}=    Create Dictionary
    ...    username=${palavra_aleatoria}
    ...    email=${palavra_aleatoria}@teste.com
    ...    password=senha123
    ...    name=Usuario ${palavra_aleatoria}
    ...    job=Tester
    RETURN    ${usuario}