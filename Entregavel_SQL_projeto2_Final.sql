-- PROJETO 2 - Sistema de Gestão Bibliotecária (LibriTech)
-- Disciplina: Conectar Banco de Dados com P.O.O. - Professora: Anna Beatriz Lucena Lira
--  Grupo:
-- • Arthur Pereira Silva
-- • Bernardo Ramos dos Santos
-- • Rodrigo Lira Rodrigues
-- • Luiz Gustavo Barbosa Machado

-- -------------------------------------------------------------------

-- ••• SEÇÃO 1: Modelagem e Estrutura (DDL) •••
CREATE DATABASE db_libritech;
USE db_libritech;

CREATE TABLE Usuarios (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(150) NOT NULL,
    cpf CHAR(11) NOT NULL UNIQUE,
    email VARCHAR(150) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    tipo ENUM('ALUNO','GERENTE','BIBLIOTECARIO','ESTAGIARIO') NOT NULL
);

CREATE TABLE Enderecos (
    id_endereco INT PRIMARY KEY AUTO_INCREMENT,
    logradouro VARCHAR(150) NOT NULL,
    bairro VARCHAR(100) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    uf CHAR(2) NOT NULL,
    id_usuario_fk INT NOT NULL,
    CONSTRAINT fk_endereco_usuario
	FOREIGN KEY (id_usuario_fk) REFERENCES Usuarios(id_usuario)
);

CREATE TABLE Livros (
    id_livro INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(200) NOT NULL,
    autor VARCHAR(150) NOT NULL,
    isbn VARCHAR(20) NOT NULL UNIQUE,
    preco_custo DECIMAL(10,2) NOT NULL,
    quantidade_estoque INT NOT NULL DEFAULT 0,
    status VARCHAR(20) NOT NULL DEFAULT 'DISPONIVEL'
);

CREATE TABLE Emprestimos (
    id_emprestimo INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario_fk INT NOT NULL,
    id_livro_fk INT NOT NULL,
    data_saida DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_prevista DATE NOT NULL,
    data_devolucao DATETIME NULL,
    CONSTRAINT fk_emprestimo_usuario
	FOREIGN KEY (id_usuario_fk) REFERENCES Usuarios(id_usuario),
    CONSTRAINT fk_emprestimo_livro
	FOREIGN KEY (id_livro_fk) REFERENCES Livros(id_livro)
);

CREATE TABLE Multas (
    id_multa INT PRIMARY KEY AUTO_INCREMENT,
    id_emprestimo_fk INT NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    pago TINYINT NOT NULL DEFAULT 0,
    CONSTRAINT fk_multa_emprestimo
	FOREIGN KEY (id_emprestimo_fk) REFERENCES Emprestimos(id_emprestimo)
);

