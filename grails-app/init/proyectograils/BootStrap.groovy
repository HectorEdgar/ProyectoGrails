package proyectograils
import mx.mrhe.*;
class BootStrap {

  def init = { servletContext ->



    def rolAdmin = new Rol(authority: 'ROLE_ADMINISTRADOR').save()
    def rolDirectivo = new Rol(authority: 'ROLE_DIRECTIVO').save()
    def rolJefe = new Rol(authority: 'ROLE_JEFE').save()
    def rolTrabajador = new Rol(authority: 'ROLE_TRABAJADOR').save()

    def usuAdmin = new Usuario(username: 'admin', password: 'admin').save()
    def usuDirectivo = new Usuario(username: 'director', password: 'director').save()
    def usuJefe = new Usuario(username: 'jefe', password: 'jefe').save()
    def usuTrabajador = new Usuario(username: 'trabajador', password: 'trabajador').save()

    UsuarioRol.create usuAdmin, rolAdmin
    UsuarioRol.create usuDirectivo, rolDirectivo
    UsuarioRol.create usuTrabajador, rolTrabajador
    UsuarioRol.create usuJefe, rolJefe

    UsuarioRol.withSession {
      it.flush()
      it.clear()
    }

    def cuentaAdmin = new Cuenta(
      nombre: "Héctor Edgar",
      apellidoPaterno: "Matias",
      apellidoMaterno: "Rodríguez",
      usuario:usuAdmin,
      superior: null
      ).save(flush:true)

    def cuentaDirectivo = new Cuenta(
      nombre: "Jair Christhian",
      apellidoPaterno: "Olmedo",
      apellidoMaterno: "Carbajal",
      usuario:usuDirectivo,
      superior:cuentaAdmin
      ).save(flush:true)

    def cuentaJefe = new Cuenta(
      nombre: "Yu Ban",
      apellidoPaterno: "Mena",
      apellidoMaterno: "Zabala",
      usuario:usuJefe,
      superior:cuentaDirectivo
      ).save(flush:true)

    def cuentaTrabajador = new Cuenta(
      nombre: "Pedro Antonio",
      apellidoPaterno: "Fernandez",
      apellidoMaterno: "Perez",
      usuario:usuTrabajador,
      superior:cuentaJefe
      ).save(flush:true)
    
    Date date= new Date();
    date.setMonth(12)
    date.setDate(20)
    def actividad = new Actividad(
      nombre:"Actividad de prueba 1",
      descripcion:"Descripción : Ma quande lingues coalesce, li grammatica del resultant lingue es plu simplic e regulari quam ti del coalescent lingues. Li nov lingua franca va esser plu simplic e regulari quam li existent Europan lingues...",
      fechaInicio: new Date(),
      fechaFinal: date,
      progreso:100,
      encargado:cuentaJefe, 
      creador:cuentaDirectivo,
      archivos:null
      ).save(flush:true)

    def subActividad1 = new SubActividad(
      nombre:"SubActividad de prueba 1",
      descripcion:"Descripción : Ma quande lingues coalesce, li grammatica del resultant lingue es plu simplic e regulari quam ti del coalescent lingues. Li nov lingua franca va esser plu simplic e regulari quam li existent Europan lingues...",
      fechaInicio: new Date(),
      fechaFinal: date,
      progreso:100,
      actividad:actividad,
      encargado:cuentaTrabajador, 
      creador:cuentaJefe,
      archivos:null
      ).save(flush:true)

    def subActividad1_2 = new SubActividad(
      nombre:"SubActividad de prueba 2",
      descripcion:"Descripción : Ma quande lingues coalesce, li grammatica del resultant lingue es plu simplic e regulari quam ti del coalescent lingues. Li nov lingua franca va esser plu simplic e regulari quam li existent Europan lingues...",
      fechaInicio: new Date(),
      fechaFinal: date,
      progreso:100,
      actividad:actividad,
      encargado:cuentaTrabajador, 
      creador:cuentaJefe,
      archivos:null
      ).save(flush:true)
    
    def revision = new Revision(
      emisor:cuentaTrabajador,
      receptor:cuentaJefe,
      archivos:null,
      comentarios:"Comentario prueba"
      ).save(flush:true)
    def revisionSubActividad = new RevisionSubActividad(
      revision:revision,
      subActividad:subActividad1,
      retroalimentacion:"Retroalimentacion de prueba",
      isRevisado:true,
      isAprobado:true,
      archivos:null
      ).save(flush:true)

      date.setMonth(10)
      date.setDate(30)
      date.setYear(118)

    def actividad2 = new Actividad(
      nombre:"Actividad de prueba 2",
      descripcion:"Descripción : Ma quande lingues coalesce, li grammatica del resultant lingue es plu simplic e regulari quam ti del coalescent lingues. Li nov lingua franca va esser plu simplic e regulari quam li existent Europan lingues...",
      fechaInicio: new Date(),
      fechaFinal: date,
      progreso:100,
      encargado:cuentaJefe, 
      creador:cuentaDirectivo,
      archivos:null
      ).save(flush:true)
    date.setMonth(12)

    for(int i=0; i<10;i++){
      date.setDate(i)
      def actAux = new Actividad(
      nombre:"Actividad de prueba"+i,
      descripcion:"Descripción : Ma quande lingues coalesce, li grammatica del resultant lingue es plu simplic e regulari quam ti del coalescent lingues. Li nov lingua franca va esser plu simplic e regulari quam li existent Europan lingues...",
      fechaInicio: new Date(),
      fechaFinal: date,
      progreso:100,
      encargado:cuentaJefe, 
      creador:cuentaDirectivo,
      archivos:null
      ).save(flush:true)
    }

      date = new Date()
      date.setYear(118)
      date.setMonth(12)
    date.setDate(29)
    def actividad3 = new Actividad(
      nombre:"Actividad de prueba 3",
      descripcion:"Descripción : Ma quande lingues coalesce, li grammatica del resultant lingue es plu simplic e regulari quam ti del coalescent lingues. Li nov lingua franca va esser plu simplic e regulari quam li existent Europan lingues...",
      fechaInicio: new Date(),
      fechaFinal: date,
      progreso:100,
      encargado:cuentaJefe, 
      creador:cuentaDirectivo,
      archivos:null
      ).save(flush:true)

  }
  def destroy = {
  }
}
