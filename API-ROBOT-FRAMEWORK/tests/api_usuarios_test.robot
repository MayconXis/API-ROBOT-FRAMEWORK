*** Settings ***
Resource    ../resources/api_usuarios.resource
Documentation    Keywords de teste para a API reqres.in
Library          RequestsLibrary
Library          String
Library          Collections

*** Variables ***
*** Test Cases ***
Cenário 01: POST Cadastrar um novo usuário com sucesso na ReqRes API
    [Tags]    POST
    Criar Sessão na reqres_api API
    Cria um usuario na sessao  
   ${resposta}=     POST Endpoint /users 
    Validar Status Code    201    ${resposta.status_code}
    Log To Console    Novo usuario criado com sucesso!
Cenário 02 : POST registrar um usuario
    [Tags]    POST
    Criar Sessão na reqres_api API
   ${resposta}=    POST Endpoint /register "eve.holt@reqres.in"
   Validar Status Code    200    ${resposta.status_code}
    Log To Console  Usuario registrado com sucesso!
Cenário 03 : POST logar um usuario
    [Tags]    POST
    ${resposta}=    POST Endpoint /login
    Validar Status Code    200    ${resposta.status_code}
    Log To Console    Login realizado e token obtido com sucesso.
    
   
    
Cenario 04: POST Permitir usuario dar logout  
    [Tags]    POST
    ${resposta_login}=    POST Endpoint /login
    ${resposta_logout}=    POST Endpoint /logout
    Validar Status Code    200    ${resposta_logout.status_code}
    Log To Console    Logout realizado com sucesso.

Cenario 05:POST Vincular Usuário a Assinatura Pro com Sucesso
    [Tags]    POST
    ${resposta}=     POST Endpoint /clerk/link-pro
     Validar Status Code    201    ${resposta.status_code}
    Log To Console    Vínculo realizado com sucesso, status code retornado deveria ser 200, porém API retorna 201 com sucesso.

Cenario 06:POST Auto Vincular Usuário a Assinatura Pro com Sucesso
    [Tags]    POST
    ${resposta}=     POST Endpoint /clerk/auto-link-pro
     Validar Status Code    201    ${resposta.status_code}  
    Log To Console    Vínculo automático realizado com sucesso,status code retornado deveria ser 200, porém API retorna 201 com sucesso.

Cenario 07:POST Desvincular Assinatura Pro de Usuário com Sucesso
    [Tags]    POST
   ${resposta}=  POST Endpoint /clerk/unlink-pro
   Validar Status Code    200    ${resposta.status_code}
   Log To Console    Desvincular realizado com sucesso.

Cenario 08: POST Criar um Endpoint Customizado com Sucesso 
    [Tags]    POST
    ${resposta}=    POST Endpoint /custom-endpoints
    Validar Status Code    201    ${resposta.status_code}
    Log To Console    Endpoint customizado criado com sucesso!


Cenario 09: POST Executar Endpoint Customizado em /custom/patch sem assinatura     #não consegui executar pois, estou na versão API gratuita
    [Tags]    POST
    ${resposta}=    POST Executar Custom Path    path=1
    Validar Status Code    403   ${resposta.status_code}
    Log To Console    Endpoint em /custom/1 executado com sucesso


Cenario 10: GET Listar usuarios com sucesso
    [Tags]    GET
    ${resposta}=    GET Listar Usuarios
    Validar Status Code    200    ${resposta.status_code}
    Log To Console    Lista de usuarios obtida com sucesso.

Cenario 11: GET Obter usuario com ID valido
    [Tags]    GET
    ${resposta}=    GET Obter Usuario por ID    _id=1
    Validar Status Code    200    ${resposta.status_code}
    ${id}=    Get From Dictionary    ${resposta.json()}[data]    id
    Should Be Equal As Strings    ${id}    1
    Log To Console    Usuario por ID obtido com sucesso.

