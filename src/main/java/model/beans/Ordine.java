package model.beans;
import java.time.LocalDate;
import java.io.Serializable;

public class Ordine implements Serializable{
	private int id;
	private LocalDate data_ordine;
	private float totale;
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
	
	
	public float getTotale() {
		return totale;
	}
	public void setTotale(float t) {
		this.totale = t;
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
