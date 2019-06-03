package mx.mrhe

class SubActividad implements Serializable {

    Cuenta encargado
    Cuenta creador
    static hasMany = [archivos: Archivo]


    Actividad actividad
    String nombre
    String descripcion
    Date fechaInicio
    Date fechaFinal
    Double progreso

    static constraints = {
        nombre nullable: false,maxSize: 255, minSize: 2
        encargado nullable: false
        creador nullable: true
        fechaInicio nullable: true
        fechaFinal nullable: false,min: new Date()
        progreso nullable: true
        actividad nullable:false
        archivos nullable:true
        descripcion nullable:true,maxSize: 1000
    }

    public String toString(){

    }
}