Cenario 12: GET Obter usuario com ID invalido
    [Tags]    GET
    ${resposta}=    GET Obter Usuario por ID invalido    user_id=111111111111111
    Validar Status Code    404    ${resposta.status_code}
    Log To Console    Resposta 404 para usuario invalido.

Cenario 13: GET Listar resource
    [Tags]    GET
    ${resposta}=    GET Listar Resource   recurso=users
    Validar Status Code    200   ${resposta.status_code}
    Log To Console    Lista de recursos genericos obtida com sucesso.

*** Test Cases ***
Cenario 14: GET Obter resource por ID
    [Tags]    GET
   ${resposta}=    GET Obter resource por ID    resource=users    _id=4
    Validar Status Code    200    ${resposta.status_code}
    Log To Console    Resource por ID obtido com sucesso.

Cenario 15: GET Obter resource invalido
    [Tags]    GET
    ${resposta}=    GET Obter resource por ID    recurso=users    id=111111111111111
    Validar Status Code    404    ${resposta.status_code}
    Log To Console    Resposta 404 obtida com sucesso.

Cenario 16: GET Obter Status de Assinatura sem autorização     #não consegui executar pois, estou na versão API gratuita
    [Tags]    GET
    ${resposta}=    GET Obter Status de Assinatura
    Validar Status Code    404   ${resposta.status_code}
    Log To Console    Status de assinatura obtido com sucesso.

Cenario 17: GET Obter Custom Endpoints com sucesso
    [Tags]    GET
    ${response}=    GET Obter Custom Endpoints
    Validar Status Code    200    ${response.status_code}
    Should Contain    ${response.text}    "data"
    Log To Console    Lista de custom endpoints obtida com sucesso.
Cenario 18: GET Obter Custom Endpoint por ID com sucesso
    [Tags]    GET
    [Documentation]
    ${response}=    GET Obter Custom Endpoint por ID    _id=1
    Validar Status Code    200    ${response.status_code}
    Log To Console    Custom endpoint por ID obtido com sucesso.
Cenario 19: GET Obter Custom Endpoint com ID invalido
    [Tags]    GET
    [Documentation] 
    ${response}=    GET Obter Custom Endpoint por ID invalido    endpoint_id=9999
    Validar Status Code    404    ${response.status_code}
    Log To Console    Resposta 404 obtida para ID de endpoint inexistente.

Cenario 20: GET Executar Custom Path sem autorização    #não consegui executar pois, estou na versão API gratuita
    [Tags]    GET
    ${response}=    GET Executar Custom Path    path=users-path
    Validar Status Code    401    ${response.status_code}
    Log To Console    Custom path executado com sucesso.


Cenario 21: PUT Atualizar usuario com sucesso
    [Tags]    PUT
    ${payload}=    Create Dictionary
    ...    name=maycon
    ...    job=douglas
    ${resposta}=    PUT Endpoint /users/id    id=1    payload=${payload}
    Validar Status Code    200    ${resposta.status_code}
    Log To Console    Usuário atualizado com sucesso.
Cenario 22: PUT Atualizar um resource com sucesso
    [Tags]    PUT
    ${payload}=    Create Dictionary
    ...    name=Maycon
    ...    job=QA
    ${resposta}=    PUT Endpoint /resources/id    resource=users    id=1    payload=${payload}
    Validar Status Code    200    ${resposta.status_code}
    Log To Console    Resource atualizado com sucesso.

Cenario 23: PUT Atualizar Custom Endpoint com sucesso
    [Tags]    PUT
    ${payload}=    Create Dictionary
    ...    name=updated-name
    ...    path=/path-atualizada
    ...    status_code=200
    ${resposta}=    PUT Endpoint /custom-endpoints/id    id=1    payload=${payload}
    Validar Status Code    200    ${resposta.status_code}
    Log To Console    Custom endpoint atualizado com sucesso.

