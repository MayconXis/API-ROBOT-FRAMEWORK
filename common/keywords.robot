*** Settings ***
Documentation    Keywords consolidadas para automação de API
Library          RequestsLibrary
Library          Collections
Library          String
Library          DateTime
Resource         static_variables.robot
Resource         ../resources/banco_dados.resource

*** Variables ***
${SESSION_NAME}  reqres_api

*** Keywords ***
Validar Status Code
    [Arguments]    ${status_esperado}    ${status_atual}
    [Documentation]    Valida se o status code está correto
    Should Be Equal As Numbers    ${status_esperado}    ${status_atual}

Criar Sessão na reqres_api API
    [Documentation]    Cria sessão para API ReqRes 
    Create Session    ${SESSION_NAME}    ${BASE_URL}

Gerar Payload Usuario Dinamico
    [Arguments]    ${tipo}=completo
    [Documentation]    Gera payload dinâmico para usuário
    ${timestamp}=    Get Current Date    result_format=%Y%m%d_%H%M%S
    ${nome_aleatorio}=    Generate Random String    length=6    chars=[LETTERS]
    ${nome_aleatorio}=    Convert To Lower Case    ${nome_aleatorio}
    
    IF    '${tipo}' == 'completo'
        ${payload}=    Create Dictionary
        ...    name=Usuario_${nome_aleatorio}_${timestamp}
        ...    job=QA_Engineer_${timestamp}
        ...    email=${nome_aleatorio}@teste.com
    ELSE IF    '${tipo}' == 'parcial'
        ${payload}=    Create Dictionary
        ...    name=Usuario_Parcial_${nome_aleatorio}
        ...    job=Tester_${timestamp}
    ELSE
        ${payload}=    Create Dictionary
        ...    name=Usuario_${nome_aleatorio}
        ...    job=Developer
    END
    
    RETURN    ${payload}

Gerar Payload Login Dinamico
    [Documentation]    Gera payload dinâmico para login
    ${payload}=    Create Dictionary
    ...    email=eve.holt@reqres.in
    ...    password=<senha_api>
    RETURN    ${payload}

Gerar Payload Registro Dinamico
    [Documentation]    Gera payload dinâmico para registro
    ${timestamp}=    Get Current Date    result_format=%Y%m%d_%H%M%S
    ${payload}=    Create Dictionary
    ...    email=eve.holt@reqres.in
    ...    password=<senha_api>
    RETURN    ${payload}

Criar Usuario Dinamico
    [Documentation]    Cria um usuário dinamicamente e retorna seus dados
    ${payload}=    Gerar Payload Usuario Dinamico    completo
    ${resposta}=    POST On Session    ${SESSION_NAME}    /users    json=${payload}
    Should Be Equal As Numbers    ${resposta.status_code}    201
    ${usuario_criado}=    Set Variable    ${resposta.json()}
    Set To Dictionary    ${usuario_criado}    email=${payload}[email]
    RETURN    ${usuario_criado}

POST Endpoint /users
    [Arguments]    ${indice_usuario}=0    ${payload}=${None}
    [Documentation]    Endpoint POST para criar usuário
    IF    ${payload} == ${None}
        ${payload}=    Gerar Payload Usuario Dinamico
    END
    ${resposta}=    POST On Session    ${SESSION_NAME}    /users    json=${payload}    expected_status=any
    RETURN    ${resposta}

POST Endpoint /register
    [Documentation]    Endpoint POST para registrar usuário
    ${payload}=    Gerar Payload Registro Dinamico
    ${resposta}=    POST On Session    ${SESSION_NAME}    /register    json=${payload}    expected_status=any
    RETURN    ${resposta}

POST Endpoint /login
    [Documentation]    Endpoint POST para login
    ${payload}=    Gerar Payload Login Dinamico
    ${resposta}=    POST On Session    ${SESSION_NAME}    /login    json=${payload}    expected_status=any
    RETURN    ${resposta}

POST Endpoint /logout
    [Documentation]    Endpoint POST para logout
    ${payload}=    Create Dictionary
    ${resposta}=    POST On Session    ${SESSION_NAME}    /logout    json=${payload}
    RETURN    ${resposta}

POST Endpoint /clerk/link-pro
    [Documentation]    Endpoint POST para vincular assinatura Pro
    ${payload}=    Create Dictionary
    ${resposta}=    POST On Session    ${SESSION_NAME}    /clerk/link-pro    json=${payload}
    RETURN    ${resposta}

