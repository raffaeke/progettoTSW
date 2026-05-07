package model.beans;
import java.io.Serializable;
public class ItemCarrello implements Serializable{
	
	private Prodotto p;
	private int count;
	
	public ItemCarrello () {
		count = 0;
	}
	
	public void setProdotto(Prodotto p) {
		this.p = p;
	}
	
	public void setQuantita(int c) {
		count=c;
	}
	
	public int getQuantita() {
		return count;
	}
	
	public Prodotto getP() {
		return p;
	}
	

}
