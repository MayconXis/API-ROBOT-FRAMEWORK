*** Settings ***
Documentation    Testes de API com dados dinâmicos - Versão Otimizada dos 36 Cenários
Resource         ../common/base.robot
Resource         ../common/keywords.robot
Resource         ../common/dynamic_usuario.robot
Resource         ../resources/banco_dados.resource
Suite Setup      Inicializar Sessao Global
Suite Teardown   Finalizar Sessao Global
Test Setup       Resetar Usuario Dinamico

*** Test Cases ***
Cenário 01: POST Cadastrar usuário dinâmico na ReqRes API
    [Tags]    POST    DINAMICO
    ${usuario_dinamico}=    Criar Usuario Dinamico Completo
    Log To Console    Usuário dinâmico criado: ${usuario_dinamico}[name]
    Log To Console    Status: ${usuario_dinamico}[response].status_code

Cenário 02: POST Registrar usuário dinâmico
    [Tags]    POST    DINAMICO
    ${payload}=    dynamic_usuario.Gerar Payload Login Dinamico
    ${resposta}=    POST On Session    ${SESSION_NAME}    /register    json=${payload}    expected_status=any
    Log To Console    Registro dinâmico testado para: ${payload}[email]

Cenário 03: POST Login usuário dinâmico
    [Tags]    POST    DINAMICO
    ${payload}=   dynamic_usuario.Gerar Payload Login Dinamico
    ${resposta}=    POST On Session    ${SESSION_NAME}    /login    json=${payload}    expected_status=any
    Log To Console    Login dinâmico testado para: ${payload}[email]

Cenário 04: POST Logout usuário dinâmico
    [Tags]    POST    DINAMICO
    ${payload_login}=    dynamic_usuario.Gerar Payload Login Dinamico
    ${resposta_login}=    POST On Session    ${SESSION_NAME}    /login    json=${payload_login}    expected_status=any
    ${payload_logout}=    Create Dictionary
    ${resposta_logout}=    POST On Session    ${SESSION_NAME}    /logout    json=${payload_logout}    expected_status=any
    Log To Console    Logout dinâmico executado

Cenário 05: POST Vincular Assinatura Pro dinâmico
    [Tags]    POST    DINAMICO
    ${usuario}=    Obter Usuario Dinamico Atual
    ${payload}=    Create Dictionary    email=${usuario}[email]
    ${resposta}=    POST On Session    ${SESSION_NAME}    /clerk/link-pro    json=${payload}    expected_status=any
    Log To Console    Vínculo Pro testado para usuário dinâmico

Cenário 06: POST Auto Vincular Assinatura Pro dinâmico
    [Tags]    POST    DINAMICO
    ${payload}=    Create Dictionary    data={}    message=Auto Vinculado Dinamico
    ${resposta}=    POST On Session    ${SESSION_NAME}    /clerk/auto-link-pro    json=${payload}    expected_status=any
    Log To Console    Auto vínculo Pro dinâmico executado

Cenário 07: POST Desvincular Assinatura Pro dinâmico
    [Tags]    POST    DINAMICO
    ${payload}=    Create Dictionary
    ${resposta}=    POST On Session    ${SESSION_NAME}    /clerk/unlink-pro    json=${payload}    expected_status=any
    Log To Console    Desvínculo Pro dinâmico executado

Cenário 08: POST Criar Endpoint Customizado dinâmico
    [Tags]    POST    DINAMICO
    ${timestamp}=    Get Current Date    result_format=%H%M%S
    ${nome_endpoint}=    Generate Random String    length=6    chars=[LETTERS]
    ${payload}=    Create Dictionary
    ...    name=endpoint_dinamico_${nome_endpoint}
    ...    path=/dynamic-path-${timestamp}
    ...    method=GET
    ${resposta}=    POST On Session    ${SESSION_NAME}    /custom-endpoints    json=${payload}    expected_status=any
    Log To Console    Endpoint customizado dinâmico criado

Cenário 09: POST Executar Custom Path dinâmico sem assinatura
    [Tags]    POST    DINAMICO
    ${payload}=    Create Dictionary
    ${resposta}=    POST On Session    ${SESSION_NAME}    /custom/1    json=${payload}    expected_status=any
    Log To Console    Custom path dinâmico executado

Cenário 10: GET Listar usuários dinâmico
    [Tags]    GET    DINAMICO
    ${resposta}=    GET On Session    ${SESSION_NAME}    /users    expected_status=any
    Log To Console    Lista de usuários obtida dinamicamente

Cenário 11: GET Obter usuário por ID dinâmico
    [Tags]    GET    DINAMICO
    ${usuario}=    Obter Usuario Dinamico Atual
    ${resposta}=    GET On Session    ${SESSION_NAME}    /users/2    expected_status=any
    Log To Console    Usuário por ID obtido dinamicamente

