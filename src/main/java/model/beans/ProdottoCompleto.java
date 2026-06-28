package model.beans;

import java.io.Serializable;

public class ProdottoCompleto implements Serializable{
	
	private Prodotto p;
	private Spec_prodotto sp;
	private Img_prodotto img;
	
	public ProdottoCompleto() {}
	
	public Prodotto getProdotto() {
		return p;
	}
	public void setProdotto(Prodotto p) {
		this.p=p;
	}
	public Spec_prodotto getSpec() {
		return sp;
	}
	public void setSpecifiche(Spec_prodotto sp) {
		this.sp=sp;
	}
	public Img_prodotto getImg() {
		return img;
	}
	public void setImg(Img_prodotto img) {
		this.img=img;
	}
	

}
