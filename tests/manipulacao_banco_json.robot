*** Settings ***
Resource    ../resources/banco_dados.resource
Resource    ../resources/manipular_json.resource
Documentation    Testes de Manipulacao do Banco de Dados JSON
Library          Collections

*** Test Cases ***
Cenario 01: Adicionar Novo Usuario ao Banco JSON
    [Tags]    JSON    MANIPULACAO
    [Documentation]    Adiciona um novo usuario ao banco JSON e valida
    ${backup}=    Backup do Banco    ${BANCO_USUARIOS}
    ${novo_usuario}=    Create Dictionary
    ...    id=99
    ...    username=teste_json
    ...    email=teste@json.com
    ...    password=senha123
    ...    name=Usuario Teste JSON
    ...    job=Tester JSON
    Adicionar Usuario ao Banco    ${novo_usuario}
    ${usuario_encontrado}=    Buscar Usuario Por Email    teste@json.com
    Should Be Equal    ${usuario_encontrado}[username]    teste_json
    Log To Console    Usuario adicionado e encontrado com sucesso
    [Teardown]    Restaurar Banco do Backup    ${backup}    ${BANCO_USUARIOS}

Cenario 02: Contar Usuarios no Banco
    [Tags]    JSON    CONSULTA
    [Documentation]    Conta o total de usuarios no banco JSON
    ${total_inicial}=    Contar Usuarios no Banco
    Should Be True    ${total_inicial} >= 3
    Log To Console    Total de usuarios no banco: ${total_inicial}

Cenario 03: Validar Estrutura dos Bancos JSON
    [Tags]    JSON    VALIDACAO
    [Documentation]    Valida a estrutura de todos os bancos JSON
    Validar Estrutura do Banco    ${BANCO_USUARIOS}
    Validar Estrutura do Banco    ${BANCO_ENDPOINTS}
    Validar Estrutura do Banco    ${BANCO_STATUS_CODES}
    Log To Console    Todas as estruturas validadas com sucesso

Cenario 04: Testar Busca de Usuario Inexistente
    [Tags]    JSON    ERRO
    [Documentation]    Testa busca por usuario que nao existe
    Run Keyword And Expect Error    *não encontrado*
    ...    Buscar Usuario Por Email    inexistente@teste.com
    Log To Console    Erro esperado capturado corretamente

Cenario 05: Adicionar e Remover Usuario Dinamicamente
    [Tags]    JSON    CRUD
    [Documentation]    Testa operacoes CRUD completas no banco JSON
    ${backup}=    Backup do Banco    ${BANCO_USUARIOS}
    ${total_inicial}=    Contar Usuarios no Banco
    ${novo_usuario}=    Create Dictionary
    ...    id=100
    ...    username=temp_user
    ...    email=temp@teste.com
    ...    password=temp123
    ...    name=Usuario Temporario
    ...    job=Temp Job
    Adicionar Usuario ao Banco    ${novo_usuario}
    ${total_apos_adicao}=    Contar Usuarios no Banco
    Should Be Equal As Numbers    ${total_apos_adicao}    ${total_inicial + 1}
    
    Remover Usuario do Banco    temp_user
    ${total_apos_remocao}=    Contar Usuarios no Banco
    Should Be Equal As Numbers    ${total_apos_remocao}    ${total_inicial}
    
    Log To Console    CRUD de usuarios executado com sucesso
    [Teardown]    Restaurar Banco do Backup    ${backup}    ${BANCO_USUARIOS}

Cenario 06: Testar Todos os Usuarios do Banco Dinamicamente
    [Tags]    JSON    DINAMICO
    [Documentation]    Valida todos os usuarios do banco dinamicamente
    ${dados}=    Carregar Dados do Banco    ${BANCO_USUARIOS}
    FOR    ${usuario}    IN    @{dados}[usuarios_validos]
        Log To Console    Testando usuario: ${usuario}[username] - ${usuario}[email]
        Should Not Be Empty    ${usuario}[username]
        Should Not Be Empty    ${usuario}[email]
        Should Not Be Empty    ${usuario}[password]
        Should Contain    ${usuario}[email]    @
    END
    Log To Console    Todos os usuarios validados com sucesso