POST Endpoint /clerk/auto-link-pro
    [Documentation]    Endpoint POST para auto vincular assinatura Pro
    ${payload}=    Create Dictionary
    ${resposta}=    POST On Session    ${SESSION_NAME}    /clerk/auto-link-pro    json=${payload}
    RETURN    ${resposta}

POST Endpoint /clerk/unlink-pro
    [Documentation]    Endpoint POST para desvincular assinatura Pro
    ${payload}=    Create Dictionary
    ${resposta}=    POST On Session    ${SESSION_NAME}    /clerk/unlink-pro    json=${payload}
    RETURN    ${resposta}

POST Endpoint /custom-endpoints
    [Documentation]    Endpoint POST para criar endpoint customizado
    ${payload}=    Create Dictionary
    ...    name=endpoint-dinamico
    ...    path=/path-dinamico
    ...    method=GET
    ${resposta}=    POST On Session    ${SESSION_NAME}    /custom-endpoints    json=${payload}
    RETURN    ${resposta}

POST Executar Custom Path
    [Arguments]    ${path}
    [Documentation]    Executa custom path via POST
    ${payload}=    Create Dictionary
    ${resposta}=    POST On Session    ${SESSION_NAME}    /custom/${path}    json=${payload}    expected_status=any
    RETURN    ${resposta}

# ========== KEYWORDS GET ==========
GET Listar Usuarios
    [Documentation]    Lista todos os usuários
    ${resposta}=    GET On Session    ${SESSION_NAME}    /users    expected_status=any
    RETURN    ${resposta}

GET Obter Usuario por ID
    [Arguments]    ${_id}
    [Documentation]    Obtém usuário por ID específico
    ${resposta}=    GET On Session    ${SESSION_NAME}    /users/${_id}    expected_status=any
    RETURN    ${resposta}

GET Obter Usuario por ID invalido
    [Arguments]    ${id}
    [Documentation]    Tenta obter usuário com ID inválido
    ${resposta}=    GET On Session    ${SESSION_NAME}    /users/${id}    expected_status=any
    RETURN    ${resposta}

GET Listar Resource
    [Arguments]    ${resource}
    [Documentation]    Lista recursos específicos
    ${resposta}=    GET On Session    ${SESSION_NAME}    /${resource}
    RETURN    ${resposta}

GET Obter resource por ID
    [Arguments]    ${resource}    ${_id}
    [Documentation]    Obtém resource por ID
    ${resposta}=    GET On Session    ${SESSION_NAME}    /${resource}/${_id}
    RETURN    ${resposta}

GET Obter resource invalido
    [Arguments]    ${recurso}    ${id}
    [Documentation]    Tenta obter resource inválido
    ${resposta}=    GET On Session    ${SESSION_NAME}    /${recurso}/${id}    expected_status=any
    RETURN    ${resposta}

GET Obter Status de Assinatura
    [Documentation]    Obtém status de assinatura
    ${resposta}=    GET On Session    ${SESSION_NAME}    /subscription/status    expected_status=any
    RETURN    ${resposta}

GET Obter Custom Endpoints
    [Documentation]    Lista custom endpoints
    ${resposta}=    GET On Session    ${SESSION_NAME}    /custom-endpoints
    RETURN    ${resposta}

GET Obter Custom Endpoint por ID
    [Arguments]    ${_id}
    [Documentation]    Obtém custom endpoint por ID
    ${resposta}=    GET On Session    ${SESSION_NAME}    /custom-endpoints/${_id}
    RETURN    ${resposta}

GET Obter Custom Endpoint por ID invalido
    [Arguments]    ${endpoint_id}
    [Documentation]    Tenta obter custom endpoint com ID inválido
    ${resposta}=    GET On Session    ${SESSION_NAME}    /custom-endpoints/${endpoint_id}    expected_status=any
    RETURN    ${resposta}

GET Executar Custom Path
    [Arguments]    ${path}
    [Documentation]    Executa custom path via GET
    ${resposta}=    GET On Session    ${SESSION_NAME}    /custom/${path}    expected_status=any
    RETURN    ${resposta}

