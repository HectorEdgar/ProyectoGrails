package mx.mrhe

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import grails.plugin.springsecurity.annotation.Secured


@Secured(['ROLE_ADMINISTRADOR','ROLE_DIRECTIVO','ROLE_JEFE'])
@Transactional(readOnly = false)
class RevisionActividadController {

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def cuentaController
    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond RevisionActividad.list(params), model:[revisionActividadCount: RevisionActividad.count()]
    }

    def show(RevisionActividad revisionActividad) {
        respond revisionActividad
    }

    def create(Actividad actividad) {
        //println "----"+actividad
        params.actividad=actividad
        def revisionActividadAux = RevisionActividad.findByActividad(actividad)
        println revisionActividadAux
        respond new RevisionActividad(params),model:[actividad:actividad,revisionActividadAux:revisionActividadAux]
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

    @Transactional
    def save(RevisionActividad revisionActividad) {
        if (revisionActividad == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }
        cuentaController = new CuentaController()
        Actividad actividad = Actividad.findById(params.actividadId)

        def revision = new Revision(
            emisor:cuentaController.getCuenta(),
            receptor:Cuenta.findById(actividad.creador.id),
            comentarios:params.revision.comentarios
            ).save(flush:true)
        revisionActividad=null
        //Agregar archivo
        ArrayList<Archivo> archivoslist = new ArrayList<>()
        def archivos = request.getParts()
        //def archivos = request.getPart("nombre")
        for(item in archivos) {
            //println item.size()
            //println item.getSubmittedFileName()
            String fileName = ArchivoController.getFileName(item);
            if(fileName!="" && fileName=="revision.archivos") {
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
                        mapa.put("actividad",actividad)
                        mapa.put("mensaje","Los archivos deben pesar menos de 50 mb.")
                        for(archivo in archivoslist) {
                            File fileAux= new File(archivo.ubicacion)
                            fileAux.delete()
                        }
                        respond revisionActividad.errors, view:'create',model:mapa
                        return
                    }
                }
                /*
                println archivoNuevo
                println archivoNuevo.id
                println archivoNuevo.ubicacion
                println archivoNuevo.peso
                */
            }
        }
        /*
        Archivo[] arrayArchivo = new Archivo[archivoslist.size()]
        int cont=0
        for(item in archivoslist) {
            item.save flush:true
            arrayArchivo[cont++] = item
        }
        */
        //
        println archivoslist
        revisionActividad = new RevisionActividad(
            revision:revision,
            actividad:actividad,
            isRevisado:false,
            isAprobado:false,
            retroalimentacion:null,
            archivos:archivoslist
            )
          revisionActividad.archivos=archivoslist
        /*
        revisionActividad.revision=revision
        revisionActividad.actividad=actividad
        revisionActividad.isRevisado=false

        println "************"
        println params.actividadId
        println actividad
        println Cuenta.findById(actividad.creador.id)
        println "Revision"
        println revision.receptor
        println revision.emisor
        println revisionActividad.actividad
        println "************"
        */
        if (revisionActividad.hasErrors()) {
            println revisionActividad.errors
            transactionStatus.setRollbackOnly()
            respond revisionActividad.errors, view:'create'
            return
        }

        revisionActividad.save flush:true
        redirect(controller: "actividad", action: "index", params: [flash: 'Se envió actividad a revisión'])
        /*request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'revisionActividad.label', default: 'RevisionActividad'), revisionActividad.id])
                redirect revisionActividad
            }
            '*' { respond revisionActividad, [status: CREATED] }
        }
        */
    }

    def edit(RevisionActividad revisionActividad) {
        respond revisionActividad
    }

    @Transactional
    def update(int id) {
        RevisionActividad revisionActividad= RevisionActividad.findById(id)
        if (revisionActividad == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }
        Actividad actividad = Actividad.findById(params.actividadId)
        Revision revision = Revision.findById(revisionActividad.revision.id)
        //println actividad.nombre
        revisionActividad.actividad=actividad
        revisionActividad.revision=revision
        revisionActividad.isRevisado=true
        //println params.isAprobado
        //
        //
        println params.isAprobado
        if(params.isAprobado){
            revisionActividad.isAprobado=true
        }else{
            revisionActividad.isAprobado=false
            revision.comentarios=""
            revision.save(flush:true)
        }

        revisionActividad.retroalimentacion=params.retroalimentacion
        //revisionActividad.archivos=params.archivos


        /*
        revisionActividad= new RevisionActividad(
            id:revisionActividad.id,
            revision:revisionActividad.revision,
            actividad:Actividad.findById(params.actividad[1]),
            retroalimentacion:params.retroalimentacion,
            isRevisado:true,
            archivos:params.archivos,
            isAprobado:params.isAprobado
            )
        /*
        /*
        println revisionActividad.revision.id
        println revisionActividad.actividad.id
        println revisionActividad.retroalimentacion
        println revisionActividad.isRevisado
        println revisionActividad.isAprobado
        */
        //println params.revision
        flush:true

        if (revisionActividad.hasErrors()) {
            println revisionActividad.errors
            transactionStatus.setRollbackOnly()
            respond revisionActividad.errors, view:'edit'
            return
        }

        revisionActividad.save flush:true
        redirect(controller: "actividad", action: "index", params: [flash: "Se reviso la actividad"])

        /*
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'revisionActividad.label', default: 'RevisionActividad'), revisionActividad.id])
                redirect revisionActividad
            }
            '*'{ respond revisionActividad, [status: OK] }
        }
        */
    }

    @Transactional
    def update2(int id) {
        RevisionActividad revisionActividad= RevisionActividad.findById(id)
        if (revisionActividad == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }
                //Agregar archivo
        ArrayList<Archivo> archivoslist = new ArrayList<>()
        def archivos = request.getParts()
        println archivos
        //def archivos = request.getPart("nombre")
        for(item in archivos) {
            println "--"
            println item
            //println item.size()
            //println item.getSubmittedFileName()
            String fileName = ArchivoController.getFileName(item);
            println fileName
            if(fileName!="" && fileName=="revision.archivos") {
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
                    archivoNuevo.save flush:true
                    //
                    archivoslist.add(archivoNuevo)
                }
                /*
                println archivoNuevo
                println archivoNuevo.id
                println archivoNuevo.ubicacion
                println archivoNuevo.peso
                */
            }
        }
        /*
        Archivo[] arrayArchivo = new Archivo[archivoslist.size()]
        int cont=0
        println archivoslist.size()
        for(item in archivoslist) {
            println "*******"
            println item
            println arrayArchivo[cont]
            arrayArchivo[cont++] = item
        }
        */
        //
        //println actividad.nombre
        revisionActividad.revision.comentarios=params.revision.comentarios
        //revisionActividad.revision.archivos=params.revision.archivos

        revisionActividad.isRevisado=false
        //println params.isAprobado
        revisionActividad.isAprobado=false


        revisionActividad.retroalimentacion=""
        println archivoslist
        revisionActividad.archivos=archivoslist


        /*
        revisionActividad= new RevisionActividad(
            id:revisionActividad.id,
            revision:revisionActividad.revision,
            actividad:Actividad.findById(params.actividad[1]),
            retroalimentacion:params.retroalimentacion,
            isRevisado:true,
            archivos:params.archivos,
            isAprobado:params.isAprobado
            )
        /*
        /*
        println revisionActividad.revision.id
        println revisionActividad.actividad.id
        println revisionActividad.retroalimentacion
        println revisionActividad.isRevisado
        println revisionActividad.isAprobado
        */
        //println params.revision
        flush:true

        if (revisionActividad.hasErrors()) {
            println revisionActividad.errors
            transactionStatus.setRollbackOnly()
            respond revisionActividad.errors, view:'edit'
            return
        }

        revisionActividad.save flush:true
        redirect(controller: "actividad", action: "index", params: [flash: "Se reenvio la actividad a revisión"])

        /*
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'revisionActividad.label', default: 'RevisionActividad'), revisionActividad.id])
                redirect revisionActividad
            }
            '*'{ respond revisionActividad, [status: OK] }
        }
        */
    }

    @Transactional
    def delete(RevisionActividad revisionActividad) {

        if (revisionActividad == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        revisionActividad.delete flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'revisionActividad.label', default: 'RevisionActividad'), revisionActividad.id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'revisionActividad.label', default: 'RevisionActividad'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
