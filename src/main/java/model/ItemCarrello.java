package model;
import java.io.Serializable;
public class ItemCarrello implements Serializable{

	private Prodotto p;
	private Spec_prodotto spec;
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

	public Spec_prodotto getSpec() {
		return spec;
	}
	public void setSpec(Spec_prodotto spec) {
		this.spec = spec;
	}

}
