<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'revisionActividad.label', default: 'RevisionActividad')}" />
        <title><g:message code="default.create.label" args="[entityName]" /></title>
    </head>
    <body>
        <div id="create-revisionActividad" class="content scaffold-create" role="main">
          <br>
    			<nav aria-label="breadcrumb">
    				<ol class="breadcrumb">
    					<li class="breadcrumb-item"><a href="${createLink(uri: '/')}">Inicio</a></li>
    					<li class="breadcrumb-item"><a href="${createLink(uri: '/actividad')}">Actividad</a></li>
    					<li class="breadcrumb-item active" aria-current="page">Revisión de actividad</li>
    				</ol>
    			</nav>
            <h1>Enviar actividad a revisión</h1>
            <g:if test="${flash.message}">
            <div class="message" role="status">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${this.revisionActividad}">
            <ul class="errors" role="alert">
                <g:eachError bean="${this.revisionActividad}" var="error">
                <li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if><g:message error="${error}"/></li>
                </g:eachError>
            </ul>
            </g:hasErrors>


            <g:if test="${revisionActividadAux!=null}">
              <div class="container">

                <div class="row">
                  <div class="clearfix col-1"></div>
                  <div class="col-10">
                    <br>
                    <g:form enctype="multipart/form-data" resource="${this.revisionActividadAux}" controller="revisionActividad"  method="PUT" action="update2">
                      <div class="form-group">
                        <label for="actividad">Actividad: </label>
                        <input value="${actividad}" type="text" name="actividad" readOnly="true" required class="form-control"/>
                        <input value="${actividad.id}" name="actividadId" type="hidden"/>
                      </div>
                      <div class="form-group">
                          <label for="revision.comentarios">Comentarios: </label>
                          <textarea class="form-control" id="revision.comentarios" rows="3" name="revision.comentarios" maxlength="1000"></textarea>
                      </div>
                      <div class="form-group">
                        <label for="revision.archivos">Archivos: </label>
                        <input type="file" class="form-control" id="revision.archivos" name="revision.archivos">
                      </div>
                      <div class="row">
                        <div class="clearfix col-4"></div>
                      <button type="submit" class="btn btn-primary col-4">Enviar a resvisión</button>
                      </div>


                    </g:form>
                  </div>
                </div>
              </div>
              %{--
                <g:form resource="${this.revisionActividadAux}" method="PUT" controller="revisionActividad" action="update2" enctype="multipart/form-data">
                <fieldset class="form">
                    %{--<f:all bean="revisionActividad"/>
                    <f:with bean="revisionActividadAux">
                        <div class="fieldcontain required">
                            <label for="">Actividad
                                <span class="required-indicator">*</span>
                            </label>
                            <g:field value="${actividad}" type="text" name="actividad" readOnly="true"/>
                            <g:field value="${actividad.id}" name="actividadId" type="hidden"/>
                        </div>
                        <f:field property="revision.comentarios"/>
                        <f:field property="revision.archivos">
                            <g:field type="file" name="revision.archivos" multiple ="true"/>
                        </f:field>
                    </f:with>
                </fieldset>
                <fieldset class="buttons">
                    <g:submitButton name="create" class="save" value="${message(code: 'default.button.create.label', default: 'Create')}" />
                </fieldset>

            </g:form>
            --}%
            </g:if>


            <g:else>
            <div class="container">

    					<div class="row">
    						<div class="clearfix col-1"></div>
    						<div class="col-10">
    							<br>
    							<g:form method="POST" enctype="multipart/form-data" action="save" controller="revisionActividad" action="save">
    								<div class="form-group">
    									<label for="actividad">Actividad: </label>
                      <input value="${actividad}" type="text" name="actividad" readOnly="true" required class="form-control"/>
                      <input value="${actividad.id}" name="actividadId" type="hidden"/>
    								</div>
    								<div class="form-group">
    								    <label for="revision.comentarios">Comentarios: </label>
    								    <textarea class="form-control" id="revision.comentarios" rows="3" name="revision.comentarios" maxlength="1000"></textarea>
    								</div>
    								<div class="form-group">
    									<label for="revision.archivos">Archivos: </label>
    									<input type="file" class="form-control" id="revision.archivos" name="revision.archivos">
    								</div>
    								<div class="row">
    									<div class="clearfix col-4"></div>
    								<button type="submit" class="btn btn-primary col-4">Crear</button>
    								</div>


    							</g:form>
    						</div>
    					</div>
    				</div>
            %{--
                <g:form resource="${this.revisionActividad}" method="POST" enctype="multipart/form-data">
                <fieldset class="form">
                    %{--<f:all bean="revisionActividad"/>
                    <f:with bean="revisionActividad">
                        <div class="fieldcontain required">
                            <label for="">Actividad
                                <span class="required-indicator">*</span>
                            </label>
                            <g:field value="${actividad}" type="text" name="actividad" readOnly="true"/>
                            <g:field value="${actividad.id}" name="actividadId" type="hidden"/>
                        </div>
                        <f:field property="revision.comentarios"/>
                        <f:field property="revision.archivos">
                            <g:field type="file" name="archivo" multiple ="true"/>
                        </f:field>
                    </f:with>
                </fieldset>
                <fieldset class="buttons">
                    <g:submitButton name="create" class="save" value="${message(code: 'default.button.create.label', default: 'Create')}" />
                </fieldset>
            </g:form>
            --}%
            </g:else>

        </div>
    </body>
</html>
