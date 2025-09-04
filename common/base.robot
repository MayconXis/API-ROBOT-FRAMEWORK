*** Settings ***
Documentation    Arquivo base com configurações globais e sessão universal
Library          RequestsLibrary
Library          Collections
Library          String
Library          DateTime
Resource         keywords.robot
Test Setup       Inicializar Sessao Global
Suite Teardown   Finalizar Sessao Global

*** Variables ***
${BASE_URL}      https://reqres.in/api
${SESSION_NAME}  reqres_api

*** Keywords ***
Inicializar Sessao Global
    [Documentation]    Cria sessão global para todos os testes
    Create Session    ${SESSION_NAME}    ${BASE_URL}
    Log To Console    Sessão global inicializada com sucesso

Finalizar Sessao Global
    [Documentation]    Finaliza sessão global
    Delete All Sessions
    Log To Console    Sessão global finalizada