# ========== KEYWORDS PUT ==========
PUT Endpoint /users/id
    [Arguments]    ${id}    ${payload}=${None}
    [Documentation]    Atualiza usuário via PUT
    IF    ${payload} == ${None}
        ${payload}=    Gerar Payload Usuario Dinamico    completo
    END
    ${resposta}=    PUT On Session    ${SESSION_NAME}    /users/${id}    json=${payload}
    RETURN    ${resposta}

PUT Endpoint /resources/id
    [Arguments]    ${resource}    ${id}    ${payload}
    [Documentation]    Atualiza resource via PUT
    ${resposta}=    PUT On Session    ${SESSION_NAME}    /${resource}/${id}    json=${payload}
    RETURN    ${resposta}

PUT Endpoint /custom-endpoints/id
    [Arguments]    ${id}    ${payload}
    [Documentation]    Atualiza custom endpoint via PUT
    ${resposta}=    PUT On Session    ${SESSION_NAME}    /custom-endpoints/${id}    json=${payload}
    RETURN    ${resposta}

PUT Endpoint /custom/path
    [Arguments]    ${path}    ${payload}
    [Documentation]    Executa custom path via PUT
    ${resposta}=    PUT On Session    ${SESSION_NAME}    /custom/${path}    json=${payload}    expected_status=any
    RETURN    ${resposta}

PUT Endpoint /users/id invalido
    [Arguments]    ${id}    ${payload}
    [Documentation]    Tenta atualizar usuário com ID inválido
    ${resposta}=    PUT On Session    ${SESSION_NAME}    /users/${id}    json=${payload}    expected_status=any
    RETURN    ${resposta}

# ========== KEYWORDS PATCH ==========
PATCH Endpoint /users/id
    [Arguments]    ${id}    ${payload}=${None}
    [Documentation]    Atualiza parcialmente usuário via PATCH
    IF    ${payload} == ${None}
        ${payload}=    Gerar Payload Usuario Dinamico    parcial
    END
    ${resposta}=    PATCH On Session    ${SESSION_NAME}    /users/${id}    json=${payload}
    RETURN    ${resposta}

PATCH Endpoint /resource/id
    [Arguments]    ${resource}    ${id}    ${payload}
    [Documentation]    Atualiza resource via PATCH
    ${resposta}=    PATCH On Session    ${SESSION_NAME}    /${resource}/${id}    json=${payload}
    RETURN    ${resposta}

PATCH Endpoint /custom/path
    [Arguments]    ${path}    ${payload}
    [Documentation]    Executa custom path via PATCH
    ${resposta}=    PATCH On Session    ${SESSION_NAME}    /custom/${path}    json=${payload}    expected_status=any
    RETURN    ${resposta}

PATCH Endpoint /resource/id invalido
    [Arguments]    ${resource}    ${id}    ${payload}
    [Documentation]    Tenta atualizar resource com ID inválido
    ${resposta}=    PATCH On Session    ${SESSION_NAME}    /${resource}/${id}    json=${payload}    expected_status=any
    RETURN    ${resposta}

# ========== KEYWORDS DELETE ==========
DELETE Endpoint /users/id
    [Arguments]    ${id}
    [Documentation]    Remove usuário via DELETE
    ${resposta}=    DELETE On Session    ${SESSION_NAME}    /users/${id}
    RETURN    ${resposta}

DELETE Endpoint /resource/id
    [Arguments]    ${id}    ${resource}
    [Documentation]    Remove resource via DELETE
    ${resposta}=    DELETE On Session    ${SESSION_NAME}    /${resource}/${id}
    RETURN    ${resposta}

DELETE Endpoint /custom-endpoints/id
    [Arguments]    ${id}
    [Documentation]    Remove custom endpoint via DELETE
    ${resposta}=    DELETE On Session    ${SESSION_NAME}    /custom-endpoints/${id}
    RETURN    ${resposta}

DELETE Endpoint /custom/path
    [Arguments]    ${path}
    [Documentation]    Executa custom path via DELETE
    ${resposta}=    DELETE On Session    ${SESSION_NAME}    /custom/${path}    expected_status=any
    RETURN    ${resposta}

DELETE Endpoint /users/id invalido
    [Arguments]    ${id}
    [Documentation]    Tenta remover usuário com ID inválido
    ${resposta}=    DELETE On Session    ${SESSION_NAME}    /users/${id}    expected_status=any
    RETURN    ${resposta}