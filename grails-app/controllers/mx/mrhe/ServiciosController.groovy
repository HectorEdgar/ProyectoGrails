package mx.mrhe

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import grails.plugin.springsecurity.annotation.Secured



@Secured(['ROLE_ADMINISTRADOR','ROLE_DIRECTIVO','ROLE_JEFE'])
@Transactional(readOnly = false)
class ServiciosController {

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond Servicios.list(params), model:[serviciosCount: Servicios.count()]
    }

    def show(Servicios servicios) {
        respond servicios
    }

    def create() {
        respond new Servicios(params)
    }

    @Transactional
    def save(Servicios servicios) {
        if (servicios == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (servicios.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond servicios.errors, view:'create'
            return
        }

        servicios.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'servicios.label', default: 'Servicios'), servicios.id])
                redirect servicios
            }
            '*' { respond servicios, [status: CREATED] }
        }
    }

    def edit(Servicios servicios) {
        respond servicios
    }

    @Transactional
    def update(Servicios servicios) {
        if (servicios == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (servicios.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond servicios.errors, view:'edit'
            return
        }

        servicios.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'servicios.label', default: 'Servicios'), servicios.id])
                redirect servicios
            }
            '*'{ respond servicios, [status: OK] }
        }
    }

    @Transactional
    def delete(Servicios servicios) {

        if (servicios == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        servicios.delete flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'servicios.label', default: 'Servicios'), servicios.id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'servicios.label', default: 'Servicios'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
