package model;
import java.io.Serializable;

public class Img_prodotto implements Serializable{
	private int id;
	private String url;
	private Prodotto p;
	
	public Img_prodotto() {}
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	
	
	
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	
	
	
	public Prodotto getProdotto() {
		return p;
	}
	public void setProdotto(Prodotto p) {
		this.p = p;
	}
}
