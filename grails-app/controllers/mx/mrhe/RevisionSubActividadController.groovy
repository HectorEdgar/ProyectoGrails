package mx.mrhe

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import grails.plugin.springsecurity.annotation.Secured



@Secured(['ROLE_ADMINISTRADOR','ROLE_DIRECTIVO','ROLE_JEFE','ROLE_TRABAJADOR'])
@Transactional(readOnly = false)
class RevisionSubActividadController {

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]
    def cuentaController
    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond RevisionSubActividad.list(params), model:[revisionSubActividadCount: RevisionSubActividad.count()]
    }

    def show(RevisionSubActividad revisionSubActividad) {
        respond revisionSubActividad
    }

    def create(SubActividad subActividad) {
        //println "----"
        //println id
        //SubActividad subActividad = SubActividad.findById(id)
        //println subActividad.id
        //println subActividad.nombre
        params.subActividad=subActividad
        def revisionSubActividadAux = RevisionSubActividad.findBySubActividad(subActividad)
        //println revisionSubActividadAux
        respond new RevisionSubActividad(params),model:[subActividad:subActividad,revisionSubActividadAux:revisionSubActividadAux]
        //respond new RevisionSubActividad(params)
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
    def save(RevisionSubActividad revisionSubActividad) {
        if (revisionSubActividad == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }
        cuentaController = new CuentaController()
        SubActividad subActividad = SubActividad.findById(params.subActividadId)

        def revision = new Revision(
            emisor:cuentaController.getCuenta(),
            receptor:Cuenta.findById(subActividad.creador.id),
            comentarios:params.revision.comentarios
            ).save(flush:true)
        revisionSubActividad=null
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
                        mapa.put("subActividad",subActividad)
                        mapa.put("mensaje","Los archivos deben pesar menos de 50 mb.")
                        for(archivo in archivoslist) {
                            File fileAux= new File(archivo.ubicacion)
                            fileAux.delete()
                        }
                        respond revisionSubActividad.errors, view:'create',model:mapa
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
        */
        //
        revisionSubActividad = new RevisionSubActividad(
            revision:revision,
            subActividad:subActividad,
            isRevisado:false,
            isAprobado:false,
            retroalimentacion:null,
            archivos:archivoslist
            )
        if (revisionSubActividad.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond revisionSubActividad.errors, view:'create'
            return
        }

        revisionSubActividad.save flush:true
        redirect(controller: "subActividad", action: "index", params: [flash: 'Se envió SubActividad a revisión'])
        /*
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'revisionSubActividad.label', default: 'RevisionSubActividad'), revisionSubActividad.id])
                redirect revisionSubActividad
            }
            '*' { respond revisionSubActividad, [status: CREATED] }
        }
        */
    }

    def edit(RevisionSubActividad revisionSubActividad) {
        respond revisionSubActividad
    }

    @Transactional
    def update(int id) {
        RevisionSubActividad revisionSubActividad= RevisionSubActividad.findById(id)
        if (revisionSubActividad == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }
        SubActividad subActividad = SubActividad.findById(params.subActividadId)
        Revision revision = Revision.findById(revisionSubActividad.revision.id)
        //println actividad.nombre

        //println params.isAprobado
        if(params.isAprobado){
            revisionSubActividad.isAprobado=true
        }else{
            revisionSubActividad.isAprobado=false
            revision.comentarios=""
            revision.save(flush:true)
        }
        revisionSubActividad.subActividad=subActividad
        revisionSubActividad.revision=revision
        revisionSubActividad.isRevisado=true

        revisionSubActividad.retroalimentacion=params.retroalimentacion
        revisionSubActividad.archivos=params.archivos

        if (revisionSubActividad.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond revisionSubActividad.errors, view:'edit'
            return
        }

        revisionSubActividad.save flush:true
        redirect(controller: "subActividad", action: "index", params: [flash: "Se reviso la SubActividad"])
        /*
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'revisionSubActividad.label', default: 'RevisionSubActividad'), revisionSubActividad.id])
                redirect revisionSubActividad
            }
            '*'{ respond revisionSubActividad, [status: OK] }
        }*/
    }

    @Transactional
    def update2(int id) {
        RevisionSubActividad revisionSubActividad= RevisionSubActividad.findById(id)
        if (revisionSubActividad == null) {
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
        Archivo[] arrayArchivo = new Archivo[archivoslist.size()]
        int cont=0
        println archivoslist.size()
        for(item in archivoslist) {
            println "*******"
            println item
            println arrayArchivo[cont]
            arrayArchivo[cont++] = item

        }
        //
        revisionSubActividad.revision.comentarios=params.revision.comentarios
        //revisionSubActividad.revision.archivos=params.revision.archivos

        revisionSubActividad.isRevisado=false
        revisionSubActividad.isAprobado=false
        revisionSubActividad.retroalimentacion=""
        revisionSubActividad.archivos=arrayArchivo

        revisionSubActividad.save flush:true
        redirect(controller: "subActividad", action: "index", params: [flash: "Se reenvio la subActividad a revisión"])
        /*
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'revisionSubActividad.label', default: 'RevisionSubActividad'), revisionSubActividad.id])
                redirect revisionSubActividad
            }
            '*'{ respond revisionSubActividad, [status: OK] }
        }*/
    }


    @Transactional
    def delete(RevisionSubActividad revisionSubActividad) {

        if (revisionSubActividad == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        revisionSubActividad.delete flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'revisionSubActividad.label', default: 'RevisionSubActividad'), revisionSubActividad.id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'revisionSubActividad.label', default: 'RevisionSubActividad'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
