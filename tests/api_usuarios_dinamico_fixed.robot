*** Settings ***
Resource    ../resources/api_usuarios.resource
Resource    ../resources/banco_dados.resource
Documentation    Testes de API usando dados dinamicos do banco JSON
Library          RequestsLibrary
Library          Collections

*** Test Cases ***
Cenario 01: POST Criar Usuario com Dados Dinamicos
    [Tags]    POST    DINAMICO
    [Documentation]    Cria usuario usando dados do banco JSON
    Criar Sessão na reqres_api API
    ${usuario}=    Obter Usuario Valido    indice=0
    ${resposta}=    POST Endpoint /users    indice_usuario=0
    ${status_esperado}=    Obter Status Code Esperado    POST    criar_usuario
    Validar Status Code    ${status_esperado}    ${resposta.status_code}
    Log To Console    Usuario ${usuario}[name] criado com sucesso

Cenario 02: GET Listar Usuarios Dinamicamente
    [Tags]    GET    DINAMICO
    [Documentation]    Lista usuarios usando configuracao dinamica
    ${resposta}=    GET Listar Usuarios
    ${status_esperado}=    Obter Status Code Esperado    GET    listar_usuarios
    Validar Status Code    ${status_esperado}    ${resposta.status_code}
    Should Contain    ${resposta.text}    data
    Log To Console    Lista obtida com ${resposta.json()}[total] usuarios

Cenario 03: GET Usuario por ID Dinamico
    [Tags]    GET    DINAMICO
    [Documentation]    Obtem usuario usando ID do banco de dados
    ${id_valido}=    Obter ID Valido    indice=0
    ${resposta}=    GET Obter Usuario por ID    _id=${id_valido}
    ${status_esperado}=    Obter Status Code Esperado    GET    obter_usuario_valido
    Validar Status Code    ${status_esperado}    ${resposta.status_code}
    ${id_retornado}=    Get From Dictionary    ${resposta.json()}[data]    id
    Should Be Equal As Strings    ${id_retornado}    ${id_valido}
    Log To Console    Usuario ID ${id_valido} obtido com sucesso

Cenario 04: PUT Atualizar Usuario Dinamicamente
    [Tags]    PUT    DINAMICO
    [Documentation]    Atualiza usuario usando payload dinamico
    ${payload}=    Obter Payload Atualizacao    usuario_completo
    ${id_valido}=    Obter ID Valido    indice=0
    ${resposta}=    PUT Endpoint /users/id    id=${id_valido}    payload=${payload}
    ${status_esperado}=    Obter Status Code Esperado    PUT    atualizar_usuario
    Validar Status Code    ${status_esperado}    ${resposta.status_code}
    Log To Console    Usuario atualizado: ${payload}[name]

Cenario 05: DELETE Usuario Dinamicamente
    [Tags]    DELETE    DINAMICO
    [Documentation]    Remove usuario usando ID dinamico
    ${id_valido}=    Obter ID Valido    indice=1
    ${resposta}=    DELETE Endpoint /users/id    id=${id_valido}
    Validar Status Code    204    ${resposta.status_code}
    Log To Console    Usuario ID ${id_valido} removido com sucesso