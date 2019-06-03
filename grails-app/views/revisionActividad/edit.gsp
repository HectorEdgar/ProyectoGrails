<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'revisionActividad.label', default: 'RevisionActividad')}" />
        <title><g:message code="default.edit.label" args="[entityName]" /></title>
        <asset:javascript src="validacion.js"/>
    </head>
    <body>
        <div id="edit-revisionActividad" class="content scaffold-edit" role="main">
          <br>
          <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
              <li class="breadcrumb-item"><a href="${createLink(uri: '/')}">Inicio</a></li>
              <li class="breadcrumb-item"><a href="${createLink(uri: '/actividad')}">Actividad</a></li>
              <li class="breadcrumb-item active" aria-current="page">Revisión de actividad</li>
            </ol>
          </nav>
            <h1>Revisar Actividad</h1>
            <g:if test="${flash.message}">
            <div class="message" role="status">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${this.revisionActividad}">
            <ul class="errors" role="alert">
                <g:eachError bean="${this.revisionActividad}" var="error">
                <li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message error="${error}"/></li>
                </g:eachError>
            </ul>
            </g:hasErrors>


            <div class="container">

              <div class="row">
                <div class="clearfix col-1"></div>
                <div class="col-10">
                  <br>
                  <g:form resource="${this.revisionActividad}" controller="revisionActividad" method="PUT" action="update">

                  <input name="revision" id="${revisionActividad.revision.id}" value="${revisionActividad.revision.id}" hidden/>
                    <div class="form-group">
                      <label for="actividad">Actividad: </label>
                      <input value="${revisionActividad.actividad.nombre}" type="text" name="actividad" readOnly="true" required class="form-control"/>
                      <input value="${revisionActividad.actividad.id}" name="actividadId" type="hidden"/>
                    </div>
                    <div class="form-group">
                        <label for="revision.comentarios">Comentarios: </label>
                        <input type="text" class="form-control" id="revision.comentarios" rows="3" name="revision.comentarios" maxlength="1000" value="${revisionActividad.revision.comentarios}" readonly>

                    </div>
                    <input name="isRevisado" value="${revisionActividad.isRevisado}" hidden="true"/>
                    <div class="form-group">
                        <label for="revision.archivos">Archivos</label>
                            <g:if test="${revisionActividad.archivos==null}">No hay archivos</g:if>
                            <g:if test="${revisionActividad.archivos?.size()==0}">No hay archivos</g:if>
                            <g:each var="${archivo}" in="${revisionActividad.archivos}">
                                <g:link class="btn btn-outline-dark btn-sm container-fluid form-control" style="max-width:11.5rem" action="descargarArchivo" controller="actividad" params="[ubicacion: archivo.ubicacion]" data-toggle="tooltip" data-placement="top" title="${archivo}">${archivo}
                                                                                                            %{--
                                    <g:img file="dowload.png"/>--}%
                                </g:link>
                            </g:each>
                    </div>


                    <input type="checkbox" name="isAprobado" value="${revisionActividad.isAprobado}" hidden/>
                    <div class="form-group">
                        <label for="retroalimentacion">Retroalimentación: </label>
                        <textArea type="text" class="form-control" id="retroalimentacion" rows="3" name="retroalimentacion" maxlength="1000"></textArea>

                    </div>
                    <div class="row">

                    <input class="btn btn-danger col-6" type="submit" value="Rechazar" onmousedown="rechazar(event)" />
                    <input class="btn btn-success col-6" type="submit" value="Aprobar" onmousedown="aprobar(event)" />
                    </div>


                  </g:form>
                </div>
              </div>
            </div>
            %{--
            <g:form resource="${this.revisionActividad}" method="PUT">
                <g:hiddenField name="version" value="${this.revisionActividad?.version}" />
                <fieldset class="form">


                    %{--
                    <f:all bean="revisionActividad"/>


                    <f:with bean="revisionActividad">
                        <g:field name="revision" id="${revisionActividad.revision.id}" value="${revisionActividad.revision}" hidden="true"/>

                        <f:field property="actividad">
                            <g:field name="actividad" id="actividad.id" value="${revisionActividad.actividad.nombre}"/>
                            <g:field name="actividad" value="${revisionActividad.actividad.id}" hidden="true"/>
                        </f:field>
                        <f:field property="revision.comentarios">
                            <g:field name="revision.comentarios"  value="${revisionActividad.revision.comentarios}" readOnly="true"/>
                        </f:field>

                        <g:checkBox name="isRevisado" value="${revisionActividad.isRevisado}" hidden="true"/>
                        <div class="fieldcontain">
                            <label for="revision.archivos">Archivos</label>
                                <g:if test="${revisionActividad.archivos==null}">No hay archivos</g:if>
                                <g:if test="${revisionActividad.archivos?.size()==0}">No hay archivos</g:if>
                                <g:each var="${archivo}" in="${revisionActividad.archivos}">
                                    <g:link class="btn btn-sm " style="max-width:11.5rem" action="descargarArchivo" controller="actividad" params="[ubicacion: archivo.ubicacion]" data-toggle="tooltip" data-placement="top" title="${archivo}">${archivo}
                                                                                                                %{--
                                        <g:img file="dowload.png"/>
                                    </g:link>
                                </g:each>
                        </div>


                        <g:checkBox name="isAprobado" value="${revisionActividad.isAprobado}" hidden="true"/>
                        <f:field property="retroalimentacion">
                            <g:textArea name="retroalimentacion" value="" rows="5" cols="40"/>
                        </f:field>

                    </f:with>
                </fieldset>

                <fieldset class="buttons">
                    <input class="save" type="submit" value="Rechazar" onmousedown="rechazar(event)" />
                    <input class="save" type="submit" value="Aprobar" onmousedown="aprobar(event)" />

                </fieldset>
            </g:form>
            --}%
        </div>
    </body>
</html>
