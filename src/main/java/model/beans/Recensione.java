package model.beans;
import java.time.LocalDate;
import java.io.Serializable;

public class Recensione implements Serializable{
	private int id;
	private int p;
	private int u;
	private int voto;
	private String commento;
	private LocalDate rec_data;
	
	public Recensione() {}
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	
	
	public int getProdottoId() {
		return p;
	}
	public void setProdottoId(int id) {
		this.p = id;
	}
	
	
	public int getUtenteId() {
		return u;
	}
	public void setUtenteId(int id) {
		this.u = id;
	}
	
	
	public int getVoto() {
		return voto;
	}
	public void setVoto(int v) {
		this.voto = v;
	}
	
	
	public String getCommento() {
		return commento;
	}
	public void setCommento(String c) {
		this.commento=c;
	}
	
	
	public LocalDate getData() {
		return rec_data;
	}
	public void setData(LocalDate d) {
		this.rec_data= d;
	}
}
