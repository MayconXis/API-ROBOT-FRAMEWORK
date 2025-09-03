*** Settings ***
Documentation    Criando Casos de Teste Usando Massas de Dados Dinamicos
Library          Collections
Library          OperatingSystem  
Library          String
Suite Setup      Carregar Dados de Teste

*** Variables ***
${ARQUIVO_DADOS}    ${CURDIR}${/}..${/}data${/}test_data_users.json

*** Keywords ***
Carregar Dados de Teste
    [Documentation]    Carrega dados de teste do arquivo JSON
    ${conteudo_json}=    Get File    ${ARQUIVO_DADOS}
    ${DADOS_TESTE}=      Evaluate    json.loads('''${conteudo_json}''')    json
    Set Suite Variable    ${DADOS_TESTE}

Validar Estrutura Usuario
    [Arguments]    ${usuario}
    [Documentation]    Valida estrutura de dados do usuario
    Should Not Be Empty    ${usuario}[name]
    Should Not Be Empty    ${usuario}[job]
    Should Not Be Empty    ${usuario}[department]
    Should Not Be Empty    ${usuario}[status]
    Should Contain    ${usuario}[email]    @
    Should Contain    ${usuario}[email]    .com

*** Test Cases ***
Cenario 01: Validar Dados de Usuarios Dinamicos
    [Documentation]    Valida estrutura dos dados de usuarios do arquivo JSON
    [Tags]    dinamico    validacao
    FOR    ${usuario}    IN    @{DADOS_TESTE}[test_users]
        Validar Estrutura Usuario    ${usuario}
        Log To Console    Usuario ${usuario}[name] validado com sucesso
    END

Cenario 02: Contar Usuarios por Status
    [Documentation]    Conta usuarios por status usando dados dinamicos
    [Tags]    dinamico    contagem
    ${usuarios_ativos}=    Create List
    ${usuarios_inativos}=    Create List
    FOR    ${usuario}    IN    @{DADOS_TESTE}[test_users]
        IF    "${usuario}[status]" == "active"
            Append To List    ${usuarios_ativos}    ${usuario}
        ELSE
            Append To List    ${usuarios_inativos}    ${usuario}
        END
    END
    ${total_ativos}=    Get Length    ${usuarios_ativos}
    ${total_inativos}=    Get Length    ${usuarios_inativos}
    Log To Console    Total usuarios ativos: ${total_ativos}
    Log To Console    Total usuarios inativos: ${total_inativos}
    Should Be True    ${total_ativos} > 0

Cenario 03: Agrupar Usuarios por Departamento
    [Documentation]    Agrupa usuarios por departamento usando dados dinamicos
    [Tags]    dinamico    departamento
    ${departamentos}=    Create Dictionary
    FOR    ${usuario}    IN    @{DADOS_TESTE}[test_users]
        ${dept}=    Set Variable    ${usuario}[department]
        ${dept_existe}=    Run Keyword And Return Status    Dictionary Should Contain Key    ${departamentos}    ${dept}
        IF    ${dept_existe}
            ${usuarios_dept}=    Get From Dictionary    ${departamentos}    ${dept}
        ELSE
            ${usuarios_dept}=    Create List
        END
        Append To List    ${usuarios_dept}    ${usuario}[name]
        Set To Dictionary    ${departamentos}    ${dept}    ${usuarios_dept}
    END
    FOR    ${dept}    ${usuarios}    IN    &{departamentos}
        ${total}=    Get Length    ${usuarios}
        Log To Console    Departamento ${dept}: ${total} usuarios
        Should Be True    ${total} > 0
    END

Cenario 04: Validar Cenarios de Teste
    [Documentation]    Valida cenarios de teste definidos no JSON
    [Tags]    dinamico    cenarios
    ${cenarios}=    Set Variable    ${DADOS_TESTE}[test_scenarios]
    Should Contain    ${cenarios}    create_user
    Should Contain    ${cenarios}    update_user
    Should Contain    ${cenarios}    invalid_user
    ${create_user}=    Get From Dictionary    ${cenarios}    create_user
    Should Not Be Empty    ${create_user}[name]
    Should Not Be Empty    ${create_user}[job]
    Log To Console    Cenarios de teste validados com sucesso

Cenario 05: Validar Endpoints da API
    [Documentation]    Valida definicoes de endpoints no JSON
    [Tags]    dinamico    endpoints
    ${endpoints}=    Set Variable    ${DADOS_TESTE}[api_endpoints]
    Should Contain    ${endpoints}    users
    Should Contain    ${endpoints}    single_user
    Should Contain    ${endpoints}    register
    Should Contain    ${endpoints}    login
    ${users_endpoint}=    Get From Dictionary    ${endpoints}    users
    Should Be Equal    ${users_endpoint}    /users
    Log To Console    Endpoints validados com sucesso