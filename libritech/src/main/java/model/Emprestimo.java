package model;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Modelo Emprestimo. Atributos PRIVATE (Encapsulamento).
 */
public class Emprestimo {

    private int id;
    private int idUsuario;
    private int idLivro;
    private LocalDateTime dataSaida;
    private LocalDate dataPrevista;
    private LocalDateTime dataDevolucao;

    public Emprestimo() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getIdUsuario() { return idUsuario; }
    public void setIdUsuario(int idUsuario) { this.idUsuario = idUsuario; }

    public int getIdLivro() { return idLivro; }
    public void setIdLivro(int idLivro) { this.idLivro = idLivro; }

    public LocalDateTime getDataSaida() { return dataSaida; }
    public void setDataSaida(LocalDateTime dataSaida) { this.dataSaida = dataSaida; }

    public LocalDate getDataPrevista() { return dataPrevista; }
    public void setDataPrevista(LocalDate dataPrevista) { this.dataPrevista = dataPrevista; }

    public LocalDateTime getDataDevolucao() { return dataDevolucao; }
    public void setDataDevolucao(LocalDateTime dataDevolucao) { this.dataDevolucao = dataDevolucao; }
}
