*** Settings ***
Documentation    Manipulacao de JSON no Robot Framework
Library          Collections
Library          OperatingSystem

*** Test Cases ***
Cenario 01: Criar e Validar JSON Dinamicamente
    [Documentation]    Cria um payload JSON dinamicamente e valida estrutura
    [Tags]    json    dinamico

    &{dados_usuario}=    Create Dictionary
    ...                  name=Joao Silva
    ...                  job=Engenheiro QA
    ...                  email=joao.silva@teste.com

    ${payload_json}=    Evaluate    json.dumps(${dados_usuario})    json
    Log    JSON Criado: ${payload_json}
    
    Should Not Be Empty    ${dados_usuario}[name]
    Should Not Be Empty    ${dados_usuario}[job]
    Should Contain       ${dados_usuario}[email]    @
    Log    Payload JSON validado com sucesso

Cenario 02: Modificar Dados JSON Existentes
    [Documentation]    Modifica campos especificos de um JSON existente
    [Tags]    json    modificacao
    
    ${json_original}=    Create Dictionary
    ...                  name=Nome Original
    ...                  job=Desenvolvedor
    ...                  active=true
    
    Set To Dictionary    ${json_original}    name=Nome Atualizado
    Set To Dictionary    ${json_original}    job=Desenvolvedor 
    
    Should Be Equal    ${json_original}[name]    Nome Atualizado
    Should Be Equal    ${json_original}[job]     Desenvolvedor 
    Log    JSON modificado com sucesso: ${json_original}

Cenario 03: Extrair Dados de JSON Simulado
    [Documentation]    Extrai campos especificos de um JSON simulado
    [Tags]    json    extracao
    
    ${json_simulado}=    Evaluate    {"data": {"id": 2, "first_name": "Janet", "email": "janet.weaver@reqres.in"}}
    
    ${id_usuario}=      Set Variable    ${json_simulado}[data][id]
    ${primeiro_nome}=   Set Variable    ${json_simulado}[data][first_name]
    ${email}=           Set Variable    ${json_simulado}[data][email]
    
    Should Be Equal As Numbers    ${id_usuario}      2
    Should Be Equal              ${primeiro_nome}   Janet
    Should Contain               ${email}           @reqres.in
    Log    Dados extraidos: ID=${id_usuario}, Nome=${primeiro_nome}, Email=${email}

Cenario 04: Trabalhar com Arrays JSON
    [Documentation]    Manipula arrays JSON e processa cada elemento
    [Tags]    json    arrays
    
    @{lista_usuarios}=    Create List
    
    &{usuario1}=    Create Dictionary    name=Usuario Um      job=Desenvolvedor
    &{usuario2}=    Create Dictionary    name=Usuario Dois    job=Testador
    &{usuario3}=    Create Dictionary    name=Usuario Tres    job=Gerente
    
    Append To List    ${lista_usuarios}    ${usuario1}
    Append To List    ${lista_usuarios}    ${usuario2}
    Append To List    ${lista_usuarios}    ${usuario3}
    
    ${total_usuarios}=    Get Length    ${lista_usuarios}
    Should Be Equal As Numbers    ${total_usuarios}    3
    
    FOR    ${usuario}    IN    @{lista_usuarios}
        Should Not Be Empty    ${usuario}[name]
        Should Not Be Empty    ${usuario}[job]
        Log    Usuario validado: ${usuario}[name] - ${usuario}[job]
    END

Cenario 05: Validar Estrutura JSON Complexa
    [Documentation]    Valida a estrutura e tipos de dados de um JSON complexo
    [Tags]    json    validacao
    
    ${json_complexo}=    Evaluate    {"data": [{"id": 1, "name": "Test"}], "page": 1, "total": 12}
    
    Should Contain    ${json_complexo}    data
    Should Contain    ${json_complexo}    page
    Should Contain    ${json_complexo}    total
    
    ${numero_pagina}=    Set Variable    ${json_complexo}[page]
    ${total_items}=      Set Variable    ${json_complexo}[total]
    
    Should Be Equal As Numbers    ${numero_pagina}    1
    Should Be Equal As Numbers    ${total_items}      12
    Log    Estrutura JSON validada com sucesso