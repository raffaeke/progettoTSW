import java.time.LocalDate;
import java.io.Serializable;

public class Recensione implements Serializable{
	private int id;
	private Prodotto p;
	private Utente u;
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
	
	
	public Prodotto getProdotto() {
		return p;
	}
	public void setProdotto(Prodotto p) {
		this.p = p;
	}
	
	
	public Utente getUtente() {
		return u;
	}
	public void setUtente(Utente u) {
		this.u = u;
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
