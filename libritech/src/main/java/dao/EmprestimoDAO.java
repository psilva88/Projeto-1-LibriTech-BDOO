package dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * DAO de Emprestimo.
 */
public class EmprestimoDAO {

    // Historico de emprestimos de um usuario (Menu do Aluno).
    public String historicoUsuario(Connection conn, int idUsuario) throws SQLException {
        StringBuilder sb = new StringBuilder("MEUS EMPRESTIMOS\n\n");
        try (CallableStatement cs = conn.prepareCall("{CALL sp_historico_usuario(?)}")) {
            cs.setInt(1, idUsuario);
            try (ResultSet rs = cs.executeQuery()) {
                boolean temDados = false;
                while (rs.next()) {
                    temDados = true;
                    sb.append("Emprestimo #").append(rs.getInt("id_emprestimo"))
                      .append(" - ").append(rs.getString("titulo")).append("\n")
                      .append("   Saida:    ").append(rs.getString("data_saida")).append("\n")
                      .append("   Prevista: ").append(rs.getString("data_prevista")).append("\n")
                      .append("   Situacao: ").append(rs.getString("situacao")).append("\n\n");
                }
                if (!temDados) sb.append("Nenhum emprestimo encontrado.");
            }
        }
        return sb.toString();
    }

    // Realiza emprestimo via sp_transacao_emprestimo.
    public void realizarEmprestimo(Connection conn, int idUser, int idLivro) throws SQLException {
        try (CallableStatement cs = conn.prepareCall("{CALL sp_transacao_emprestimo(?, ?)}")) {
            cs.setInt(1, idUser);
            cs.setInt(2, idLivro);
            cs.execute();
        }
    }

    // Renova via sp_renovar_emprestimo.
    public void renovar(Connection conn, int idEmprestimo) throws SQLException {
        try (CallableStatement cs = conn.prepareCall("{CALL sp_renovar_emprestimo(?)}")) {
            cs.setInt(1, idEmprestimo);
            cs.execute();
        }
    }

    // Devolve via sp_transacao_devolucao.
    public void devolver(Connection conn, int idEmprestimo) throws SQLException {
        try (CallableStatement cs = conn.prepareCall("{CALL sp_transacao_devolucao(?)}")) {
            cs.setInt(1, idEmprestimo);
            cs.execute();
        }
    }
}
