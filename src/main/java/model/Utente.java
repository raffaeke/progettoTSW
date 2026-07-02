package model;
import java.io.Serializable;
public class Utente implements Serializable{
	private int id;
	private String nome;
	private String cognome;
	private String email;
	private String password;
	private String indirizzo;
	private String provincia;
	private String paese;
	
	public Utente() {	}
	
	public int getId() {
		return id; 
		}
    public void setId(int id) { 
    	this.id = id; 
    	}

    
    public String getNome() { 
    	return nome; 
    	}
    public void setNome(String nome) {
    	this.nome = nome; 
    	}

    
    public String getCognome() { 
    	return cognome; 
    	}
    public void setCognome(String cognome) {
    	this.cognome = cognome; 
    	}
    
    
    public String getEmail() {
    	return email; 
    	}
    public void setEmail(String email) {
    	this.email = email; 
    	}
    
    
    public String getPassword() { 
    	return password; 
    	}
    public void setPassword(String password) {
    	this.password = password; 
    	}

    
    
    public String getIndirizzo() {
    	return indirizzo; 
    	}
    public void setIndirizzo(String indirizzo) {
    	this.indirizzo = indirizzo; 
    	}
    
    
    public String getPaese() { 
    	return paese; 
    	}
    public void setPaese(String paese) {
    	this.paese = paese; 
    	}
    
    
    public String getProvincia() { 
    	return provincia; 
    	}
    public void setProvincia(String provincia) {
    	this.provincia = provincia; 
    	}

    
 
}
