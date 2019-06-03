<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'revisionSubActividad.label', default: 'RevisionSubActividad')}" />
        <title><g:message code="default.edit.label" args="[entityName]" /></title>
        <asset:javascript src="validacion.js"/>

    </head>
    <body>
        <div id="edit-revisionSubActividad" class="content scaffold-edit" role="main">
          <br>
          <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
              <li class="breadcrumb-item"><a href="${createLink(uri: '/')}">Inicio</a></li>
              <li class="breadcrumb-item"><a href="${createLink(uri: '/subActividad')}">Sub-Actividad</a></li>
              <li class="breadcrumb-item active" aria-current="page">Revisión de sub-actividad</li>
            </ol>
          </nav>
            <h1>Revisar SubActividad</h1>
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
            <div class="container">

              <div class="row">
                <div class="clearfix col-1"></div>
                <div class="col-10">
                  <br>
                  <g:form resource="${this.revisionSubActividad}" controller="revisionSubActividad" method="PUT">

                  <input name="revision" id="${revisionSubActividad.revision.id}" value="${revisionSubActividad.revision}" hidden/>
                    <div class="form-group">
                      <label for="subActividad">Sub-actividad: </label>
                      <input value="${revisionSubActividad.subActividad.nombre}" type="text" name="subActividad" readOnly="true" required class="form-control"/>
                      <input value="${revisionSubActividad.subActividad.id}" name="subActividadId" type="hidden"/>
                    </div>
                    <div class="form-group">
                        <label for="revision.comentarios">Comentarios: </label>
                        <input type="text" class="form-control" id="revision.comentarios" rows="3" name="revision.comentarios" maxlength="1000" value="${revisionSubActividad.revision.comentarios}" readonly>

                    </div>
                    <input name="isRevisado" value="${revisionSubActividad.isRevisado}" hidden="true"/>
                    <div class="form-group">
                        <label for="revision.archivos">Archivos</label>
                            <g:if test="${revisionSubActividad.archivos==null}">No hay archivos</g:if>
                            <g:if test="${revisionSubActividad.archivos?.size()==0}">No hay archivos</g:if>
                            <g:each var="${archivo}" in="${revisionSubActividad.archivos}">
                                <g:link class="btn btn-outline-dark btn-sm container-fluid form-control" style="max-width:11.5rem" action="descargarArchivo" controller="actividad" params="[ubicacion: archivo.ubicacion]" data-toggle="tooltip" data-placement="top" title="${archivo}">${archivo}
                                                                                                            %{--
                                    <g:img file="dowload.png"/>--}%
                                </g:link>
                            </g:each>
                    </div>


                    <input type="checkbox" name="isAprobado" value="${revisionSubActividad.isAprobado}" hidden/>
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
            <g:form resource="${this.revisionSubActividad}" method="PUT">
                <g:hiddenField name="version" value="${this.revisionSubActividad?.version}" />
                <fieldset class="form">
                    %{--<f:all bean="revisionSubActividad"/>
                    <f:with bean="revisionSubActividad">
                        <g:field name="revision" id="${revisionSubActividad.revision.id}" value="${revisionSubActividad.revision}" hidden="true"/>

                        <f:field property="subActividad">
                            <g:field name="subActividad" id="subActividad.id" value="${revisionSubActividad.subActividad.nombre}"/>
                            <g:field name="subActividad" value="${revisionSubActividad.subActividad.id}" hidden="true"/>
                        </f:field>
                        <f:field property="revision.comentarios">
                            <g:field name="revision.comentarios"  value="${revisionSubActividad.revision.comentarios}" readOnly="true"/>
                        </f:field>

                        <g:checkBox name="isRevisado" value="${revisionSubActividad.isRevisado}" hidden="true"/>


                        <div class="fieldcontain">
                            <label for="revisionSubActividad.archivos">Archivos</label>
                                <g:if test="${revisionSubActividad.archivos==null}">No hay archivos</g:if>
                                <g:if test="${revisionSubActividad.archivos?.size()==0}">No hay archivos</g:if>
                                <g:each var="${archivo}" in="${revisionSubActividad.archivos}">
                                    <g:link class="btn btn-sm " style="max-width:11.5rem" action="descargarArchivo" controller="actividad" params="[ubicacion: archivo.ubicacion]" data-toggle="tooltip" data-placement="top" title="${archivo}">${archivo}
                                                                                                                %{--
                                        <g:img file="dowload.png"/>
                                    </g:link>
                                </g:each>
                        </div>


                        <g:checkBox name="isAprobado" value="${revisionSubActividad.isAprobado}" hidden="true"/>
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
