<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'cuenta.label', default: 'Cuenta')}" />
        <title><g:message code="default.create.label" args="[entityName]" /></title>
    </head>
    <body>
        
        <div id="create-cuenta" class="content scaffold-create" role="main">
        <br>
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item">
                    <a href="${createLink(uri: '/')}">Inicio</a>
                </li>
                <li class="breadcrumb-item">
                    <a href="${createLink(uri: '/cuenta')}">Cuenta</a>
                </li>
                <li class="breadcrumb-item active" aria-current="page">Crear</li>
            </ol>
        </nav>
            <h1><g:message code="default.create.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message" role="status">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${this.cuenta}">
            <ul class="errors" role="alert">
                <g:eachError bean="${this.cuenta}" var="error">
                <li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message error="${error}"/></li>
                </g:eachError>
            </ul>
            </g:hasErrors>
            <sec:ifAnyGranted roles="ROLE_ADMINISTRADOR,ROLE_DIRECTIVO,ROLE_JEFE">
                <div class="container">
                    <div class="row">
                        
                        <div class="col-1"></div>
                        <g:form resource="${this.cuenta}" method="POST" class="col-10">
                            <div class="form-group">
                                <label for="nombre">Nombre: </label>
                                <input type="text" class="form-control" id="nombre" name="nombre" placeholder="Nombre..." required>
                            </div>
                            <div class="form-group">
                                <label for="apellidoPaterno">Apellido paterno: </label>
                                <input type="text" name="apellidoPaterno" class="form-control" id="apellidoPaterno" placeholder="Apelido paterno..." required>
                            </div>
                            <div class="form-group">
                                <label for="apellidoMaterno">Apellido Materno: </label>
                                <input type="text" name="apellidoMaterno" class="form-control" id="apellidoMaterno" placeholder="Apellido materno..." required>
                            </div>
                            <div class="form-group">
                                <label for="usuario.username">Usuario: </label>
                                <input type="text" name="usuario.username" class="form-control" id="usuario.username" placeholder="Usuario..." required>
                            </div>
                            <div class="form-group">
                                <label for="usuario.password">Contrseña: </label>
                                <input type="text" name="usuario.password" class="form-control" id="usuario.password" placeholder="******" required>
                            </div>
                            <div class="form-group">
                                <label for="usuario.rol">Rol: </label>
                                <sec:ifAnyGranted roles="ROLE_JEFE">
                                    <input type="text" name="usuario.rol" class="form-control" value="ROLE_TRABAJADOR" id="usuario.rol" required readonly>
                                </sec:ifAnyGranted>
                                 <sec:ifAnyGranted roles="ROLE_DIRECTIVO">
                                    <input type="text" name="usuario.rol" class="form-control" value="ROLE_JEFE" id="usuario.rol" required readonly>
                                </sec:ifAnyGranted>
                                
                                <sec:ifAnyGranted roles="ROLE_ADMINISTRADOR">
                                    <select class="form-control" id="usuario.rol" name="usuario.rol" required="required">
										<g:each in="${roles}">
											<option value="${it.authority}">${it}</option>
										</g:each>
									</select>
                                   
                                </sec:ifAnyGranted>
                                
                            </div>
                            
                            <button type="submit" class="btn btn-primary">Submit</button>
                        </g:form>
                    </div>
                </div>
            %{--
                <g:form resource="${this.cuenta}" method="POST">
                    <fieldset class="form">
                         <f:all bean="cuenta"/> 
                        <f:with bean="cuenta">
                            <f:field property="nombre"/>
                            <f:field property="apellidoPaterno"/>
                            <f:field property="apellidoMaterno"/>
                            <f:field property="usuario.username"/>
                            <f:field property="usuario.password"/>
                            <div class="fieldcontain required">
                                <label for="">Rol
                                    <span class="required-indicator">*</span>
                                </label>
                                
                                
                                <sec:ifAnyGranted roles="ROLE_JEFE">
                                    <g:field name="usuario.rol"  value="ROLE_TRABAJADOR" readonly="readonly"/>
                                </sec:ifAnyGranted>
                                 <sec:ifAnyGranted roles="ROLE_DIRECTIVO">
                                    <g:field name="usuario.rol"  value="ROLE_JEFE" readonly="readonly"/>
                                </sec:ifAnyGranted>
                                
                                <sec:ifAnyGranted roles="ROLE_ADMINISTRADOR">
                                    <g:select name="usuario.rol" from="${roles}"
                                        optionValue="authority">
                                    </g:select>
                                </sec:ifAnyGranted>
                            </div>
                        </f:with>                        
                    </fieldset>
                    <fieldset class="buttons">
                        <g:submitButton name="create" class="save" value="${message(code: 'default.button.create.label', default: 'Create')}" />
                    </fieldset>
                </g:form>
 --}%
            </sec:ifAnyGranted>
            
            
        </div>
    </body>
</html>
