
public class Spec_prodotto {
		private int id;
		private String taglia;
		private int quantita;
		private Prodotto p;
		
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
		
		
		public Prodotto getProdotto() {
			return p;
		}
		public void setProdotto(Prodotto p) {
			this.p = p;
		}
}