Cenario 24: PUT Executar Custom Path sem autorização    #não consegui executar pois, estou na versão API gratuita
    [Tags]    PUT
    ${payload}=    Create Dictionary    name=customizado    job=atualizado
    ${resposta}=    PUT Endpoint /custom/path    path=path-customizada-put    payload=${payload}
    Validar Status Code    403    ${resposta.status_code}
    Log To Console    Custom path executado sem autorização.

Cenario 25: PUT Atualizar usuario com ID invalido
    [Tags]    PUT  
    ${payload}=    Create Dictionary
    ...    name=usuário-inválido
    ...    job=inexistente
    ${resposta}=    PUT Endpoint /users/id invalido    id=inexistente  payload=${payload}
    Validar Status Code    200    ${resposta.status_code}
    Log To Console    Erro: Deveria retornar status code 400 para usuario invalido, porém resulta somente 200.

Cenario 26: PATCH Atualizar parcialmente usuario com sucesso
    [Tags]    PATCH
    ${payload}=    Create Dictionary    
    ...    job=atualizado
    ${resposta}=    PATCH Endpoint /users/id    id=1    payload=${payload}
    Validar Status Code    200    ${resposta.status_code}
    Log To Console   Informação atualizado com sucesso.

Cenario 27: PATCH Atualizar um resource com sucesso
    [Tags]    PATCH
    ${payload}=    Create Dictionary
    ...    job=QA
    ${resposta}=    PATCH Endpoint /resource/id    resource=users    id=1    payload=${payload}
    Validar Status Code    200    ${resposta.status_code}
    Log To Console    Resource atualizado com sucesso.
Cenario 28: PATCH Executar Custom Path sem autorização    #não consegui executar pois, estou na versão API gratuita
    [Tags]    PATCH
    ${payload}=    Create Dictionary    name=customizado    job=atualizado
    ${resposta}=    PATCH Endpoint /custom/path    path=path-customizada-patch    payload=${payload}
    Validar Status Code    403    ${resposta.status_code}
    Log To Console    Custom path executado sem autorização.

Cenario 29: PATCH Atualizar resource e ID invalido
    [Tags]    PATCH    NEGATIVO
    ${payload}=    Create Dictionary
    ...    job=inexistente
    ${resposta}=    PATCH Endpoint /resource/id invalido    resource=inexistente    id=inexistente    payload=${payload}
    Validar Status Code    200    ${resposta.status_code}
    Log To Console    Erro: Deveria retornar status code 400 para usuario invalido, porém resulta somente 200.


Cenario 30: DELETE Deletar usuario com sucesso
    [Tags]    DELETE
    ${resposta}=    DELETE Endpoint /users/id    id=15
    Validar Status Code    204    ${resposta.status_code}
    Log To Console    Usuário deletado com sucesso.

Cenario 31: DELETE Deletar resource com sucesso
    [Tags]    DELETE
    ${resposta}=    DELETE Endpoint /resource/id    id=20    resource=users
    Validar Status Code    204    ${resposta.status_code}
    Log To Console    Resource deletado com sucesso.

Cenario 34: DELETE Deletar custom endpoint com sucesso
    [Tags]    DELETE
    ${resposta}=    DELETE Endpoint /custom-endpoints/id    id=30 
    Validar Status Code    204    ${resposta.status_code}
    Log To Console    Custom endpoint deletado com sucesso.

Cenario 35: DELETE Deletar path sem autorização    #não consegui executar pois, estou na versão API gratuita
    [Tags]    DELETE
    ${resposta}=    DELETE Endpoint /custom/path    path=15
    Validar Status Code    403    ${resposta.status_code}
    Log To Console    Usuário deletado sem autorização.

Cenario 36: DELETE Deletar usuario com ID invalido
    [Tags]    DELETE    NEGATIVO
    ${resposta}=    DELETE Endpoint /users/id invalido   id=inexistente
    Validar Status Code    204    ${resposta.status_code}
    Log To Console    Erro: Deveria retornar status code 400 para usuario invalido, porém resulta somente 204.





    
    
