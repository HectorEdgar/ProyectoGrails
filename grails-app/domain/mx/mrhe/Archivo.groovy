package mx.mrhe

class Archivo implements Serializable{

    String nombre
    String ubicacion
    Double peso

    static constraints = {	
    	nombre nullable: false,maxSize: 255
    	ubicacion nullable: false,maxSize: 255
    	peso nullable: false, max:new Double(50000.0)
    }

    public String toString(){
    	return nombre
    }
}
