package mx.mrhe

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import grails.plugin.springsecurity.annotation.Secured
import grails.plugin.springsecurity.SpringSecurityService
import grails.plugin.springsecurity.SecurityTagLib


@Secured(['ROLE_ADMINISTRADOR','ROLE_DIRECTIVO','ROLE_JEFE','ROLE_TRABAJADOR'])
@Transactional(readOnly = false)
class CuentaController {

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def springSecurityService
    def cuenta
    def getCuenta() {
        springSecurityService = new SpringSecurityService()
        
        /*
        def usuario = springSecurityService.isLoggedIn() ? springSecurityService.loadCurrentUser() : null
        Cuenta cuenta=null
        if (usuario) {
            cuenta = Cuenta.findByUsuario(usuario)
            println cuenta
        }
        return cuenta
        def principal = springSecurityService.principal
        String username = principal.username
        def authorities = principal.authorities // a Collection of GrantedAuthority
        boolean enabled = principal.enabled
        */
        def principal = springSecurityService.principal
        if (principal.enabled) {
            //println principal.username
            //println principal.id
            def usuario =Usuario.findById(principal.id)
            //println usuario.username
            //println Cuenta.findAll()
            cuenta = Cuenta.findByUsuario(usuario)
            //println cuenta
        }
        return cuenta
    }

    def getAuthority(Cuenta cuenta) {
        def usuarioRol=UsuarioRol.findByUsuario(cuenta.usuario)
        return usuarioRol.rol.authority
    }
    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        def mapa=[:]
        def cuentas
        def rol = getAuthority(getCuenta())
        if(rol=="ROLE_ADMINISTRADOR"){
            cuentas=Cuenta.findAll();
        }else {
            if(rol=="ROLE_JEFE" || rol=="ROLE_DIRECTIVO") {
                cuentas=Cuenta.findAllBySuperior(getCuenta())
            }
        }
        mapa.put("cuentas",cuentas)
        respond Cuenta.list(params), model:mapa
    }

    def show(Cuenta cuenta) {
        respond cuenta
    }

    def create() {
        def mapa = [:]//Definir un LinkedHashMap
        //println Rol.findAll()
        mapa.put("roles",Rol.findAll())
        respond new Cuenta(params),model:mapa
    }

    @Transactional
    def save(Cuenta cuenta) {
        if (cuenta == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }
        def usuario =  new Usuario(username: params.usuario.username, password: params.usuario.password).save(flush:true)
        def rol= Rol.findByAuthority(params.usuario.rol)
        //println rol.authority
        UsuarioRol.create usuario, rol
        UsuarioRol.withSession {
            it.flush()
            it.clear()
        }
        cuenta.usuario=usuario
        cuenta.superior=getCuenta()

        if (cuenta.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond cuenta.errors, view:'create'
            return
        }

        cuenta.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'cuenta.label', default: 'Cuenta'), cuenta.id])
                redirect cuenta
            }
            '*' { respond cuenta, [status: CREATED] }
        }
    }

    @Transactional
    def saveTrabajador(Cuenta cuenta) {
        if (cuenta == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }
        def usuario =  new Usuario(username: params.usuario.username, password: params.usuario.password).save(flush:true)
        def rol= Rol.findByAuthority(params.usuario.rol)
        //println rol.authority
        UsuarioRol.create usuario, rol
        UsuarioRol.withSession {
            it.flush()
            it.clear()
        }
        cuenta.usuario=usuario

        if (cuenta.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond cuenta.errors, view:'create'
            return
        }

        cuenta.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'cuenta.label', default: 'Cuenta'), cuenta.id])
                redirect cuenta
            }
            '*' { respond cuenta, [status: CREATED] }
        }
    }


    def edit(Cuenta cuenta) {
        respond cuenta
    }

    @Transactional
    def update(Cuenta cuenta) {
        if (cuenta == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (cuenta.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond cuenta.errors, view:'edit'
            return
        }

        cuenta.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'cuenta.label', default: 'Cuenta'), cuenta.id])
                redirect cuenta
            }
            '*'{ respond cuenta, [status: OK] }
        }
    }

    @Transactional
    def delete(Cuenta cuenta) {

        if (cuenta == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        cuenta.delete flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'cuenta.label', default: 'Cuenta'), cuenta.id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'cuenta.label', default: 'Cuenta'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
