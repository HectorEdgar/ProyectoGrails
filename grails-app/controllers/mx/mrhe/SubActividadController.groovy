package mx.mrhe

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import grails.plugin.springsecurity.annotation.Secured



@Secured(['ROLE_ADMINISTRADOR','ROLE_TRABAJADOR','ROLE_JEFE','ROLE_DIRECTIVO'])
@Transactional(readOnly = false)
class SubActividadController {

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]
    def cuentaController = new CuentaController();
    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        def mapa = [:]
        def subActividades=null
        def rol = cuentaController.getAuthority(cuentaController.getCuenta())
        if(rol=="ROLE_ADMINISTRADOR") {
            subActividades=SubActividad.findAll([sort:"progreso",order:"desc"])
        }else {
            if(rol=="ROLE_JEFE") {
                subActividades=SubActividad.findAllByCreador(cuentaController.getCuenta(),[sort:"progreso",order:"desc"])
            }else {
                if(rol=="ROLE_TRABAJADOR") {
                    subActividades=SubActividad.findAllByEncargado(cuentaController.getCuenta(),[sort:"progreso",order:"desc"])
                }
            }
        }
        RevisionSubActividad[] revisionSubActividades= new RevisionSubActividad[subActividades.size()]
        for(int i=0; i<subActividades.size();i++) {
            RevisionSubActividad revisionSubActividad = RevisionSubActividad.findBySubActividad(subActividades.get(i))
            if(revisionSubActividad!=null){
                revisionSubActividades[i]=revisionSubActividad
            } else {
                revisionSubActividades[i]=null
            }
        }
        mapa.put("subActividades",subActividades)
        mapa.put("revisionSubActividades",revisionSubActividades)
        mapa.put("subActividadCount", subActividades.size())
        respond SubActividad.list(params), model:mapa
        //respond SubActividad.list(params), model:[]
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
    def verSubActividades(int id) {
        def mapa = [:]
        def subActividades=null
        def rol = cuentaController.getAuthority(cuentaController.getCuenta())
        def actividad = Actividad.findById(id)
        subActividades=SubActividad.findAllByActividad(actividad)

        RevisionSubActividad[] revisionSubActividades= new RevisionSubActividad[subActividades.size()]
        for(int i=0; i<subActividades.size();i++) {
            RevisionSubActividad revisionSubActividad = RevisionSubActividad.findBySubActividad(subActividades.get(i))
            if(revisionSubActividad!=null){
                revisionSubActividades[i]=revisionSubActividad
            } else {
                revisionSubActividades[i]=null
            }
        }
        mapa.put("subActividades",subActividades)
        mapa.put("revisionSubActividades",revisionSubActividades)

        respond SubActividad.list(params), model:mapa
        //respond SubActividad.list(params), model:[]
    }

    def show(SubActividad subActividad) {
        respond subActividad
    }
    public ArrayList<Cuenta> getListaCuentas(){
        def rol = Rol.findByAuthority("ROLE_TRABAJADOR")
        def usuarioRol = UsuarioRol.findAllByRol(rol)
        def listaCuentas = new ArrayList<Cuenta>()
        def rolCuenta=cuentaController.getAuthority(cuentaController.getCuenta())
        if(rolCuenta=="ROLE_JEFE") {
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
    public ArrayList<Actividad> getListaActividades(){
        def revisionActividades = RevisionActividad.findAllByIsAprobado(true);
        def actividades = Actividad.findAllByEncargado(cuentaController.getCuenta())
        def listaActividades=new ArrayList<Actividad>()
        for(item in actividades) {
            boolean bandera =false
            for(item2 in revisionActividades) {
                if (item.id==item2.actividad.id) {
                    bandera =true
                    break;
                }
            }
            if(!bandera){
                listaActividades.add(item)
            }
        }
        return listaActividades
    }
    def create() {
        def mapa=[:]
        mapa.put("actividades",getListaActividades())
        mapa.put("cuentas",getListaCuentas())
        respond new SubActividad(params),model:mapa
        //respond new SubActividad(params)
    }

    @Transactional
    def save(SubActividad subActividad) {
        subActividad= new SubActividad(
            encargado:Cuenta.findById(params.encargado),
            creador:cuentaController.getCuenta(),
            archivos:null,
            actividad:Actividad.findById(params.actividad),
            nombre:params.nombre,
            descripcion:params.descripcion,
            fechaInicio:new Date(),
            fechaFinal: params.fechaFinal,
            progreso:100.0
            )
        if (subActividad == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (subActividad.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond subActividad.errors, view:'create'
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
                    if(archivoNuevo.hasErrors()){
                        transactionStatus.setRollbackOnly()
                        def mapa=[:]
                        mapa.put("actividades",getListaActividades())
                        mapa.put("cuentas",getListaCuentas())
                        mapa.put("mensaje","Los archivos deben pesar menos de 50 mb.")
                        for(archivo in archivoslist) {
                            File fileAux= new File(archivo.ubicacion)
                            fileAux.delete()
                        }
                        respond subActividad.errors, view:'create',model:mapa
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
        
        subActividad.archivos=arrayArchivo
        */
        subActividad.archivos=archivoslist
        subActividad.save flush:true
        redirect(controller: "subActividad", action: "index", params: [flash: "Se agrego SubActividad"])
        /*
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'subActividad.label', default: 'SubActividad'), subActividad.id])
                redirect subActividad
            }
            '*' { respond subActividad, [status: CREATED] }
        }
        */
    }

    def edit(SubActividad subActividad) {
        respond subActividad
    }

    @Transactional
    def update(SubActividad subActividad) {
        if (subActividad == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (subActividad.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond subActividad.errors, view:'edit'
            return
        }

        subActividad.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'subActividad.label', default: 'SubActividad'), subActividad.id])
                redirect subActividad
            }
            '*'{ respond subActividad, [status: OK] }
        }
    }

    @Transactional
    def delete(SubActividad subActividad) {

        if (subActividad == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }
        def revisiones=RevisionSubActividad.findAllBySubActividad(subActividad)
        
        for (element in revisiones) {
            element.delete flush:true
        }
        

        subActividad.delete flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'subActividad.label', default: 'SubActividad'), subActividad.id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'subActividad.label', default: 'SubActividad'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
