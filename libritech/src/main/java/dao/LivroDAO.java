package dao;

import model.Livro;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO de Livro.
 */
public class LivroDAO {

    // Le a vw_acervo_publico.
    public List<Livro> listarAcervoPublico(Connection conn) throws SQLException {
        List<Livro> livros = new ArrayList<>();
        String sql = "SELECT id_livro, titulo, autor, isbn, quantidade_estoque, status "
                   + "FROM vw_acervo_publico";

        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Livro l = new Livro();
                l.setId(rs.getInt("id_livro"));
                l.setTitulo(rs.getString("titulo"));
                l.setAutor(rs.getString("autor"));
                l.setIsbn(rs.getString("isbn"));
                l.setQuantidadeEstoque(rs.getInt("quantidade_estoque"));
                l.setStatus(rs.getString("status"));
                livros.add(l);
            }
        }
        return livros;
    }

    // Cadastra um livro.
    public void cadastrar(Connection conn, Livro l) throws SQLException {
        String sql = "INSERT INTO Livros (titulo, autor, isbn, preco_custo, quantidade_estoque, status) "
                   + "VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, l.getTitulo());
            ps.setString(2, l.getAutor());
            ps.setString(3, l.getIsbn());
            ps.setDouble(4, l.getPrecoCusto());
            ps.setInt(5, l.getQuantidadeEstoque());
            ps.setString(6, l.getStatus());
            ps.executeUpdate();
        }
    }

    // Exclui um livro.
    public void deletar(Connection conn, int idLivro) throws SQLException {
        String sql = "DELETE FROM Livros WHERE id_livro = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idLivro);
            ps.executeUpdate();
        }
    }
}
