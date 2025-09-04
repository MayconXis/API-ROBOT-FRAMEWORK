*** Settings ***
Documentation    Sistema auxiliar para criação dinâmica de usuários com dados únicos
Library          RequestsLibrary
Library          Collections
Library          String
Library          DateTime
Resource         static_variables.robot

*** Variables ***
${DYNAMIC_USER_DATA}    ${None}

*** Keywords ***
Criar Usuario Dinamico Completo
    [Documentation]    Cria usuário dinamicamente com dados únicos e armazena para reutilização nos testes
    ${timestamp}=    Get Current Date    result_format=%Y%m%d_%H%M%S
    ${nome_aleatorio}=    Generate Random String    length=8    chars=[LETTERS]
    ${nome_aleatorio}=    Convert To Lower Case    ${nome_aleatorio}
    
    ${payload_dinamico}=    Create Dictionary
    ...    name=Usuario_${nome_aleatorio}_${timestamp}
    ...    job=QA_Engineer_${timestamp}
    ...    email=${nome_aleatorio}@dinamico.com
    ...    username=${nome_aleatorio}_user
    ...    password=<senha_dinamica>
    
    ${resposta}=    POST On Session    ${SESSION_NAME}    /users    json=${payload_dinamico}    expected_status=any
    
    ${usuario_criado}=    Create Dictionary
    ...    payload=${payload_dinamico}
    ...    response=${resposta}
    ...    id=${resposta.json().get('id', 'N/A')}
    ...    name=${payload_dinamico}[name]
    ...    email=${payload_dinamico}[email]
    ...    job=${payload_dinamico}[job]
    
    Set Global Variable    ${DYNAMIC_USER_DATA}    ${usuario_criado}
    RETURN    ${usuario_criado}

Obter Usuario Dinamico Atual
    [Documentation]    Retorna dados do último usuário criado dinamicamente ou cria novo se não existir
    IF    ${DYNAMIC_USER_DATA} == ${None}
        ${usuario}=    Criar Usuario Dinamico Completo
        RETURN    ${usuario}
    END
    RETURN    ${DYNAMIC_USER_DATA}

Gerar Payload Login Dinamico
    [Documentation]    Gera payload de login com dados dinâmicos do usuário atual
    ${usuario}=    Obter Usuario Dinamico Atual
    ${payload_login}=    Create Dictionary
    ...    email=${usuario}[email]
    ...    password=<senha_dinamica>
    RETURN    ${payload_login}

Gerar Payload Atualizacao Dinamico
    [Arguments]    ${tipo}=completo
    [Documentation]    Gera payload de atualização dinâmico - tipos: completo ou parcial
    ${timestamp}=    Get Current Date    result_format=%H%M%S
    ${nome_update}=    Generate Random String    length=6    chars=[LETTERS]
    ${nome_update}=    Convert To Lower Case    ${nome_update}
    
    IF    '${tipo}' == 'completo'
        ${payload}=    Create Dictionary
        ...    name=Updated_${nome_update}_${timestamp}
        ...    job=Senior_QA_${timestamp}
        ...    email=${nome_update}_updated@dinamico.com
    ELSE
        ${payload}=    Create Dictionary
        ...    job=Updated_Job_${timestamp}
    END
    
    RETURN    ${payload}

Resetar Usuario Dinamico
    [Documentation]    Reseta dados do usuário dinâmico para garantir dados únicos no próximo teste
    Set Global Variable    ${DYNAMIC_USER_DATA}    ${None}
    Log To Console    Dados de usuário dinâmico resetados