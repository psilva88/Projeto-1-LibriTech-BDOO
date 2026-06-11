import connection.Conexao;
import dao.LivroDAO;
import dao.EmprestimoDAO;
import dao.UsuarioDAO;
import dao.RelatorioDAO;
import model.Aluno;
import model.Funcionario;
import model.Livro;
import model.Usuario;

import javax.swing.JOptionPane;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
import java.util.List;

/**
 * LibriTech - Main
 */
public class Main {

    public static void main(String[] args) {

        // Selecao de Perfil
        String[] perfis = {"Funcionario", "Aluno", "Sair"};
        int perfil = JOptionPane.showOptionDialog(
                null, "Qual e o seu perfil de acesso?", "LibriTech - Acesso",
                JOptionPane.DEFAULT_OPTION, JOptionPane.QUESTION_MESSAGE,
                null, perfis, perfis[0]);

        if (perfil == 2 || perfil == JOptionPane.CLOSED_OPTION) {
            JOptionPane.showMessageDialog(null, "Saindo... Ate logo!");
            return;
        }

        // Login real
        String usuario = JOptionPane.showInputDialog(null,
                "Usuario do Banco:\n(usr_gerente, usr_bibliotecario, usr_estagiario ou usr_aluno)");
        if (usuario == null) return;
        String senha = JOptionPane.showInputDialog(null, "Senha do Banco:");
        if (senha == null) return;

        try (Connection conn = Conexao.conectar(usuario, senha)) {

            // Checagem para quem logou no banco
            String dbUser = getCurrentUser(conn);
            boolean isAluno = dbUser.startsWith("usr_aluno");

            JOptionPane.showMessageDialog(null,
                    "Conexao realizada com sucesso!\nUsuario: " + usuario,
                    "LibriTech", JOptionPane.INFORMATION_MESSAGE);

            // Checagem perfil x login
            if (isAluno && perfil != 1) {
                JOptionPane.showMessageDialog(null,
                        "Voce escolheu 'Funcionario', mas logou com um usuario de Aluno.\n" +
                        "Abrindo o Menu do Aluno (correspondente ao seu login).");
            } else if (!isAluno && perfil != 0) {
                JOptionPane.showMessageDialog(null,
                        "Voce escolheu 'Aluno', mas logou com um usuario de Funcionario.\n" +
                        "Abrindo o Menu do Funcionario (correspondente ao seu login).");
            }

            if (isAluno) menuAluno(conn);
            else         menuFuncionario(conn);

        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null,
                    "Falha no login / acesso negado.\n\nDetalhe: " + e.getMessage(),
                    "Erro de Conexao", JOptionPane.ERROR_MESSAGE);
        }
    }

    // Descobre o usuario logado no banco (para a checagem perfil x login)
    private static String getCurrentUser(Connection conn) throws SQLException {
        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery("SELECT CURRENT_USER()")) {
            if (rs.next()) return rs.getString(1);
        }
        return "";
    }

    // MENU A (ALUNO)
    private static void menuAluno(Connection conn) {
        int idAluno = pedirInt("Informe seu ID de aluno (ex: 4 = Arthur, 5 = Bernardo):");
        if (idAluno == -1) return;

        LivroDAO livroDAO = new LivroDAO();
        EmprestimoDAO emprestimoDAO = new EmprestimoDAO();

        int op;
        do {
            String[] opcoes = {"Consultar Acervo Disponivel", "Meus Emprestimos", "Sair"};
            op = JOptionPane.showOptionDialog(null, "MENU DO ALUNO", "LibriTech - Aluno",
                    JOptionPane.DEFAULT_OPTION, JOptionPane.PLAIN_MESSAGE, null, opcoes, opcoes[0]);

            try {
                switch (op) {
                    case 0 -> {
                        List<Livro> acervo = livroDAO.listarAcervoPublico(conn);
                        StringBuilder sb = new StringBuilder("ACERVO DISPONIVEL\n\n");
                        for (Livro l : acervo) {
                            sb.append("- ").append(l.getTitulo())
                              .append("  (").append(l.getAutor()).append(")")
                              .append("  | estoque: ").append(l.getQuantidadeEstoque()).append("\n");
                        }
                        JOptionPane.showMessageDialog(null, sb.toString());
                    }
                    case 1 -> JOptionPane.showMessageDialog(null,
                            emprestimoDAO.historicoUsuario(conn, idAluno));
                }
            } catch (SQLException e) {
                JOptionPane.showMessageDialog(null, "Erro: " + e.getMessage(),
                        "Erro", JOptionPane.ERROR_MESSAGE);
            }
        } while (op != 2 && op != JOptionPane.CLOSED_OPTION);
    }

    // MENU B (FUNCIONARIO)
    private static void menuFuncionario(Connection conn) {
        LivroDAO livroDAO = new LivroDAO();
        EmprestimoDAO empDAO = new EmprestimoDAO();
        UsuarioDAO usuarioDAO = new UsuarioDAO();
        RelatorioDAO relDAO = new RelatorioDAO();

        int op;
        do {
            String[] opcoes = {
                "Cadastrar Livro", "Realizar Emprestimo", "Renovar Emprestimo",
                "Realizar Devolucao", "Excluir Livro", "Relatorios", "Sair"
            };
            op = JOptionPane.showOptionDialog(null, "MENU DO FUNCIONARIO", "LibriTech - Funcionario",
                    JOptionPane.DEFAULT_OPTION, JOptionPane.PLAIN_MESSAGE, null, opcoes, opcoes[0]);

            try {
                switch (op) {
                    case 0 -> cadastrarLivro(conn, livroDAO);
                    case 1 -> realizarEmprestimo(conn, empDAO, usuarioDAO);
                    case 2 -> {
                        int id = pedirInt("ID do emprestimo a renovar:");
                        if (id != -1) {
                            empDAO.renovar(conn, id);
                            JOptionPane.showMessageDialog(null, "Emprestimo renovado (+7 dias)!");
                        }
                    }
                    case 3 -> {
                        int id = pedirInt("ID do emprestimo a devolver:");
                        if (id != -1) {
                            empDAO.devolver(conn, id);
                            JOptionPane.showMessageDialog(null, "Devolucao registrada com sucesso!");
                        }
                    }
                    case 4 -> excluirLivro(conn, livroDAO);
                    case 5 -> mostrarRelatorios(conn, relDAO);
                }
            } catch (SQLException e) {
                // Operacoes barradas (pendencia, limite, livro reservado,fora de horario, ou falta de permissao do usuario logado).
                JOptionPane.showMessageDialog(null,
                        "OPERACAO BLOQUEADA pelo banco de dados.\n\n" +
                        "Pode ser falta de permissao do seu perfil ou uma regra\n" +
                        "de negocio (estoque, limite, horario, etc.).\n\nDetalhe: " + e.getMessage(),
                        "Bloqueado", JOptionPane.ERROR_MESSAGE);
            }
        } while (op != 6 && op != JOptionPane.CLOSED_OPTION);
    }

    private static void cadastrarLivro(Connection conn, LivroDAO dao) throws SQLException {
        String titulo = JOptionPane.showInputDialog("Titulo:");
        if (titulo == null) return;
        String autor = JOptionPane.showInputDialog("Autor:");
        if (autor == null) return;
        String isbn = JOptionPane.showInputDialog("ISBN:");
        if (isbn == null) return;
        String precoStr = JOptionPane.showInputDialog("Preco de custo (ex: 49.90):");
        if (precoStr == null) return;
        String estoqueStr = JOptionPane.showInputDialog("Quantidade em estoque:");
        if (estoqueStr == null) return;

        Livro l = new Livro();
        l.setTitulo(titulo);
        l.setAutor(autor);
        l.setIsbn(isbn);
        l.setStatus("DISPONIVEL");
        try {
            // setters validam (Encapsulamento): preco/estoque nao podem ser negativos
            l.setPrecoCusto(Double.parseDouble(precoStr.replace(",", ".")));
            l.setQuantidadeEstoque(Integer.parseInt(estoqueStr.trim()));
        } catch (IllegalArgumentException ex) { // NumberFormatException ja e subclasse desta
            JOptionPane.showMessageDialog(null, "Dado invalido: " + ex.getMessage());
            return;
        }
        dao.cadastrar(conn, l);
        JOptionPane.showMessageDialog(null, "Livro cadastrado com sucesso!");
    }

    private static void realizarEmprestimo(Connection conn, EmprestimoDAO empDAO, UsuarioDAO usuarioDAO)
            throws SQLException {
        int idUser = pedirInt("ID do usuario:");
        if (idUser == -1) return;
        int idLivro = pedirInt("ID do livro:");
        if (idLivro == -1) return;

        empDAO.realizarEmprestimo(conn, idUser, idLivro); // pode lancar (pendencia/limite/estoque)

        // Polimorfismo: mostra o prazo conforme o tipo do usuario.
        String msg = "Emprestimo realizado com sucesso!";
        try {
            String tipo = usuarioDAO.consultarTipo(conn, idUser);
            if (tipo != null) {
                Usuario u = "ALUNO".equals(tipo) ? new Aluno() : new Funcionario();
                int dias = u.getDiasPrazoEmprestimo();      // metodo polimorfico
                msg += "\nPrazo (" + tipo + "): " + dias + " dias"
                     + "\nDevolver ate: " + LocalDate.now().plusDays(dias);
            }
        } catch (SQLException ignore) {

        }
        JOptionPane.showMessageDialog(null, msg);
    }

    private static void excluirLivro(Connection conn, LivroDAO dao) {
        int id = pedirInt("ID do livro a excluir:");
        if (id == -1) return;
        try {
            dao.deletar(conn, id);
            JOptionPane.showMessageDialog(null,
                    "Livro excluido com sucesso!\n(A exclusao foi registrada no Log de Auditoria.)");
        } catch (SQLException e) {
            // Observação do estagiário
            JOptionPane.showMessageDialog(null,
                    "ERRO: Acesso Negado!\n\n" +
                    "Seu perfil de usuario nao tem permissao para excluir\n" +
                    "registros do sistema.\n\n(Detalhe tecnico: " + e.getMessage() + ")",
                    "Acesso Negado", JOptionPane.ERROR_MESSAGE);
        }
    }

    private static void mostrarRelatorios(Connection conn, RelatorioDAO dao) throws SQLException {
        String[] ops = {"Livros Atrasados", "Ranking de Leitura", "Dashboard Financeiro", "Voltar"};
        int o = JOptionPane.showOptionDialog(null, "RELATORIOS", "Relatorios",
                JOptionPane.DEFAULT_OPTION, JOptionPane.PLAIN_MESSAGE, null, ops, ops[0]);
        switch (o) {
            case 0 -> JOptionPane.showMessageDialog(null, dao.livrosAtrasados(conn));
            case 1 -> JOptionPane.showMessageDialog(null, dao.rankingLeitura(conn));
            case 2 -> JOptionPane.showMessageDialog(null, dao.dashboardFinanceiro(conn));
        }
    }

    private static int pedirInt(String msg) {
        String s = JOptionPane.showInputDialog(null, msg);
        if (s == null) return -1;
        try {
            return Integer.parseInt(s.trim());
        } catch (NumberFormatException e) {
            JOptionPane.showMessageDialog(null, "Valor invalido. Use um numero.");
            return -1;
        }
    }
}
