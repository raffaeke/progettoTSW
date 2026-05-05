package model.beans;
import java.io.Serializable;

public class Dett_ordine implements Serializable{
	private Ordine o;
	private Utente u;
	private String taglia;
	private int quantita;
	private float prezzo;
	
	public Dett_ordine() {}
	
	public Ordine getOrdine() {
		return o;
	}
	public void setOrdine(Ordine o) {
		this.o = o;
	}
	
	
	public Utente getUtente() {
		return u;
	}
	public void setUtente(Utente u) {
		this.u = u;
	}	
	
	
	public String getTaglia() {
		return taglia;
	}
	public void setTaglia(String t) {
		this.taglia = t;
	}	
	
	
	public int getQ() {
		return quantita;
	}
	public void setQ(int q) {
		this.quantita = q;
	}
	
	
	public float getPrezzo() {
		return prezzo;
	}
	public void setPrezzo(float p) {
		this.prezzo = p;
	}
}
