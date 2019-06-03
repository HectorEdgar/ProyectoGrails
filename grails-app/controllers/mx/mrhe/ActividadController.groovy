package mx.mrhe

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import grails.plugin.springsecurity.annotation.Secured

import grails.converters.JSON
import javax.servlet.MultipartConfigElement
import javax.servlet.*
import java.io.*
import javax.servlet.http.*

import mx.mrhe.*

@Secured(['ROLE_ADMINISTRADOR','ROLE_DIRECTIVO','ROLE_JEFE','ROLE_TRABAJADOR'])
@Transactional(readOnly = false)
class ActividadController {

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]
    def cuentaController

    def actualizarProgresoActividades() {
        ArrayList<ActividadController> actividades = Actividad.findAll();
        for(actividad in actividades){
            ArrayList<SubActividad> subActividades=SubActividad.findAllByActividad(actividad)
            if(subActividades.size()!=0){
                ArrayList<RevisionSubActividad> revisionesSubActividades = new ArrayList<RevisionSubActividad>()
                for(subActividad in subActividades){
                    RevisionSubActividad revisionSubActividad=RevisionSubActividad.findBySubActividadAndIsAprobado(subActividad,true)
                    if(revisionSubActividad!=null){
                        revisionesSubActividades.add(revisionSubActividad)
                    }
                }
                
                Double progreso
                progreso=(revisionesSubActividades.size()*100)/subActividades.size()
                actividad.progreso=progreso
                actividad.save(flush:true)
            }else{
                actividad.progreso=100.0
                actividad.save(flush:true)
            }
        }
    }

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        def mapa = [:]
        actualizarProgresoActividades()
        def actividades=null
        cuentaController = new CuentaController()
        def rol = cuentaController.getAuthority(cuentaController.getCuenta())
        if(rol=="ROLE_ADMINISTRADOR") {
            actividades=Actividad.findAll([max:params.max,sort:"fechaFinal",order:"asc",offset: params.offset])
            mapa.put("actividadCount",Actividad.findAll().size())
        }else {
            if(rol=="ROLE_DIRECTIVO") {

                actividades=Actividad.findAllByCreador(cuentaController.getCuenta(),[max:params.max,sort:"fechaFinal",order:"asc",offset: params.offset])
                mapa.put("actividadCount",Actividad.findAllByCreador(cuentaController.getCuenta()).size())
            }else {
                if(rol=="ROLE_JEFE") {
                    actividades=Actividad.findAllByEncargado(cuentaController.getCuenta(),[max:params.max,sort:"fechaFinal",order:"asc",offset: params.offset])
                    mapa.put("actividadCount",Actividad.findAllByEncargado(cuentaController.getCuenta()).size())
                }
            }
        }
        RevisionActividad[] revisionActividades= new RevisionActividad[actividades.size()]
        int[] subActividades = new int[actividades.size()]
        for(int i=0; i<actividades.size();i++) {
            RevisionActividad revisionActividad = RevisionActividad.findByActividad(actividades.get(i))
            if(revisionActividad!=null) {
                revisionActividades[i]=revisionActividad
            } else {
                revisionActividades[i]=null
            }
            ArrayList<SubActividad> subActividadesAux = SubActividad.findAllByActividad(actividades.get(i))
            if(subActividadesAux != null) {
                subActividades[i]=subActividadesAux.size()
            }else {
                subActividades[i]=0
            }
        }

        /*
        if(rol=="ROLE_ADMINISTRADOR") {

        }else {
            if(rol=="ROLE_DIRECTIVO") {
                def actividadesTerminadas=Actividad.findAllByCreadorAndProgreso(cuentaController.getCuenta(),100)

                for(element in actividadesTerminadas) {
                    println actividadesTerminadas.nombre
                }

            } else {

                if(rol=="ROLE_JEFE") {
                    def actividadesTerminadas=Actividad.findAllByEncargadoAndProgreso(cuentaController.getCuenta(),100)

                    for(element in actividadesTerminadas) {
                        //println element.nombre
                        if(RevisionActividad.findByActividad(element)){
                            println element.nombre
                            actividadesTerminadas.remove(element)
                        }
                    }
                }
            }
        }
        */

        mapa.put("actividades",actividades)
        mapa.put("revisionActividades",revisionActividades)
        mapa.put("subActividades",subActividades)



        respond Actividad.list(params), model:mapa
    }

    def show(Actividad actividad) {
        respond actividad
    }

    def descargarArchivo(String ubicacion) {
        def file = new File(ubicacion);

        if (file.exists()) {
           response.setContentType("application/octet-stream")
           response.setHeader("Content-disposition", "filename=${file.name}")
           response.outputStream << file.bytes
           return
       }
    }

    public ArrayList<Cuenta> getListaCuentas(){
        def rol = Rol.findByAuthority("ROLE_JEFE")
        def usuarioRol = UsuarioRol.findAllByRol(rol)
        def listaCuentas = new ArrayList<Cuenta>()
        cuentaController = new CuentaController()
        def rolCuenta=cuentaController.getAuthority(cuentaController.getCuenta())
        if(rolCuenta=="ROLE_DIRECTIVO") {
            for(item in usuarioRol){
            def cuenta=Cuenta.findByUsuarioAndSuperior(item.usuario,cuentaController.getCuenta())
                if(cuenta!=null) {
                    listaCuentas.add(cuenta)
                }
            }
        }else{
            if(rolCuenta=="ROLE_ADMINISTRADOR") {
                listaCuentas = Cuenta.findAll()
            }
        }
        return listaCuentas
    }

    def create() {
        def mapa=[:]
        mapa.put("cuentas",getListaCuentas())
        respond new Actividad(params),model:mapa
    }

    @Transactional
    def save(Actividad actividad) {

        if (actividad == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }
        CuentaController cuentaController = new CuentaController()
        actividad.fechaInicio= new Date()
        actividad.progreso=0.0
        actividad.creador=cuentaController.getCuenta()
        //Agregar archivo
        if (actividad.hasErrors()) {
            transactionStatus.setRollbackOnly()
            def mapa=[:]
            mapa.put("cuentas",getListaCuentas())
            respond actividad.errors, view:'create',model:mapa
            return
        }

        ArrayList<Archivo> archivoslist = new ArrayList<>()
        def archivos = request.getParts()
        for(item in archivos) {
            String fileName = ArchivoController.getFileName(item);
            if(fileName!="" && fileName=="archivo") {
                println fileName
                String ubicacion = request.getServletContext().getRealPath("/")+"archivosUsuarios"
                println ubicacion
                def storagePathDirectory = new File(ubicacion)

                if (!storagePathDirectory.exists()) {
                    storagePathDirectory.mkdirs()
                }
                InputStream is = item.getInputStream();
                if (item.getSubmittedFileName()!="") {
                    String ruta = request.getServletContext().getRealPath("/") + "archivosUsuarios" + "/" + item.getSubmittedFileName();
                    FileOutputStream fos = new FileOutputStream(new File(ruta));
                    int dato = is.read();
                    while (dato != -1) {
                        fos.write(dato);
                        dato = is.read();
                    }
                    fos.close();
                    is.close();
                    File file = new File(ruta)
                    Double peso=file.length()/1024
                    Archivo archivoNuevo = new Archivo(
                        nombre: item.getSubmittedFileName(),
                        ubicacion: ruta,
                        peso: peso
                        )
                    archivoslist.add(archivoNuevo)
                    archivoNuevo.validate()
                    if(archivoNuevo.hasErrors()){
                        transactionStatus.setRollbackOnly()
                        def mapa=[:]
                        mapa.put("cuentas",getListaCuentas())
                        mapa.put("mensaje","Los archivos deben pesar menos de 50 mb.")
                        for(archivo in archivoslist) {
                            File fileAux= new File(archivo.ubicacion)
                            fileAux.delete()
                        }
                        respond actividad.errors, view:'create',model:mapa
                        return
                    }
                }
            }
        }
        /*
        Archivo[] arrayArchivo = new Archivo[archivoslist.size()]
        int cont=0
        for(item in archivoslist) {
            item.save flush:true
            arrayArchivo[cont++] = item
        }
        //

        actividad.archivos=arrayArchivo
        */
        actividad.archivos=archivoslist
        actividad.save flush:true
        redirect(controller: "actividad", action: "index", params: [flash: "Se agrego actividad"])
        /*
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'actividad.label', default: 'Actividad'), actividad.id])
                redirect actividad
            }
            '*' { respond actividad, [status: CREATED] }
        }
        */
    }



    def edit(Actividad actividad) {
      def mapa=[:]
      mapa.put("cuentas",getListaCuentas())
      respond actividad,model:mapa
      //respond actividad
    }

    @Transactional
    def update(Actividad actividad) {
        if (actividad == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (actividad.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond actividad.errors, view:'edit'
            return
        }

        actividad.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'actividad.label', default: 'Actividad'), actividad.id])
                redirect actividad
            }
            '*'{ respond actividad, [status: OK] }
        }
    }

    @Transactional
    def delete(Actividad actividad) {

        if (actividad == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }
        def revisiones=RevisionActividad.findAllByActividad(actividad)
        def subactividades=SubActividad.findAllByActividad(actividad)
        for (element in revisiones) {
            element.delete flush:true
        }
        for (element in subactividades) {
            element.delete flush:true
        }

        actividad.delete flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'actividad.label', default: 'Actividad'), actividad.id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'actividad.label', default: 'Actividad'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
