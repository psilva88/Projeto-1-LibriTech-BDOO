package connection;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexao {

    private static final String URL = "jdbc:mysql://localhost:3306/db_libritech";

    public static Connection conectar(String usuario, String senha) throws SQLException {
        return DriverManager.getConnection(URL, usuario, senha);
    }
}
