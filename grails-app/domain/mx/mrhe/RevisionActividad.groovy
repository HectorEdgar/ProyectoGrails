package mx.mrhe

class RevisionActividad implements Serializable{

    //Revision revision
    //Actividad actividad
    static belongsTo = [actividad: Actividad, revision: Revision]
    String retroalimentacion
    boolean isRevisado
    static hasMany = [archivos: Archivo]
    boolean isAprobado

    static constraints = {
    	revision nullable: false
    	actividad nullable: false
    	retroalimentacion nullable: true,maxSize: 1000
    	isRevisado nullable:true
    	archivos nullable:true
        isAprobado nullable:true
    }
}
