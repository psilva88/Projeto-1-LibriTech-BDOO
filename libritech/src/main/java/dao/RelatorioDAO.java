package dao;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * DAO de Relatorios.
 */
public class RelatorioDAO {

    public String livrosAtrasados(Connection conn) throws SQLException {
        StringBuilder sb = new StringBuilder("LIVROS ATRASADOS\n\n");
        String sql = "SELECT usuario, contato, livro, data_prevista, dias_atraso "
                   + "FROM vw_livros_atrasados";
        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            boolean any = false;
            while (rs.next()) {
                any = true;
                sb.append(rs.getString("usuario")).append(" - ")
                  .append(rs.getString("livro"))
                  .append(" (").append(rs.getInt("dias_atraso")).append(" dias)\n")
                  .append("   Contato: ").append(rs.getString("contato")).append("\n\n");
            }
            if (!any) sb.append("Nenhum livro atrasado.");
        }
        return sb.toString();
    }

    public String rankingLeitura(Connection conn) throws SQLException {
        StringBuilder sb = new StringBuilder("RANKING DE LEITURA (Top 10)\n\n");
        String sql = "SELECT titulo, autor, total_emprestimos FROM vw_ranking_leitura";
        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            int pos = 1;
            while (rs.next()) {
                sb.append(pos++).append(". ").append(rs.getString("titulo"))
                  .append(" - ").append(rs.getInt("total_emprestimos"))
                  .append(" emprestimo(s)\n");
            }
        }
        return sb.toString();
    }

    public String dashboardFinanceiro(Connection conn) throws SQLException {
        String sql = "SELECT total_multas, valor_arrecadado, valor_pendente "
                   + "FROM vw_dashboard_financeiro";
        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) {
                return "DASHBOARD FINANCEIRO\n\n"
                     + "Total de multas: " + rs.getInt("total_multas") + "\n"
                     + "Arrecadado:  R$ " + rs.getBigDecimal("valor_arrecadado") + "\n"
                     + "Pendente:    R$ " + rs.getBigDecimal("valor_pendente");
            }
        }
        return "Sem dados financeiros.";
    }
}
