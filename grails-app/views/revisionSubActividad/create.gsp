<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'revisionSubActividad.label', default: 'RevisionSubActividad')}" />
        <title><g:message code="default.create.label" args="[entityName]" /></title>
    </head>
    <body>

        <div id="create-revisionSubActividad" class="content scaffold-create" role="main">
          <br>
          <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
              <li class="breadcrumb-item"><a href="${createLink(uri: '/')}">Inicio</a></li>
              <li class="breadcrumb-item"><a href="${createLink(uri: '/subActividad')}">Sub-Actividad</a></li>
              <li class="breadcrumb-item active" aria-current="page">Revisión de sub-actividad</li>
            </ol>
          </nav>
            <h1><g:message code="default.create.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message" role="status">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${this.revisionSubActividad}">
            <ul class="errors" role="alert">
                <g:eachError bean="${this.revisionSubActividad}" var="error">
                <li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message error="${error}"/></li>
                </g:eachError>
            </ul>
            </g:hasErrors>


            <g:if test="${revisionSubActividadAux!=null}">
              <div class="container">

                <div class="row">
                  <div class="clearfix col-1"></div>
                  <div class="col-10">
                    <br>
                    <g:form enctype="multipart/form-data" resource="${this.revisionSubActividadAux}" controller="revisionSubActividad"  method="PUT" action="update2">
                      <div class="form-group">
                        <label for="subActividad">Sub-actividad: </label>
                        <input value="${subActividad.nombre}" type="text" name="subActividad" readOnly="true" required class="form-control"/>
                        <input value="${subActividad.id}" name="subActividadId" type="hidden"/>
                      </div>
                      <div class="form-group">
                          <label for="revision.comentarios">Comentarios: </label>
                          <textarea class="form-control" id="revision.comentarios" rows="3" name="revision.comentarios" maxlength="1000">${revision?.comentarios}</textarea>
                      </div>
                      <div class="form-group">
                        <label for="revision.archivos">Archivos: </label>
                        <input type="file" class="form-control" id="revision.archivos" name="revision.archivos">
                      </div>
                      <div class="row">
                        <div class="clearfix col-4"></div>
                      <button type="submit" class="btn btn-primary col-4">Enviar a revisión</button>
                      </div>


                    </g:form>
                  </div>
                </div>
              </div>
                %{--
                <g:form resource="${this.revisionSubActividad}" method="PUT" controller="revisionSubActividad" action="update2" enctype="multipart/form-data">
                <fieldset class="form">
                  <f:all bean="revisionActividad"/>
                    <f:with bean="revisionSubActividadAux">
                        <div class="fieldcontain required">
                            <label for="">SubActividad
                                <span class="required-indicator">*</span>
                            </label>
                            <g:field value="${subActividad.nombre}" type="text" name="subActividad" readOnly="true"/>
                            <g:field value="${subActividad.id}" name="subActividadId" type="hidden"/>
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
            </g:if>


            <g:else>
            <div class="container">

              <div class="row">
                <div class="clearfix col-1"></div>
                <div class="col-10">
                  <br>
                  <g:form enctype="multipart/form-data" resource="${this.revisionSubActividad}" controller="revisionSubActividad"  method="POST">
                    <div class="form-group">
                      <label for="subActividad">Sub-actividad: </label>
                      <input value="${subActividad.nombre}" type="text" name="subActividad" readOnly="true" required class="form-control"/>
                      <input value="${subActividad.id}" name="subActividadId" type="hidden"/>
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
                <g:form resource="${this.revisionSubActividad}" method="POST" enctype="multipart/form-data">
                <fieldset class="form">
                    %{--<f:all bean="revisionActividad"/>
                    <f:with bean="revisionSubActividad">
                        <div class="fieldcontain required">
                            <label for="">SubActividad
                                <span class="required-indicator">*</span>
                            </label>
                            <g:field value="${subActividad.nombre}" type="text" name="subActividad" readOnly="true"/>
                            <g:field value="${subActividad.id}" name="subActividadId" type="hidden"/>
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
            %{--
            <g:form resource="${this.revisionSubActividad}" method="POST">
                <fieldset class="form">
                    <f:all bean="revisionSubActividad"/>
                </fieldset>
                <fieldset class="buttons">
                    <g:submitButton name="create" class="save" value="${message(code: 'default.button.create.label', default: 'Create')}" />
                </fieldset>
            </g:form>
            --}%
        </div>
    </body>
</html>
