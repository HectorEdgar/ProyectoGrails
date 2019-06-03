<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'actividad.label', default: 'Actividad')}" />
        <title><g:message code="default.edit.label" args="[entityName]" /></title>
    </head>
    <body>

        <div id="edit-actividad" class="content scaffold-edit" role="main">
          <br>
    			<nav aria-label="breadcrumb">
    				<ol class="breadcrumb">
    					<li class="breadcrumb-item"><a href="${createLink(uri: '/')}">Inicio</a></li>
    					<li class="breadcrumb-item"><a href="${createLink(uri: '/actividad')}">Actividad</a></li>
    					<li class="breadcrumb-item active" aria-current="page">Editar</li>
    				</ol>
    			</nav>
            <h1><g:message code="default.edit.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message" role="status">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${this.actividad}">
            <ul class="errors" role="alert">
                <g:eachError bean="${this.actividad}" var="error">
                <li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message error="${error}"/></li>
                </g:eachError>
            </ul>
            </g:hasErrors>
            <sec:ifAnyGranted roles="ROLE_ADMINISTRADOR,ROLE_DIRECTIVO">
            <div class="container">

              <div class="row">
                <div class="clearfix col-1"></div>
                <div class="col-10">
                  <br>
                  <g:form method="PUT" enctype="multipart/form-data" action="update" controller="actividad">
                    <div class="form-group">
                      <label for="encargado">Encargado: </label>
                      <select class="form-control" id="encargado" name="encargado" required="required">
                        <g:each in="${cuentas}">
                          <option value="${it.id}">${it.nombre}</option>
                        </g:each>
                      </select>
                    </div>
                    <div class="form-group">
                      <label for="nombre">Nombre: </label>
                      <input type="text" class="form-control" id="nombre" name="nombre" placeholder="Nombre de la actividad..." required="required" value="${actividad.nombre}">
                    </div>
                    <div class="form-group">
                        <label for="descripcion">Descripción: </label>
                        <textarea class="form-control" id="descripcion" rows="3" name="descripcion" maxlength="1000" value="${actividad.descripcion}"></textarea>
                    </div>

                    <div class="form-group">
                      <label for="fechaFinal">Fecha: </label>

                      <g:datePicker name="fechaFinal"  precision="minute" value="${new Date()}" years="${(new Date().getYear()+1900)..(new Date().getYear()+1910)}" />
                    </div>
                    <div class="form-group">
                      <label for="nombre">Archivos: </label>
                      <input type="file" class="form-control" id="archivo" name="archivo">
                    </div>
                    <div class="row">
                      <div class="clearfix col-4"></div>
                    <button type="submit" class="btn btn-primary col-4">Crear</button>
                    </div>


                  </g:form>
                </div>
              </div>
            </div>
          </sec:ifAnyGranted>
            %{--
            <g:form resource="${this.actividad}" method="PUT">
                <g:hiddenField name="version" value="${this.actividad?.version}" />
                <fieldset class="form">
                    <f:all bean="actividad" except="fechaFinal"/>
                    <f:field property="fechaFinal">
                        <g:datePicker name="fechaFinal"  precision="minute" value="${new Date()}" years="${(new Date().getYear()+1900)..(new Date().getYear()+1910)}" />
                    </f:field>
                </fieldset>
                <fieldset class="buttons">
                    <input class="save" type="submit" value="${message(code: 'default.button.update.label', default: 'Update')}" />
                </fieldset>
            </g:form>
            --}%
        </div>
    </body>
</html>
