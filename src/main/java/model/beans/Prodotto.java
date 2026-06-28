package model.beans;
import java.io.Serializable;

public class Prodotto implements Serializable{
	private int id;
	private String nome;
	private String desc;
	private String marca;
	private float prezzo;
	private Categoria cat;
	private int sconto;
	private boolean inEvidenza;
	
	public Prodotto() {}
	
	
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	
	public String getMarca() {
		return marca;
	}
	public void setMarca(String m) {
		marca=m;
	}
	
	public String getNome() {
		return nome;
	}
	public void setNome(String nome) {
		this.nome = nome;
	}
	
	
	public String getDesc() {
		return desc;
	}
	public void setDesc(String desc) {
		this.desc = desc;
	}
	
	public float getPrezzo() {
		return prezzo;
	}
	public float getPrezzoScontato() {
		if(sconto == 0) {
			return prezzo;
		}else {
			return prezzo-((prezzo*sconto)/100);
		}
		
	}
	public void setPrezzo(float prezzo) {
		this.prezzo = prezzo;
	}
	
	
	public Categoria getCat() {
		return cat;
	}
	public void setCat(Categoria cat) {
		this.cat = cat;
	}
	
	
	public int getSconto() {
		return sconto;
	}
	public void setSconto(int sconto) {
		this.sconto = sconto;
	}
	
	public boolean isInEvidenza() {
		return inEvidenza;
	}
	public void setInEvidenza(boolean k) {
		this.inEvidenza = k;
	}
}
