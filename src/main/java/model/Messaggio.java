package model;
import java.time.LocalDate;
import java.io.Serializable;

public class Messaggio implements Serializable{
		private int id;
		private int chat_id;
		private int utente_id;
		private String testo;
		private LocalDate inviatoIl;
		
		public Messaggio() {}
		
		public int getId() {
			return id;
		}
		public void setId(int id) {
			this.id = id;
		}
		
		
		public int getChat() {
			return chat_id;
		}
		public void setChat(int c) {
			this.chat_id = c;
		}
		
		
		public int getMittente() {
			return utente_id;
		}
		public void setMittente(int m) {
			this.utente_id = m;
		}
		
		
		public String getTesto() {
			return testo;
		}
		public void setTesto(String t) {
			this.testo = t;
		}
		
		
		public LocalDate getDataInvio() {
			return inviatoIl;
		}
		public void setDataInvio(LocalDate d) {
			this.inviatoIl = d;
		}
}
