*** Settings ***
Library    OperatingSystem
Library    Collections
Library    JSONLibrary
Library    String
Library    DateTime
Resource   banco_dados.resource

*** Keywords ***
Adicionar Usuario ao Banco
    [Arguments]    ${novo_usuario}
    [Documentation]    Adiciona um novo usuário ao banco de dados JSON
    ${dados}=    Carregar Dados do Banco    ${BANCO_USUARIOS}
    Append To List    ${dados}[usuarios_validos]    ${novo_usuario}
    ${json_string}=    Convert Json To String    ${dados}
    Create File    ${BANCO_USUARIOS}    ${json_string}
    Log To Console    Usuário adicionado ao banco: ${novo_usuario}[username]

Remover Usuario do Banco
    [Arguments]    ${username}
    [Documentation]    Remove um usuário do banco de dados JSON pelo username
    ${dados}=    Carregar Dados do Banco    ${BANCO_USUARIOS}
    ${usuarios_atualizados}=    Create List
    FOR    ${usuario}    IN    @{dados}[usuarios_validos]
        IF    '${usuario}[username]' != '${username}'
            Append To List    ${usuarios_atualizados}    ${usuario}
        END
    END
    Set To Dictionary    ${dados}    usuarios_validos=${usuarios_atualizados}
    ${json_string}=    Convert Json To String    ${dados}
    Create File    ${BANCO_USUARIOS}    ${json_string}
    Log To Console    Usuário removido do banco: ${username}

Atualizar Status Code no Banco
    [Arguments]    ${metodo}    ${operacao}    ${novo_status}
    [Documentation]    Atualiza um status code no banco de dados
    ${dados}=    Carregar Dados do Banco    ${BANCO_STATUS_CODES}
    Set To Dictionary    ${dados}[status_codes_esperados][${metodo}]    ${operacao}=${novo_status}
    ${json_string}=    Convert Json To String    ${dados}
    Create File    ${BANCO_STATUS_CODES}    ${json_string}
    Log To Console    Status code atualizado: ${metodo}.${operacao} = ${novo_status}

Adicionar Payload ao Banco
    [Arguments]    ${tipo}    ${dados_payload}
    [Documentation]    Adiciona um novo payload ao banco de dados
    ${dados}=    Carregar Dados do Banco    ${BANCO_ENDPOINTS}
    ${novo_payload}=    Create Dictionary    tipo=${tipo}    dados=${dados_payload}
    Append To List    ${dados}[payloads_atualizacao]    ${novo_payload}
    ${json_string}=    Convert Json To String    ${dados}
    Create File    ${BANCO_ENDPOINTS}    ${json_string}
    Log To Console    Payload adicionado: ${tipo}

Buscar Usuario Por Email
    [Arguments]    ${email}
    [Documentation]    Busca um usuário pelo email no banco de dados
    ${dados}=    Carregar Dados do Banco    ${BANCO_USUARIOS}
    FOR    ${usuario}    IN    @{dados}[usuarios_validos]
        IF    '${usuario}[email]' == '${email}'
            RETURN    ${usuario}
        END
    END
    Fail    Usuário com email ${email} não encontrado

Contar Usuarios no Banco
    [Documentation]    Retorna o número total de usuários no banco
    ${dados}=    Carregar Dados do Banco    ${BANCO_USUARIOS}
    ${total}=    Get Length    ${dados}[usuarios_validos]
    RETURN    ${total}

Validar Estrutura do Banco
    [Arguments]    ${arquivo_banco}
    [Documentation]    Valida se a estrutura do arquivo JSON está correta
    ${dados}=    Carregar Dados do Banco    ${arquivo_banco}
    Should Be True    isinstance($dados, dict)    Banco deve ser um dicionário
    Log To Console    Estrutura do banco validada com sucesso

Backup do Banco
    [Arguments]    ${arquivo_banco}
    [Documentation]    Cria um backup do arquivo de banco de dados
    ${timestamp}=    Get Current Date    result_format=%Y%m%d_%H%M%S
    @{path_parts}=    Split String    ${arquivo_banco}    ${/}
    ${nome_arquivo}=    Get From List    ${path_parts}    -1
    ${path_parts_without_file}=    Get Slice From List    ${path_parts}    0    -1
    ${diretorio}=    Catenate    SEPARATOR=${/}    @{path_parts_without_file}
    ${arquivo_backup}=    Set Variable    ${diretorio}${/}backup_${timestamp}_${nome_arquivo}
    Copy File    ${arquivo_banco}    ${arquivo_backup}
    Log To Console    Backup criado: ${arquivo_backup}
    RETURN    ${arquivo_backup}

Restaurar Banco do Backup
    [Arguments]    ${arquivo_backup}    ${arquivo_destino}
    [Documentation]    Restaura um banco de dados a partir de um backup
    Copy File    ${arquivo_backup}    ${arquivo_destino}
    Log To Console    Banco restaurado de: ${arquivo_backup}