CREATE TABLE Log_Auditoria (
    id_log INT PRIMARY KEY AUTO_INCREMENT,
    tabela_afetada VARCHAR(50) NOT NULL,
    acao VARCHAR(50) NOT NULL,
    usuario_responsavel VARCHAR(100) NOT NULL,
    dados_antigos TEXT,
    data_hora TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ••• SEÇÃO 1: Povoamento do banco de dados (DML) •••
INSERT INTO Usuarios (nome, cpf, email, senha, tipo) VALUES
('Ana Beatriz Lucena',   '12345678901', 'ana.gerente@libritech.com',   '$2a$10$N9qo8uLOickgx2ZMRZoM1eHASHplaceholderGerente0000000000', 'GERENTE'),
('Carlos Bibliotecario',  '23456789012', 'carlos.biblio@libritech.com', '$2a$10$N9qo8uLOickgx2ZMRZoM1eHASHplaceholderBiblio00000000000', 'BIBLIOTECARIO'),
('Estela Estagiaria',     '34567890123', 'estela.estagio@libritech.com','$2a$10$N9qo8uLOickgx2ZMRZoM1eHASHplaceholderEstagio0000000000', 'ESTAGIARIO'),
('Arthur Pereira Silva',  '45678901234', 'arthur@aluno.libritech.com',  '$2a$10$N9qo8uLOickgx2ZMRZoM1eHASHplaceholderAluno100000000000', 'ALUNO'),
('Bernardo Ramos',        '56789012345', 'bernardo@aluno.libritech.com','$2a$10$N9qo8uLOickgx2ZMRZoM1eHASHplaceholderAluno200000000000', 'ALUNO'),
('Rodrigo Lira',          '67890123456', 'rodrigo@aluno.libritech.com', '$2a$10$N9qo8uLOickgx2ZMRZoM1eHASHplaceholderAluno300000000000', 'ALUNO'),
('Luiz Gustavo Machado',  '78901234567', 'luiz@aluno.libritech.com',    '$2a$10$N9qo8uLOickgx2ZMRZoM1eHASHplaceholderAluno400000000000', 'ALUNO');

INSERT INTO Enderecos (logradouro, bairro, cidade, uf, id_usuario_fk) VALUES
('Rua das Flores, 100',        'Centro',       'Campina Grande', 'PB', 1),
('Av. Floriano Peixoto, 250',  'Prata',        'Campina Grande', 'PB', 2),
('Rua Joao Pessoa, 45',        'Catole',       'Campina Grande', 'PB', 3),
('Rua Maciel Pinheiro, 78',    'Centro',       'Campina Grande', 'PB', 4),
('Av. Brasilia, 900',          'Liberdade',    'Campina Grande', 'PB', 5),
('Rua Vigario Calixto, 321',   'Catole',       'Campina Grande', 'PB', 6),
('Rua Cazuza Barreto, 12',     'Jose Pinheiro','Campina Grande', 'PB', 7);

INSERT INTO Livros (titulo, autor, isbn, preco_custo, quantidade_estoque, status) VALUES
('Clean Code',                 'Robert C. Martin',     '9780132350884', 120.00, 5, 'DISPONIVEL'), -- id 1
('O Senhor dos Aneis',         'J. R. R. Tolkien',     '9788595084759',  89.90, 4, 'DISPONIVEL'), -- id 2
('Dom Casmurro',               'Machado de Assis',     '9788594318600',  34.50, 6, 'DISPONIVEL'), -- id 3
('Java: Como Programar',       'Paul Deitel',          '9788543004792', 210.00, 3, 'DISPONIVEL'), -- id 4 (livre p/ teste do 4 empréstimo)
('1984',                       'George Orwell',        '9788535914849',  45.00, 2, 'DISPONIVEL'), -- id 5 (atrasado c/ Bernardo)
('A Revolucao dos Bichos',     'George Orwell',        '9788535909555',  39.90, 4, 'DISPONIVEL'), -- id 6
('Algoritmos: Teoria e Pratica','Thomas H. Cormen',    '9788535236996', 320.00, 3, 'DISPONIVEL'), -- id 7
('Livro Para Exclusao (Teste)','Autor Teste',          '0000000000001',  10.00, 1, 'DISPONIVEL'), -- id 8 (usado no teste de auditoria/segurança)
('Harry Potter e a Pedra Filosofal','J. K. Rowling',   '9788532530783',  55.00, 8, 'DISPONIVEL'), -- id 9
('O Pequeno Principe',         'Antoine de Saint-Exupery','9788595081512', 29.90, 1, 'DISPONIVEL'); -- id 10 (estoque baixo p/ teste de estoque)

INSERT INTO Emprestimos (id_usuario_fk, id_livro_fk, data_saida, data_prevista, data_devolucao) VALUES
(4, 1, '2026-06-05 10:00:00', '2026-06-12', NULL),                 -- 1 Arthur ativo
(4, 2, '2026-06-05 10:05:00', '2026-06-12', NULL),                 -- 2 Arthur ativo
(4, 3, '2026-06-05 10:10:00', '2026-06-12', NULL),                 -- 3 Arthur ativo
(5, 5, '2026-05-20 09:00:00', '2026-05-27', NULL),                 -- 4 Bernardo Atrasado
(6, 6, '2026-05-01 14:00:00', '2026-05-08', '2026-05-07 16:00:00'),-- 5 Rodrigo devolveu no prazo
(7, 7, '2026-04-10 11:00:00', '2026-04-17', '2026-04-25 15:00:00');-- 6 Luiz devolveu com atraso (8 dias)

INSERT INTO Multas (id_emprestimo_fk, valor, pago) VALUES
(6, 16.00, 1),
(4, 26.00, 0);

-- -------------------------------------------------------------------

-- ••• SEÇÃO 2: VIEWS (VISÕES) •••
-- 1. vw_acervo_publico
-- Catálogo público que o aluno enxerga. Esconde o preço de custo e lista apenas os livros DISPONIVEL.
CREATE VIEW vw_acervo_publico AS
SELECT
    id_livro,
    titulo,
    autor,
    isbn,
    quantidade_estoque,
    status
FROM Livros
WHERE status = 'DISPONIVEL';

-- 2. vw_livros_atrasados
-- Lista os empréstimos vencidos e ainda não devolvidos, com contato do usuário e os dias de atraso.
CREATE VIEW vw_livros_atrasados AS
SELECT
    e.id_emprestimo,
    u.nome AS usuario,
    u.email AS contato,
    l.titulo AS livro,
    e.data_prevista,
    DATEDIFF(CURDATE(), e.data_prevista)  AS dias_atraso
FROM Emprestimos e
JOIN Usuarios u ON u.id_usuario = e.id_usuario_fk
JOIN Livros   l ON l.id_livro   = e.id_livro_fk
WHERE e.data_devolucao IS NULL
AND e.data_prevista  < CURDATE();

-- 3. vw_ranking_leitura
-- Top 10 livros mais emprestados (usa GROUP BY + COUNT).
CREATE VIEW vw_ranking_leitura AS
SELECT
    l.id_livro,
    l.titulo,
    l.autor,
    COUNT(e.id_emprestimo) AS total_emprestimos
FROM Livros l
JOIN Emprestimos e ON e.id_livro_fk = l.id_livro
GROUP BY l.id_livro, l.titulo, l.autor
ORDER BY total_emprestimos DESC
LIMIT 10;

-- 4. vw_dashboard_financeiro
-- Resumo das multas: total arrecadado (pagas) e total pendente (não pagas), via SUM condicional.
CREATE VIEW vw_dashboard_financeiro AS
SELECT
    COUNT(*) AS total_multas,
    SUM(CASE WHEN pago = 1 THEN valor ELSE 0 END) AS valor_arrecadado,
    SUM(CASE WHEN pago = 0 THEN valor ELSE 0 END) AS valor_pendente
FROM Multas;

-- -------------------------------------------------------------------

-- ••• SEÇÃO 3: Stored Procedures (Procedimentos Armazenados) •••
DELIMITER $$

-- 1. sp_transacao_emprestimo
-- Faz o empréstimo numa transação: checa pendências e estoque, registra e dá baixa no estoque e ROLLBACK se algo falhar.
CREATE PROCEDURE sp_transacao_emprestimo(IN p_id_user INT, IN p_id_livro INT)
BEGIN
    DECLARE v_estoque INT;
    DECLARE v_pendencias INT;
    DECLARE v_tipo VARCHAR(20);
    DECLARE v_dias INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SELECT tipo INTO v_tipo FROM Usuarios WHERE id_usuario = p_id_user;
    IF v_tipo IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Usuario nao encontrado.';
    END IF;

    SELECT COUNT(*) INTO v_pendencias
    FROM Multas m
    JOIN Emprestimos e ON e.id_emprestimo = m.id_emprestimo_fk
    WHERE e.id_usuario_fk = p_id_user AND m.pago = 0;

    IF v_pendencias > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Emprestimo negado: usuario possui multas pendentes.';
    END IF;

    SELECT quantidade_estoque INTO v_estoque
    FROM Livros WHERE id_livro = p_id_livro;

    IF v_estoque IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Livro nao encontrado.';
    END IF;

    IF v_estoque <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Emprestimo negado: livro sem estoque.';
    END IF;

    IF v_tipo = 'ALUNO' THEN
        SET v_dias = 7;
    ELSE
        SET v_dias = 14;
    END IF;

    INSERT INTO Emprestimos (id_usuario_fk, id_livro_fk, data_prevista)
    VALUES (p_id_user, p_id_livro, DATE_ADD(CURDATE(), INTERVAL v_dias DAY));

    UPDATE Livros SET quantidade_estoque = quantidade_estoque - 1
    WHERE id_livro = p_id_livro;

    COMMIT;
END$$

-- 2. sp_renovar_emprestimo
-- Renova o empréstimo por +7 dias, desde que o livro não esteja reservado nem já tenha sido devolvido.
CREATE PROCEDURE sp_renovar_emprestimo(IN p_id_emprestimo INT)
BEGIN
    DECLARE v_id_livro INT;
    DECLARE v_status VARCHAR(20);
    DECLARE v_devolucao DATETIME;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SELECT e.id_livro_fk, e.data_devolucao, l.status
    INTO v_id_livro, v_devolucao, v_status
    FROM Emprestimos e
    JOIN Livros l ON l.id_livro = e.id_livro_fk
    WHERE e.id_emprestimo = p_id_emprestimo;

    IF v_id_livro IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Emprestimo nao encontrado.';
    END IF;

    IF v_devolucao IS NOT NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Renovacao negada: este emprestimo ja foi devolvido.';
    END IF;

    IF v_status = 'RESERVADO' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Renovacao negada: livro reservado por outro usuario.';
    END IF;

    UPDATE Emprestimos
    SET data_prevista = DATE_ADD(data_prevista, INTERVAL 7 DAY)
    WHERE id_emprestimo = p_id_emprestimo;

    COMMIT;
END$$

-- 3. sp_calcular_multa
-- Calcula a multa por atraso (dias x R$2,00) e retorna o valor pelo parâmetro de saída (OUT).
CREATE PROCEDURE sp_calcular_multa(IN p_id_emprestimo INT, OUT p_valor_multa DECIMAL(10,2))
BEGIN
    DECLARE v_prevista DATE;
    DECLARE v_devolucao DATETIME;
    DECLARE v_data_ref DATE;
    DECLARE v_dias INT;

    SELECT data_prevista, data_devolucao
    INTO v_prevista, v_devolucao
    FROM Emprestimos WHERE id_emprestimo = p_id_emprestimo;

    IF v_prevista IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Emprestimo nao encontrado.';
    END IF;

    IF v_devolucao IS NOT NULL THEN
        SET v_data_ref = DATE(v_devolucao);
    ELSE
        SET v_data_ref = CURDATE();
    END IF;

    SET v_dias = DATEDIFF(v_data_ref, v_prevista);

    IF v_dias > 0 THEN
        SET p_valor_multa = v_dias * 2.00;
    ELSE
        SET p_valor_multa = 0.00;
    END IF;
END$$

-- 4. sp_transacao_cadastro_completo
-- Cadastra usuário + endereço numa única transação e se o endereço falhar, desfaz o usuário (sem registros órfãos).
CREATE PROCEDURE sp_transacao_cadastro_completo(
    IN p_nome VARCHAR(150),
    IN p_cpf CHAR(11),
    IN p_email VARCHAR(150),
    IN p_senha VARCHAR(255),
    IN p_tipo VARCHAR(20),
    IN p_logradouro VARCHAR(150),
    IN p_bairro VARCHAR(100),
    IN p_cidade VARCHAR(100),
    IN p_uf CHAR(2)
)
BEGIN
    DECLARE v_id_usuario INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    INSERT INTO Usuarios (nome, cpf, email, senha, tipo)
    VALUES (p_nome, p_cpf, p_email, p_senha, p_tipo);

    SET v_id_usuario = LAST_INSERT_ID();

    INSERT INTO Enderecos (logradouro, bairro, cidade, uf, id_usuario_fk)
    VALUES (p_logradouro, p_bairro, p_cidade, p_uf, v_id_usuario);

    COMMIT;
END$$

-- 5. sp_transacao_devolucao (citada no menu - Passo 4)
-- Registra a devolução: marca a data, repõe o estoque e gera multa se houver atraso (tudo numa transação).
CREATE PROCEDURE sp_transacao_devolucao(IN p_id_emprestimo INT)
BEGIN
    DECLARE v_id_livro INT;
    DECLARE v_prevista DATE;
    DECLARE v_devolucao DATETIME;
    DECLARE v_dias INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SELECT id_livro_fk, data_prevista, data_devolucao
    INTO v_id_livro, v_prevista, v_devolucao
    FROM Emprestimos WHERE id_emprestimo = p_id_emprestimo;

    IF v_id_livro IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Emprestimo nao encontrado.';
    END IF;

    IF v_devolucao IS NOT NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Este emprestimo ja foi devolvido.';
    END IF;

    UPDATE Emprestimos SET data_devolucao = NOW()
    WHERE id_emprestimo = p_id_emprestimo;

    UPDATE Livros SET quantidade_estoque = quantidade_estoque + 1
    WHERE id_livro = v_id_livro;

    SET v_dias = DATEDIFF(CURDATE(), v_prevista);
    IF v_dias > 0 THEN
        INSERT INTO Multas (id_emprestimo_fk, valor, pago)
        VALUES (p_id_emprestimo, v_dias * 2.00, 0);
    END IF;

    COMMIT;
END$$

-- 6. sp_historico_usuario (citada no menu do Aluno - "Meus Empréstimos")
-- Retorna o histórico de empréstimos de um usuário (usado no 'Meus Empréstimos' do aluno).
CREATE PROCEDURE sp_historico_usuario(IN p_id_usuario INT)
BEGIN
    SELECT
        e.id_emprestimo,
        l.titulo,
        e.data_saida,
        e.data_prevista,
        e.data_devolucao,
        CASE WHEN e.data_devolucao IS NULL THEN 'EM ABERTO' ELSE 'DEVOLVIDO' END AS situacao
    FROM Emprestimos e
    JOIN Livros l ON l.id_livro = e.id_livro_fk
    WHERE e.id_usuario_fk = p_id_usuario
    ORDER BY e.data_saida DESC;
END$$

DELIMITER ;

-- -------------------------------------------------------------------

-- ••• SEÇÃO 4: GATILHOS (TRIGGERS) •••
DELIMITER $$

-- 1a. trg_horario_emprestimo_insert
-- Impede de criar empréstimos fora do horário comercial (08h-18h).
CREATE TRIGGER trg_horario_emprestimo_insert
BEFORE INSERT ON Emprestimos
FOR EACH ROW
BEGIN
    IF HOUR(NOW()) < 8 OR HOUR(NOW()) >= 18 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Operacao bloqueada: fora do horario comercial (08h-18h).';
    END IF;
END$$

-- 1b. trg_horario_emprestimo_update
-- Impede de alterar empréstimos (devolução/renovação) fora do horário comercial (08h-18h).
CREATE TRIGGER trg_horario_emprestimo_update
BEFORE UPDATE ON Emprestimos
FOR EACH ROW
BEGIN
    IF HOUR(NOW()) < 8 OR HOUR(NOW()) >= 18 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Operacao bloqueada: fora do horario comercial (08h-18h).';
    END IF;
END$$

-- 2. trg_auditoria_delecao
-- Grava no Log de Auditoria todo livro excluído: dados antigos em JSON + quem apagou.
CREATE TRIGGER trg_auditoria_delecao
AFTER DELETE ON Livros
FOR EACH ROW
BEGIN
    INSERT INTO Log_Auditoria (tabela_afetada, acao, usuario_responsavel, dados_antigos)
    VALUES (
        'Livros',
        'DELETE',
        USER(),
        JSON_OBJECT(
            'id_livro', OLD.id_livro,
            'titulo', OLD.titulo,
            'autor', OLD.autor,
            'isbn', OLD.isbn,
            'preco_custo', OLD.preco_custo,
            'quantidade_estoque', OLD.quantidade_estoque,
            'status', OLD.status
        )
    );
END$$

-- 3. trg_limite_emprestimos
-- Bloqueia um aluno que já tem 3 empréstimos ativos de pegar um quarto livro.
CREATE TRIGGER trg_limite_emprestimos
BEFORE INSERT ON Emprestimos
FOR EACH ROW
BEGIN
    DECLARE v_tipo   VARCHAR(20);
    DECLARE v_ativos INT;

    SELECT tipo INTO v_tipo FROM Usuarios WHERE id_usuario = NEW.id_usuario_fk;

    IF v_tipo = 'ALUNO' THEN
        SELECT COUNT(*) INTO v_ativos
        FROM Emprestimos
        WHERE id_usuario_fk = NEW.id_usuario_fk
          AND data_devolucao IS NULL;

        IF v_ativos >= 3 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Limite atingido: aluno ja possui 3 livros emprestados.';
        END IF;
    END IF;
END$$

-- 4. trg_preventiva_estoque
-- Impede que a quantidade em estoque de um livro fique negativa.
CREATE TRIGGER trg_preventiva_estoque
BEFORE UPDATE ON Livros
FOR EACH ROW
BEGIN
    IF NEW.quantidade_estoque < 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Operacao bloqueada: estoque nao pode ficar negativo.';
    END IF;
END$$

DELIMITER ;

-- -------------------------------------------------------------------

-- ••• SEÇÃO 5: USERS •••
DROP USER IF EXISTS 'usr_gerente'@'%';
DROP USER IF EXISTS 'usr_bibliotecario'@'%';
DROP USER IF EXISTS 'usr_estagiario'@'%';
DROP USER IF EXISTS 'usr_aluno'@'%';
CREATE USER 'usr_gerente'@'%' IDENTIFIED BY 'gerente123';
CREATE USER 'usr_bibliotecario'@'%' IDENTIFIED BY 'biblio123';
CREATE USER 'usr_estagiario'@'%' IDENTIFIED BY 'estagio123';
CREATE USER 'usr_aluno'@'%' IDENTIFIED BY 'aluno123';

-- 1. usr_gerente (O ADMINISTRADOR)
-- Administrador: acesso total + PROCESS para backup. Único que vê dados financeiros.
GRANT ALL PRIVILEGES ON db_libritech.* TO 'usr_gerente'@'%';
GRANT PROCESS ON *.* TO 'usr_gerente'@'%';

-- 2. usr_bibliotecário (O OPERADOR) - rotina diaria
-- Operador do dia a dia: lê tudo e gerencia livros/empréstimos, mas NÃO apaga a auditoria.
GRANT SELECT ON db_libritech.* TO 'usr_bibliotecario'@'%';
GRANT INSERT, UPDATE, DELETE ON db_libritech.Livros TO 'usr_bibliotecario'@'%';
GRANT INSERT, UPDATE ON db_libritech.Emprestimos TO 'usr_bibliotecario'@'%';
GRANT INSERT, UPDATE ON db_libritech.Multas TO 'usr_bibliotecario'@'%';
GRANT INSERT ON db_libritech.Usuarios TO 'usr_bibliotecario'@'%';
GRANT INSERT ON db_libritech.Enderecos TO 'usr_bibliotecario'@'%';
GRANT EXECUTE ON db_libritech.* TO 'usr_bibliotecario'@'%';

-- 3. usr_estagiário (O RESTRITO)
-- Perfil restrito: só consulta acervo e cria empréstimos simples; o DELETE é explicitamente revogado.
GRANT SELECT ON db_libritech.Livros TO 'usr_estagiario'@'%';
GRANT SELECT, INSERT ON db_libritech.Emprestimos TO 'usr_estagiario'@'%';
GRANT EXECUTE ON PROCEDURE db_libritech.sp_transacao_emprestimo TO 'usr_estagiario'@'%';
GRANT  DELETE ON db_libritech.Livros TO 'usr_estagiario'@'%';
REVOKE DELETE ON db_libritech.Livros FROM 'usr_estagiario'@'%';

-- 4. usr_aluno (O VISITANTE)
-- Visitante: somente leitura e APENAS pela view pública (sem acesso direto às tabelas).
GRANT SELECT  ON db_libritech.vw_acervo_publico TO 'usr_aluno'@'%';
GRANT EXECUTE ON PROCEDURE db_libritech.sp_historico_usuario TO 'usr_aluno'@'%';

-- Mostras permissões dos Users:
SHOW GRANTS FOR 'usr_gerente'@'%';
SHOW GRANTS FOR 'usr_bibliotecario'@'%';
SHOW GRANTS FOR 'usr_estagiario'@'%';
SHOW GRANTS FOR 'usr_aluno'@'%';

-- -------------------------------------------------------------------

-- ••• SEÇÃO 6: ÍNDICES E EXPLAIN •••
-- PARTE 1 - Volume para o teste (2000 livros fake, INDISPONIVEL)
-- INDISPONÍVEL para não aparecerem na vw_acervo_publico.
SET SESSION cte_max_recursion_depth = 10000;

INSERT INTO Livros (titulo, autor, isbn, preco_custo, quantidade_estoque, status)
WITH RECURSIVE seq AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM seq WHERE n < 2000
)
SELECT
    CONCAT('Livro Dummy ', n),
    CONCAT('Autor Dummy ', n),
    CONCAT('DUMMY', LPAD(n, 10, '0')),
    10.00,
    1,
    'INDISPONIVEL'
