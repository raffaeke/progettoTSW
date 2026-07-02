package model.beans;
import java.time.LocalDate;
import java.util.ArrayList;
import java.io.Serializable;

public class Ordine implements Serializable{
	private int id;
	private LocalDate data_ordine;
	private Stato stato;
	private int utente_id;
	
	public Ordine() {}
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	
	
	public LocalDate getData() {
		return data_ordine;
	}
	public void setData(LocalDate d) {
		this.data_ordine= d;
	}
	
	
	
	public Stato getStato() {
		return stato;
	}
	public void setStato(Stato s) {
		this.stato = s;
	}
	
	
	
	public int getUtenteId() {
		return utente_id;
	}
	public void setUtenteId(int id) {
		this.utente_id = id;
	}
	
}
