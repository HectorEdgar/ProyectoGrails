package mx.mrhe

class Cuenta{

    String nombre
    String apellidoPaterno
    String apellidoMaterno
    Usuario usuario
    Cuenta superior

    static constraints = {
        nombre nullable: false, maxSize: 255, minSize: 2
        apellidoPaterno nullable: false,maxSize: 255, minSize: 2
        apellidoMaterno nullable: false,maxSize: 255, minSize: 2
        usuario nullable: false
        superior nullable: true
    }

    public String toString() {
      return nombre+" "+apellidoPaterno+" "+apellidoMaterno
    }

}
