package model;

/**
 * Modelo Livro. Atributos PRIVATE (Encapsulamento).
 */
public class Livro {

    private int id;
    private String titulo;
    private String autor;
    private String isbn;
    private double precoCusto;
    private int quantidadeEstoque;
    private String status;

    public Livro() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitulo() { return titulo; }
    public void setTitulo(String titulo) { this.titulo = titulo; }

    public String getAutor() { return autor; }
    public void setAutor(String autor) { this.autor = autor; }

    public String getIsbn() { return isbn; }
    public void setIsbn(String isbn) { this.isbn = isbn; }

    public double getPrecoCusto() { return precoCusto; }
    public void setPrecoCusto(double precoCusto) {
        if (precoCusto < 0) {
            throw new IllegalArgumentException("Preco de custo nao pode ser negativo.");
        }
        this.precoCusto = precoCusto;
    }

    public int getQuantidadeEstoque() { return quantidadeEstoque; }
    public void setQuantidadeEstoque(int quantidadeEstoque) {
        if (quantidadeEstoque < 0) {
            throw new IllegalArgumentException("Estoque nao pode ser negativo.");
        }
        this.quantidadeEstoque = quantidadeEstoque;
    }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
