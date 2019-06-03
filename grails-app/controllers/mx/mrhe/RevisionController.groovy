package mx.mrhe

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import grails.plugin.springsecurity.annotation.Secured



@Secured(['ROLE_ADMINISTRADOR','ROLE_DIRECTIVO','ROLE_TRABAJADOR','ROLE_JEFE'])
@Transactional(readOnly = false)
class RevisionController {

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond Revision.list(params), model:[revisionCount: Revision.count()]
    }

    def show(Revision revision) {
        respond revision
    }

    def create() {
        respond new Revision(params)
    }

    @Transactional
    def save(Revision revision) {
        if (revision == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (revision.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond revision.errors, view:'create'
            return
        }

        revision.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'revision.label', default: 'Revision'), revision.id])
                redirect revision
            }
            '*' { respond revision, [status: CREATED] }
        }
    }

    def edit(Revision revision) {
        respond revision
    }

    @Transactional
    def update(Revision revision) {
        if (revision == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (revision.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond revision.errors, view:'edit'
            return
        }

        revision.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'revision.label', default: 'Revision'), revision.id])
                redirect revision
            }
            '*'{ respond revision, [status: OK] }
        }
    }

    @Transactional
    def delete(Revision revision) {

        if (revision == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        revision.delete flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'revision.label', default: 'Revision'), revision.id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'revision.label', default: 'Revision'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
