package model;
import java.time.LocalDate;
import java.io.Serializable;

public class Messaggio implements Serializable{
		private int id;
		private Chat chat;
		private Utente mittente;
		private String testo;
		private LocalDate inviatoIl;
		
		public Messaggio() {}
		
		public int getId() {
			return id;
		}
		public void setId(int id) {
			this.id = id;
		}
		
		
		public Chat getChat() {
			return chat;
		}
		public void setChat(Chat c) {
			this.chat = c;
		}
		
		
		public Utente getMittente() {
			return mittente;
		}
		public void setMittente(Utente m) {
			this.mittente = m;
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