FROM seq;

-- PARTE 2 - EXPLAIN ANTES (sem indíce em título)
EXPLAIN SELECT * FROM Livros WHERE titulo = 'Livro Dummy 1500';

-- PARTE 3 - Os 3 indíces estratégicos
-- (1) Busca de livros pelo título. E a consulta mais comum do acervo ("Consultar Acervo") e e o indíce exigido pelo Teste 7.8.
CREATE INDEX idx_livro_titulo ON Livros(titulo);

-- (2) Identifica emprestimos ATIVOS (data_devolucao IS NULL). Usado na trigger de limite e na vw_livros_atrasados - consultas frequentes.
CREATE INDEX idx_emprestimo_devolucao ON Emprestimos(data_devolucao);

-- (3) Filtro de disponibilidade. A vw_acervo_publico filtra por status = 'DISPONIVEL' a cada consulta do aluno.
CREATE INDEX idx_livro_status ON Livros(status);

-- PARTE 4 - EXPLAIN DEPOIS (com indíce em título)
EXPLAIN SELECT * FROM Livros WHERE titulo = 'Livro Dummy 1500';

-- -------------------------------------------------------------------

-- ••• SEÇÃO 7: PLANO DE TESTES •••
-- ATENCÃO:DEMONSTRAÇÃO MANUAL E NA APLICAÇÃO JAVA.

