package model;

/**
 * Superclasse ABSTRATA (Heranca).
 * Atributos PRIVATE (Encapsulamento) acessados via getters/setters.
 */
public abstract class Usuario {

    private int id;
    private String nome;
    private String cpf;
    private String login;
    private String senha;

    public Usuario() {}

    public Usuario(int id, String nome, String cpf) {
        this.id = id;
        this.nome = nome;
        setCpf(cpf); // valida no setter
    }

    // Metodo POLIMORFICO: Aluno -> 7 dias, Funcionario -> 14 dias
    public abstract int getDiasPrazoEmprestimo();

    // ----- Getters / Setters (Encapsulamento) -----
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }

    public String getCpf() { return cpf; }
    public void setCpf(String cpf) {
        if (cpf != null && cpf.length() != 11) {
            throw new IllegalArgumentException("CPF deve ter 11 digitos.");
        }
        this.cpf = cpf;
    }

    public String getLogin() { return login; }
    public void setLogin(String login) { this.login = login; }

    public String getSenha() { return senha; }
    public void setSenha(String senha) { this.senha = senha; }
}
