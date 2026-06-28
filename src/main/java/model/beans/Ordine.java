package model.beans;
import java.time.LocalDate;
import java.util.ArrayList;
import java.io.Serializable;

public class Ordine implements Serializable{
	private int id;
	private LocalDate data_ordine;
	private Stato stato;
	private ArrayList<ProdottoCompleto> prodotti= new ArrayList<>();
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
		float tot=0;
		for ( ProdottoCompleto e : prodotti) {
			tot+=e.getProdotto().getPrezzoScontato();
		}
		return tot;
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
	
	public ArrayList<ProdottoCompleto> getProdotti(){
		return prodotti;
	}
	public void aggiungiProdotto(ProdottoCompleto p) {
		prodotti.add(p);
	}
}
