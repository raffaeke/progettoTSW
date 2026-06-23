package model.beans;
import java.io.Serializable;
import java.time.LocalDate;
public class Chat implements Serializable{
	private int id;
	private int cliente_id;
	private LocalDate creataIl;
	
	public Chat() {}
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	
	
	public int getCliente() {
		return cliente_id;
	}
	public void setCliente(int c) {
		this.cliente_id = c;
	}
	
	
	public LocalDate getDataCreazione() {
		return creataIl;
	}
	public void setDataCreazione(LocalDate d) {
		this.creataIl = d;
	}
}