-- =====================================================================
-- USUÁRIOS DO BANCO (login no app Java)
--   USUÁRIO             | SENHA       |
--   --------------------|-------------|
--   usr_gerente         | gerente123  |
--   usr_bibliotecario   | biblio123   |
--   usr_estagiario      | estagio123  |
--   usr_aluno           | aluno123    |
-- =====================================================================

-- =====================================================================
-- TESTE 1 - HORÁRIO: operação fora das 08h-18h deve dar erro de trigger (rode fora do horário comercial para ver o bloqueio).
-- App Java: qualquer empréstimo/devolução fora do horário -> "fora do horário comercial".
INSERT INTO Emprestimos (id_usuario_fk, id_livro_fk, data_prevista)
VALUES (6, 9, '2026-06-20');
-- =====================================================================

-- =====================================================================
-- TESTE 2 - ATOMICIDADE: cadastro com UF inválido deve desfazer tudo.
-- App Java: e teste de procedure, não tem tela -> rode aqui no Workbench.
CALL sp_transacao_cadastro_completo('Teste Atomicidade', '99999999911', 'teste@x.com', 'senha', 'ALUNO', 'Rua X', NULL, 'Campina Grande', 'PB');
SELECT * FROM Usuarios WHERE nome = 'Teste Atomicidade'; -- deve vir vazio (ROLLBACK).
-- =====================================================================

