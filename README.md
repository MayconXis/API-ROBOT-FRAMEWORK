# 🚀 Automação de Testes de API - Robot Framework

## 📖 Visão Geral do Projeto
Este projeto foi desenvolvido como parte do **desafio técnico da Compass UOL**, com o objetivo de **aprofundar o conhecimento em automação de testes de API utilizando Robot Framework**.  

A automação foi construída utilizando o **Robot Framework**, que permite criar testes de aceitação e **TDD** .  

O foco principal está na **validação de requisições HTTP** e na interação com uma **API RESTful**. Para isso, foi utilizada a **[Reqres API](https://reqres.in/)** como ambiente de testes, possibilitando a exploração dos verbos HTTP:

- **GET**
- **POST**
- **PUT**
- **PATCH**
- **DELETE**

Além disso, foram incluídos cenários envolvendo **autenticação**, **validação de erros** e **respostas em diferentes contextos**.

---

## 🛠️ Requisitos e Tecnologias
- **Python 3.6+**
- **Robot Framework**
- Dependências listadas em `requirements.txt`

---
api-automation-reqres/
│

├── tests/
│ 

└── api_usuarios_test.robot       ---> Arquivo principal com os cenários de teste
│

├── resources/
│  
└── api_usuarios.resource      ---> Keywords dos cenários de teste   
│

├── requirements.txt          ---> Dependências do projeto

---

## ✅ Cobertura de Testes

### GET
- Listagem de usuários e recursos
- Obtenção de usuário por **ID válido**
- Obtenção de usuário por **ID inválido**
- Obtenção de resources (válido e inválido)
- Obtenção de **endpoints customizados**
- Consulta de status de assinatura **sem autorização**

### POST
- Criação de novos usuários
- Registro e login de usuários
- Logout de usuário
- Vincular e desvincular assinaturas
- Criação e execução de endpoints customizados

### PUT
- Atualização completa de usuário
- Atualização de resources
- Atualização de endpoints customizados
- Teste de atualização com **ID inválido**
- Execução de custom path sem autorização

### PATCH
- Atualização parcial de usuário
- Atualização parcial de resource
- Atualização de custom endpoints
- Teste de atualização com **ID inválido**
- Execução de custom path sem autorização

### DELETE
- Deleção de usuário
- Deleção de resource
- Deleção de custom endpoints
- Tentativa de deleção com **ID inválido**
- Tentativa de deleção sem autorização



## 🧾 Cenários de Teste Detalhados

### POST
1. Cenário 01 : POST Cadastrar um novo usuário com sucesso na ReqRes API
2. Cenário 02 : POST registrar um usuario
3. Cenário 03 : POST logar um usuario
4. Cenario 04 : POST Permitir usuario dar logout
5. Cenario 05 :POST Vincular Usuário a Assinatura Pro com Sucesso
6. Cenario 06 :POST Auto Vincular Usuário a Assinatura Pro com Sucesso
7. Cenario 07 :POST Desvincular Assinatura Pro de Usuário com Sucesso
8. Cenario 08 : POST Criar um Endpoint Customizado com Sucesso
9. Cenario 09 : POST Executar Endpoint Customizado em /custom/patch sem assinatura

### GET
10. Cenario 10: GET Listar usuarios com sucesso  
11. Cenario 11: GET Obter usuario com ID valido  
12. Cenario 12: GET Obter usuario com ID invalido  
13. Cenario 13: GET Listar resource  
14. Cenario 14: GET Obter resource por ID  
15. Cenario 15: GET Obter resource invalido  
16. Cenario 16: GET Obter Status de Assinatura sem autorização  
17. Cenario 17: GET Obter Custom Endpoints com sucesso  
18. Cenario 18: GET Obter Custom Endpoint por ID com sucesso  
19. Cenario 19: GET Obter Custom Endpoint com ID invalido  
20. Cenario 20: GET Executar Custom Path sem autorização  

### PUT
21. Cenario 21: PUT Atualizar usuario com sucesso  
22. Cenario 22: PUT Atualizar um resource com sucesso  
23. Cenario 23: PUT Atualizar Custom Endpoint com sucesso  
24. Cenario 24: PUT Executar Custom Path sem autorização  
25. Cenario 25: PUT Atualizar usuario com ID invalido 

### PATCH
26.Cenario 26: PATCH Atualizar parcialmente usuario com sucesso  
27. Cenario 27: PATCH Atualizar um resource com sucesso  
28. Cenario 28: PATCH Executar Custom Path sem autorização  
29. Cenario 29: PATCH Atualizar resource e ID invalido  

### DELETE
30. Cenario 30: DELETE Deletar usuario com sucesso  
31. Cenario 31: DELETE Deletar resource com sucesso  
34. Cenario 34: DELETE Deletar custom endpoint com sucesso  
35. Cenario 35: DELETE Deletar path sem autorização  
36. Cenario 36: DELETE Deletar usuario com ID invalido


# Sistema de Banco de Dados Dinâmico para Robot Framework

## Visão Geral
Este sistema implementa um banco de dados JSON dinâmico para testes automatizados com Robot Framework, permitindo:
- Gerenciamento centralizado de dados de teste  
- Testes data-driven  
- Manipulação dinâmica de dados JSON  
- Reutilização de dados entre diferentes cenários  

## Estrutura dos Arquivos

### Bancos de Dados JSON
- `data/banco_usuarios.json` - Dados de usuários, IDs e recursos  
- `data/banco_endpoints.json` - Dados de endpoints e payloads  
- `data/banco_status_codes.json` - Status codes esperados por operação  

### Resources
- `resources/banco_dados.resource` - Keywords para carregar dados dos bancos  
- `resources/manipular_json.resource` - Keywords para manipular dados JSON  
- `resources/api_usuarios.resource` - Keywords da API (modificado para usar dados dinâmicos)  

### Testes
- `tests/api_usuarios_test.robot` - Testes originais modificados  
- `tests/api_usuarios_dinamico_test.robot` - Testes data-driven  
- `tests/manipulacao_json_test.robot` - Testes de manipulação JSON  

## Como Usar

### 1. Carregar Dados do Banco
```robot
${usuario}=    Obter Usuario Valido    indice=0
${id_valido}=    Obter ID Valido    indice=1
${status_esperado}=    Obter Status Code Esperado    POST    criar_usuario
```
---

### 🏁 Conclusão
Este projeto foi desenvolvido com o objetivo de exercitar boas práticas em **automação de testes de API** utilizando o **Robot Framework**.  
Através da integração com a **Reqres API**, foi possível validar diferentes **verbos HTTP**, explorar cenários **positivos e negativos**, além de garantir **organização e manutenibilidade** do código com o uso de **keywords reutilizáveis**.  
O trabalho contribuiu para aprimorar minha experiência prática com **testes automatizados**, consolidando conhecimentos técnicos importantes e preparando terreno para desafios mais complexos em projetos futuros. 🚀  

---

👨‍💻 Desenvolvido por: **Maycon Douglas da Silva**  
📧 Contato: [mayconcontacts@gmail.com]  
🌐 GitHub: [https://github.com/MayconXis]
