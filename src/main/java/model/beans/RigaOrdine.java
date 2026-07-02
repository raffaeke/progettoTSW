package model.beans;

import java.io.Serializable;

public class RigaOrdine implements Serializable{
	private int prodotto_id;
	private int ordine_id;
	private int q;
	private float prezzo;
	
	public RigaOrdine() {}

	public int getProdottoId() {
		return prodotto_id;
	}
	public void setProdottoId(int id) {
		prodotto_id=id;
	}
	
	public int getOrdineId() {
		return ordine_id;
	}
	public void setOrdineId(int id) {
		ordine_id=id;
	}
	
	public int getQuantita() {
		return q;
	}
	public void setQuantita(int q) {
		this.q=q;
	}
	
	public float getPrezzo() {
		return prezzo;
	}
	public void setPrezzo(float p) {
		prezzo=p;
	}
}
