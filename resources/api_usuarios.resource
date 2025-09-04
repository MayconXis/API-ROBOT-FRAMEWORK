*** Settings ***
Library       RequestsLibrary
Library       String
Library       Collections
Resource      banco_dados.resource


*** Keywords ***
Cria um usuario na sessao
    ${palavra_aleatoria}    Generate Random String    length=4    chars=[LETTERS]
    ${palavra_aleatoria}    Convert To Lower Case    ${palavra_aleatoria}
    Set Test Variable    ${EMAIL_TESTE}    ${palavra_aleatoria}@gmail.com
    log    ${EMAIL_TESTE}


Criar Sessão na reqres_api API
    ${headers}    Create Dictionary
    ...           accept=application/json
    ...           Content-Type=application/json
    ...           x-api-key=reqres-free-v1
    Create Session
    ...           alias=reqres_api
    ...           url=https://reqres.in/api
    ...           headers=${headers}

POST Endpoint /users
    [Arguments]    ${indice_usuario}=0
    ${usuario}=    Obter Usuario Valido    ${indice_usuario}
    Criar Sessão na reqres_api API
    ${response}=    POST On Session
    ...             alias=reqres_api
    ...             url=/users
    ...             json=${usuario}
    ${ID_USUARIO}=    Get From Dictionary    ${response.json()}    id
    Set Test Variable    ${ID_USUARIO}
    Log To Console    Usuário criado: ${usuario}[username]
    RETURN    ${response}

Validar Status Code
    [Arguments]    ${status_code_esperado}    ${status_code_recebido}
    [Documentation] 
    Should Be True    ${status_code_recebido} == ${status_code_esperado}

POST Endpoint /register
    [Arguments]    ${indice_registro}=0
    [Documentation]    Registra usuário usando dados dinâmicos
    ${dados_registro}=    Carregar Dados do Banco    ${BANCO_USUARIOS}
    ${usuario_registro}=    Get From List    ${dados_registro}[usuarios_registro]    ${indice_registro}
    Criar Sessão na reqres_api API
    ${response}=    POST On Session
    ...            reqres_api
    ...            /register    json=${usuario_registro}
    ${token}=    Get From Dictionary    ${response.json()}    token
    Log To Console    Token gerado: ${token}
    Should Not Be Empty    ${token}
    RETURN    ${response}

POST Endpoint /login
    [Arguments]    ${indice_login}=0
    [Documentation]    Faz login usando dados dinâmicos
    ${dados_login}=    Obter Usuario Login    ${indice_login}
    Criar Sessão na reqres_api API
    ${response}=    POST On Session
    ...             alias=reqres_api
    ...             url=/login
    ...             json=${dados_login}
    ${token}=    Get From Dictionary    ${response.json()}    token
    Should Not Be Empty    ${token}
    Log To Console    Token gerado: ${token}
    Set Global Variable    ${response}
    RETURN    ${response}

POST Endpoint /logout
    [Documentation]    
    Criar Sessão na reqres_api API
    &{payload}=    Create Dictionary
    ${response}=    POST On Session
    ...             alias=reqres_api
    ...             url=/logout
    ...             json=${payload}
    RETURN    ${response}

GET Listar Usuarios
    Criar Sessão na reqres_api API
    ${response}=    GET On Session    
    ...            alias=reqres_api    
    ...            url=/users
    RETURN    ${response}

GET Obter Usuario por ID
    [Arguments]    ${_id}
    Criar Sessão na reqres_api API
    ${response}=    GET On Session    
    ...            alias=reqres_api   
    ...            url=/users/${_id}
    RETURN    ${response}

GET Obter Usuario por ID invalido
    [Arguments]    ${id}
    Criar Sessão na reqres_api API
    ${response}=    GET On Session    
    ...            alias=reqres_api   
    ...            url=/users/${id}
    ...            expected_status=404
    RETURN    ${response}

GET Listar Resource
    [Arguments]    ${resource}
    Criar Sessão na reqres_api API
    ${response}=    GET On Session    
    ...             alias=reqres_api    
    ...             url=/${resource}
    RETURN    ${response}

GET Obter resource por ID
    [Arguments]    ${resource}    ${_id}
    Criar Sessão na reqres_api API
    ${response}=    GET On Session
    ...    alias=reqres_api
    ...    url=/${resource}/${_id}
    RETURN    ${response}

