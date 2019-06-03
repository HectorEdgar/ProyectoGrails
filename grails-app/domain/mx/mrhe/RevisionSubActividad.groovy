package mx.mrhe

class RevisionSubActividad implements Serializable{

    //Revision revision
    //SubActividad subActividad
    
    static belongsTo = [revision: Revision, subActividad: SubActividad]
    String retroalimentacion
    boolean isRevisado
    static hasMany = [archivos: Archivo]
    boolean isAprobado

    static constraints = {
    	revision nullable: false
    	subActividad nullable: false
    	retroalimentacion nullable: true,maxSize: 1000
    	isRevisado nullable:true
    	archivos nullable:true
        isAprobado nullable:true
    }
}
