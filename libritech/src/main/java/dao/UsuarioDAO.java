package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * DAO de Usuario.
 */
public class UsuarioDAO {

    public String consultarTipo(Connection conn, int idUsuario) throws SQLException {
        String sql = "SELECT tipo FROM Usuarios WHERE id_usuario = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getString("tipo");
            }
        }
        return null;
    }
}