GET Obter resource invalido
    [Arguments]    ${resource}    ${id}
    Criar Sessão na reqres_api API
    ${response}=    GET On Session
    ...    alias=reqres_api
    ...    url=/${resource}/${id}
    ...    expected_status=404
    RETURN    ${response}

GET Obter Status de Assinatura
    [Documentation]    Gets subscription status
    Criar Sessão na reqres_api API
    ${response}=    GET On Session
    ...    alias=reqres_api
    ...    url=/clerk/subscription-status
    ...    expected_status=404
    RETURN    ${response}

GET Obter Custom Endpoints
    [Documentation]    Gets custom endpoints list
    Criar Sessão na reqres_api API
    ${response}=    GET On Session
    ...    alias=reqres_api
    ...    url=/custom-endpoints
    RETURN    ${response}

GET Obter Custom Endpoint por ID
    [Arguments]    ${_id}
    [Documentation]    Gets custom endpoint by ID
    Criar Sessão na reqres_api API
    ${response}=    GET On Session
    ...    alias=reqres_api
    ...    url=/custom-endpoints/${_id}
    RETURN    ${response}

GET Obter Custom Endpoint por ID invalido
    [Arguments]    ${endpoint_id}
    [Documentation]    Gets invalid custom endpoint
    Criar Sessão na reqres_api API
    ${response}=    GET On Session
    ...    alias=reqres_api
    ...    url=/custom-endpoints/${endpoint_id}
    ...    expected_status=404
    RETURN    ${response}

GET Executar Custom Path
    [Arguments]    ${path}
    [Documentation]    Executes custom path
    Criar Sessão na reqres_api API
    ${response}=    GET On Session
    ...    alias=reqres_api
    ...    url=/custom/${path}
    ...    expected_status=401
    RETURN    ${response}

POST Endpoint /clerk/link-pro
    [Documentation]    Links user to pro subscription
    ${payload}=    Create Dictionary    email=eve.holt@reqres.in
    Criar Sessão na reqres_api API
    ${response}=    POST On Session
    ...    alias=reqres_api
    ...    url=/clerk/link-pro
    ...    json=${payload}
    RETURN    ${response}

POST Endpoint /clerk/auto-link-pro
    [Documentation]    Auto links user to pro subscription
    ${payload}=    Create Dictionary    data={}    message=Auto Vinculado
    Criar Sessão na reqres_api API
    ${response}=    POST On Session
    ...    alias=reqres_api
    ...    url=/clerk/auto-link-pro
    ...    json=${payload}
    RETURN    ${response}

POST Endpoint /clerk/unlink-pro
    [Documentation]    Unlinks user from pro subscription
    Criar Sessão na reqres_api API
    ${payload}=    Create Dictionary
    ${response}=    POST On Session
    ...    alias=reqres_api
    ...    url=/clerk/unlink-pro
    ...    json=${payload}
    RETURN    ${response}

POST Endpoint /custom-endpoints
    [Documentation]    Creates custom endpoint
    ${nome_aleatorio}=    Generate Random String    length=8    chars=[LETTERS]
    ${nome_aleatorio}=    Convert To Lower Case    ${nome_aleatorio}
    ${headers_body}=    Create Dictionary    Content-Type=application/json
    ${response_data}=    Create Dictionary    data=Customizado
    ${payload}=    Create Dictionary
    ...    name=${nome_aleatorio}
    ...    path=/new-path-${nome_aleatorio}
    ...    response_data=${response_data}
    ...    status_code=200
    ...    headers=${headers_body}
    Criar Sessão na reqres_api API
    ${response}=    POST On Session
    ...    alias=reqres_api
    ...    url=/custom-endpoints
    ...    json=${payload}
    RETURN    ${response}

POST Executar Custom Path
    [Arguments]    ${path}
    [Documentation]    Executes custom path via POST
    Criar Sessão na reqres_api API
    ${payload}=    Create Dictionary
    ${response}=    POST On Session
    ...    alias=reqres_api
    ...    url=/custom/${path}
    ...    json=${payload}
    ...    expected_status=403
    RETURN    ${response}

