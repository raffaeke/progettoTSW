package model.beans;
import java.io.Serializable;

public class Img_prodotto implements Serializable{
	private int id;
	private String url;
	private int prodotto_id;
	
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
	
	
	
	public int getProdottoId() {
		return prodotto_id;
	}
	public void setProdottoId(int id) {
		this.prodotto_id= id;
	}
}