Cenário 12: GET Obter usuário com ID inválido dinâmico
    [Tags]    GET    DINAMICO
    ${id_invalido}=    Generate Random String    length=10    chars=[NUMBERS]
    ${resposta}=    GET On Session    ${SESSION_NAME}    /users/${id_invalido}    expected_status=any
    Log To Console    Teste de ID inválido dinâmico: ${id_invalido}

Cenário 13: GET Listar resource dinâmico
    [Tags]    GET    DINAMICO
    ${resposta}=    GET On Session    ${SESSION_NAME}    /users    expected_status=any
    Log To Console    Resource listado dinamicamente

Cenário 14: GET Obter resource por ID dinâmico
    [Tags]    GET    DINAMICO
    ${resposta}=    GET On Session    ${SESSION_NAME}    /users/4    expected_status=any
    Log To Console    Resource por ID obtido dinamicamente

Cenário 15: GET Obter resource inválido dinâmico
    [Tags]    GET    DINAMICO
    ${id_invalido}=    Generate Random String    length=15    chars=[NUMBERS]
    ${resposta}=    GET On Session    ${SESSION_NAME}    /users/${id_invalido}    expected_status=any
    Log To Console    Resource inválido testado dinamicamente

Cenário 16: GET Status de Assinatura dinâmico sem autorização
    [Tags]    GET    DINAMICO
    ${resposta}=    GET On Session    ${SESSION_NAME}    /subscription/status    expected_status=any
    Log To Console    Status de assinatura dinâmico testado

Cenário 17: GET Custom Endpoints dinâmico
    [Tags]    GET    DINAMICO
    ${resposta}=    GET On Session    ${SESSION_NAME}    /custom-endpoints    expected_status=any
    Log To Console    Custom endpoints listados dinamicamente

Cenário 18: GET Custom Endpoint por ID dinâmico
    [Tags]    GET    DINAMICO
    ${resposta}=    GET On Session    ${SESSION_NAME}    /custom-endpoints/1    expected_status=any
    Log To Console    Custom endpoint por ID obtido dinamicamente

Cenário 19: GET Custom Endpoint ID inválido dinâmico
    [Tags]    GET    DINAMICO
    ${id_invalido}=    Generate Random String    length=8    chars=[NUMBERS]
    ${resposta}=    GET On Session    ${SESSION_NAME}    /custom-endpoints/${id_invalido}    expected_status=any
    Log To Console    Custom endpoint ID inválido testado: ${id_invalido}

Cenário 20: GET Executar Custom Path dinâmico sem autorização
    [Tags]    GET    DINAMICO
    ${resposta}=    GET On Session    ${SESSION_NAME}    /custom/users-path    expected_status=any
    Log To Console    Custom path dinâmico executado

Cenário 21: PUT Atualizar usuário dinâmico
    [Tags]    PUT    DINAMICO
    ${payload}=    dynamic_usuario.Gerar Payload Atualizacao Dinamico    completo
    ${resposta}=    PUT On Session    ${SESSION_NAME}    /users/2    json=${payload}    expected_status=any
    Log To Console    Usuário atualizado dinamicamente: ${payload}[name]

Cenário 22: PUT Atualizar resource dinâmico
    [Tags]    PUT    DINAMICO
    ${payload}=    dynamic_usuario.Gerar Payload Atualizacao Dinamico    completo
    ${resposta}=    PUT On Session    ${SESSION_NAME}    /users/1    json=${payload}    expected_status=any
    Log To Console    Resource atualizado dinamicamente

Cenário 23: PUT Atualizar Custom Endpoint dinâmico
    [Tags]    PUT    DINAMICO
    ${timestamp}=    Get Current Date    result_format=%H%M%S
    ${payload}=    Create Dictionary
    ...    name=updated-endpoint-${timestamp}
    ...    path=/updated-path-${timestamp}
    ...    status_code=200
    ${resposta}=    PUT On Session    ${SESSION_NAME}    /custom-endpoints/1    json=${payload}    expected_status=any
    Log To Console    Custom endpoint atualizado dinamicamente

Cenário 24: PUT Executar Custom Path dinâmico sem autorização
    [Tags]    PUT    DINAMICO
    ${payload}=   dynamic_usuario.Gerar Payload Atualizacao Dinamico    parcial
    ${resposta}=    PUT On Session    ${SESSION_NAME}    /custom/path-dinamica    json=${payload}    expected_status=any
    Log To Console    Custom path PUT dinâmico executado

