<div align="center">

<img src="https://github.com/user-attachments/assets/f582938a-61ad-48f6-a34d-17b7be54826d" alt="LibriTech" width="220"/>

# 📚 LibriTech — Sistema de Gestão Bibliotecária

**Projeto 2 · Conectar Banco de Dados com P.O.O.**

![Java](https://img.shields.io/badge/Java-21-007396?logo=openjdk&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-8.0-4479A1?logo=mysql&logoColor=white)
![Maven](https://img.shields.io/badge/Maven-build-C71A36?logo=apachemaven&logoColor=white)
![JDBC](https://img.shields.io/badge/JDBC-Connector%2FJ-F29111)
![Status](https://img.shields.io/badge/status-conclu%C3%ADdo-success)

</div>

## 👥 Integrantes do Grupo

- Arthur Pereira Silva
- Bernardo Ramos dos Santos
- Rodrigo Lira Rodrigues
- Luiz Gustavo Barbosa Machado

## 🎯 Sobre o Projeto

O **LibriTech** é um sistema de gestão de uma biblioteca universitária onde o **MySQL atua como o "cérebro"** que protege as regras de negócio e a segurança, enquanto o **Java** é a interface que conversa com esse banco via **JDBC**. A ideia central do projeto: a **segurança é imposta pelo próprio banco de dados**, e não apenas pela interface gráfica.

## 🏗️ Arquitetura

A aplicação é dividida em camadas, conectadas ao MySQL pela ponte do JDBC:

| Camada | Responsabilidade |
| --- | --- |
| **Model** | Classes de POO (`Usuario`, `Aluno`, `Funcionario`, `Livro`, `Emprestimo`) |
| **DAO** | Acesso a dados — executa SQL e chama as procedures |
| **Conexão** | Abre a conexão com as credenciais de quem fez login |
| **Interface** | Menus dinâmicos via `JOptionPane` |

> 💡 Cada operação roda com as **permissões do usuário que fez login** no banco. Se um estagiário loga, a conexão só tem o que o `usr_estagiario` pode fazer — quem manda na segurança é o banco.

## 🧩 Conceitos de POO

- **Encapsulamento** — atributos `private` com getters/setters e validação (ex.: `setPrecoCusto` não aceita valor negativo).
- **Herança** — classe abstrata `Usuario` → subclasses `Aluno` e `Funcionario`.
- **Polimorfismo** — `getDiasPrazoEmprestimo()` retorna **7 dias** para Aluno e **14 dias** para Funcionário.

## 🔐 Segurança — Princípio do Privilégio Mínimo

Quatro usuários no MySQL, cada um com permissões definidas via `GRANT`/`REVOKE`:

| Usuário | Papel | Acesso |
| --- | --- | --- |
| `usr_gerente` | Administrador | Acesso total + backup |
| `usr_bibliotecario` | Operador | Rotina diária (não apaga auditoria) |
| `usr_estagiario` | Restrito | Mínimo — `DELETE` revogado |
| `usr_aluno` | Visitante | Somente leitura, e apenas por uma View |

## 🗄️ Estrutura do Banco

**6 tabelas:** `Usuarios`, `Enderecos`, `Livros`, `Emprestimos`, `Multas`, `Log_Auditoria`

<details>
<summary><b>Objetos ativos do banco</b> (clique para expandir)</summary>

<br>

**4 Views**
- `vw_acervo_publico` — catálogo para o aluno (esconde o preço de custo)
- `vw_livros_atrasados` — empréstimos vencidos com contato do usuário
- `vw_ranking_leitura` — top 10 livros mais emprestados
- `vw_dashboard_financeiro` — total de multas arrecadadas e pendentes

**6 Stored Procedures**
`sp_transacao_emprestimo` · `sp_renovar_emprestimo` · `sp_calcular_multa` · `sp_transacao_cadastro_completo` · `sp_transacao_devolucao` · `sp_historico_usuario`

**5 Triggers**
- 2 de horário comercial — bloqueiam operações fora das **08h–18h**
- `trg_auditoria_delecao` — registra no Log todo livro excluído (dados em JSON)
- `trg_limite_emprestimos` — impede um aluno de pegar mais de **3 livros**
- `trg_preventiva_estoque` — impede o estoque de ficar negativo

**3 Índices** + análise `EXPLAIN` antes/depois (coluna `type`: `ALL` → `ref`)

</details>

## 🚀 Como Executar

**Pré-requisitos:** JDK 21 · MySQL Server 8.0 · MySQL Workbench · VS Code (Extension Pack for Java)

1. **Crie o banco** — abra o `Entregavel_SQL_projeto2_Final.sql` no MySQL Workbench e execute, ou pela linha de comando:
   ```bash
   mysql -u root -p < Entregavel_SQL_projeto2_Final.sql
   ```
2. **Abra o projeto Java** — `File → Open Folder` na pasta `libritech/`.
3. **Rode** o `Main.java` (botão **Run**).
4. Selecione o **perfil** → faça **login** com um dos usuários de teste abaixo.

### 👤 Usuários de Teste

| Login | Senha |
| --- | --- |
| `usr_gerente` | `gerente123` |
| `usr_bibliotecario` | `biblio123` |
| `usr_estagiario` | `estagio123` |
| `usr_aluno` | `aluno123` |

## ✅ Plano de Testes

| # | Teste | Resultado esperado |
| --- | --- | --- |
| 1 | **Horário** | Operação fora das 08h–18h → erro de trigger |
| 2 | **Atomicidade** | Cadastro com endereço inválido → usuário não é salvo (rollback) |
| 3 | **Segurança** | Estagiário tenta excluir → "Acesso Negado" |
| 4 | **Auditoria** | Gerente exclui livro → registrado no Log |
| 5 | **Limite** | 4º empréstimo do mesmo aluno → bloqueado |
| 6 | **Multa** | Devolução atrasada → valor correto (dias × R$ 2,00) |
| 7 | **View** | Aluno não consegue ver o preço de custo |
| 8 | **EXPLAIN** | Índice em `titulo`: `type` passa de `ALL` para `ref` |

## 📁 Estrutura do Repositório

```
.
├── libritech/                            # Projeto Java (Maven)
│   ├── pom.xml
│   └── src/main/java/
│       ├── Main.java                     # Perfil + login + menus
│       ├── connection/Conexao.java       # Conexão JDBC (login do usuário)
│       ├── dao/                          # LivroDAO, EmprestimoDAO, UsuarioDAO, RelatorioDAO
│       └── model/                        # Usuario, Aluno, Funcionario, Livro, Emprestimo
├── Entregavel_SQL_projeto2_Final.sql     # Script de criação (DDL, views, procedures, triggers, users)
├── dump_libritech.sql                    # Dump com dados de teste
└── LibriTech_Apresentacao.pdf            # Slides da apresentação
```
<div align="center">
</div>