PUT Endpoint /resources/id
    [Arguments]    ${resource}    ${id}    ${payload}
    Criar Sessão na reqres_api API
    ${response}=    PUT On Session
    ...    alias=reqres_api
    ...    url=/${resource}/${id}
    ...    json=${payload}
    RETURN    ${response}

PUT Endpoint /users/id
    [Arguments]    ${id}    ${payload}
    Criar Sessão na reqres_api API
    ${response}=    PUT On Session
    ...    alias=reqres_api
    ...    url=/users/${id}
    ...    json=${payload}
    RETURN    ${response}

PUT Endpoint /users/id invalido
    [Arguments]    ${id}    ${payload}
    Criar Sessão na reqres_api API
    ${response}=    PUT On Session
    ...    alias=reqres_api
    ...    url=/users/${id}
    ...    json=${payload}
    RETURN    ${response}

PUT Endpoint /custom-endpoints/id
   [Documentation]
    [Arguments]    ${id}    ${payload}
    Criar Sessão na reqres_api API
    ${response}=    PUT On Session
    ...    alias=reqres_api
    ...    url=/custom-endpoints/${id}
    ...    json=${payload}
    [Return]    ${response}
PUT Endpoint /custom/path
    [Documentation]  
    [Arguments]    ${path}    ${payload}
    Criar Sessão na reqres_api API
    ${response}=    PUT On Session    
    ...    alias=reqres_api    
    ...    url=/custom/${path}    
    ...    json=${payload}
    ...    expected_status=403
    [Return]    ${response}


    

PATCH Endpoint /users/id
    [Documentation]  
    [Arguments]    ${id}    ${payload}
    Criar Sessão na reqres_api API
    ${response}=    PATCH On Session    
    ...    alias=reqres_api    
    ...    url=/users/${id}    
    ...    json=${payload}
    [Return]    ${response}

PATCH Endpoint /resource/id invalido
      [Documentation]  
    [Arguments]    ${id}     ${resource}  ${payload}
    Criar Sessão na reqres_api API
    ${response}=    PATCH On Session    
    ...    alias=reqres_api    
    ...    url=/users/${id}    
    ...    json=${payload}
    [Return]    ${response}


PATCH Endpoint /resource/id
    [Documentation]
    [Arguments]    ${resource}    ${id}    ${payload}
    Criar Sessão na reqres_api API
    ${response}=    PATCH On Session
    ...    alias=reqres_api
    ...    url=/${resource}/${id}
    ...    json=${payload}
    [Return]    ${response}

PATCH Endpoint /custom/path
    [Documentation]
    [Arguments]     ${path}    ${payload}
    Criar Sessão na reqres_api API
    ${response}=    PATCH On Session
    ...    alias=reqres_api
    ...    url=/custom/${path}
    ...    json=${payload}
    ...     expected_status=403
    [Return]    ${response}
    
DELETE Endpoint /users/id
    [Documentation]    
    [Arguments]    ${id}
    Criar Sessão na reqres_api API
    ${response}=    DELETE On Session    
    ...    alias=reqres_api    
    ...    url=/users/${id}
    [Return]    ${response}
DELETE Endpoint /users/id invalido
    [Documentation]    
    [Arguments]    ${id}
    Criar Sessão na reqres_api API
    ${response}=    DELETE On Session    
    ...    alias=reqres_api    
    ...    url=/users/${id}
    [Return]    ${response}

DELETE Endpoint /resource/id    
     [Documentation]    
    [Arguments]    ${id}    ${resource}    
    Criar Sessão na reqres_api API
    ${response}=    DELETE On Session    
    ...    alias=reqres_api    
    ...    url=/{resource}/${id}
    [Return]    ${response}

DELETE Endpoint /custom-endpoints/id
    [Documentation]    
    [Arguments]    ${id}
    Criar Sessão na reqres_api API
    ${response}=    DELETE On Session    
    ...    alias=reqres_api    
    ...    url=/custom-endpoints/${id}
    [Return]    ${response}

DELETE Endpoint /custom/path
    [Documentation]    
    [Arguments]    ${path}
    Criar Sessão na reqres_api API
    ${response}=    DELETE On Session    
    ...    alias=reqres_api    
    ...    url=/custom/${path}
    ...    expected_status=403
    [Return]    ${response}

