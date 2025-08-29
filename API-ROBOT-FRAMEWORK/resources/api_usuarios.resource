*** Settings ***
Library       RequestsLibrary
Library       String
Library       Collections


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
    Cria um usuario na sessao  
    &{payload}=    Create Dictionary
    ...           username=maycon
    ...           email=${EMAIL_TESTE}  
    ...           password=teste123
    log to console    ${payload}
    Criar Sessão na reqres_api API

    ${response}=    POST On Session
    ...             alias=reqres_api
    ...             url=/users
    ...             json=${payload}

    ${ID_USUARIO}=    Get From Dictionary    ${response.json()}    id
    Set Test Variable    ${ID_USUARIO}
    [Return]    ${response}
Validar Status Code
    [Arguments]    ${status_code_esperado}    ${status_code_recebido}
    [Documentation] 
    Should Be True    ${status_code_recebido} == ${status_code_esperado}

POST Endpoint /register "eve.holt@reqres.in"
    [Documentation]
    Criar Sessão na reqres_api API
    ${payload}=    Create Dictionary    
    ...         email=eve.holt@reqres.in    
    ...         password=teste123
    ${reposta}=    POST On Session    
    ...            reqres_api    
    ...            /register    json=${payload}
    Status Should Be    
    ...    200    ${reposta}
    ${token}=    Get From Dictionary    
    ...    ${reposta.json()}    token
    Log To Console    Token gerado: ${token}
    Should Not Be Empty    ${token}
        [Return]    ${reposta}

POST Endpoint /login
    [Documentation]
    &{payload}=    Create Dictionary
    ...           email=eve.holt@reqres.in
    ...           password=teste123
    Criar Sessão na reqres_api API
    ${response}=    POST On Session
    ...             alias=reqres_api
    ...             url=/login
    ...             json=${payload}
    ${token}=    Get From Dictionary    ${response.json()}    token
    Should Not Be Empty    ${token}
    Log To Console    Token gerado: ${token}
    [Return]    ${response}

POST Endpoint /logout
    [Documentation]    
    Criar Sessão na reqres_api API
    &{payload}=    Create Dictionary
    ${response}=    POST On Session
    ...             alias=reqres_api
    ...             url=/logout
    ...             json=${payload}
    [Return]    ${response}

POST Endpoint /clerk/link-pro
    [Documentation]
    &{payload}=    Create Dictionary
    ...           email=eve.holt@reqres.in
    Criar Sessão na reqres_api API
    ${response}=    POST On Session
    ...             alias=reqres_api
    ...             url=/clerk/link-pro
    ...             json=${payload}
    [Return]    ${response}

POST Endpoint /clerk/auto-link-pro
      [Documentation]
    &{payload}=    Create Dictionary
    ...           data={}    
    ...           message="Auto Vinculado"
    Criar Sessão na reqres_api API
    ${response}=    POST On Session
    ...             alias=reqres_api
    ...             url=/clerk/auto-link-pro
    ...             json=${payload}
    [Return]    ${response}

POST Endpoint /clerk/unlink-pro
    [Documentation]    
    Criar Sessão na reqres_api API
    &{body}=    Create Dictionary
    ${response}=    POST On Session
    ...             alias=reqres_api
    ...             url=/logout
    ...             json=${body}
    [Return]    ${response}

POST Endpoint /custom-endpoints
    [Documentation]   #Criei variáveis aleatórias, pois a API dá conflito se eu tentar customizar um que já existe.
    ${nome_aleatorio}=    Generate Random String    length=8    chars=[LETTERS]
    ${nome_aleatorio}=    Convert To Lower Case    ${nome_aleatorio} 
    &{headers_body}=    Create Dictionary    Content-Type=application/json
    &{response_data_body}=    Create Dictionary    data=Customizado
    &{payload}=    Create Dictionary
    ...           name=${nome_aleatorio} 
    ...           path=/new-path-${nome_aleatorio}
    ...           response_data=${response_data_body}
    ...           status_code=200
    ...           headers=${headers_body}
    Criar Sessão na reqres_api API
    ${response}=    POST On Session
    ...             alias=reqres_api
    ...             url=/custom-endpoints
    ...             json=${payload}
    [Return]     ${response}

