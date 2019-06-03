package mx.mrhe

class Actividad implements Serializable{

    String nombre
    String descripcion
    Date fechaInicio
    Date fechaFinal
	  Double progreso

    Cuenta encargado
    Cuenta creador
    static hasMany = [archivos: Archivo]

    static constraints = {
        nombre nullable: false ,maxSize: 255, minSize: 2
        encargado nullable: false
    	creador nullable: true
    	fechaInicio nullable: true

        fechaFinal nullable: true, min: new Date()
    	progreso nullable: true
        archivos nullable: true
        descripcion nullable:true,maxSize: 1000
    }

    public String toString(){
        return nombre
    }
}
            /*validator: { val,errors ->
                Date fechaActual= new Date()
                if(val.getYear()==fechaActual.getYear()){
                    if(act.fechaFinal.getMonth()==fechaActual.getMonth()){
                        if(act.fechaFinal.getDate()==fechaActual.getDate()){
                            if(act.fechaFinal.getHour()==fechaActual.getHour()){
                                if(act.fechaFinal.getMinute()==fechaActual.getMinute()){
                                    errors.rejectValue('fechaFinal', 'No puedes ingresar una fecha anterior a la actual')
                                }
                            }
                        }

                    return ['La fecha debe ser menor a la actual']
                    //errors.rejectValue('fechaFinal','noMatch')
                }
            }
            }*/
