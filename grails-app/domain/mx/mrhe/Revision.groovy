package mx.mrhe

class Revision {

    Cuenta emisor
    Cuenta receptor
    static hasMany = [archivos: Archivo]
    String comentarios

    static constraints = {
    	emisor nullable: true
    	receptor nullable: true
    	archivos nullable: true
    	comentarios nullable: true,maxSize: 1000
    }
}
