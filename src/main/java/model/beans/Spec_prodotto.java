package model.beans;
import java.io.Serializable;

public class Spec_prodotto implements Serializable{
		private int id;
		private String taglia;
		private int quantita;
		private int prodotto_id;
		
		public Spec_prodotto() {}
		
		public int getId() {
			return id;
		}
		public void setId(int id) {
			this.id = id;
		}
		
		
		public String getTaglia() {
			return taglia;
		}
		public void setTaglia(String t) {
			this.taglia = t;
		}
		
		
		public int getQuantita() {
			return quantita;
		}
		public void setQuantita(int q) {
			this.quantita = q;
		}
		
		
		public int getProdottoId() {
			return prodotto_id;
		}
		public void setProdottoId(int id) {
			this.prodotto_id = id;
		}
}
