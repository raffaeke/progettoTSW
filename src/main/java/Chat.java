import java.time.LocalDate;
public class Chat {
	private int id;
	private Utente cliente;
	private LocalDate creataIl;
	
	public Chat() {}
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	
	
	public Utente getCliente() {
		return cliente;
	}
	public void setCliente(Utente c) {
		this.cliente = c;
	}
	
	
	public LocalDate getDataCreazione() {
		return creataIl;
	}
	public void setDataCreazione(LocalDate d) {
		this.creataIl = d;
	}
}
