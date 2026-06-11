package model;

/**
 * Subclasse concreta Aluno (Heranca de Usuario).
 */
public class Aluno extends Usuario {

    public Aluno() {}

    public Aluno(int id, String nome, String cpf) {
        super(id, nome, cpf);
    }

    @Override
    public int getDiasPrazoEmprestimo() {
        return 7;
    }
}
