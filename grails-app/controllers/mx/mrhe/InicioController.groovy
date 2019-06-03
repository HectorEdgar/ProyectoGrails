package mx.mrhe

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import grails.plugin.springsecurity.annotation.Secured
import grails.plugin.springsecurity.SpringSecurityService
import grails.plugin.springsecurity.SecurityTagLib

@Secured("permitAll")
@Transactional(readOnly = false)
class InicioController {

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]
    def cuentaController
    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        def mapa = [:]//Definir un LinkedHashMap
        cuentaController = new CuentaController()
        def cuenta = cuentaController.getCuenta();
        if(cuenta!=null){
            def rol = cuentaController.getAuthority(cuentaController.getCuenta())
            if(rol=="ROLE_ADMINISTRADOR") {
                redirect(controller:"actividad",action:"index")
            }else {
                if(rol=="ROLE_DIRECTIVO") {
                    redirect(controller:"actividad",action:"index")
                }else {
                    if(rol=="ROLE_JEFE") {
                        redirect(controller:"actividad",action:"index")
                    }else {
                        redirect(controller:"subActividad",action:"index")
                    }
                }
            }
        }
        
        /*def results = Actividad.findAll {
            fechaFinal <= new Date()
        }
        */
       /*
        mapa.put("results",results)
        */
       
        mapa.put("cuenta",cuenta)

        respond Inicio.list(params), model:mapa
        //respond Inicio.list(params), model:[inicioCount: Inicio.count()]
    }
    
    def show(Inicio inicio) {
        respond inicio
    }

    def create() {
        respond new Inicio(params)
    }

    @Transactional
    def save(Inicio inicio) {
        if (inicio == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (inicio.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond inicio.errors, view:'create'
            return
        }

        inicio.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'inicio.label', default: 'Inicio'), inicio.id])
                redirect inicio
            }
            '*' { respond inicio, [status: CREATED] }
        }
    }

    def edit(Inicio inicio) {
        respond inicio
    }

    @Transactional
    def update(Inicio inicio) {
        if (inicio == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (inicio.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond inicio.errors, view:'edit'
            return
        }

        inicio.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'inicio.label', default: 'Inicio'), inicio.id])
                redirect inicio
            }
            '*'{ respond inicio, [status: OK] }
        }
    }

    @Transactional
    def delete(Inicio inicio) {

        if (inicio == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        inicio.delete flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'inicio.label', default: 'Inicio'), inicio.id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'inicio.label', default: 'Inicio'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
