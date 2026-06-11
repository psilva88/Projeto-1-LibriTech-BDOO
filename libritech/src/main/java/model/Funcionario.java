package model;

/**
 * Subclasse concreta Funcionario (Heranca de Usuario).
 */
public class Funcionario extends Usuario {

    public Funcionario() {}

    public Funcionario(int id, String nome, String cpf) {
        super(id, nome, cpf);
    }

    @Override
    public int getDiasPrazoEmprestimo() {
        return 14;
    }
}