-- =====================================================================
-- TESTE 3 - SEGURANÇA: estagiário não pode excluir livro.
-- App Java: login usr_estagiario -> Excluir Livro -> "Acesso Negado".
-- =====================================================================

-- =====================================================================
-- TESTE 4 - AUDITORIA: gerente exclui e fica registrado no Log (como gerente ou root; use um livro que ainda exista, ex: id 8).
-- App Java: login usr_gerente -> Excluir Livro, ex: id 8 -> sucesso; depois confira o Log.
DELETE FROM Livros WHERE id_livro = 8;
SELECT * FROM Log_Auditoria; -- mostra o JSON do livro apagado + quem apagou.
-- =====================================================================

-- =====================================================================
-- TESTE 5 - LIMITE: aluno com 3 ativos não pega o 4 livros (rode entre 08h-18h; fora disso a trigger de horário bloqueia antes).
-- App Java: login funcionário -> Realizar Empréstimo -> usuário 4, livro 9.
CALL sp_transacao_emprestimo(4, 9); -- Arthur(4) tem 3 -> "Limite atingido".
-- =====================================================================

-- =====================================================================
-- TESTE 6.1 - RENOVAÇÃO: renovar livro RESERVADO deve falhar.
-- App Java: usr_gerente -> Renovar Empréstimo (de um livro reservado, ex: 1).
UPDATE Livros SET status = 'RESERVADO'  WHERE id_livro = 1; -- prepara o cenário.
CALL sp_renovar_emprestimo(1); -- deve falhar: "livro reservado".
UPDATE Livros SET status = 'DISPONIVEL' WHERE id_livro = 1; -- desfaz a preparacao.

-- TESTE 6.2 - MULTA: verifica o cálculo da multa de um atraso.
CALL sp_calcular_multa(4, @multa); -- Bernardo, empréstimo 4 atrasado.
SELECT @multa AS valor_multa; -- dias de atraso x R$2,00.
-- =====================================================================

-- =====================================================================
-- TESTE 7 - VIEW: aluno não ve o preço de custo.
-- Abra uma NOVA conexão como usr_aluno / aluno123 e rode:
-- App Java: login usr_aluno -> Consultar Acervo -> nenhuma coluna de preço.
SELECT * FROM vw_acervo_publico; -- funciona, mas SEM a coluna preco_custo.
-- =====================================================================

-- =====================================================================
-- TESTE 8 - EXPLAIN: já realizado na Seção 6.
EXPLAIN SELECT * FROM Livros WHERE titulo = 'Livro Dummy 1500';
-- =====================================================================