POST Executar Custom Path
    [Arguments]    ${path}
    [Documentation]
    Criar Sessão na reqres_api API
    &{payload}=    Create Dictionary
    ${response}=    POST On Session
    ...             alias=reqres_api
    ...             url=/custom/${path}
    ...             json=${payload}
    ...             expected_status=403
    [Return]    ${response}

GET Listar Usuarios
    Criar Sessão na reqres_api API
    ${response}=    GET On Session    
    ...            alias=reqres_api    
    ...            url=/users
    [Return]    ${response}

GET Obter Usuario por ID
    [Arguments]    ${_id}
    Criar Sessão na reqres_api API
    ${response}=    GET On Session    
    ...            alias=reqres_api   
    ...            url=/users/${_id}
    [Return]    ${response}
GET Obter Usuario por ID invalido
    [Arguments]    ${_id}
    Criar Sessão na reqres_api API
    ${response}=    GET On Session    
    ...            alias=reqres_api   
    ...            url=/users/${_id}
    ...            expected_status=404
    [Return]    ${response}
GET Listar Resource
    [Arguments]    ${resource}
    Criar Sessão na reqres_api API
    ${response}=    GET On Session    
    ...             alias=reqres_api    
    ...             url=/${resource}
    [Return]    ${response}

GET Obter Resource por ID
    [Arguments]    ${resource}    ${_id}
    Criar Sessão na reqres_api API
    ${response}=    GET On Session    
    ...            alias=reqres_api    
    ...            url=/${resource}/${_id}
    [Return]    ${response}
GET Obter resource invalido
    [Arguments]    ${resource}    ${_id}
    Criar Sessão na reqres_api API
    ${response}=    GET On Session    
    ...            alias=reqres_api    
    ...            url=/${resource}/${_id}
    ...            expected_status=404
    [Return]    ${response}

GET Obter Status de Assinatura     
    [Documentation]  
    Criar Sessão na reqres_api API
    ${response}=    GET On Session
    ...    alias=reqres_api
    ...    url=/clerk/subscription-status
    ...    expected_status=404
    [Return]    ${response}

GET Obter Custom Endpoints
    [Documentation]
    Criar Sessão na reqres_api API
    ${response}=    GET On Session
    ...    alias=reqres_api
    ...    url=/custom-endpoints
    [Return]    ${response}

GET Obter Custom Endpoint por ID
    [Documentation]  
    [Arguments]    ${_id}
    Criar Sessão na reqres_api API
    ${response}=    GET On Session
    ...    alias=reqres_api
    ...    url=/custom-endpoints/${_id}
    [Return]    ${response}
GET Obter Custom Endpoint por ID invalido
    [Documentation]  
    [Arguments]    ${_id}
    Criar Sessão na reqres_api API
    ${response}=    GET On Session
    ...    alias=reqres_api
    ...    url=/custom-endpoints/${_id}
    ...    expected_status=404
    [Return]    ${response}
GET Executar Custom Path
    [Documentation] 
    [Arguments]    ${path}
    Criar Sessão na reqres_api API
    ${response}=    GET On Session
    ...    alias=reqres_api
    ...    url=/custom/${path}
    ...    expected_status=401
    [Return]    ${response}


PUT Endpoint /users/id
    [Documentation]  
    [Arguments]    ${id}    ${payload}
    Criar Sessão na reqres_api API
    ${response}=    PUT On Session
    ...    alias=reqres_api
    ...    url=/users/${id}
    ...    json=${payload}
    [Return]    ${response}

PUT Endpoint /users/id invalido
    [Documentation]  
    [Arguments]    ${id}    ${payload}
    Criar Sessão na reqres_api API
    ${response}=    PUT On Session
    ...    alias=reqres_api
    ...    url=/users/${id}
    ...    json=${payload}
    [Return]    ${response}

PUT Endpoint /resources/id 
   [Arguments]    ${resource}    ${id}    ${payload}
    Criar Sessão na reqres_api API
    ${response}=    PUT On Session
    ...    alias=reqres_api
    ...    url=/${resource}/${id}
    ...    json=${payload}
    [Return]    ${response}

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