Cenário 25: PUT Atualizar usuário ID inválido dinâmico
    [Tags]    PUT    DINAMICO
    ${payload}=   dynamic_usuario.Gerar Payload Atualizacao Dinamico    completo
    ${id_invalido}=    Generate Random String    length=12    chars=[LETTERS][NUMBERS]
    ${resposta}=    PUT On Session    ${SESSION_NAME}    /users/${id_invalido}    json=${payload}    expected_status=any
    Log To Console    PUT com ID inválido dinâmico testado: ${id_invalido}

Cenário 26: PATCH Atualizar parcialmente usuário dinâmico
    [Tags]    PATCH    DINAMICO
    ${payload}=    dynamic_usuario.Gerar Payload Atualizacao Dinamico    parcial
    ${resposta}=    PATCH On Session    ${SESSION_NAME}    /users/2    json=${payload}    expected_status=any
    Log To Console    Usuário atualizado parcialmente de forma dinâmica

Cenário 27: PATCH Atualizar resource dinâmico
    [Tags]    PATCH    DINAMICO
    ${payload}=    dynamic_usuario.Gerar Payload Atualizacao Dinamico    parcial
    ${resposta}=    PATCH On Session    ${SESSION_NAME}    /users/1    json=${payload}    expected_status=any
    Log To Console    Resource atualizado via PATCH dinâmico

Cenário 28: PATCH Executar Custom Path dinâmico sem autorização
    [Tags]    PATCH    DINAMICO
    ${payload}=    dynamic_usuario.Gerar Payload Atualizacao Dinamico    parcial
    ${resposta}=    PATCH On Session    ${SESSION_NAME}    /custom/path-patch    json=${payload}    expected_status=any
    Log To Console    Custom path PATCH dinâmico executado

Cenário 29: PATCH Atualizar resource ID inválido dinâmico
    [Tags]    PATCH    DINAMICO
    ${payload}=    dynamic_usuario.Gerar Payload Atualizacao Dinamico    parcial
    ${id_invalido}=    Generate Random String    length=10    chars=[LETTERS]
    ${resposta}=    PATCH On Session    ${SESSION_NAME}    /users/${id_invalido}    json=${payload}    expected_status=any
    Log To Console    PATCH com ID inválido dinâmico testado: ${id_invalido}

Cenário 30: DELETE Deletar usuário dinâmico
    [Tags]    DELETE    DINAMICO
    ${resposta}=    DELETE On Session    ${SESSION_NAME}    /users/15    expected_status=any
    Log To Console    Usuário deletado dinamicamente

Cenário 31: DELETE Deletar resource dinâmico
    [Tags]    DELETE    DINAMICO
    ${resposta}=    DELETE On Session    ${SESSION_NAME}    /users/20    expected_status=any
    Log To Console    Resource deletado dinamicamente

Cenário 32: DELETE Deletar custom endpoint dinâmico
    [Tags]    DELETE    DINAMICO
    ${resposta}=    DELETE On Session    ${SESSION_NAME}    /custom-endpoints/30    expected_status=any
    Log To Console    Custom endpoint deletado dinamicamente

Cenário 33: DELETE Deletar path dinâmico sem autorização
    [Tags]    DELETE    DINAMICO
    ${resposta}=    DELETE On Session    ${SESSION_NAME}    /custom/15    expected_status=any
    Log To Console    Path deletado dinamicamente sem autorização

Cenário 34: DELETE Deletar usuário ID inválido dinâmico
    [Tags]    DELETE    DINAMICO
    ${id_invalido}=    Generate Random String    length=15    chars=[LETTERS][NUMBERS]
    ${resposta}=    DELETE On Session    ${SESSION_NAME}    /users/${id_invalido}    expected_status=any
    Log To Console    DELETE com ID inválido dinâmico testado: ${id_invalido}

Cenário 35: Teste Integrado Criar-Consultar-Atualizar dinâmico
    [Tags]    INTEGRADO    DINAMICO
    ${usuario}=    Criar Usuario Dinamico Completo
    ${resposta_get}=    GET On Session    ${SESSION_NAME}    /users/2    expected_status=any
    ${payload_update}=    dynamic_usuario.Gerar Payload Atualizacao Dinamico    completo
    ${resposta_put}=    PUT On Session    ${SESSION_NAME}    /users/2    json=${payload_update}    expected_status=any
    Log To Console    Teste integrado dinâmico executado com sucesso

Cenário 36: Validação Completa Dados Dinâmicos
    [Tags]    VALIDACAO    DINAMICO
    ${usuario}=    Criar Usuario Dinamico Completo
    Should Contain    ${usuario}[name]    Usuario_
    Should Contain    ${usuario}[email]    @dinamico.com
    Should Contain    ${usuario}[job]    QA_Engineer_
    Log To Console    Validação completa de dados dinâmicos realizada