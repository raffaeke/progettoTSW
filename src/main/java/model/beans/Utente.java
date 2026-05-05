package model.beans;
import java.io.Serializable;
public class Utente implements Serializable{
	private int id;
	private String username;
	private String email;
	private String password;
	private String indirizzo;
	private Ruolo r;
	
	public Utente() {	}
	
	public int getId() {
		return id; 
		}
    public void setId(int id) { 
    	this.id = id; 
    	}

    
    
    public String getUsername() { 
    	return username; 
    	}
    public void setUsername(String username) {
    	this.username = username; 
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

    
    public Ruolo getRuolo() {
    	return r;
    }
    public void setRuolo(Ruolo r) {
    	this.r = r;
    }
    
    
    public boolean isAdmin() {
    	return Ruolo.admin.equals(r);
    }
}
